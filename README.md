# Arduino-Uno (ATMega328p) Makefile

**Notes by Henjie Agadan**

*If I have mistakes please have mercy (T_T) and correct me, It took me days to come up with one that works
and one that matches the output content and file size that the Arduino IDE come up with. Compiling part
was a bit easy to understand but the linking, oh boy, it's way too much to take in, but here's my best.*

[YouTube video  - Uploading demonstration](https://youtu.be/08P6qaV6GPM)

### * Makefile does not erase bootloader
### * Uploading is done through the USB cable, the one you usually get when you buy an Arduino-Uno board

A tested and working Makefile I came up with for automating the compilation and flashing of my codes to the 
ATmega328p through USB and BOOTLOADER.

The files in this repository are the same one I upload with the repositories I make when I upload a project.
This readMe would serve as to where I explain the options I included during compile and upload.

For more in-depth study on linking and compiling, there are many resources online, but the resources I'm about
to share was enough for me to get a gist of what is happening when compiling, linking, and flashing, here are
the links you must look up,
  1. [GCC C C++ Options (Stanford University)](http://ccrma.stanford.edu/planetccrma/man/man1/avr-gcc.1.html "Stanford AVR-GCC")
  2. [AVRDude Options (Non-GNU org)](https://www.nongnu.org/avrdude/user-manual/avrdude_3.html)

Excellent resources I must say, the options are already right there, defined/described on what they do and what
are they for.

## **The Process**
The Makefile just bundles up various commands so that I do not have to type them all the time. For simplicity,
I simply have the Makefile and the souce file (main.c) in the same folder. So after I code I have two files in
a folder, Makefile, main.c.
  1. **Compiling and linking**
  
     ```
     avr-gcc -Os -DF_CPU=16000000 -mmcu=atmega328p main.c.
     ```
      a. **avr-gcc** calls avr-gcc compiler.
      
      b. **-Os** in simple words, Optimize the output file for Size.
      
      c. **DF_CPU=** defines the MCU system clock which is indeed the 16MHz for the Arduino-Uno.
      
      d. **-mmcu=atmega328p** pretty straightworward, defines the MCU so that it would only compile and
                              link files/definitions that are related to the ATMega328p chip. If you look up the contents of io.h
                              it contains things that are not for the chip so, what I understood is i'tll only grab things for
                              specified chip.
      
      e. **main.c** says that it'll create an object from the source file, main.c.
      
      f. since there is no specificed object file, the output will be an "a.out" file.
      
  2. **Creating a machine readable code**
  
      ```
      avr-objcopy -O ihex -j .text -j .data a.out a.hex
      ```
      a. **avr-objcopy** calls the program for "transforming" an object file
      
      b. **-O** optimize for code size and try to get the process faster
      
      c. **ihex** create an intex hex format file (.ihex) from the output file (a.out)
      
      d. **j .text** only try to compile my code
      
      e. **j .data** ony try to compile my variables
      
      f. **a.out** specifies the ouput file to create a .hex file from
      
      g. **a.hex** specifies what is the name of the .hex file (machine readable code/instructions)
      
  3. **Flashing/Uploading the Code to the Board**
  
      ```
      sudo avrdude -v -D -F -c arduino -p ATMEGA328P -P /dev/ttyACM0 -b 115200 -U flash:w:a.hex:i
      ```
      a. **avrdude** DO NOT INCLUDE "sudo" if you are with a Windows/Mac OS. Just calls avrdude
      
      b. **-v** verbose reporting on upload, good for debugging
      
      c. **-D** disables erasing of flash memory. **Important as it protects the Bootloader in the flash memory**
      
      d. **-F** Just tries to disable the checking for device signature, since I am using the USB calbe and directly
                uploading the code through it, it might not be needed.

      e. **-c arduino** says that we will be using the arduino programmer. Since we are using the USB and the bootloader.
      
      f. **-P "port here"** specifies the port as to where Arduino is connected to. This is different for every computer,
                            /dev/x are for Linux OS while COM# for Windows OS. Simply type your port after a space from -P.
     
      g. **-b 115200** specifies the programmer's baudrate, people usually just set this to 115200
      
      h. **-U** says we upload a file to the device with these options,
      
            flash --> upload code to the flash memory
              
            w -----_> we write to that memory
              
            a.hex --> we take this file named a.hex. It can also be a directory to the file we want to upload.
              
            i ------> says we are to upload the file in intel hex format
