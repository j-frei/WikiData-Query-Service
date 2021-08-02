#!/usr/bin/env bash

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
            if [ -d $2 ]; then
                echo -n " -> delete directory: $2"
                rm -r $2
            fi
        fi
        echo ""
        exit -1
    fi
}