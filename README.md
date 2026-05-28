# Docker & NVIDIA Container Toolkit on Ubuntu — Setup Guide

This guide walks you through installing Docker on Ubuntu, verifying the installation, and setting up the NVIDIA Container Toolkit so your containers can access your GPU's power.

## 0. Introduction & Key Concepts

### What are these tools?
*   **The Terminal:** This is the text-based interface used to control your computer by typing commands. On Ubuntu, you can open it by pressing **`Ctrl + Alt + T`** or by searching for "Terminal" in your applications.
*   **Docker:** A tool that allows you to package an application and its dependencies into an isolated "container." This ensures the software runs the same way on any machine.
*   **NVIDIA Container Toolkit:** This acts as a "bridge" that allows Docker to see and use the computing power of your NVIDIA graphics card, which is essential for AI, deep learning, or 3D rendering.

---

## Prerequisites

- Ubuntu 20.04, 22.04, or 24.04 (64-bit)
- A user account with `sudo` privileges
- NVIDIA drivers already installed on the host (the command `nvidia-smi` must work in your terminal before proceeding).

---

## 1. Install Docker

> **Already have Docker installed?** Skip straight to [3. Install the NVIDIA Container Toolkit](#3-install-the-nvidia-container-toolkit).

### 1.1 — Remove old versions

Before installing the official version, clean up any old Docker-related packages:

```bash
sudo apt remove docker docker-engine docker.io containerd runc
```

> **Note:** If you see an error like `E: Unable to locate package docker-engine`, this is **perfectly normal**. It simply means that specific package was not installed on your system. You can proceed to the next step.

> **⚠️ Data Warning:** Uninstalling Docker does not delete your images or volumes as long as you do not delete the `/var/lib/docker/` directory. See the [Preserving existing Docker data](#preserving-existing-docker-data) section at the end of this guide.

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

By default, Docker requires administrator rights. To use it with your current user:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 2. Verify the Docker Installation

Check if Docker is correctly installed by running the classic test image:

```bash
docker run hello-world
```

If you see the message `"Hello from Docker!"`, everything is working correctly.

---

## 3. Install the NVIDIA Container Toolkit

The toolkit allows Docker containers to access the host's GPU.

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

This command updates Docker's configuration to recognize the NVIDIA driver:

```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

---

## 4. Test GPU Access Inside a Container

### 4.1 — Quick smoke test

We will use an official NVIDIA image to verify the GPU is visible from inside a container:

```bash
docker run --rm --gpus all nvidia/cuda:12.6.0-base-ubuntu22.04 nvidia-smi
```

*Note: You can replace `12.6.0` with a different version depending on your needs.*

### 4.2 — Target a specific GPU

If you have multiple GPUs and only want to assign one to the container (e.g., the first one, index 0):

```bash
docker run --rm --gpus '"device=0"' nvidia/cuda:12.6.0-base-ubuntu22.04 nvidia-smi
```

---

## Preserving existing Docker data

### Safety & Backup
If you reinstall Docker, your data is stored in `/var/lib/docker/`.

*   **`apt remove`**: Removes the software but keeps your images and volumes.
*   **`apt purge`**: Deletes everything, including your configurations and data.

To list your important volumes before making changes:
```bash
docker volume ls
```

To backup a custom image to a file:
```bash
docker save my-image:tag -o my-backup.tar
```

And to restore it later:
```bash
docker load -i my-backup.tar
```

| Resource | `apt remove` | `apt purge` / `rm -rf /var/lib/docker` |
|---|---|---|
| Docker Binaries | ✅ Removed | ✅ Removed |
| Images | ✅ Kept | ❌ Destroyed |
| Containers | ✅ Kept | ❌ Destroyed |
| Named Volumes | ✅ Kept | ❌ Destroyed |