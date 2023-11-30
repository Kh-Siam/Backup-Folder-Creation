#!/bin/sh 
main=$1
backup=$2
interval=$3
max=$4
ls -lR $main > $backup/directory-info.last
cp -r $main/. $backup/"`date +'%Y-%m-%d-%I-%M-%S'`"/
while :
do
    sleep $interval
    ls -lR $main > $backup/directory-info.new
    if ! cmp -s $backup/directory-info.last $backup/directory-info.new
    then
        num=`find $backup/* -maxdepth 0 -type d | wc -l`
        if [ $num -lt $max ]
        then
            cp -r $main/. $backup/"`date +'%Y-%m-%d-%I-%M-%S'`"/
            cp $backup/directory-info.new $backup/directory-info.last
        else
            rm -r `ls -1d $backup/*/ | sort | head -1`
            cp -r $main/. $backup/"`date +'%Y-%m-%d-%I-%M-%S'`"/
            cp $backup/directory-info.new $backup/directory-info.last
        fi  
    fi
done