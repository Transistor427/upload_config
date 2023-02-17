#!bin/sh
### -- Comments
# -- Off comand

################################################
#===================Modules====================#
################################################

### Режим отладки (1 - включить, 0 - выключить)
log_work=1
### Установка gdrive в систему
upload_on_server=1
### Отправка на usb-устройство
upload_on_usb=0

################################################
#=================Конфигурация=================#
################################################

### Определение имени пользователя
host=`whoami`

### Поиск файла с названием printer.cfg
prt_conf=/home/$host/klipper_config/printer.cfg

### Путь к usb-устройство
usb_path=$(mount | grep "dev/${DEVBASE}" | awk '{ print $3 }' | grep "/home/$host")

### Получение серийного номера принтера (Формат: ZBxxxxxxx)
ID=$(cat $prt_conf | grep "Z" | cut -b 8-)

### Переменная получения текущих даты и времени из системы
now_date_time=$(date +"%d.%m.%Y-%I.%M.%S")

### Функция копирования конфигурационных файлов в директорию
copy_to() {
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
}

### Функция создания директории и копирования в нее конфигурационных файлов
copy_to_dir() {
	mkdir ./conf_$ID
	sudo cp $prt_conf ./conf_$ID/printer_$ID-$now_date_time.cfg
	}

### Копирование файлов в директорию
if [ -d $ID ];
	then
		copy_to
	else
		copy_to_dir
fi

################################################
#============Autoupload to server==============#
################################################

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


################################################
#====Автокопирование  на вставленную флешку====#
################################################

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

