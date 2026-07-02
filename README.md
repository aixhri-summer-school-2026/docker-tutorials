# Welcome to the AI & Human-Robot Interaction Summer School 🤖

This repository contains all the instructions and materials for the practical sessions you will attend during the event.

We ask you to download all practical sessions **before the start of the event** to avoid configuration issues.

---

## Prerequisites

Please make sure your system meets the following requirements. Otherwise, we cannot guarantee that all practical sessions will run correctly on your machine. If you encounter any issues while installing the images, please contact us.

- **Operating system**: Ubuntu 20.04, 22.04, or 24.04 (64-bit).
- **Storage space**: ~150 GB available
- **Tools**: Docker configured with NVIDIA support & Git installed  
  see: [`nvidia-docker-setup`](./nvidia-docker-setup)

## Downloading all tutorials

We recommend creating a dedicated folder on your machine named aixhri-summer-school to store all practical sessions. Then run the following commands to set it up:
```bash
mkdir aixhri-summer-school
cd aixhri-summer-school
```

Next, clone the repository that contains the setup scripts:
```bash
git clone https://github.com/aixhri-summer-school-2026/docker-tutorials.git
cd docker-tutorials
```

The script [`run_all_setup.sh`](./run_all_setup.sh) lets you choose between two options:

1. **Download all tutorials at once** – it automatically executes every individual setup script (`setup_tutorial_??.sh`).
2. **Download tutorials one by one** – you can run the corresponding `setup_tutorial_??.sh` script inside each tutorial folder.

`run_all_setup.sh` requires one argument: the path to the directory where all Git repositories will be cloned. If you provide a custom path, make sure to include the trailing `/` at the end.

Before running it, make it executable:
```bash
chmod +x run_all_setup.sh
```

Then run:

```bash
./run_all_setup.sh ../
cd ..
```

### Updating repositories
Depending on the tutorial and when you ran the setup, you may need to update the repositories manually at the beginning of the practical session. To do so, go into the relevant tutorial folder and run:
```bash
git pull
```

---

## Tutorial Status

The table below shows the status of each tutorial, indicating whether it has been completed or is still in progress.

| Tutorial | Folder | Description |  Status |
|----------|--------|-------------|---------|
| 1 | [Tutorial_01_Finetuning_LLM](./Tutorial_01_Finetuning_LLM) | Fine-tuning a LLM | 🚧 Building |
| 2 | [Tutorial_02_Chat_with_your_robot](./Tutorial_02_Chat_with_your_robot) | Using LLM/VLM to interact with a robot | ✅ OK |
| 3 | [Tutorial_03_Flow_Matching](./Tutorial_03_Flow_Matching) | Flow Matching | 🚧 Building |
| 4 | [Tutorial_04_FlowerVLA](./Tutorial_04_FlowerVLA) | FlowerVLA | 🚧 Building |
| 5 | [Tutorial_05_RL_Human_Feedback](./Tutorial_05_RL_Human_Feedback) | RL with human feedback | ✅ OK |
| 6 | [Tutorial_06_PPO_Locomotion](./Tutorial_06_PPO_Locomotion) | PPO & expressive locomotion | ✅ OK |
| 7 | [Tutorial_07_PoseAction](./Tutorial_07_PoseAction) | Hand & person tracking | 🚧 Building |
| 8 | [Tutorial_08_Gemini_Robotics](./Tutorial_08_Gemini_Robotics) | Gemini Robotics tutorial | 🚧 Building |
| 9 | [Tutorial_09_Social_Robot_Navigation](./Tutorial_09_Social_Robot_Navigation) | Social navigation | 🚧 Building |

---