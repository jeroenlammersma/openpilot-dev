![repo_header](https://user-images.githubusercontent.com/33349469/187457910-bd12e99a-7e36-4528-b009-286c1a7d0938.png)


What is openpilot-dev?
------

[openpilot-dev](http://github.com/jeroenlammersma/openpilot-dev) is is an interactive setup that simplifies and automates the process of setting up an [openpilot](http://github.com/commaai/openpilot) development environment. It also contains a collection of convenient scripts.


System Requirements
------

openpilot-dev is developed for **Ubuntu 20.04**, thereby aligning it with the same [system requirements](https://github.com/commaai/openpilot/tree/master/tools#system-requirements) as openpilot. It may, however, also work on macOS, but this is untested. For the best experience, stick to Ubuntu 20.04, otherwise openpilot and the tools should work with minimal to no modifications on macOS and other Linux systems.


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


Custom configuration
------

The setup will load [config.defaults](https://github.com/jeroenlammersma/openpilot-dev/blob/master/setup/config.defaults) as default configuration. This will set variables for openpilot (such as the repository) and CARLA version. To override the default configuration, create a file 'config' in the setup directory. Best is to copy config.default:
``` bash
cd setup
cp config.default config
```
Now edit the config file. It is possible to only add the variables you want to override in this file, because before checking for a custom config and overriding variables, the default configuration will always be loaded anyway.


Directory Structure
------
    .
    └── carla                         # Run openpilot in a simulator
        └── scenario_runner           # Run traffic scenarios in the simulator
        logs                          # Convenient scripts for openpilot logs
        openpilot                     # Convenient scripts for openpilot
        setup                         # Set up the dev environment
        ├── carla                     # CARLA simulator setup
        ├── dev-env                   # poetry setup
        ├── drivers                   # Utilities for drivers
        │   ├── nvidia-graphics       # Autoinstall recommended NVIDIA driver
        │   └── wifi-adapter-88x2bu   # Driver for Realtek Wi-Fi adapter (RTL88x2bu chipsets)
        ├── lib                       # Contains helper functions
        ├── openpilot                 # Complete openpilot setup
        └── tools                     # Useful development tools
