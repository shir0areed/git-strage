FFLIVE = fflive
MONITOR = $(FFLIVE)-monitor

install: uninstall
	mkdir ~/$(FFLIVE)
	cp *.sh ~/$(FFLIVE)
	./input.sh
	mv *.txt ~/$(FFLIVE)
	sudo cp *.service *.timer /etc/systemd/system
	sudo systemctl enable $(MONITOR).timer

uninstall:
	sudo systemctl stop $(MONITOR).timer ||:
	sudo systemctl disable $(MONITOR).timer ||:
	sudo rm /etc/systemd/system/$(MONITOR).timer ||:
	sudo systemctl stop $(MONITOR).service ||:
	sudo rm /etc/systemd/system/$(MONITOR).service ||:
	sudo systemctl stop $(FFLIVE).service ||:
	sudo rm /etc/systemd/system/$(FFLIVE).service ||:
	rm -rf ~/$(FFLIVE)

