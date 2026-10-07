#!/bin/bash 

# log-archiver.sh

# This scripts compresses a given logs directory and stores it in
# /var/log/archives 
# The archived file uses a timestamped name for better record keeping 
# It also maintains an audit logged named audit_log.txt in the archives directory 
# How to use: sudo ./log_archiver.sh <log_directory> 
# Example: sudo ./log_archiver.sh /var/log

if [ $# -ne 1 ]; then
    echo "The script requires the target directory as input to run."
    echo "Please provide the path which needs to be archived."
    exit 1
fi

target_directory=$1

timestamp=$(date +'%Y%m%d_%H%M%S')

filename="logs_archive_${timestamp}.tar.gz"
destination_directory="/var/log/archives"
audit_log="${destination_directory}/archive_history.txt"
full_path="${destination_directory}/${filename}"

if [ ! -d "$destination_directory" ]; then 
     mkdir -p "$destination_directory"
    echo "Directory created: ${destination_directory}"
fi

# echo "target directory: $target_directory"
echo "${full_path}"


# excluding the backup folder from tar
tar  --exclude="$destination_directory" -czvf "$full_path" "$target_directory"

echo "[(${timestamp})] Archived $target_directory to ${full_path}" >> "${audit_log}" 

echo "Logs archived in ${destination_directory}"


