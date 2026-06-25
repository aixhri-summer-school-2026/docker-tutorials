#!/bin/bash
set -e  # Stop the script on error

# Get the target directory passed as argument (default to current directory)
TARGET_DIR="${1:-.}"

# Pull the image
docker pull aixhrisummerschool2026/aixhri-summer-school-2026:Tutorial_09_Social_Robot_Navigation

# Rename the image
docker tag aixhrisummerschool2026/aixhri-summer-school-2026:Tutorial_09_Social_Robot_Navigation ros-humble-socnav

# # Clone the repository
# REPO_URL="https://github.com/aixhri-summer-school-2026/Tutorial_09_Social_Robot_Navigation.git"

# if [ -d "$TARGET_DIR" ] && [ -d "$TARGET_DIR/.git" ]; then
#     echo "→ Folder $TARGET_DIR already exists, update with git pull..."
#     cd "$TARGET_DIR"
#     git pull
# else
#     echo "→ Clone into $TARGET_DIR..."
#     git clone "$REPO_URL" "$TARGET_DIR"
# fi