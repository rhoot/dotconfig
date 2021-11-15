#!/bin/bash

# Wraps flameshot to ensure the output directory - if specified - is created

get_output_dir()
{
    while [ "$1" != "" ]
    do
        case "$1" in
            "-p")
                shift
                echo "$1"
                exit
                ;;
        esac
        shift
    done
    exit 1
}

outputdir="$(get_output_dir $@)"

if [ $? -eq 0 ]; then
    mkdir -p "$outputdir"
fi

flameshot $@
