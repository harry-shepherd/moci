#!/usr/bin/env bash
#
# NAME: extract_xios_git.sh
#
# DESCRIPTION: Extracts XIOS from a FCM repository
#
# ENVIRONMENT VARIABLES (COMPULSORY):
#    XIOS_GIT_REPOSITORY
#    XIOS_HASH
#    XIOSPATH

xios_repository=$XIOS_GIT_REPOSITORY
user=${HPC_HOST_USERNAME:-$(whoami)}

xios_extract_dir=xios
if [ -z "$XIOS_HASH" ]; then
    echo "Please specify a git hash for the XIOS source required"
    exit 999;
fi

git clone $xios_repository
if [ ! -d $xios_extract_dir ]; then
    1>&2 echo "Unable to successfully clone the xios repository"
    exit 999;
fi

cd $xios_extract_dir
git checkout $XIOS_HASH

cd ../

#Upload the XIOS sourcec code to the HPCs
scp -r $xios_extract_dir $user@$HPC_HOST:$XIOSPATH/;
if [ $? -ne 0 ]; then
    1>&2 "Unable to succesfully uplad oasis source to $HPC_HOST"
    exit 999;
fi
#cleanup
rm -rf $xios_extract_dir

#End of script test, check that the code is avaliable
ssh $user@$HPC_HOST ls $XIOSPATH
[ $? -eq 0 ] || exit 1
