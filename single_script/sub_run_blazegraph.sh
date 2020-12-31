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
            if [ -d $2 ]; then
                echo -n " -> delete directory: $2"
                rm -r $2
            fi
        fi
        echo ""
        exit -1
    fi
}

# check whether server is running...
if [ curl -Is http://localhost:9999/bigdata 2>/dev/null | grep "HTTP/1.1" 1>/dev/null ]; then
    # Page is up and running!
    echo "Server 'http://localhost:9999/bigdata' is available"
else
    # Server is not running...
    echo "Server is not running... Starting server now..."
    nohup 2>&1 sh -c "HOST=0.0.0.0 ./service/Blazegraph.sh" &> /service/blazegraph.log &
    echo "Server started... Wait 10 secs until availability check..."
    sleep 10
    echo "Checking availability..."
    curl -Is http://localhost:9999/bigdata 2>/dev/null | grep "HTTP/1.1" 1>/dev/null
    checkSuccess $?
fi
 