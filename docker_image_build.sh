#!/bin/bash

# Set timeout and default APP
DEFAULT_APP="all"
TIMEOUT_SECONDS=20
APPLIST_FILE="app_list.txt"

# Check if app_list file exists
if [[ ! -f "$APPLIST_FILE" ]]; then
   echo "Error: File not found at $APPLIST_FILE"
   exit 1
fi

# Read app list from file. Skips first line. Accounts for either upper or lower case
APPS=($(tail -n +2 "$APPLIST_FILE"))
APPS_LOWER=($(tail -n +2 "$APPLIST_FILE" | tr '[:upper:]' '[:lower:]' ))

echo "Available apps:"
for app in "${APPS[@]}; do
    echo " - $app"
done
echo " - all"

while true; do
    read -r -t $TIMEOUT_SECONDS -p "Choose what app to build container: [${APPS[*]},all] " ANS
    if [[ -z "$ANS" ]]; then
        echo "no answer given. Exiting script"
        exit 1
    fi
    ANS=$(echo "$ANS" | tr '[:upper:]' '[:lower:]')
    if [[ "$ANS" == "all" ]]; then
        $APP="ALL"
        break
    fi

    # Find the app in the list (case-insensitive)    
    MATCHED_APP=""
    for i in "${!APPS_LOWER[@]}"; do
	if [[ " ${APPS_LOWER[$i]}" == "$ANS" ]]; then
	    MATCHED_APP="${APPS[$i]}"
	    break
	fi
    done
    if [[ -n "$MATCHED_APP" ]]; then
        APP="$MATCHED_APP"
	break
    else 
        echo "Invalid input, try again."
    fi
done

echo "Selected app: $APP"

# Build function for container images based on selection
build_image() {
  (
    cd "$1" || { echo "Directory $1 not found"; return 1; }
    ./docker_build.sh
    build_script_exit=$?
    if [ $build_script_exit -ne 0 ]; then
       echo "Image build failed with exit status $build_script_exit"
       return $build_script_status
    else
       echo "Image for $1 has been built."
    fi
    sleep 3
  )
}

if [[ "$APP" == "ALL" ]]; then
    while IFS= read -r line; do
	    build_app "$line"
		echo "Build image $line"
		sleep 3
    done < <(tail -n +2 "$APPFILE_LIST")
else
    build_app "$APP"
fi

