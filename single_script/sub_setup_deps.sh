#!/bin/bash

old_cwd=$(pwd)
cd $(dirname "$0")


# Check last command and remove file if given
checkSuccess() {
    if [ $1 -eq 0 ]; then 
        echo "...succeeded."
    else
        echo -n "...but execution FAILED!"
        if [ ! -z $2 ]; then
            if [ -f $2 ]; then
                echo -n " -> delete file: $2"
                rm $2
            fi
        fi
        echo ""
        exit -1
    fi
}

# check required commands
required_commands=(
    "wget"
    "curl"
    "java"
    "mvn"
    "tar"
)

ubuntu_packages=(
    "wget"
    "curl"
    "openjdk-8-jdk-headless"
    "maven"
    "tar"
)


# Install every missing command
pkg_index_updated=""
for (( i=0; i<${#required_commands[*]}; ++i)); do
    cmd=${required_commands[$i]}
    pkg=${ubuntu_packages[$i]}

    if ! which $cmd 2>&1 >/dev/null; then
        # command is missing
        if [ -n "$(uname -a | grep Ubuntu)" ]; then
            # Check whether we need to update the package index
            if [ -z $pkg_index_updated ]; then
                echo "Updating package index..."
                sudo apt-get update -y
                checkSuccess $?
                pkg_index_updated="updated"
            fi
            echo "Installing package $pkg that provides command $cmd..."
            sudo apt-get install -y $pkg
            checkSuccess $?
        else
            echo "Please install command: $cmd"
            exit -1
        fi
    else
        echo "Command $cmd found."
    fi
done

if java -version 2>&1 | grep "version" | grep "1.8" 1>/dev/null 2>&1 ; then
    echo "Installed Java version seems to be Java 8."
else
    echo "Installed Java version is not Java 8."
    exit -1
fi