#!/bin/bash

function response_code() {
    RESPONSE=$1
    ABORT=$2

    CODE=$(jq <$RESPONSE ".response_code")
    if [ "$ABORT" ]; then
        if [[ ! "$CODE" || CODE -lt 0 ]]; then
            echo "$ABORT"
            cat "$1"
            exit 1
        fi
    else
        echo $CODE
    fi
}

function virustotal_scan() {
    SCAN_FILE=$1

    if [ -z "$VIRUSTOTAL_API_KEY" ]; then
        echo "Skipping Virustotal scan as no API key is present."
        return 0
    fi
    
    echo "Submitting $SCAN_FILE to Virustotal"
    curl "https://www.virustotal.com/vtapi/v2/file/scan" --form "apikey=$VIRUSTOTAL_API_KEY" --form "file=@$SCAN_FILE" >scan.tmp
    response_code scan.tmp "Virustotal did not accept the scan request"
    RESOURCE=$(jq -r <scan.tmp ".resource")

    COUNT_MAX=20
    POLL_INTERVAL=60
    for COUNT in $(seq $COUNT_MAX); do
        sleep $POLL_INTERVAL
        echo "Polling Virustotal for scan results - attempt no $COUNT of 20"
        curl "https://www.virustotal.com/vtapi/v2/file/report?apikey=$VIRUSTOTAL_API_KEY&resource=$RESOURCE" >report.tmp
        response_code=$(response_code report.tmp)

        if [[ $response_code -gt 0 ]]; then
            echo "The results are in"
            break
        fi
    done

    NUM_DETECTIONS=$(jq <report ".scans[] | select(.detected == true)" | jq -s "length")
    if [[ NUM_DETECTIONS -gt 0 ]]; then
        jq <report.tmp ".scans[] | select(.detected == true)" | jq -s
        exit 1
    fi
}

function file_exists() {
    SCAN_FILE=$1
    if [ ! -f "$SCAN_FILE" ]; then
        echo "$SCAN_FILE does not exist"
        exit 1
    fi
}

function file_is_pe() {
    SCAN_FILE=$1
    if ! file $SCAN_FILE | egrep "PE(32|64)" >/dev/null; then
        file $SCAN_FILE
        echo "$SCAN_FILE is not a PE executable"
        exit 1
    fi
}

# ============================
# Script begins here
# ============================

set -ex
FILE=$1

file_exists $FILE
file_is_pe $FILE
virustotal_scan $SCAN_FILE

echo "Passes tests"