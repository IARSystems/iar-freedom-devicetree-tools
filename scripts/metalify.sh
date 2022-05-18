#!/bin/bash

# Check input args and setup variables
while getopts a:f:m: flag
do
    case "${flag}" in
        a)
            ARTIFACT_REPO=${OPTARG}
            ;;
        f)
            FREEDOM_DEVICE_TOOLS_REPO=${OPTARG}
            ;;
        m)
            FREEDOM_METAL_REPO=${OPTARG}
            ;;
    esac
done

if [ -z ${ARTIFACT_REPO+x} ]; then
    echo "Artifact repo must be set"
    exit 1
fi
if [ -z ${FREEDOM_DEVICE_TOOLS_REPO+x} ]; then
    echo "freedom-device-tools repo must be set"
    exit 1
fi
if [ -z ${FREEDOM_METAL_REPO+x} ]; then
    echo "freedom-metal repo must be set"
    exit 1
fi

DESIGN_ARTY_FOLDER=${ARTIFACT_REPO}/freedom-e-sdk/bsp/design-arty
DTS_FILE=${DESIGN_ARTY_FOLDER}/design.dts
DTB_FILE=${DESIGN_ARTY_FOLDER}/design.dtb
if [[ -f "${DTB_FILE}" ]]; then
    rm ${DTB_FILE}
fi

#Create DTB from DTS
cd ${DESIGN_ARTY_FOLDER}
dtc -I dts -o dtb -o ${DTB_FILE} ${DTS_FILE}

#Generate device header files from the .dtb
${FREEDOM_DEVICE_TOOLS_REPO}/freedom-metal_header-generator -d ${DTB_FILE} -o machine.h
${FREEDOM_DEVICE_TOOLS_REPO}/freedom-bare_header-generator -d ${DTB_FILE} -o platform.h

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
