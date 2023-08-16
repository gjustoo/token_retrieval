#!/bin/bash

COMMAND_LOG="command_log.txt"

function list_commands() {
    echo "List of generated commands:"
    cat "$COMMAND_LOG" || echo "No commands recorded."
}

function delete_command() {
    if [ -z "$1" ]; then
        echo "Usage: $0 --delete <command_name>"
        exit 1
    fi

    command_name="$1"
    if [ -f "/usr/local/bin/$command_name" ]; then
        rm "/usr/local/bin/$command_name"
        sed -i "/$command_name/d" "$COMMAND_LOG"
        echo "Command '$command_name' deleted."
    else
        echo "Command '$command_name' not found."
    fi
}

case "$1" in
    --list)
        list_commands
        ;;
    --delete)
        delete_command "$2"
        ;;
    *)
        echo "Usage: $0 --<list|delete>"
        exit 1
        ;;
esac
