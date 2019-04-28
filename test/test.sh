#!/bin/bash

set -ex
HERE=$(dirname $0)

$HERE/wait.sh $1/test.exe 30
sleep 2
$HERE/test-exe.sh $1/test.exe