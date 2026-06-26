# Welcome to the AI & Human-Robot Interaction Summer School 🤖

This repository contains all the instructions and materials for the practical sessions you will attend during the event.

We ask you to download all practical sessions **before the start of the event** to avoid configuration issues.

---

## Prerequisites

Please make sure your system meets the following requirements. Otherwise, we cannot guarantee that all practical sessions will run correctly on your machine. If you encounter any issues while installing the images, please contact us.

- **Operating system**: Ubuntu 20.04, 22.04, or 24.04 (64-bit).
- **Storage space**: ~100 GB available
- **Tools**: Docker configured with NVIDIA support & Git installed  
  see: [`nvidia-docker-setup`](./nvidia-docker-setup)

We recommend that you create a folder on your computer called `aixhri-summer-school` and run the instructions commands to clone the practical sessions into that folder:
```bash
mkdir aixhri-summer-school
cd aixhri-summer-school
```

---

## What you need to do

For each practical session, go to the corresponding folder and follow the instructions inside.

| Tutorial | Folder | Description |  Status |
|----------|--------|-------------|---------|
| 1 | [Tutorial_01_Finetuning_LLM](./Tutorial_01_Finetuning_LLM) | Fine-tuning a LLM | 🚧 Building |
| 2 | [Tutorial_02_Chat_with_your_robot](./Tutorial_02_Chat_with_your_robot) | Using LLM/VLM to interact with a robot | 🚧 Building |
| 3 | [Tutorial_03_Flow_Matching](./Tutorial_03_Flow_Matching) | Flow Matching | 🚧 Building |
| 4 | [Tutorial_04_FlowerVLA](./Tutorial_04_FlowerVLA) | FlowerVLA | 🚧 Building |
| 5 | [Tutorial_05_RL_Human_Feedback](./Tutorial_05_RL_Human_Feedback) | RL with human feedback | ✅ OK |
| 6 | [Tutorial_06_PPO_Locomotion](./Tutorial_06_PPO_Locomotion) | PPO & expressive locomotion | ✅ OK |
| 7 | [Tutorial_07_PoseAction](./Tutorial_07_PoseAction) | Hand & person tracking | ✅ OK |
| 8 | [Tutorial_08_Gemini_Robotics](./Tutorial_08_Gemini_Robotics) | Gemini Robotics tutorial | 🚧 Building |
| 9 | [Tutorial_09_Social_Robot_Navigation](./Tutorial_09_Social_Robot_Navigation) | Social navigation | ✅ OK |

---

## Running all setup scripts

The script [`run_all_setup.sh`](./run_all_setup.sh) automatically runs every `setup_tutorial_??.sh` script.  
**It requires one argument**: the directory where the Git repositories will be cloned.

Example usage:

```bash
chmod +x run_all_setup.sh
./run_all_setup.sh ~/summer-school
```

If you forget the argument, an error message is shown and the script stops.  
The target directory is created if it does not exist.  
Each setup script receives this directory as an argument and places its Git clone inside it.
