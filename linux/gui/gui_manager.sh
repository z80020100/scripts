#!/bin/bash
# Control the desktop GUI of an Ubuntu guest

set -e

show_usage() {
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  status        Show if the GUI starts at boot and if the GUI runs now"
    echo "  start         Start the GUI now. The GUI replaces the text login on tty1"
    echo "                A user who is logged in on tty1 is logged out"
    echo "  stop          Stop the GUI now. Then show the text login on tty1"
    echo "                The command fails when a user is logged in to the GUI"
    echo "  stop --force  Stop the GUI and end the GUI sessions. Unsaved work in them is lost"
    echo "  enable        Start the GUI at each boot"
    echo "  disable       Start in text mode at each boot"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
}

# Print the IDs of the GUI sessions that users are logged in to
list_gui_sessions() {
    loginctl list-sessions --no-legend | while read -r id _; do
        [[ "$(loginctl show-session "$id" -p Class --value 2>/dev/null)" == user ]] || continue
        case "$(loginctl show-session "$id" -p Type --value 2>/dev/null)" in
        wayland | x11) echo "$id" ;;
        esac
    done
}

show_status() {
    local target
    target=$(systemctl get-default)
    if [[ "$target" == graphical.target ]]; then
        echo "Start at boot: yes ($target)"
    else
        echo "Start at boot: no ($target)"
    fi
    if systemctl is-active --quiet gdm; then
        echo "Running now: yes"
    else
        echo "Running now: no"
    fi
    echo "Logged-in GUI sessions: $(list_gui_sessions | wc -l)"
}

stop_gui() {
    if [[ "$1" != --force && -n "$(list_gui_sessions)" ]]; then
        echo "Error: A user is logged in to the GUI. The GUI did not stop."
        echo "Use '$0 stop --force' to stop the GUI and end the GUI sessions."
        exit 1
    fi
    # gdm stops getty@tty1 when gdm starts. Start getty again to show a text login.
    local steps="systemctl stop gdm && systemctl start getty@tty1"
    # A caller on a text console already sees that console.
    [[ "$(tty)" == /dev/tty[0-9]* ]] || steps+=" && chvt 1"
    # A caller in a GUI terminal ends with the GUI. A separate unit completes the steps.
    sudo systemd-run --quiet --wait --collect --pipe sh -c "$steps"
}

case "$*" in
status)
    show_status
    ;;
start)
    sudo systemctl start gdm
    ;;
stop | "stop --force")
    stop_gui "${2:-}"
    ;;
enable)
    sudo systemctl set-default graphical.target
    ;;
disable)
    sudo systemctl set-default multi-user.target
    ;;
-h | --help)
    show_usage
    exit 0
    ;;
*)
    show_usage
    exit 1
    ;;
esac
