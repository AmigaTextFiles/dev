OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
-> --- functions in V40 or higher (Release 3.1) ---
-> 
->  CONTROLLER HANDLING
-> 
MACRO ReadJoyPort(port) IS (D0:=port) BUT (A6:=lowlevelbase) BUT ASM ' jsr -30(a6)'
-> 
->  LANGUAGE HANDLING
-> 
MACRO GetLanguageSelection() IS (A6:=lowlevelbase) BUT ASM ' jsr -36(a6)'
-> 
->  KEYBOARD HANDLING
-> 
MACRO GetKey() IS (A6:=lowlevelbase) BUT ASM ' jsr -48(a6)'
MACRO QueryKeys(queryArray,arraySize) IS Stores(lowlevelbase,queryArray,arraySize) BUT Loads(A6,A0,D1) BUT ASM ' jsr -54(a6)'
MACRO AddKBInt(intRoutine,intData) IS Stores(lowlevelbase,intRoutine,intData) BUT Loads(A6,A0,A1) BUT ASM ' jsr -60(a6)'
MACRO RemKBInt(intHandle) IS (A1:=intHandle) BUT (A6:=lowlevelbase) BUT ASM ' jsr -66(a6)'
-> 
->  SYSTEM HANDLING
-> 
MACRO SystemControlA(tagList) IS (A1:=tagList) BUT (A6:=lowlevelbase) BUT ASM ' jsr -72(a6)'
-> 
->  TIMER HANDLING
-> 
MACRO AddTimerInt(intRoutine,intData) IS Stores(lowlevelbase,intRoutine,intData) BUT Loads(A6,A0,A1) BUT ASM ' jsr -78(a6)'
MACRO RemTimerInt(intHandle) IS (A1:=intHandle) BUT (A6:=lowlevelbase) BUT ASM ' jsr -84(a6)'
MACRO StopTimerInt(intHandle) IS (A1:=intHandle) BUT (A6:=lowlevelbase) BUT ASM ' jsr -90(a6)'
MACRO StartTimerInt(intHandle,timeInterval,continuous) IS Stores(lowlevelbase,intHandle,timeInterval,continuous) BUT Loads(A6,A1,D0,D1) BUT ASM ' jsr -96(a6)'
MACRO ElapsedTime(context) IS (A0:=context) BUT (A6:=lowlevelbase) BUT ASM ' jsr -102(a6)'
-> 
->  VBLANK HANDLING
-> 
MACRO AddVBlankInt(intRoutine,intData) IS Stores(lowlevelbase,intRoutine,intData) BUT Loads(A6,A0,A1) BUT ASM ' jsr -108(a6)'
MACRO RemVBlankInt(intHandle) IS (A1:=intHandle) BUT (A6:=lowlevelbase) BUT ASM ' jsr -114(a6)'
-> 
->  MORE CONTROLLER HANDLING
-> 
MACRO SetJoyPortAttrsA(portNumber,tagList) IS Stores(lowlevelbase,portNumber,tagList) BUT Loads(A6,D0,A1) BUT ASM ' jsr -132(a6)'
