PROGRAM = wake-push
SERVICE = $(PROGRAM).service

install: uninstall
	mkdir ~/$(PROGRAM)
	cp *.sh ~/$(PROGRAM)
	./input.sh
	mv *.txt ~/$(PROGRAM)
	sudo cp $(SERVICE) /etc/systemd/system/
	sudo systemctl enable $(SERVICE)

uninstall:
	sudo systemctl disable $(SERVICE) || :
	sudo systemctl stop $(SERVICE) || :
	sudo rm /etc/systemd/system/$(SERVICE) || :
	rm -rf ~/$(PROGRAM)

