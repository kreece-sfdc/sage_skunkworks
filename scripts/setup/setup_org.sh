#!/bin/bash

# set perms chmod u+x ./scripts/package_install.sh
# end immediately on non-zero exit codes
set -e

ALIAS=none
WAIT=15
PUBLISHWAIT=10

# print message function
printMsg() {
  echo ""
  date +"%T $*"
}

printError() {
  echo "Error:"
  date +"%T $*"
}

createOrg() {
  printMsg "Creating new Scratch Org $ALIAS"
  sfdx force:org:create -f config/project-scratch-def.json -a $ALIAS --wait $WAIT --json
}

installPackage () {
  printMsg "Installing Trail Tracker in $ALIAS"
  sfdx force:package:install -p 04t1Q000001ABf5QAG -s AdminsOnly -u $ALIAS -r --wait $WAIT --publishwait $PUBLISHWAIT --json
}

openOrg() {
  printMsg "Opening  $ALIAS"
  sfdx force:org:open -u $ALIAS
}

while [[ $# > 1 ]]
do
    key="$1"

    case $key in
    -a)
        ALIAS="$2"
        shift # past argument
        ;;
    *)
        # unknown option
        ;;
    esac
shift # past argument or value
done

createOrg
installPackage
openOrg