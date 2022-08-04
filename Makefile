default:
	avr-gcc -Os -DF_CPU=16000000 -mmcu=atmega328p main.c
	avr-objcopy -O ihex -j .text -j .data a.out a.hex
	sudo avrdude -v -D -F -c arduino -p ATMEGA328P -P /dev/ttyACM0 -b 115200 -U flash:w:a.hex:i