# Docker & NVIDIA Container Toolkit on Ubuntu — Setup Guide

This guide walks you through installing Docker on Ubuntu, verifying the installation with the classic `hello-world` image, then setting up the NVIDIA Container Toolkit so your containers can access your GPU.

---

## Prerequisites

- Ubuntu 20.04, 22.04, or 24.04 (64-bit)
- A user account with `sudo` privileges
- NVIDIA drivers already installed on the host (`nvidia-smi` should work on the host before proceeding)

---

## 1. Install Docker

> **Already have Docker installed?** You can skip this section entirely and jump straight to [Install the NVIDIA Container Toolkit](#3-install-the-nvidia-container-toolkit).

### 1.1 — Remove any old versions

Before installing, remove any previously installed versions of Docker:

```bash
sudo apt remove docker docker-engine docker.io containerd runc
```

> **⚠️ Warning — existing data:** Uninstalling Docker **does not** automatically delete your existing images, containers, or volumes as long as you do not remove `/var/lib/docker/`. However, running `apt purge` or manually deleting that directory will permanently destroy all of them. If you have data worth keeping, see [Preserving existing Docker data](#preserving-existing-docker-data) below before proceeding.

### 1.2 — Install dependencies

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
```

### 1.3 — Add Docker's official GPG key and repository

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
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

> **Note:** You may need to log out and back in for this to take full effect.

---

## 2. Verify the Docker Installation

Pull and run the official `hello-world` image:

```bash
docker run hello-world
```

Expected output (abridged):

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

If you see that message, Docker is up and running.

---

## 3. Install the NVIDIA Container Toolkit

The NVIDIA Container Toolkit allows Docker containers to access the host's GPU(s) through the NVIDIA driver.

### 3.1 — Add the NVIDIA repository and GPG key

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

### 3.3 — Configure Docker to use the NVIDIA runtime

```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

This updates `/etc/docker/daemon.json` to register the NVIDIA runtime and restarts the Docker daemon.

---

## 4. Test GPU Access Inside a Container

### 4.1 — Quick smoke test with a minimal image

The `nvidia/cuda` images ship with `nvidia-smi`. Pull a minimal one and run the tool directly:

```bash
docker run --rm --gpus all nvidia/cuda:12.3.0-base-ubuntu22.04 nvidia-smi
```

You should see your GPU listed with its driver version and CUDA version, for example:

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 545.23.08    Driver Version: 545.23.08    CUDA Version: 12.3    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
|   0  NVIDIA GeForce ...  Off  | 00000000:01:00.0  On |                  N/A |
+-----------------------------------------------------------------------------+
```

> Adapt the image tag (`12.3.0-base-ubuntu22.04`) to match your driver's supported CUDA version. Check the [CUDA release notes](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/) or run `nvidia-smi` on the host to see the maximum supported CUDA version.

### 4.2 — List all available GPUs

```bash
docker run --rm --gpus all nvidia/cuda:12.3.0-base-ubuntu22.04 nvidia-smi -L
```

Expected output:

```
GPU 0: NVIDIA GeForce RTX 4090 (UUID: GPU-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
```

### 4.3 — Target a specific GPU

Use the `device` option to expose only one GPU to the container:

```bash
docker run --rm --gpus '"device=0"' nvidia/cuda:12.3.0-base-ubuntu22.04 nvidia-smi
```

---

## Preserving existing Docker data

If you already have images, containers, or volumes on your machine and need to reinstall or upgrade Docker, follow these steps to avoid data loss.

### Inventory what you have

```bash
docker images       # locally available images
docker ps -a        # all containers (running or stopped)
docker volume ls    # named volumes
```

### Back up images you care about

Export an image to a portable archive:

```bash
docker save my-image:tag -o my-image.tar
```

Restore it after reinstalling Docker:

```bash
docker load -i my-image.tar
```

### Safe reinstall — keep `/var/lib/docker/`

All of Docker's data (images, containers, volumes) lives under `/var/lib/docker/`. As long as you **do not delete this directory** and avoid `apt purge`, Docker will rediscover its data automatically after reinstallation:

```bash
# Safe: removes binaries only, data directory is untouched
sudo apt remove docker-ce docker-ce-cli containerd.io

# Dangerous: wipes everything including /var/lib/docker
# sudo apt purge docker-ce docker-ce-cli containerd.io
# sudo rm -rf /var/lib/docker
```

### What gets destroyed if you purge

| Resource | `apt remove` | `apt purge` / `rm -rf /var/lib/docker` |
|---|---|---|
| Docker binaries | ✅ removed | ✅ removed |
| Images | ✅ kept | ❌ destroyed |
| Containers | ✅ kept | ❌ destroyed |
| Named volumes | ✅ kept | ❌ destroyed |
| Custom networks | ✅ kept | ❌ destroyed |

---

## Automated testing with Multipass

[Multipass](https://multipass.run/) lets you spin up a fresh Ubuntu VM in seconds. Combined with a **cloud-init** script, you can reproduce the full setup automatically in an isolated environment without touching your host machine.

### The `setup.yaml` cloud-init script

Save the following as `setup.yaml`. It installs Docker, runs the `hello-world` test, installs the NVIDIA Container Toolkit, and runs the GPU smoke tests — all automatically on first boot.

```yaml
#cloud-config

package_update: true
package_upgrade: true

packages:
  - ca-certificates
  - curl
  - gnupg
  - lsb-release

runcmd:
  # --- Docker ---
  - install -m 0755 -d /etc/apt/keyrings
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  - chmod a+r /etc/apt/keyrings/docker.gpg
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
  - apt-get update -qq
  - apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - usermod -aG docker ubuntu
  # --- Hello World test ---
  - docker run hello-world
  # --- NVIDIA Container Toolkit ---
  - curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  - curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  - apt-get update -qq
  - apt-get install -y nvidia-container-toolkit
  - nvidia-ctk runtime configure --runtime=docker
  - systemctl restart docker
  # --- GPU smoke tests ---
  - docker run --rm --gpus all nvidia/cuda:12.3.0-base-ubuntu22.04 nvidia-smi
  - docker run --rm --gpus all nvidia/cuda:12.3.0-base-ubuntu22.04 nvidia-smi -L
```

### Launch the VM

```bash
multipass launch 22.04 \
  --name docker-test \
  --cpus 2 \
  --memory 4G \
  --disk 20G \
  --gpus all \
  --cloud-init setup.yaml
```

Remove `--gpus all` if you only want to test the Docker steps without GPU passthrough.

### Follow the logs in real time

```bash
multipass exec docker-test -- tail -f /var/log/cloud-init-output.log
```

### GPU passthrough prerequisites

The `--gpus` flag requires a few things on the host:

- **IOMMU enabled** in BIOS/UEFI (`Intel VT-d` or `AMD-Vi`)
- **Multipass ≥ 1.11** with the **LXD backend** (recommended on Linux — simpler than QEMU for GPU passthrough)
- **NVIDIA drivers installed on the host** (the toolkit inside the VM relies on them)

Check and switch to the LXD backend if needed:

```bash
multipass get local.driver           # show current backend
sudo multipass set local.driver=lxd  # switch to LXD
```

### Clean up

```bash
multipass delete docker-test && multipass purge
```

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `docker: permission denied` | User not in `docker` group | Re-run `newgrp docker` or log out/in |
| `nvidia-smi` fails on host | Driver not installed | Install the NVIDIA driver first |
| `could not select device driver "" with capabilities: [[gpu]]` | Toolkit not configured | Re-run `nvidia-ctk runtime configure --runtime=docker && sudo systemctl restart docker` |
| Wrong CUDA version tag | Image tag mismatch | Check supported CUDA version with host `nvidia-smi` |
| `--gpus` flag not working in Multipass | Wrong backend or IOMMU disabled | Switch to LXD backend; enable IOMMU in BIOS |

---

## Summary

| Step | Command |
|---|---|
| Install Docker *(optional if already installed)* | `sudo apt install docker-ce ...` |
| Hello World test | `docker run hello-world` |
| Install NVIDIA toolkit | `sudo apt install nvidia-container-toolkit` |
| Configure runtime | `sudo nvidia-ctk runtime configure --runtime=docker` |
| GPU smoke test | `docker run --rm --gpus all nvidia/cuda:... nvidia-smi` |
| Save an image | `docker save my-image:tag -o my-image.tar` |
| Restore an image | `docker load -i my-image.tar` |
| Automated test VM | `multipass launch --cloud-init setup.yaml --gpus all` |