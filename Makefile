talk: 
	@echo "Do you need to create a back-up directory?[y/n]"
	@echo "<If you have a directory ready to be a backup, please make sure it is empty!>"
	@read answer ;\
	if [ "$$answer" = "y" ] ;\
	then \
		make build ;\
	else \
		make ask ;\
	fi

build:
	@echo "Enter the path ending with the name of the directory to be created:"
	@read directory;\
	mkdir $$directory;
	@echo "Directory is created!"
	@make ask

ask:
	@echo
	@echo
	@echo "Do you want to work with a cron job or just a script?[c/s]"
	@read answer ;\
	if [ "$$answer" = "c" ] ;\
	then \
		make cron ;\
	else \
		make script ;\
	fi

cron:
	@echo
	@echo "##########################"
	@echo "Please fill the following:"
	@echo "##########################"
	@echo
	@read -p "Enter the main directory to be backed-up: " main ;\
	read -p "Enter the back-up directory: " backup ;\
	read -p "Enter the maximum number of back-up folders to be created: " max ;\
	read -p "Enter the full path to the directory 7010-lab1: " path ;\
	crontab -l > $$backup/mycron ;\
	echo "* * * * * cd $$path && ./backup-cron.sh $$main $$backup $$max" >> $$backup/mycron ;\
	crontab $$backup/mycron ;\
	rm $$backup/mycron 
	@echo

script:
	@echo
	@echo "##########################"
	@echo "Please fill the following:"
	@echo "##########################"
	@echo
	@read -p "Enter the main directory to be backed-up: " main ;\
	read -p "Enter the back-up directory: " backup ;\
	read -p "Enter the time interval between each check: " interval ;\
	read -p "Enter the maximum number of back-up folders to be created: " max ;\
	./backupd.sh $$main $$backup $$interval $$max