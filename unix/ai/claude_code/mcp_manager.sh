#!/bin/bash
# Manage MCP servers for Claude Code
# Reference: https://docs.anthropic.com/en/docs/claude-code/mcp
#
# Usage:
#   ./mcp_manager.sh install <mcp-name>    - Install MCP server
#   ./mcp_manager.sh uninstall <mcp-name>  - Uninstall MCP server
#   ./mcp_manager.sh status [mcp-name]     - Check installation status (all if no name)
#   ./mcp_manager.sh list                  - List available MCP servers
#   ./mcp_manager.sh -h|--help             - Show this help message
#
# Available MCP servers:
#   context7        - Retrieve up-to-date documentation for any library
#   chrome-devtools - Chrome DevTools integration for web development

set -e

CLAUDE_CMD=""

# MCP server configurations: name|command|description|docs
MCP_CONFIGS=(
    "context7|npx -y @upstash/context7-mcp|Retrieve up-to-date documentation for any library|https://docs.anthropic.com/en/docs/claude-code/mcp"
    "chrome-devtools|npx chrome-devtools-mcp@latest|Chrome DevTools integration for web development|https://github.com/ChromeDevTools/chrome-devtools-mcp/"
)

# Get MCP config field by name
# Usage: get_mcp_field <mcp-name> <field-index>
# Fields: 1=command, 2=description, 3=docs
get_mcp_field() {
    local name="$1"
    local field="$2"
    for config in "${MCP_CONFIGS[@]}"; do
        if [[ "$config" == "$name|"* ]]; then
            echo "$config" | cut -d'|' -f"$((field + 1))"
            return 0
        fi
    done
    echo ""
}

# Get list of MCP names
get_mcp_names() {
    for config in "${MCP_CONFIGS[@]}"; do
        echo "$config" | cut -d'|' -f1
    done
}

show_usage() {
    echo "Usage: $0 <command> [mcp-name]"
    echo ""
    echo "Commands:"
    echo "  install <mcp-name>    Install MCP server"
    echo "  uninstall <mcp-name>  Uninstall MCP server"
    echo "  status [mcp-name]     Check installation status (all if no name)"
    echo "  list                  List available MCP servers"
    echo ""
    echo "Options:"
    echo "  -h, --help  Show this help message"
    echo ""
    echo "Available MCP servers:"
    for name in $(get_mcp_names); do
        printf "  %-16s %s\n" "$name" "$(get_mcp_field "$name" 2)"
    done
}

list_mcp() {
    echo "Available MCP servers:"
    echo ""
    for name in $(get_mcp_names); do
        printf "  %-16s %s\n" "$name" "$(get_mcp_field "$name" 2)"
    done
    echo ""
    echo "Use '$0 install <mcp-name>' to install a server."
}

require_mcp_name() {
    if [[ -z "$1" ]]; then
        echo "Error: MCP server name is required."
        echo "Use '$0 list' to see available servers."
        exit 1
    fi
}

validate_mcp() {
    local mcp_name="$1"
    local mcp_cmd
    mcp_cmd=$(get_mcp_field "$mcp_name" 1)
    if [[ -z "$mcp_cmd" ]]; then
        echo "Error: Unknown MCP server '$mcp_name'."
        echo "Use '$0 list' to see available servers."
        exit 1
    fi
}

find_claude() {
    if command -v claude &>/dev/null; then
        CLAUDE_CMD="claude"
    elif [[ -x "$HOME/.claude/local/claude" ]]; then
        CLAUDE_CMD="$HOME/.claude/local/claude"
    else
        echo "Error: Claude Code is not installed. Please install Claude Code first."
        exit 1
    fi
}

install_mcp() {
    local mcp_name="$1"
    require_mcp_name "$mcp_name"
    validate_mcp "$mcp_name"
    local mcp_cmd
    mcp_cmd=$(get_mcp_field "$mcp_name" 1)
    echo "Installing $mcp_name MCP server..."
    find_claude
    if $CLAUDE_CMD mcp add -s user "$mcp_name" -- $mcp_cmd; then
        echo "$mcp_name MCP server installed successfully!"
        echo ""
        echo "Description: $(get_mcp_field "$mcp_name" 2)"
        echo "Documentation: $(get_mcp_field "$mcp_name" 3)"
    else
        echo "Failed to install $mcp_name MCP server."
        exit 1
    fi
}

uninstall_mcp() {
    local mcp_name="$1"
    require_mcp_name "$mcp_name"
    validate_mcp "$mcp_name"
    echo "Uninstalling $mcp_name MCP server..."
    find_claude
    if $CLAUDE_CMD mcp remove -s user "$mcp_name"; then
        echo "$mcp_name MCP server uninstalled successfully!"
    else
        echo "Failed to uninstall $mcp_name MCP server."
        exit 1
    fi
}

status_mcp() {
    local mcp_name="$1"
    find_claude

    # If no name provided, show status of all MCP servers
    if [[ -z "$mcp_name" ]]; then
        echo "MCP server status:"
        echo ""
        local mcp_list
        mcp_list=$($CLAUDE_CMD mcp list 2>/dev/null || true)
        for name in $(get_mcp_names); do
            if echo "$mcp_list" | grep -q "^$name:"; then
                printf "  %-16s %s\n" "$name" "✓ Installed"
            else
                printf "  %-16s %s\n" "$name" "✗ Not installed"
            fi
        done
        return 0
    fi

    validate_mcp "$mcp_name"
    if $CLAUDE_CMD mcp list 2>/dev/null | grep -q "^$mcp_name:"; then
        echo "$mcp_name MCP server is installed."
    else
        echo "$mcp_name MCP server is not installed."
        exit 1
    fi
}

case "${1:-}" in
install)
    install_mcp "$2"
    ;;
uninstall)
    uninstall_mcp "$2"
    ;;
status)
    status_mcp "$2"
    ;;
list)
    list_mcp
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
