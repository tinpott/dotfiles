#!/usr/bin/env python3

import csv
import os
import sys
import subprocess

from dataclasses import dataclass

DIR_FILE = "dirs.csv"

@dataclass
class ConfigItem:
	NUM_ENTRIES = 3
	appName: str
	configPath: str
	symlinkPath: str

def create_directoryList(csvReader: csv.reader) -> list[ConfigItem]:
	configItems: list[ConfigItem] = []
	for row in csvReader:
		if len(row) != ConfigItem.NUM_ENTRIES:
			print(f"Illegal number of columns in {DIR_FILE}. Expected {ConfigItem.NUM_ENTRIES}, but got {len(row)}", file=sys.stderr)
			return []
		appName = row[0].strip()
		configPath = row[1].strip()
		configPath = os.environ["HOME"] + "/proj/dotfiles/" + configPath
		symlinkPath = row[2].strip()
		if symlinkPath[0] == "~":
			symlinkPath = os.environ["HOME"] + symlinkPath[1:]
		elif symlinkPath[:5] == "$HOME":
			symlinkPath = os.environ["HOME"] + symlinkPath[5:]
		configItems.append(ConfigItem(appName, configPath, symlinkPath))
	return configItems

def make_symlinks(configItems: list[ConfigItem]) -> bool:
	for configItem in configItems:
		result = subprocess.run(f"ln -sf {configItem.configPath} {configItem.symlinkPath}", check=True, shell=True)
		if result.returncode != 0:
			print(result.stdout, file=sys.stdout)
			print(result.stderr, file=sys.stderr)
			return False
		else:
			print(f"{configItem.appName}: {configItem.configPath} -> {configItem.symlinkPath}", file=sys.stdout)
	return True

def main():
	file = open(DIR_FILE, mode="r")
	configItems = create_directoryList(csv.reader(file, delimiter=","))
	if len(configItems) == 0:
		file.close()
		sys.exit(1)
	if not make_symlinks(configItems):
		file.close()
		sys.exit(1)

if __name__ == "__main__":
	main()
