#!/bin/bash

####################################################################################################################
# openSUSE Provisioning Software (oSPS)
#
# Author        Nichtbinär <nichtbinar@gmail.com>
# URL           https://github.com/nichtbinar/oSPS/
# Copyright     (c) 2023 Nichtbinär. All Rights Reserved.
#
# Permission to copy and modify is granted under the GPL v3 license.
# Last revised  20/02/2023
####################################################################################################################

# Current version.
VERSION="0.0.1"

# Colours for outputting installation information.
TXTBP='\033[1;95m'
TXTNC='\033[0m'

####################################################################################################################
# FUNCTIONS.
#
# Main functions:
# Help      Print help information.
# Category  Category-based package installations.
# Machine   Machine-based package installations.
# Version   Print current version information + copyright.
#
# Helper functions:
# RepositoriesHandler   Add repositories via zypper.
# PackagesHandler       Grab packages from a file (supplied via a variable).
####################################################################################################################

Help()
{
    echo "SYNOPSYS"
    echo "${0} [-r|-c|-m|-V|-v|-h] or [--repositories|--category|--machine|--verbose|--version|--help] args ..."
    echo
    echo "DESCRIPTION"
    echo "openSUSE Provisioning Software (oSPS) handles post-install provisioning of your system via package "
    echo "installations, either by category or machine (dependent on user input)."
    echo
    echo "OPTIONS"
    echo "-r|--repositories Add appropriate repositories specified in data/repositories.txt"
    echo "-c|--category     Install packages listed in specified category (data/pkglists/<category>.txt)"
    echo "-m|--machine      Install packages listed for specified machine (data/pkglists/<machine>.txt)"
    echo "-V|--verbose      Execute oSPS in verbose mode (more details will be outputted to terminal)"
    echo "-v|--version      Current version of oSPS"
    echo "-h|--help         Print this menu"
    echo
    echo "EXAMPLES"
    echo "${0} --category admin.txt"
    echo "${0} --machine ace.txt"
    echo "${0} --repositories"
    echo
    echo "IMPLEMENTATION"
    echo "version   ${VERSION}"
    echo "author    Nichtbinär <nichtbinar@gmail.com>"
    echo "copyright Copyright (c) 2023 Nichtbinär. All Rights Reserved."
    echo "license   GNU General Public License v3"
}

Version()
{
    echo "openSUSE Provisioning Software (oSPS) ${VERSION}"
    echo
    echo "This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

Try \"${0} --help\" for more information."
    echo
    echo "IMPLEMENTATION"
    echo "version   ${VERSION}"
    echo "author    Nichtbinär <nichtbinar@gmail.com>"
    echo "copyright Copyright (c) 2023 Nichtbinär. All Rights Reserved."
    echo "license   GNU General Public License v3"
}

RepositoriesHandler()
{
    if [ -f "$path" ]
    then
        echo "${path} exists!"
    else
        echo "${path} does not exist."
    fi

    echo -e "${TXTBP}ADDING REPOSITORIES...${TXTNC}"

    while read repo
    do
        echo "${repo}"
    done <$path
    #sudo zypper dup --from packman --allow-vendor-change
    #sudo zypper refresh
}

PackagesHandler()
{
    local opt="$1"
    local file="$2"

    path="pkglists/${opt}/${file}.txt"

    if [ -f "$path" ]
    then
        while read pkg
        do
            echo "${pkg}"
        done <$path
    else
        echo "${path} does not exist."
    fi
}

####################################################################################################################
# MAIN SCRIPT.
#
# Check for switches - if provided, call appropriate functions.
####################################################################################################################

# $@ is all command line parameters passed to the script.
# -c is for specified category package installations.
# -m is for specified machine package installations.
# -V is for verbose output.
# -h is for help.
options=$(getopt -l "help,version,verbose,repositories,category,machine" -o "hv:Vrcm" -a -- "$@")
# set --:

# are set to the arguments, even if some of them begin with a ‘-’.
eval set -- "$options"

# Main loop.
while true
do
    case "$1" in
        -r|--repositories)
            RepositoriesHandler
            ;;
        -c|--category) export value="$3"
            PackagesHandler "category" "$value"
            ;;
        -m|--machine) export value="$3"
            PackagesHandler "machine" "$value"
            ;;
        -V|--verbose)
            ;;
        -v|--version)
            Version
            ;;
        -h|--help)
            Help
            exit 0
            ;;
        --)
            shift
            break;;
    esac
    shift
done
