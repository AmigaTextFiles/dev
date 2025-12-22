OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO CDInputHandler(events,consoleDevice) IS Stores(consoledevice,events,consoleDevice) BUT Loads(A6,A0,A1) BUT ASM ' jsr -42(a6)'
MACRO RawKeyConvert(events,buffer,length,keyMap) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(consoledevice,events,buffer,length,keyMap) BUT Loads(A6,A0,A1,D1,A2) BUT ASM ' jsr -48(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
