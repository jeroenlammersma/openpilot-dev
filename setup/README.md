# Setup
The following instructions can be used to set up a openpilot development environment.

## Table of Contents

* [Requirements](#requirements)
* [Automatic setup](#automatic-setup)
* [Manual setup](#manual-setup)
* [(Manually) run openpilot in the simulator](#manually-run-openpilot-in-the-simulator)

## Requirements
You **must** use Ubuntu 20.04.

## Automatic setup
Easiest option. Just follow the instructions found [here](https://github.com/jeroenlammersma/openpilot-dev/tree/pipenv-2-poetry#setup-the-environment).
**IMPORTANT:** use the [pipenv-2-poetry](https://github.com/jeroenlammersma/openpilot-dev/tree/pipenv-2-poetry) branch of this repo when running the setup.

**At the moment** it is recommended to manually install openpilot (see instructions below) and then skip openpilot setup during the interactive setup (when asked for full setup, choose 'no').

You can, however, use this interactive setup to install CARLA, recommended drivers, configure openpilot-dev environment to make use of useful scripts, et cetera.

## Manual setup
### openpilot
First clone the openpilot repo on the `working-sim` branch:
  
```bash
git clone https://github.com/jeroenlammersma/openpilot --branch working-sim --recurse-submodules 
```
<sup>(use `working-sim-color` or alternatively `working-sim-color-opencl` for colored output)</sup>

Then, run the setup script:
```bash
cd openpilot
tools/ubuntu_setup.sh
```

Reload bashrc and activate a shell with the installed Python dependencies:
```bash
source ~/.bashrc
cd openpilot && pipenv shell
```

Build openpilot with this command:
```bash
scons -u -j$(nproc)
```

### CARLA
Start by adding the CARLA repository:

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1AF1527DE64CB8D9
sudo add-apt-repository "deb [arch=amd64] http://dist.carla.org/carla $(lsb_release -sc) main" > /dev/null
```

Then, install CARLA:
```bash
sudo apt-get update > /dev/null
sudo apt-get install -y carla-simulator=0.9.13
```

Add the following to your bashrc file by executing these commands:
```bash
printf '\n%s' "export CARLA_ROOT=/opt/carla-simulator" >> ~/.bashrc
printf '\n%s' "export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/carla/dist/carla-3.8.egg:${CARLA_ROOT}/PythonAPI/carla/agents:${CARLA_ROOT}/PythonAPI/carla" >> ~/.bashrc
```
<sup>Or add these exports manually at the end of your bashrc file.</sup>

To run CARLA, execute the following:
```bash
/opt/carla-simulator/CarlaUE4.sh
```
<sup>To start CARLA in off-screen mode, add the following flag: `-RenderOffScreen`. See the carla docs about [rendering options](https://carla.readthedocs.io/en/latest/adv_rendering_options/#off-screen-mode) for details.</sup>

### Update NVIDIA drivers (optional)
Is, however, recommended. Execute the script found [here](https://github.com/jeroenlammersma/openpilot-dev/blob/pipenv-2-poetry/setup/drivers/nvidia-graphics/autoinstall-recommended.sh), or manually update your drivers.

## (Manually) run openpilot in the simulator
Make sure CARLA is running. Then, using 2 shells, execute the following:

**shell 1**
```bash
cd openpilot
pipenv shell
cd tools/sim
./launch_openpilot.sh
```

**shell 2**
```bash
cd openpilot
pipenv shell
cd tools/sim
./bridge.py
```
For more information, see the instructions found [here](https://github.com/jeroenlammersma/openpilot/tree/working-sim/tools/sim).
See [Bridge usage](https://github.com/jeroenlammersma/openpilot/tree/working-sim/tools/sim#bridge-usage) for options you can pass to the bridge.
