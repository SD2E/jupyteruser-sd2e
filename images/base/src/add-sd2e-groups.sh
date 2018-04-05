#!/bin/sh

while read -r nb_gid nb_group ; do
    echo "Adding ${nb_gid}:${nb_group}"
    groupadd --force --gid ${nb_gid} "G-${nb_gid}"
done <<EOM
819382 sd2program
819902 safegenes
819970 srins01
EOM
