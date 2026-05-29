# Docker & NVIDIA Container Toolkit on Ubuntu — Setup Guide

This guide walks you through installing Docker on Ubuntu, verifying the installation, and setting up the NVIDIA Container Toolkit so your containers can access your GPU's power.

## 0. Introduction & Key Concepts

### What are these tools?
*   **The Terminal:** This is the text-based interface used to control your computer. On Ubuntu, open it with **`Ctrl + Alt + T`**.
*   **Docker:** A tool that packages applications into isolated "containers."
*   **NVIDIA Container Toolkit:** The "bridge" that allows Docker to use your NVIDIA GPU for AI or rendering.
*   **nvidia-smi:** A command-line utility that communicates with your NVIDIA driver to show GPU usage and temperature. **If this command fails, your GPU cannot be used by Docker.**

---

## Prerequisites

- Ubuntu 20.04, 22.04, or 24.04 (64-bit).
- A user account with `sudo` privileges.
- **NVIDIA Drivers:** These must be installed. Test this by typing `nvidia-smi` in your terminal. 
    *   *If it works:* You’ll see a table with GPU details (model, driver version, temperature, memory usage, etc.). Proceed to Section 1.
    *   *If it fails (e.g., "command not found" or "no devices found"):* Follow Section 0.1 below.

---

## 0.1 — Installing NVIDIA Drivers (if needed)

**Important Warning:** Driver installation and management is a critical system-level task. **We strongly recommend only experienced users attempt this**, as incorrect driver versions or installation methods can lead to system instability, boot loops, or display issues. If unsure, **seek advice from someone who has experience with Linux or GPU driver management**.

If `nvidia-smi` does not work, you need to install the drivers on your host machine first.

### A. Detect your GPU and recommended driver
Run the following command to see which driver is recommended for your hardware:
```bash
ubuntu-drivers devices
```
Look for the line that says `vendor : NVIDIA Corporation` and identifies a driver as `recommended`.

### B. Install the driver
You can either install the recommended one automatically:
```bash
sudo ubuntu-drivers autoinstall
```
**OR** install a specific version (e.g., version 550) manually:
```bash
sudo apt update
sudo apt install -y nvidia-driver-550
```

### C. Reboot
For the driver to activate, you **must** restart your computer:
```bash
sudo reboot
```

### D. Verify
After rebooting, open your terminal and type:
```bash
nvidia-smi
```
If you see a table showing your GPU name and driver version, you are ready to proceed to Section 1.

---

## 1. Install Docker

### 1.1 — Remove old versions
```bash
sudo apt remove docker docker-engine docker.io containerd runc
```
> **Note:** If you see `E: Unable to locate package docker-engine`, it's normal. It just means it wasn't there.

### 1.2 — Install dependencies
```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
```

### 1.3 — Add Docker's official GPG key and repository
```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 1.4 — Install Docker Engine
```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 1.5 — (Optional) Run Docker without `sudo`
```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 2. Verify the Docker Installation

```bash
docker run hello-world
```
If you see `"Hello from Docker!"`, Docker is working.

---

## 3. Install the NVIDIA Container Toolkit

### 3.1 — Configure the repository
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

### 3.2 — Install the toolkit
```bash
sudo apt update
sudo apt install -y nvidia-container-toolkit
```

### 3.3 — Configure the Docker runtime
```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

---

## 4. Test GPU Access Inside a Container

### 4.1 — Quick smoke test
```bash
docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu22.04 nvidia-smi
```

### 4.2 — Target a specific GPU
```bash
docker run --rm --gpus '"device=0"' nvidia/cuda:12.6.0-base-ubuntu22.04 nvidia-smi
```

---

## Preserving existing Docker data

| Resource | `apt remove` | `apt purge` / `rm -rf /var/lib/docker` |
|---|---|---|
| Docker Binaries | ✅ Removed | ✅ Removed |
| Images | ✅ Kept | ❌ Destroyed |
| Containers | ✅ Kept | ❌ Destroyed |
| Named Volumes | ✅ Kept | ❌ Destroyed |

*To backup an image:* `docker save my-image:tag -o backup.tar`  
*To restore an image:* `docker load -i backup.tar`