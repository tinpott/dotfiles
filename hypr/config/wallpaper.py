#!/usr/bin/env python3

import random
import os
import subprocess
import sys


def main():
	# find wallpaper directory
	WALLPAPER_DEFAULT_DIR = os.environ["WALLPAPER_DEFAULT_DIR"]
	if not os.path.isdir(WALLPAPER_DEFAULT_DIR):
		print(f"Failed to find wallpaper directory: {WALLPAPER_DEFAULT_DIR}")
		sys.exit(1)

	# find default wallpaper
	WALLPAPER_FILE_PATH = f"{WALLPAPER_DEFAULT_DIR}/{os.environ["WALLPAPER_DEFAULT_FILE"]}"
	if not os.path.isfile(WALLPAPER_FILE_PATH):
		print(f"Failed to find wallpaper file: {WALLPAPER_FILE_PATH}")
		sys.exit(1)


	# choose a random wallpaper
	WALLPAPER_LIST_PATH = f"{WALLPAPER_DEFAULT_DIR}/{os.environ["WALLPAPER_DEFAULT_LIST"]}"
	if not os.path.isfile(WALLPAPER_LIST_PATH):
		print(f"Failed to find wallpaper list: {WALLPAPER_LIST_PATH}")
		sys.exit(1)
	with open(WALLPAPER_LIST_PATH, "r") as file:
		line = file.readline()
		while line != "":
			print(line, end="")
			line = file.readline()
	WALLPAPER_RAND = random.choice(["hypr0.png", "hypr1.png"])
	print(f"Using wallpaper: {WALLPAPER_RAND}", file=sys.stderr) # TODO: change to stdout

	# set wallpaper symlink
	CMD = f"ln -sf {WALLPAPER_DEFAULT_DIR}/{WALLPAPER_RAND} {WALLPAPER_FILE_PATH}"
	RESULT = subprocess.run(CMD, shell=True, check=True)
	if RESULT.returncode != 0:
		print(RESULT.stderr, file=sys.stderr)
		sys.exit(1)


if __name__ == "__main__":
	main()
