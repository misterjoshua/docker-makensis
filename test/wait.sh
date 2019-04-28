#!/bin/sh

function show_usage() {
    echo "Usage: $1 /path/toreadyfile <timeout|ready>"
}

function wait_ready() {
    touch $1
}

function wait_reset() {
    rm -f $1
}

function wait_test() {
    READY_CONDITION=$1

    if [ -f "$READY_CONDITION" ]; then
        return 0
    else
        return 1
    fi
}

function wait_for() {
    READY_CONDITION=$1
    TIMEOUT=$2

    for i in `seq $TIMEOUT`; do
        if wait_test $READY_CONDITION; then
            return
        else
            sleep 1
        fi
    done

    echo "Timed out waiting for $READY_CONDITION after $TIMEOUT seconds" >&2
    exit 1
}

# ============================
# Script begins here
# ============================

# wait.sh /path/to/readyfile 300
# wait.sh /path/to/readyfile ready

set -ex

READY_CONDITION=$1
if [ -z "$READY_CONDITION" ]; then
    show_usage $0
    exit 1
fi

TIMEOUT=$2
if [ "$TIMEOUT" = "reset" ]; then
    wait_reset $READY_CONDITION
elif [ "$TIMEOUT" = "ready" ]; then
    wait_ready $READY_CONDITION
elif [[ $TIMEOUT -gt 0 ]]; then
    wait_for $READY_CONDITION $TIMEOUT
fi