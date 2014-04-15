#!/bin/sh
tar cvf - notes/ | gzip > notes-2014-02-02.tgz
openssl enc -aes-256-cbc -in notes-2014-02-02.tgz  -out notes-2014-02-02.tgz.enc
