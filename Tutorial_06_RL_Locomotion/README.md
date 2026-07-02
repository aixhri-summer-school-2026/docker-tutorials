# Tutorial 06 : PPO Locomotion

> It is **recommended** to use the [`run_all_setup.sh`](./run_all_setup.sh) script to download the entire codebase. If you prefer to download only this tutorial, you can instead follow the instructions below.

If you haven't already, clone this repository and navigate to the tutorial directory:
```bash
git clone https://github.com/aixhri-summer-school-2026/docker-tutorials.git
cd docker-tutorials/Tutorial_06_RL_Locomotion
```

Make the tutorial setup script executable:
```bash
chmod +x setup_tutorial_06.sh
```

Run the setup script and specify the destination directory where the tutorial should be installed. The script will automatically create the target directory if it does not exist and set up all the required files.
```bash
./setup_tutorial_07.sh <path_to_directory>/Tutorial_06_RL_Locomotion
```
For example:
```bash
./setup_tutorial_07.sh ~/aixhri-summer-school/Tutorial_06_RL_Locomotion
```

## 2. Run the tutorial

Once the tutorial is publicly available, the complete instructions will be available at:

[`https://github.com/aixhri-summer-school-2026/Tutorial_06_RL_Locomotion`](https://github.com/aixhri-summer-school-2026/Tutorial_06_RL_Locomotion)


You can therefore follow the main tutorial **while skipping the image build command**.

First, navigate to the tutorial directory:
```bash
cd ~/aixhri-summer-school/Tutorial_06_RL_Locomotion
```

Update the repository to ensure you have the latest version of the tutorial:
```bash
git pull
```

Allow Docker to access the graphical display
```bash
xhost +local:docker
```

You can then resume the tutorial from the section shown below:
<p style="text-align: left;">
  <img src="../docs/tutorial-06.png" width="700" alt="nvidia-smi output">
  <br>
</p>

You can now download the next practical session: [Tutorial_07_PoseAction](../Tutorial_07_PoseAction)