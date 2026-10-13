#!/bin/bash
# Clean an Ubuntu guest of Parallels Desktop and compact its virtual disks

set -euo pipefail

usage() {
    cat <<EOF
Usage: $0 [--no-compact] [--dry-run] <vm-name>

Clean an Ubuntu guest through prlctl. Then return the free disk space to the host.

In the guest the script does the steps below. It does steps 5 to 7 for root and for each user in /home as the owner of the home directory. It does the other steps as root.
  1. Remove the apt package cache and the apt package lists.
  2. Remove the archived journal files and the rotated logs in /var/log.
  3. Remove the crash reports in /var/crash.
  4. Remove the disabled snap revisions.
  5. Remove the shell, less, vim, and recent-file history.
  6. Remove ~/.claude and ~/.claude.json. They hold the Claude Code login credentials, sessions, memory, and settings. Then remove the old Claude Code releases.
  7. Remove all of ~/.codex except the Codex program in ~/.codex/packages. Then remove the old Codex releases.
  8. Run fstrim on all mounted file systems.

On the host the script stops the VM. Then it compacts each expanding virtual disk with prl_disk_tool.
Compact cannot free the disk space that a snapshot holds.

The VM must be running or stopped. At the end the script returns the VM to its initial power state.

Options:
  --no-compact  Clean the guest only. Do not stop the VM.
  --dry-run     Show the guest script and the virtual disks. Change nothing.
  -h, --help    Show this help.
EOF
}

compact=1
dry_run=0
vm=""
while [ $# -gt 0 ]; do
    case "$1" in
    --no-compact) compact=0 ;;
    --dry-run) dry_run=1 ;;
    -h | --help)
        usage
        exit 0
        ;;
    -*)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 2
        ;;
    *)
        [ -z "$vm" ] || {
            usage >&2
            exit 2
        }
        vm="$1"
        ;;
    esac
    shift
done
[ -n "$vm" ] || {
    usage >&2
    exit 2
}

vm_state() {
    prlctl list -H -o status "$vm"
}

# prl_disk_tool can compact only an expanding disk.
expanding_disks() {
    prlctl list -i "$vm" | sed -n "s/^  hdd[0-9]* .* image='\([^']*\)' type='expanded'.*/\1/p"
}

guest_script() {
    cat <<'EOF'
set -u
df -h / | tail -1
apt-get clean && rm -rf /var/lib/apt/lists/*
journalctl --rotate
journalctl --vacuum-time=1s
# A Samba log for a client IP address ends in a number but is not rotated.
find /var/log -type f \( -name '*.gz' -o -regex '.*[^0-9]\.[0-9]+' -o -name '*.old' \) -delete
rm -f /var/crash/*
if command -v snap >/dev/null; then
    snap list --all | awk '/disabled/ {print $1, $3}' | while read -r name rev; do
        snap remove "$name" --revision="$rev"
    done
fi
for home in /root /home/*; do
    [ -d "$home" ] || continue
    # Run as the owner so that a link in the home cannot point root at other files.
    runuser -u "$(stat -c %U "$home")" -- bash -s "$home" <<'CLEAN_HOME'
home=$1
rm -rf "$home"/{.bash_history,.zsh_history,.lesshst,.viminfo,.local/share/recently-used.xbel} \
    "$home"/.claude "$home"/.claude.json*
# The Claude Code installer keeps old releases after an update. A custom launcher can need any release.
versions="$home"/.local/share/claude/versions
if current=$(readlink -e "$home"/.local/bin/claude) && [ "$(dirname "$current")" = "$versions" ]; then
    find "$versions" -mindepth 1 -maxdepth 1 ! -name "$(basename "$current")" -exec rm -rf {} +
fi
# ~/.codex/packages holds the Codex program itself.
[ ! -d "$home"/.codex ] ||
    find "$home"/.codex -mindepth 1 -maxdepth 1 ! -name packages -exec rm -rf {} +
# The Codex installer keeps each old release after an update.
standalone="$home"/.codex/packages/standalone
if [ -d "$standalone"/current ] && current=$(readlink "$standalone"/current); then
    find "$standalone"/releases -mindepth 1 -maxdepth 1 ! -name "$(basename "$current")" -exec rm -rf {} +
fi
CLEAN_HOME
done
# Compact can free only the blocks that the guest discards.
fstrim -av
df -h / | tail -1
EOF
}

wait_for_guest() {
    for _ in $(seq 1 60); do
        if prlctl exec "$vm" true >/dev/null 2>&1; then
            prlctl exec "$vm" systemctl is-system-running --wait >/dev/null 2>&1 || true
            return 0
        fi
        sleep 5
    done
    echo "Parallels Tools in $vm did not respond." >&2
    return 1
}

restore_state() {
    [ "$(vm_state)" = "$initial" ] && return
    case "$initial" in
    running) prlctl start "$vm" ;;
    stopped) prlctl stop "$vm" ;;
    esac
}

initial=$(vm_state)
case "$initial" in
running | stopped) ;;
*)
    echo "$vm is $initial. Resume or stop it first." >&2
    exit 1
    ;;
esac

if [ "$dry_run" = 1 ]; then
    echo "VM: $vm ($initial)"
    echo "--- guest script"
    guest_script
    if [ "$compact" = 1 ]; then
        echo "--- disks to compact"
        expanding_disks
    fi
    exit 0
fi

trap restore_state EXIT

[ "$initial" = running ] || prlctl start "$vm"
wait_for_guest
guest_script | prlctl exec "$vm" bash -s

if [ "$compact" = 1 ]; then
    prlctl stop "$vm"
    expanding_disks | while IFS= read -r disk; do
        echo "Compact $disk (size: $(du -sh "$disk" | cut -f1))"
        prl_disk_tool compact --hdd "$disk" </dev/null
        echo "Size after compact: $(du -sh "$disk" | cut -f1)"
    done
fi
