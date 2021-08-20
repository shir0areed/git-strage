install: uninstall
	wget https://raw.githubusercontent.com/shir0areed/git-strage/master/git-strage-setup/git-read.sh
	chmod +x git-read.sh
	sudo mv git-read.sh /usr/local/bin/git-read
	wget https://raw.githubusercontent.com/shir0areed/git-strage/master/git-strage-setup/git-write.sh
	chmod +x git-write.sh
	sudo mv git-write.sh /usr/local/bin/git-write
	wget https://raw.githubusercontent.com/shir0areed/git-strage/master/git-strage-setup/git-delete.sh
	chmod +x git-delete.sh
	sudo mv git-delete.sh /usr/local/bin/git-delete

uninstall:
	sudo rm /usr/local/bin/git-delete ||:
	sudo rm /usr/local/bin/git-write ||:
	sudo rm /usr/local/bin/git-read ||:

