#!/bin/sh

DATE=`date +%Y-%m-%d`
pushd ~

# Based on http://stackoverflow.com/a/8217870
safeRunCommand() {
    typeset cmnd="$*"
    typeset ret_code

    echo $cmnd
    eval $cmnd
    ret_code=$?
    if [ $ret_code != 0 ]; then
        printf "'$cmnd' exited with %d. Bailing.\n" $ret_code
        exit $ret_code
    fi
}

command="tar cvf - notes/ | gzip > notes-$DATE.tgz"
safeRunCommand $command
command="openssl enc -aes-256-cbc -in notes-$DATE.tgz  -out Dropbox/Backups/notes-$DATE.tgz.enc"
safeRunCommand $command
command="rm notes-$DATE.tgz"
safeRunCommand $command

popd
