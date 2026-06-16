# Tutorial 06 : PPO Locomotion

This README provides a step-by-step guide on how to retrieve the project code, download the necessary Docker image, run the isolated container, and ensure that graphical environments (like Reinforcement Learning simulations) render correctly on your screen.

# 1. Prerequisites

To ensure a smooth and reproducible experience without installing complex dependencies directly on your host machine, this project relies on Docker. Docker creates an isolated environment (a "container") where all the required libraries and tools are already configured.

Before starting, verify that both Docker and Docker Compose are installed and running on your system.

Open your terminal and run the following commands:

```bash
docker --version
docker compose version
```

# 2. Download the code

Next, you need to download the repository containing the configuration files and the code for the Summer School.

We use git to clone the repository from GitHub to your local machine, and then we navigate into the newly created folder:

```bash
git clone https://github.com/TheoBounac/SUMMER-SCHOOL-RL.git
cd SUMMER-SCHOOL-RL
```

# 3. Authorize Graphical Display (GUI Forwarding)

Reinforcement Learning (RL) projects often require a graphical interface to render environments and watch the agents learn (e.g., viewing a simulated robot or a game screen). Because Docker containers run in strict isolation, they do not have direct permission to open windows on your host computer's screen.
To fix this, we need to grant the Docker container permission to communicate with your machine's X11 display server.

Run the following command:

```bash
xhost +local:docker
```
xhost: A utility to control access to the X server (your display).
+local:docker: Explicitly grants permission to local Docker containers to connect to your display and open graphical windows. (Note: This step is primarily for Linux users. Windows/macOS users may need additional tools like VcXsrv or XQuartz).

# 4. Run the Docker Container

Now that the code is downloaded and the display permissions are set, you can launch the container. Docker Compose will read the configuration file, automatically download (pull) the required image if you don't have it yet, and start the environment.

Run the following command:

```bash
docker compose -f docker/docker-compose.yml run --rm summer-school-rl
```