# IAR flavoured Device Tree Tools for the Freedom SDK

This library is based on the 
[SiFive Freedom Device Tree Tools library](https://github.com/sifive/freedom-devicetree-tools), 
but has been modified to be work with the IAR toolchain. Check the SiFive
repository for the original library documentation.

__The IAR flavoured Freedom Device Tree Tools library 
is provided as-is, and there is no guarantee of its status and that it will be 
maintained.__

## Setup
This library should be used to generate bare metal device files which is 
needed in order to use the
[IAR version of the Freedom Metal library](https://github.com/IARSystems/iar-freedom-metal).

To simplify the file generating process, IAR are providing a simple bash 
script that do most of the steps automatically. The script can be found 
at /scripts/metalify.sh and will need the path to this library, a path to the 
IAR Freedom Metal library and a path to the device tree specific files that
you aim to build for (the 
[SiFive Freedom E SDK](https://github.com/sifive/freedom-e-sdk) 
contain theese kind of files):

    $ ./scripts/metalify.sh -d /SiFive/fredom-e-sdk/bsp/freedom-e310-arty -t /SiFive/iar-freedom-devictree-tools -m /SiFive/iar-freedom-metal

If everything is going as intended, the new generated files should now 
populate the IAR Freedom Metal repo in the following fashion:

    freedom-metal
    └── metal
        ├── machine
        │   ├── inline.h
        |   └── platform.h
        └── machine.h
