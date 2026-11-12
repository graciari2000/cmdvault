#!/usr/bin/env python3
"""A tiny local command library with prefix search and an interactive picker."""
import argparse
import json
import os
from pathlib import Path
import sys

DATA = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "cmdvault" / "commands.json"

def read_commands():
    try:
        return json.loads(DATA.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return []

def write_commands(items):
    DATA.parent.mkdir(parents=True, exist_ok=True)
    DATA.write_text(json.dumps(items, indent=2, ensure_ascii=False), encoding="utf-8")

def add(command):
    command = command.strip()
    if not command:
        return
    items = read_commands()
    items = [x for x in items if x["command"] != command]
    items.insert(0, {"command": command})
    write_commands(items[:5000])

def matches(prefix=""):
    p = prefix.casefold()
    return [x["command"] for x in read_commands() if x["command"].casefold().startswith(p)]

def pick(prefix):
    found = matches(prefix)
    if not found:
        print("No saved commands match.", file=sys.stderr)
        return
    for i, cmd in enumerate(found[:40], 1):
        print(f"{i:>2}. {cmd}", file=sys.stderr)
    try:
        choice = input("Choose a command number (Enter to cancel): ").strip()
    except (EOFError, KeyboardInterrupt):
        return
    if choice.isdigit() and 1 <= int(choice) <= min(len(found), 40):
        print(found[int(choice) - 1])

def main():
    parser = argparse.ArgumentParser(description="Save and reuse terminal commands")
    sub = parser.add_subparsers(dest="action", required=True)
    sub.add_parser("add", help="save a command (reads command from stdin)")
    s = sub.add_parser("search", help="list saved commands starting with a prefix")
    s.add_argument("prefix", nargs="?", default="")
    p = sub.add_parser("pick", help="choose a saved command by prefix")
    p.add_argument("prefix", nargs="?", default="")
    sub.add_parser("list", help="list saved commands")
    args = parser.parse_args()
    if args.action == "add":
        add(sys.stdin.read())
    elif args.action == "search":
        print("\n".join(matches(args.prefix)))
    elif args.action == "list":
        print("\n".join(matches()))
    else:
        pick(args.prefix)

if __name__ == "__main__":
    main()
