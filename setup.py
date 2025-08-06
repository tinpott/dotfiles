#!/usr/bin/env python3

import csv
import io
import os
import sys
import subprocess

from dataclasses import dataclass as struct


CWD = os.path.dirname(os.path.realpath(__file__))
DIR_FILE = f'{CWD}/dirs.csv'
RUN_BROKEN_OVERRIDE_FLAG = '--override-exit-despite-broken'


@struct
class AppConfig:
    NUM_ENTRIES = 3
    name: str
    src: str
    dst: str


def create_directoryList(csvReader: csv.reader) -> list[AppConfig]:
    configs: list[AppConfig] = []
    for row in csvReader:
        if len(row) != AppConfig.NUM_ENTRIES:
            print(f'Illegal number of columns in {DIR_FILE}. Expected {AppConfig.NUM_ENTRIES}, but got {len(row)}', file=sys.stderr)
            return []
        name = row[0].strip()
        src = row[1].strip()
        src = os.environ['HOME'] + '/proj/dotfiles/' + src
        dst = row[2].strip()
        if dst[0] == '~':
            dst = os.environ['HOME'] + dst[1:]
        elif dst[:5] == '$HOME':
            dst = os.environ['HOME'] + dst[5:]
        configs.append(AppConfig(name, src, dst))
    return configs


def make_symlinks(configs: list[AppConfig]) -> bool:
    for config in configs:
        subprocess.run(f'rm -r {config.dst}', shell=True)
        subprocess.run(f'ln -s {config.src} {config.dst}', shell=True)
        print(f'{config.name}: {config.src} -> {config.dst}', file=sys.stdout)
    return True


def run_setup(file: io.TextIOWrapper) -> bool:
    configItems = create_directoryList(csv.reader(file, delimiter=','))
    if len(configItems) == 0 or not make_symlinks(configItems):
        return False
    return True


def main():
    args = sys.argv[1:]
    if len(args) == 1 and args[0] != RUN_BROKEN_OVERRIDE_FLAG:
        print(f'This script is currently broken. To run anyway, use the {RUN_BROKEN_OVERRIDE_FLAG} flag.', file=sys.stderr)
        sys.exit(1)
    with open(DIR_FILE, mode='r') as file:
        if not run_setup(file):
            sys.exit(1)


if __name__ == '__main__':
    main()
