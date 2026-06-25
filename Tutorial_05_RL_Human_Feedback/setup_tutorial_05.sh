#!/bin/bash
set -e  # Stop the script on error

# Get the target directory passed as argument (default to current directory)
TARGET_DIR="${1:-.}"

# Pull the image
docker pull aixhrisummerschool2026/aixhri-summer-school-2026:Tutorial_05_RL_With_Human_Feedback_mile

# Rename the image
docker tag aixhrisummerschool2026/aixhri-summer-school-2026:Tutorial_05_RL_With_Human_Feedback_mile mile:franka-humble

# Clone the repository
REPO_URL="https://github.com/aixhri-summer-school-2026/Tutorial_05_RL_With_Human_Feedback.git"

if [ -d "$TARGET_DIR" ] && [ -d "$TARGET_DIR/.git" ]; then
    echo "→ Folder $TARGET_DIR already exists, update with git pull..."
    cd "$TARGET_DIR"
    git pull
else
    echo "→ Clone into $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR"
fi