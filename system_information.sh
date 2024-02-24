#!/bin/bash
touch /Volumes/TXT/script/mac_info.json 
# Function to get the serial number of a Mac
get_mac_serial_number() {
    serial_number=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
    echo "$serial_number"
}

# Function to get the model date of the Mac
get_model_date() {
   model_date=$(defaults read ~/Library/Preferences/com.apple.SystemProfiler.plist 'CPU Names' | cut -sd '"' -f 4 | uniq)
    echo "$model_date" | cut -c 23-26
}

get_chip() {
    chip=$(system_profiler SPHardwareDataType | grep "Processor Name" | cut -c 23-)
    echo "$chip"
}

# Function to create or update the JSON file
create_or_update_json() {
    local serial_number="$1"
    local model_year="$2"
    local screen_size="$3"
    local chip_type="$4"
    local status="$5"  # New argument for status
    local json_file="../../TXT/script/mac_info.json"
    local data=""

   
    # Check if JSON file exists
    if [ -f "$json_file" ]; then
        # Check if the JSON file has content
        if [ -s "$json_file" ]; then
            # If it exists and has content, load the existing data
            data=$(< "$json_file")
        else
            # If it exists but has no content, initialize with an empty JSON array
            data="[]"
        fi
    fi
    # Check for duplicate serial numbers to not append any unnessary data we have
    duplicate=$(echo "$data" | grep "\"serial_number\": \"$serial_number\"")
    if [ -n "$duplicate" ]; then
        echo "Duplicate serial number found. Skipping..."
        return
    fi

    # Create a stringified json so we could put it easily in a file that reads different sequences like quotations for properties
    new_macbook_info="{\"laptop_number\": \"no number\", \"serial_number\": \"$serial_number\", \"model_date\": \"$model_year\", \"screen_size\": \"$screen_size\",  \"chip\": \"$chip_type\", \"status\": \"$status\"}"
    new_macbook_info=$(echo "$new_macbook_info" | cut -c 1-)

    # If the data is not empty, add a comma before appending new data
    data_length=${#data}
    if [ "${data}" != "[]" ]; then
       data="${data%?}" # Cut the ending piece of the array to append to the object instead of array
       data="${data},${new_macbook_info},]" # Append to the previous object and add the array ending

    else # Creating our first object
        
        data=$(echo "${data}" | cut -c 1-$((data_length - 1)))
        data="${data}${new_macbook_info},]"

    fi
    
    # Write data to JSON file
    echo "$data" > "$json_file"
    echo "JSON file updated successfully."
}

# TODO: Issue with smaller macbook screens
get_screen_size() {
    model_name=$(sysctl hw.model | awk -F '[:,]' '{print $2}' | tr -d ' ')
    serial_number=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 9-)
    screen_size=$(/usr/libexec/PlistBuddy -c "print :'CPU Names':${serial_number}-en-US_US" ~/Library/Preferences/com.apple.SystemProfiler.plist | awk '{print $3}' | cut -c 2-8)
    echo "$screen_size"
}

main() {
    # Get the serial number of the MacBook
    serial_number=$(get_mac_serial_number)
    # Get the model date of the MacBook
    model_date=$(get_model_date)

    chip=$(get_chip)
    # Extract the model year from the model date
    model_year=$(echo "$model_date" | awk '{print $NF}')

    screen_size=$(get_screen_size)

    # Check if status argument is provided, otherwise set default value
    if [ -n "$1" ]; then
        status="$1"
    else
        status="Incomplete"
    fi

    if [ -n "$serial_number" ]; then
        # Create or update the JSON file with MacBook information
        create_or_update_json "$serial_number" "$model_year" "$screen_size" "$chip" "$status"

        # Move the JSON file to /Volumes/TXT/script
        mv mac_info.json /Volumes/TXT/script
    else
        echo "Serial number not found. JSON file not updated."
    fi

    # Sort the JSON file by model_date as a number
    if [ -f "/Volumes/TXT/script/mac_info.json" ]; then
        sort -t '"' -k 10,10 -o /Volumes/TXT/mac_info.json /Volumes/TXT/mac_info.json
        echo "JSON file sorted by model_date."
    else
        echo "JSON file not found. Unable to sort."
    fi
}

main "$@"
