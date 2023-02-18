#!bin/sh

upload_on_server=0
upload_on_usb=0

prt_conf=/home/rock/klipper_config/printer.cfg

usb_path=`mount | grep "dev/${DEVBASE}" | awk '{ print $3 }' | grep "/home/$host"`

ID=`cat $prt_conf | grep "ZB" | cut -b 8-16`

now_date_time=`date +"%d.%m.%Y-%I.%M.%S"`

### Server configuration
srv_usr="test"
srv_ip="178.172.161.8"
srv_ssh=`ssh $srv_usr@$srv_ip`
srv_connect=`ping -q -c1 $srv_ip &>/dev/null && echo online || echo offline`


copy_to() {
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
}
copy_to_dir() {
	mkdir ./conf_$ID
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
	}


if [ -d conf_$ID ];
	then
		copy_to
	else
		copy_to_dir
fi

if [ $upload_on_server == 1 ];
	then
		if [ $srv_connect == online ];
			then
			echo "online"
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

