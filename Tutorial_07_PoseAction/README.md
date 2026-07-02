# Tutorial 07 : Pose Action

## 1. Download the tutorial

> It is **recommended** to use the [`run_all_setup.sh`](./run_all_setup.sh) script to download the entire codebase. If you prefer to download only this tutorial, you can instead follow the instructions below.

If you haven't already, clone this repository and navigate to the tutorial directory:
```bash
git clone https://github.com/aixhri-summer-school-2026/docker-tutorials.git
cd docker-tutorials/Tutorial_07_PoseAction
```

Make the tutorial setup script executable:
```bash
chmod +x setup_tutorial_07.sh
```

Run the setup script and specify the destination directory where the tutorial should be installed. The script will automatically create the target directory if it does not exist and set up all the required files.
```bash
./setup_tutorial_07.sh <path_to_directory>/Tutorial_07_PoseAction
```
For example:
```bash
./setup_tutorial_07.sh ~/aixhri-summer-school/Tutorial_07_PoseAction
```

## 2. Run the tutorial

Once the tutorial is publicly available, the complete instructions will be available at:

[`https://github.com/aixhri-summer-school-2026/Tutorial_07_PoseAction`](https://github.com/aixhri-summer-school-2026/Tutorial_07_PoseAction)

You can therefore follow the main tutorial **while skipping the image build command**.

First, navigate to the tutorial directory:
```bash
cd ~/aixhri-summer-school/Tutorial_07_PoseAction
```

Update the repository to ensure you have the latest version of the tutorial:
```bash
git pull
```

Install udev rules (USB + camera symlink):
```bash
make install-rules
```

You can then resume the tutorial from the section shown below:
<p style="text-align: left;">
  <img src="../docs/tutorial-07.png" width="700" alt="nvidia-smi output">
  <br>
</p>

You can now download the next practical session: [Tutorial_08_Gemini_Robotics](../Tutorial_08_Gemini_Robotics)