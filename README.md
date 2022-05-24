# IAR flavoured Device Tree Tools for the Freedom SDK

This library is based on the 
[SiFive Freedom Device Tree Tools library](https://github.com/sifive/freedom-devicetree-tools), 
but has been modified to be work with the IAR toolchain. Check the SiFive
repository for the original library documentation.

__The IAR flavoured Freedom Device Tree Tools library 
is provided as-is, and there is no guarantee of its status and that it will be 
maintained.__

# Prerequisites
Downloading and building the SiFive Metal libraries currently requires Linux 
and a few packages like g++, make, libfdt etc.

Under Windows you can install the Ubuntu WSL (Windows Subsystem for Linux) 
in order to make and create the SiFive Metal library in a way that is usable 
for the EWRISCV (IAR Embedded Workbench for RISC-V).

Before we can make the SiFive Metal libraries we need to make sure we 
have installed the required packages. In the Linux terminal window, run the
following command to fetch and update the required packages:

    $ sudo apt install -y g++ make device-tree-compiler libfdt-dev

## Setup
This library should be used to generate bare metal device files which is 
needed in order to use the
[IAR version of the Freedom Metal library](https://github.com/IARSystems/iar-freedom-metal).

Make sure you are located in the _iar-freedom-devicetree-tools_ directory 
and use autoconf to setup the configuration:

    $ ./configure

And simply use make to build the tools with g++:

    $ make

This takes a few minutes but when finished, the tools are ready to be used.

To simplify the file generating process, IAR are providing a simple bash 
script that do most of the steps automatically. The script can be found 
at /scripts/metalify.sh and will need the path to this library, a path to the 
IAR Freedom Metal library and a path to the device tree specific files that
you aim to build for (the 
[SiFive Freedom E SDK](https://github.com/sifive/freedom-e-sdk) 
contain theese kind of files):

    $ ./scripts/metalify.sh -d /SiFive/fredom-e-sdk/bsp/freedom-e310-arty -t /SiFive/iar-freedom-devictree-tools -m /SiFive/iar-freedom-metal

Check the script to get a better understanding of what is going on, but in 
short:

1. Generate DTB files from the DTS files (generally in the _freedom-e-sdk_ 
   repository for the device you are building for).

2. Generate the device header files from the DTB files

3. Create and move the generated headers to the _iar-freedom-metal_ 
   repository.

If everything is going as intended, the new generated files should now 
populate the IAR Freedom Metal repo in the following fashion:

    iar-freedom-metal
    └── metal
        ├── machine
        │   ├── inline.h
        |   └── platform.h
        └── machine.h
