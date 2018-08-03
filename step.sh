#!/bin/bash
set -v

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e
depDiff=$(git difftool -y -x "diff -y -w" ext.gradle 2>&1  | grep "|" | tr -d '[:blank:]' | sed 's/|.*[:=]/ /' | ruby $THIS_SCRIPTDIR/compileDep.rb) 
envman add --key PJ_DEP_DIFF --value "$depDiff"