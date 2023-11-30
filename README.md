# Backup Creation
## Lab Assignment

Contents of the folder are:
- maindir
- backupd.sh
- Makefile
- README.md
- backup-cron.sh  [BONUS]

The maindir is the source directory to be backed up by the script. There is no directory that functions as the destination directory that holds the back-up folders.  Keep in mind that the Makefile gives you the option to create a back-up directory if none exists. Moreover, the script doesn't necessarily work on the maindir as the Makefile lets you choose whatever director you'd like to work on. 

## Installation

After unzipping the folder, you need to make sure that you have make installed.

You can install it by running down: 

```sh
sudo apt install make
```

Then, go into the path of the directory and you're set to go.

## Runnig the script

Open the terminal inside the directory and just type: 

```sh
make
```

The Makefile will ask whether you have a back-up directory ready or not, answer accordingly and then you will also be asked whether you'd like it to run as a cron job or not! type c for the cron job.

Fill the parameters requested in the terminal in the case of a normal script not a cron job:
- The full path to the source file to be backed-up
- The full path to the destination file where the back-up files will be created
- The time interval between each check 
- The maximum number of back-up folders to be created

In case you have picked cron job, fill these parameters:
- The full path to the source file to be backed-up
- The full path to the destination file where the back-up files will be created
- The maximum number of back-up folders to be created
- The full path to the directory 7010-lab2 where the script exists

> Important Note: `Make sure if you have chosen an existing directory to work as your back-up directory, that the said directory is empty!!

## Code Explanation

Using ls -lR to save the status of the directory just as given and comparing it with another file using cmp -s command. 
```sh
ls -lR $main > $backup/directory-info.last
```
The format of the date in the names of the back-up directories is as the given format in the sheet: YYYY-MM-DD-hh-mm-ss
```sh
cp -r $main/. $backup/"`date +'%Y-%m-%d-%I-%M-%S'`"/
```
The Code uses the find command to find the number of directories in the back-up directory to make sure that the maximum numbers of allowed folders wasn't reached. 
```sh
num=`find $backup/* -maxdepth 0 -type d | wc -l`
```
In the case where the limit is reached, the code uses ls -dt1 and then get the tail of the list to remove the oldest directory keeping the latest ones.
```sh
rm -r `ls -dt1 $backup/*/ | tail -1`
```
> Note: `The directory-info.last and the directory-info.new that are used to save and compare the statues of the directory, are both written and saved in the back-up directory.

## The Bonus

The same algorithm is used in the backup-cron.sh file but without the infinite loop!

The only other alteration is an if condition added so that a back-up of the source is copied directly for the first run of the script as a cron job.

It checks whether the destination directory is empty or not so that it learns if it is its first run or not.
```sh
if [ -z "$(ls -A $backup)" ] 
then
    ls -lR $main > $backup/directory-info.last
    cp -r $main/. $backup/"`date +'%Y-%m-%d-%I-%M-%S'`"/
fi
```

The makefile does all the work afterwards as it is responsible to add the job to the cron list. 

The cron job works every minute by default. If you'd like to change it, then it will have to be manually by editting the makefile line 42
```sh
	echo "* * * * * cd $$path && ./backup-cron.sh $$main $$backup $$max" >> $$backup/mycron ;\
```

For example, if you need to run this backup every 3rd Friday
of the month at 12:31 am, then the line should be written as follows:
```sh
	echo "31 12 15-21 * 5 cd $$path && ./backup-cron.sh $$main $$backup $$max" >> $$backup/mycron ;\
```
15-21, because the 3rd friday in the third week of the month!