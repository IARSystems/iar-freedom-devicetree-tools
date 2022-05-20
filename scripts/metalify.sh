#!/bin/bash

usage() {
    echo
    echo "Usage:"
    echo "$0 -d <design_repo> -t <tools_repo> -m <metal_repo>"
    echo "Where:"
    echo "<design-repo> is the full path to the repo containing the .dts" \
    "design files"
    echo "<tools-repo> is the full path to the freedom-devicetree-tools repo."
    echo "<metal-repo> is the full path to the freedom-metal repo."
    echo
}

help_message() {
    echo
    echo "Given the correct input, this script will generate the required"\
    "header files necessary to build a project using the freedom-metal"\
    "library."
    echo "The generated files will be moved to the correct place in the"\
    "freedom-metal repository. You should find the new generated files as:"
    echo
    echo "freedom-metal"
    echo "└── metal"
    echo "    ├── machine"
    echo "    │   ├── inline.h"
    echo "    |   └── platform.h"
    echo "    └── machine.h"
    usage
}

# Check input args and setup variables
while getopts d:t:m:h flag
do
    case "${flag}" in
        d)
            DESIGN_REPO=${OPTARG}
            ;;
        t)
            FREEDOM_DEVICE_TOOLS_REPO=${OPTARG}
            ;;
        m)
            FREEDOM_METAL_REPO=${OPTARG}
            ;;
        h)
            help_message
            exit 0
    esac
done

if [ -z ${DESIGN_REPO+x} ]; then
    echo
    echo "Error: design repo must be set" 2>&1
    usage
    exit 1
fi
if [ -z ${FREEDOM_DEVICE_TOOLS_REPO+x} ]; then
    echo
    echo "Error: freedom-device-tools repo must be set" 2>&1
    usage
    exit 1
fi
if [ -z ${FREEDOM_METAL_REPO+x} ]; then
    echo
    echo "Error: freedom-metal repo must be set" 2>&1
    usage
    exit 1
fi

DTS_FILE=${DESIGN_REPO}/design.dts
DTB_FILE=${DESIGN_REPO}/design.dtb
if [[ -f "${DTB_FILE}" ]]; then
    rm ${DTB_FILE}
fi

#Create DTB from DTS
cd ${DESIGN_REPO}
dtc -I dts -o dtb -o ${DTB_FILE} ${DTS_FILE}

#Generate device header files from the .dtb
${FREEDOM_DEVICE_TOOLS_REPO}/freedom-metal_header-generator\
 -d ${DTB_FILE} -o machine.h
${FREEDOM_DEVICE_TOOLS_REPO}/freedom-bare_header-generator\
 -d ${DTB_FILE} -o platform.h

#Create and move generated headers to output folder
if [[ -d "./machine" ]]; then
    rm -rf ./machine
fi
mkdir machine
mv ./machine-inline.h machine/inline.h #Also rename file
mv ./platform.h machine/platform.h
if [[ -d "${FREEDOM_METAL_REPO}/metal/machine" ]]; then
    rm -rf ${FREEDOM_METAL_REPO}/metal/machine
fi
rsync -a ./machine ${FREEDOM_METAL_REPO}/metal/

if [[ -f "${FREEDOM_METAL_REPO}/metal/machine.h" ]]; then
    rm ${FREEDOM_METAL_REPO}/metal/machine.h
fi
mv ./machine.h ${FREEDOM_METAL_REPO}/metal/
