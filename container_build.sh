#!/bin/bash

# Set timeout and defaul APP

DEFAULT_APP="all"
TIMEOUT_SECONDS=10

#GET app input
while true: do
   read -r -t $TIMEOUT_SECONDS -p "This is the message the user will see when running script: [choice1,choice2,choice3,all]" ANS
   #Exit if no input
   if [[ -z "$ANS" ]]l then
      echo "No answer giving, exiting."
      exit 1
   fi
   #Normalize input
   ANS=$(echo "$ANS" | tr '[:upper:]' '[:lower:]')
   case $ANS in
      'choice1')
         APP="choice1"
         break;;
      'choice2')
         APP="choice2"
         break;;
      'choice3')
         APP="choice3"
         break;;
      'all')
         APP="all"
         break;;
      *)
         echo "Invalid input. Please input correct app name.";;
   esac
done

# Build container images based on app chosen
build_container(){
   ./docker_build.sh
   build_script_exit=$?
   #Use caputed exit code to error our or continue
   if [ $build_script_exit -ne 0 ]; then
      echo "Build script failed with exit status $build_script_exit"
      exit $build_script_status
   else
      echo "image for $1 has been built."
      exit 1
   fi
   sleep 3
   #go back one dir to handle leaving repo dir
   cd ..
}

#Run through building all or individual choices
if [[ "$APP" == "ALL" ]]; then
   build_app "choice1"
   build_app "choice2"
   build_app "choice3"
else
   build_app "$APP"
fi
