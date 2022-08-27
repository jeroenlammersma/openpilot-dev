![repo_header](https://user-images.githubusercontent.com/33349469/185484492-f25ba6e1-c341-4070-b3dc-9c23c4143a49.png)

What is openpilot-dev?
------

[openpilot-dev](http://github.com/jeroenlammersma/openpilot-dev) is is an interactive setup that simplifies and automates the process of setting up an [openpilot](http://github.com/commaai/openpilot) development environment. It also contains a collection of convenient scripts.

Setup the environment
------

First, clone openpilot-dev:
``` bash
cd ~
git clone https://github.com/jeroenlammersma/openpilot-dev

cd openpilot-dev 
git submodule update --init
```

Then, run the setup script:

``` bash
setup/setup.sh
```

This wil start an interactive shell which will guide you through the setup.

Directory Structure
------
    .
    └── carla                         # Run openpilot in a simulator
        └── scenario_runner           # Run traffic scenarios in the simulator
        logs                          # Convenient scripts for openpilot logs
        openpilot                     # Convenient scripts for openpilot
        setup                         # Set up the dev environment 
        ├── carla                     # CARLA simulator setup
        ├── dev-env                   # Pipenv setup
        ├── drivers                   # Utilities for drivers
        │   ├── nvidia-graphics       # Autoinstall recommended NVIDIA driver
        │   └── wifi-adapter-88x2bu   # Driver for Realtek Wi-Fi adapter (RTL88x2bu chipsets)
        ├── lib                       # Contains helper functions
        ├── openpilot                 # Complete openpilot setup
        └── tools                     # Useful development tools
