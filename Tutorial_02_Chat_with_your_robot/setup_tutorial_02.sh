#!/bin/bash
set -e  # Stop the script on error

# Get the target directory passed as argument (default to current directory)
TARGET_DIR="${1:-.}"

# NVIDIA GPU detection
GPU_FOUND=false

# Method 1: nvidia-smi (if drivers are installed)
if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
    GPU_FOUND=true
fi

# Method 2: lspci (if nvidia-smi is unavailable but GPU is present)
if ! $GPU_FOUND && command -v lspci &> /dev/null; then
    if lspci | grep -qi "NVIDIA"; then
        GPU_FOUND=true
    fi
fi

# Choose the image suffix
if [ "$GPU_FOUND" = true ]; then
    SUFFIX="_gpu"
    echo "→ NVIDIA GPU detected, using GPU image"
else
    SUFFIX="_cpu"
    echo "→ No NVIDIA GPU detected, using CPU image"
fi

BASE_IMAGE="aixhrisummerschool2026/aixhri-summer-school-2026:Tutorial_02_Chat_with_your_robot${SUFFIX}"

# Pull the appropriate image
docker pull "${BASE_IMAGE}"

# Clone the repository
REPO_URL="https://github.com/aixhri-summer-school-2026/Tutorial_02_Chat_with_your_robot.git"

if [ -d "$TARGET_DIR" ] && [ -d "$TARGET_DIR/.git" ]; then
    echo "→ Folder $TARGET_DIR already exists, update with git pull..."
    cd "$TARGET_DIR"
    git pull
else
    echo "→ Clone into $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR"
fi