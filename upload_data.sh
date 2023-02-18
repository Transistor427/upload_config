#!bin/sh

check_err_klp=1
upload_on_server=1
upload_on_usb=0

# Conifg klipper
prt_conf=/home/rock/klipper_config/printer.cfg
# Log file klipper
klp_conf=/home/rock/klipper_logs/klippy.log

usb_path=`mount | grep "dev/${DEVBASE}" | awk '{ print $3 }' | grep "/home/$host"`

ID=`cat $prt_conf | grep "ZB" | cut -b 8-16`

now_date_time=`date +"%d.%m.%Y-%I.%M"`

copy_to() {
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
	sudo cp $klp_conf ./conf_$ID/klippy_$ID-$now_date_time.cfg
}
copy_to_dir() {
	mkdir ./conf_$ID
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
	sudo cp $klp_conf ./conf_$ID/klippy_$ID-$now_date_time.cfg
	}


if [ -d conf_$ID ];
	then
		copy_to
	else
		copy_to_dir
fi

if [ $upload_on_server == 1 ];
	then
	if [ $check_err_klp == 1 ];
	then

		ping -c1 -i3 178.172.161.8
		if [ $? -eq 0 ];
			then
				echo "Server avaible."
				echo "Copy configs and logs to server."
				scp -r ./conf_$ID/ test@178.172.161.8:/home/test/data_printer/
				echo "Remove config and logs."
				sudo rm ./conf_$ID/printer*
				sudo rm ./conf_$ID/klippy*
			else
				echo “Server not avaible.”
		fi
	fi

fi

if [ $upload_on_usb == 1 ];
	then
			if [ -d $usb_path ];
				then
					if [ -d $usb_path/$ID ];
						then
							cp $klp_conf $usb_path/$ID/printer_$ID-$now_date_time.cfg
						else
							mkdir $usb_path/$ID
							cp $klp_conf $usb_path/$ID/printer_$ID-$now_date_time.cfg
					fi
			fi
fi

