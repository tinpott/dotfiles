#!/usr/bin/env python3

import json
import os
import sys
import argparse
from pathlib import Path
from datetime import datetime

# ANSI color codes
class Colors:
    RED    = '\033[0;31m'
    GREEN  = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE   = '\033[0;34m'
    NONE   = '\033[0m'  # No Color

CONFIG_FILE = 'dirs.json'
DRY_RUN_TAG = '[DRY RUN] '

def print_colored(color: str, message: str) -> None:
    """Print colored message to stdout."""
    print(f"{color}{message}{Colors.NONE}")

def expand_path(path: str) -> Path:
    """Expand environment variables and resolve path."""
    return Path(os.path.expandvars(path)).expanduser()

def backup_item(item: Path, dry_run: bool = False) -> None:
    """Backup a file or directory."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = Path(f"{item}.backup.{timestamp}")

    if dry_run:
        print_colored(Colors.YELLOW, f"{DRY_RUN_TAG}Would backup: {item} -> {backup_path}")
    else:
        item.rename(backup_path)
        print_colored(Colors.BLUE, f"Backed up: {item} -> {backup_path}")

def create_symlink(
    source: Path,
    target: Path,
    name: str,
    dry_run: bool = False,
    force: bool = False,
    backup: bool = True
) -> bool:
    """Create a symlink from source to target."""

    print(f"\n{Colors.BLUE}Processing:{Colors.NONE} {name}")
    print(f"  Source: {source}")
    print(f"  Target: {target}")

    # Check if source exists
    if not source.exists():
        print_colored(Colors.RED, "  ✗ Source does not exist")
        return False

    # Create parent directory if it doesn't exist
    target_dir = target.parent
    if not target_dir.exists():
        if dry_run:
            print_colored(Colors.YELLOW, f"  {DRY_RUN_TAG}Would create directory: {target_dir}")
        else:
            target_dir.mkdir(parents=True, exist_ok=True)
            print_colored(Colors.GREEN, f"  Created directory: {target_dir}")

    # Check if target already exists
    if target.exists() or target.is_symlink():
        # Check if it's already the correct symlink
        if target.is_symlink() and target.resolve() == source.resolve():
            print_colored(Colors.GREEN, "  ✓ Symlink already correct")
            return True

        # Handle existing file/directory/symlink
        if force:
            if backup and not target.is_symlink():
                backup_item(target, dry_run)
            else:
                if dry_run:
                    print_colored(Colors.YELLOW, f"  {DRY_RUN_TAG}Would remove: {target}")
                else:
                    if target.is_dir() and not target.is_symlink():
                        import shutil
                        shutil.rmtree(target)
                    else:
                        target.unlink()
                    print_colored(Colors.YELLOW, f"  Removed: {target}")
        else:
            print_colored(Colors.RED, "  ✗ Target already exists (use --force to overwrite)")
            return False

    # Create the symlink
    if dry_run:
        print_colored(Colors.YELLOW, f"  {DRY_RUN_TAG}Would create symlink: {target} -> {source}")
    else:
        target.symlink_to(source)
        print_colored(Colors.GREEN, "  ✓ Created symlink")

    return True

def main():
    parser = argparse.ArgumentParser(
        description=f"Install dotfiles as symlinks based on {CONFIG_FILE} configuration"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes"
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite existing symlinks"
    )
    parser.add_argument(
        "--no-backup",
        action="store_true",
        help="Don't backup existing files/directories"
    )

    args = parser.parse_args()

    # Get script directory and config file path
    script_dir = Path(__file__).parent.resolve()
    dirs_json_path = script_dir / CONFIG_FILE

    # Check if config file exists
    if not dirs_json_path.exists():
        print_colored(Colors.RED, f"Error: {CONFIG_FILE} not found at {dirs_json_path}")
        sys.exit(1)

    # Read and parse config file
    try:
        with open(dirs_json_path, 'r') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        print_colored(Colors.RED, f"Error: Invalid JSON in {CONFIG_FILE}: {e}")
        sys.exit(1)

    # Print header
    print_colored(Colors.BLUE, "=== Dotfiles Symlink Installer ===")
    print(f"Working directory: {script_dir}")

    if args.dry_run:
        print_colored(Colors.YELLOW, "Running in DRY RUN mode - no changes will be made")

    # Process each entry
    success_count = 0
    fail_count = 0

    for name, value in config.items():
        entries = value if isinstance(value, list) else [value]

        for entry in entries:
            if 'file' in entry:
                source_path = script_dir / name / entry['file']
            else:
                source_path = script_dir / name
            target_path = expand_path(entry['target'].rstrip('/'))

            if create_symlink(
                source=source_path,
                target=target_path,
                name=name,
                dry_run=args.dry_run,
                force=args.force,
                backup=not args.no_backup
            ):
                success_count += 1
            else:
                fail_count += 1

    # Print summary
    print(f"\n{Colors.BLUE}=== Summary ==={Colors.NONE}")
    print_colored(Colors.GREEN, f"Successful: {success_count}")
    print_colored(Colors.RED, f"Failed: {fail_count}")

    if args.dry_run:
        print_colored(Colors.YELLOW, "\nThis was a dry run. Run without --dry-run to make actual changes.")

    sys.exit(fail_count)

if __name__ == "__main__":
    main()
