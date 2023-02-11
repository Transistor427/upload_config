#!bin/sh
### -- Комментарий
# -- Выключенная команда

################################################
#====================Модули====================#
################################################

### Режим отладки (1 - включить, 0 - выключить)
log_work=1
### Установка gdrive в систему
install_gdrive=0
### Авторизация в Google Drive
Oaut=1
### Отправка на Google Drive
upload_on_drive=0
### Отправка на GitHub
upload_on_github=0
### Отправка на usb-устройство
upload_on_usb=1

################################################
#=================Конфигурация=================#
################################################

### Определение имени пользователя
host=`whoami`

### Поиск файла с названием klipper.cfg
klp_conf=($(find /home/$host/ $(pwd) -name klipper.cfg))
#klp_conf=/home/$host/Documents/upload-drive/klipper.cfg

### Поиск файла с названием moonraker.conf
mnr_conf=($(find /home/$host/ $(pwd) -name moonraker.conf))
#mnr_conf=/home/$host/Documents/upload-drive/moonraker.conf

### Поиск файла с названием KlipperScreen.conf
KS_conf=($(find /home/$host/ $(pwd) -name KlipperScreen.conf))
#KS_conf=/home/$host/Documents/upload-drive/KlipperScreen.conf

### USB-устройства
### Путь к usb-устройство

#usb_path=($(mount | grep "dev/${DEVBASE}" | awk '{ print $3 }' | grep "/home/$host"))
usb_path="/run/media/$host/8255-13F6"

if [ $log_work == 1 ]; then echo "Поиск конфигурационных файлов."
fi

### Получение серийного номера принтера (Формат: ZBxxxxxxx)
ID=($(cat $klp_conf | grep "Z" | cut -b 8-))
if [ $log_work == 1 ]; then echo "Получение серийного номера принтера."
fi

### Выводим серийный номер принтера
if [ $log_work == 1 ]; then echo "Серийный номер получен: $ID"
fi

### Переменная получения текущих даты и времени из системы
now_date_time=($(date +"%d.%m.%Y-%I.%M.%S"))
if [ $log_work == 1 ]; then echo "Получение даты и времени из системы."
							echo "Текущие дата и время: $now_date_time"
fi

### Функция копирования конфигурационных файлов в директорию
copy_to() {
	cp $klp_conf ./configuration_$ID/klipper_$ID-$now_date_time.cfg
	cp $mnr_conf ./configuration_$ID/moonraker_$ID-$now_date_time.conf
	cp $KS_conf ./configuration_$ID/KlipperScreen_$ID-$now_date_time.conf
	if [ $log_work == 1 ]; then echo "Копирование конфигурационных файлов в директорию configuration_$ID."
	fi
}

### Функция создания директории и копирования в нее конфигурационных файлов
copy_to_dir() {
	mkdir configuration_$ID
	cp $klp_conf ./configuration_$ID/klipper_$ID-$now_date_time.cfg
	cp $mnr_conf ./configuration_$ID/moonraker-$ID-$now_date_time.conf
	cp $KS_conf ./configuration_$ID/KlipperScreen-$ID-$now_date_time.conf
	if [ $log_work == 1 ]; then echo "Создание директории configuration_$ID и копирование конфигурационных файлов."
	fi
}

### Копирование файлов в директорию
if [ -d configuration_$ID ];
	then
		copy_to
	else
		copy_to_dir
fi

################################################
#====Автокопирование  на вставленную флешку====#
################################################

if [ $upload_on_usb == 1 ];
	then
		if [ $log_work == 1 ]; then echo "Поиск флешки..."
		fi
	if [ $log_work == 1 ]; then
		if [ -d $usb_path ];
		then
			if [ -d $usb_path/configuration_$ID ];
				then
					if [ $log_work == 1 ]; then echo "Найдена флешка, копируются конфигурационные файлы."
					fi
					cp $klp_conf $usb_path/configuration_$ID/klipper_$ID-$now_date_time.cfg
					cp $mnr_conf $usb_path/configuration_$ID/moonraker-$ID-$now_date_time.conf
					cp $KS_conf $usb_path/configuration_$ID/KlipperScreen-$ID-$now_date_time.conf
					if [ $log_work == 1 ]; then echo "Запись завершена."
					fi
				else
					if [ $log_work == 1 ]; then echo "Найдена флешка, создается директория и копируются конфигурационные файлы."
					fi
					mkdir $usb_path/configuration_$ID
					cp $klp_conf $usb_path/configuration_$ID/klipper_$ID-$now_date_time.cfg
					cp $mnr_conf $usb_path/configuration_$ID/moonraker-$ID-$now_date_time.conf
					cp $KS_conf $usb_path/configuration_$ID/KlipperScreen-$ID-$now_date_time.conf
					if [ $log_work == 1 ]; then echo "Запись завершена."
					fi
			fi
		else
			if [ $log_work == 1 ]; then echo "Флешка не обнаружена."
			fi
		fi
	fi
fi

##############################################
#===========Установка Google Drive===========#
##############################################

if [ install_gdrive == 1 ];
	then
		if [ log_work == 1 ]; then echo "Скачивание пакетов Google Drive начато."
		fi
		gitclone https://github.com/***/gdrive.git
		cd ./gdrive
		sudo chmod 777 ./gdrive
	else
		if [ log_work == 1 ]; then echo "Установка сервиса Google Drive отключена."
		fi
fi

##############################################
#========Авторизация на Google Drive=========#
##############################################

### Авторизируемся
# Изучить! Возможно нужно делать вручную
if [ $Oaut == 1 ];
	then
		if [ log_work == 1 ]; then echo "Запуск авторизации."
		fi
	else
		if [ log_work == 1 ]; then echo "Авторизация в Google Drive отключена."
		fi
fi

##############################################
#======Отправка файлов на Google Drive=======#
##############################################

if [ upload_on_drive == 1 ];
then

### Запускаем сервис drive-google
# Возможно не нужно!

### Создаем директорию на google-drive с названием принтера
	if [ $log_work == 1 ]; then echo "Создание директории на Google Drive."
	fi
		gdrive mkdir configuration_$ID
	if [ $log_work == 1 ]; then echo "Директория на Google Drive создана."
	fi

### Получаем ID директории
	if [ $log_work == 1 ]; then echo "Получение ID директории"
	fi
	gdrive_dir=($(gdrive list | grep "configuration_$ID" | cut -b 1-28))
	if [ $log_work == 1 ]; then echo "ID директории: $gdrive_dir"
	fi

### Отправляем конфигурационный файлы на драйв в директорию данного принтера
	if [ $log_work == 1 ]; then echo "Запуск копирования файлов на Google Drive."
	fi
		gdrive upload --parent $gdrive_dir ./configuration_$ID/klipper*.cfg | gdrive upload --parent $gdrive_dir ./configuration_$ID/moonraker*.conf | gdrive upload --parent $gdrive_dir ./configuration_$ID/KlipperScreen*.conf
	if [ $log_work == 1 ]; then echo "Копирование файлов завершено."
	fi
else
	if [ $log_work == 1 ]; then echo "Выгрузка файлов на Google Drive отключена."
	fi
fi

### Отключаем сервис drive-google
# Возможно не нужно!

##############################################
#=========Отправка файлов на GitHub==========#
##############################################

if [ $upload_on_github == 1 ];
	then
	if [ $log_work == 1 ]; then echo "Синхронизация с репозиторием GitHub начата."
	fi

	else
	if [ $log_work == 1 ]; then echo "Выгрузка файлов на GitHub отключена."
	fi
fi

################################################
#===============Экспериментально===============#
################################################
