#!bin/sh
### -- Comments
# -- Off comand

################################################
#===================Modules====================#
################################################

log_work=1
upload_on_server=1
upload_on_usb=0


host=`whoami`

prt_conf=/home/$host/klipper_config/printer.cfg

usb_path=$(mount | grep "dev/${DEVBASE}" | awk '{ print $3 }' | grep "/home/$host")

ID=$(cat $prt_conf | grep "Z" | cut -b 8-)

now_date_time=$(date +"%d.%m.%Y-%I.%M.%S")

copy_to() {
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
}

copy_to_dir() {
	mkdir ./conf_$ID
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
	}

if [ -d $ID ];
	then
		copy_to
	else
		copy_to_dir
fi


if [ $upload_on_server == 1 ];
	then
			if [ -d $usb_path ];
				then
					if [ -d $usb_path/$ID ];
						then
							cp $prt_conf $usb_path/$ID/printer_$ID-$now_date_time.cfg
						else
							mkdir $usb_path/$ID
							cp $prt_conf $usb_path/$ID/printer_$ID-$now_date_time.cfg
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

