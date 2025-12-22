amisrec
=====================================
The program *amisrec* is a serial S-RECORD loader for the Amiga computer. It
loads a hex character coded S-RECORD file over the internal UART hardware. The
program is developed and tested on Amiga A1200 with Blizzard 1230 IV and will
probably work on any Amiga computer.


Features
--------
* The loader relocates itself to upper chip RAM.
* Supports S-RECORD types 2, 3, 4, 7, 8 and 9.
* Verifies record checksums.
* Polling UART with high baud (230400 on A1200).
* Program size is less than 500 bytes.
* Loads target program to any address as defined by the S-RECORD input.


User interface
--------------
Program output is just different screen colors.

* Black - Loader waits for byte to arrive on UART.
* Purple - Data is being processesed (character to byte conversion, checksum
  calculation, memory write.)
* White - Load complete, waits for user to release mouse button.
* Red - An S-RECORD has checksum error.

Load input is controlled by the left mouse button. If left mouse button is
depressed during arrival of the first termination record, the loader waits for
button release before it boots into the loaded data. If the mouse button is
*not* depressed, the program boots immediately.


Usage example
-------------
Boot the Amiga from floppy with one of the `.adf` files or run one of the
executables (see *Binary distribution*).

On another computer, run:

`cat hello.srec > /dev/ttyUSB0`


Interesting extensions
----------------------
* View S-RECORD identifer o screen when loading
* Present progress visually (or aurally!)
* Detect Fast RAM and relocate there.
* Supply system (RAM) information in registers to the booted program.


Binary distribution
-------------------
* `brittmarie_512KiB_38400`
   - Amiga executable
   - Relocates just below address `$00080000`
   - 38400 bps

* `brittmarie_2MiB_230400`
   - Amiga executable
   - Relocates just below address `$00200000`
   - 230400 bps

* `brittmarie_512KiB_38400.adf`
   - Amiga disk boot block
   - Relocates just below address `$00080000`
   - 38400 bps

* `brittmarie_2MiB_230400.adf`
   - Amiga disk boot block
   - Relocates just below address `$00200000`
   - 230400 bps


License
-------
The program *amisrec* is licensed under GPL v3.


Contact
-------
`ma0@home.se`
