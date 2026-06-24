# Tutorial 02 : Chat with robots

This README explains how to retrieve the project code, download the required Docker image, and run the container in an isolated environment.

# 1. Download the code

You need to download the repository containing the configuration files and the code for the practical session. We use Git to clone the repository from GitHub to your local machine:

```bash
git clone https://github.com/aixhri-summer-school-2026/Tutorial_02_Chat_with_your_robot.git
cd Tutorial_02_Chat_with_your_robot
```

# 2. Download the image

Run the following command:

```bash
docker pull aixhrisummerschool2026/aixhri-summer-school-2026:Tutorial_02_Chat_with_your_robot
```
It downloads the pre-built environment on your local machine that contains all the librairies, dependencies and tools for the practical session.

## 2.1 Verify that the image has been pulled

You can run:
```bash
docker image ls aixhrisummerschool2026/aixhri-summer-school-2026:Tutorial_02_Chat_with_your_robot
```
<!-- You should see output similar to the following:
<p style="text-align: left;">
  <img src="../docs/images/docker-pull-02.png" width="1000">
  <br>
</p> -->

You can now download the next practical session: [Tutorial_03_Flow_Matching](../Tutorial_03_Flow_Matching)