#!bin/sh

### Enabling upload to server
upload_on_server=1

# Config klipper
prt_conf=/home/rock/klipper_config/printer.cfg
# Log file klipper
klp_log=/home/rock/klipper_logs/klippy.log

#usb_path=`mount | grep "dev/${DEVBASE}" | awk '{ print $3 }' | grep "/home/$host"`
ID=`cat $prt_conf | grep "ZB" | cut -b 8-16`
now_date_time=`date +"%d.%m.%Y-%I.%M"`

copy_to() {
	sudo cp $prt_conf /home/rock/upload_config/printer_$ID/printer_$ID-$now_date_time.cfg
	sudo cp $klp_log /home/rock/upload_config/printer_$ID/klippy_$ID-$now_date_time.log
}
copy_to_dir() {
	mkdir /home/rock/upload_config/printer_$ID
	sudo cp $prt_conf /home/rock/upload_config/printer_$ID/printer_$ID-$now_date_time.cfg
	sudo cp $klp_log /home/rock/upload_config/printer_$ID/klippy_$ID-$now_date_time.log
}
clear_log() {
	cat /home/rock/upload_config/printer_$ID/klippy* | grep -B50 -A5 -a -e"mcu" -e"MCU" -e"Errno" >> /home/rock/upload_config/printer_$ID/output_klippy_$now_date_time.log
}

if [ -d conf_$ID ];
	then
		copy_to
		clear_log
	else
		copy_to_dir
		clear_log
fi

if [ $upload_on_server == 1 ];
	then
		echo "Server availability check."
		ping -c1 -i3 178.172.161.8
		if [ $? -eq 0 ];
			then
				echo "Server avaible." >> /tmp/KlipperScreen.log
				echo "Copy configs and logs to server."
				scp -r ./printer_$ID/ zbtest@178.172.161.8:/home/zbtest/
				echo "Remove config and logs."
				sudo rm ./printer_$ID/*
			else
				echo "Server not avaible. Check your internet connection." >> /tmp/KlipperScreen.log
		fi
	else
		echo "Uploading to the server is disabled."
fi


