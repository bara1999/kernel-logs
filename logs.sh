#!/usr/bin/env bash

LOG_STORAGE_PATH="/home/baraa/Desktop/logs"
COMPRESSED_STORAGE_PATH="/home/baraa/Desktop/logs"

CURRENT_DATE=$(date +"%Y-%m-%dT%H-%M")
LOG_FILE_NAME="kernel-logs-$CURRENT_DATE.txt"
COMPRESSED_FILE_NAME="kernel-logs-$CURRENT_DATE.tar.bz2"

journalctl -k --since "1 hour ago" > "$LOG_STORAGE_PATH/$LOG_FILE_NAME"

tar -cjf "$COMPRESSED_STORAGE_PATH/$COMPRESSED_FILE_NAME" -C "$LOG_STORAGE_PATH" "$LOG_FILE_NAME"
curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer sl.BkGYaANpT73UIq3n33lCrnjOWLeNA8yIK5GcMCUeRjGLC83iuX9BcZ1e7igEEbb-eRzbmMSqUcqgfoPmtIMxMpu9gLsOyNlPSzbejTCcrJVM8d5vdqpEW5wCLIYlQeCV_mJ8f9RDuiX6zFU" \
    --header "Dropbox-API-Arg: {\"path\": \"/$COMPRESSED_FILE_NAME\"}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @"$COMPRESSED_STORAGE_PATH/$COMPRESSED_FILE_NAME"
