# MCollective `apt-get update` agent

This is an MCollective agent and application that can execute `apt-get update` for every repository 
configured on a system, or only for given repositories defined in files in `/etc/apt/sources.list.d`.

You could use this to drive automation inside your own package building system - 
in order to tell every machine there have been packages uploaded to your custom repository
from your build system (e.g. Jenkins).

## Usage

The agent supports two actions, `list` and `update`.

### `list`

The `list` action lists the available repositories that can be updated. Each repository defined
in `/etc/apt/sources.list.d` in a separate file will be listed.

For example, if I have the following files on my nodes:

    /etc/apt/sources.list.d/custom.list
    /etc/apt/sources.list.d/docker.list
    /etc/apt/sources.list.d/main.list

The list action will return these three repositories:

    root@server:~# mco aptupdate list
    
     * [ ============================================================> ] 1 / 1
     
    server.forward3d.com                 : custom, docker, main

### `update`

The `update` action updates either every repository defined on the system, or a specific one.

To update every repository, simply execute the agent without any arguments:

    mco aptupdate update

If you want to update a single repository (for example, maybe you push packages into this repository from
a build system), then supply the name of the repository as an argument.

    mco aptupdate update custom

## Packaging

Like all MCollective agents, you can generate packages for this package very simply:

    git clone https://github.com/forward3d/mcollective-aptupdate-agent
    mco plugin package
  
This will generate packages for whatever platform you're currently on. Consult the MCollective documentation
for more information.