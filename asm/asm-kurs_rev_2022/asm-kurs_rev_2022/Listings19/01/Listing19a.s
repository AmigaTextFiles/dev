
Action Replay - referencemap

COMMANDS FOR SYSTEM INFORMATION:
	INTERRUPTS:	 SHOW EXECBASE INTERRUPTLISTS			- INTERRUPTS
	EXCEPTIONS:	 SHOW EXCEPTION- AND INTERRUPTVECTORS	- EXCEPTIONS
	EXECBASE:	 SHOW WHOLE EXECBASESTRUCTURE			- EXECBASE
	AVAIL:		 SHOW FREE MEMORY						- AVAIL
	INFO:		 SHOW IMPORTANT SYSTEMPARAMETERS		- INFO
	LIBRARIES:	 SHOW EXECBASE LIBRARYLIST				- LIBRARIES
	RESOURCES:	 SHOW EXECBASE RESOURCELIST				- RESOURCES
	CHIPREGS:	 SHOW NAME + OFFSET OF CHIPREGISTERS	- CHIPREGS
	DEVICES:	 SHOW EXECBASE DEVICELIST				- DEVICES
	TASKS:		 SHOW EXECBASE TASKLISTS				- TASKS
	PORTS:		 SHOW EXECBASE PORTLIST					- PORTS

DISK AND DISKCODING COMMANDS
	BOOTCODE:	 SHOW/SET BOOTBLOCK CODENUMBER			- BOOTCODE (CODENUMBER)
	BOOTPROT:	 CODE BOOTBLOCK OF ACTIVE DRIVE			- BOOTPROT (CODENUMBER)
	CODE:		 SHOW/SET DISK CODENUMBERS			    - CODE (DRIVE CODENUMBER)
	DCOPY:		 BACKUP AMIGADOS DISKS					- DCOPY SOURCE DEST
	CODECOPY:	 DISKCOPY + DECODE SOURCE + CODE DEST	- CODECOPY SOURCE DEST
	CD:			 SHOW/CHANGE CURRENT MODULE-PATH		- CD (PATH)
	DIR:		 SHOW DISK-DIRECTORY					- DIR (PATH)
	DIRA:		 SHOW WHOLE DISK-DIRECTORY				- DIRA (PATH) 
	MAKEDIR:	 CREATE DIRECTORY						- MAKEDIR PATH
	DELETE:		 DELETE FILE							- DELETE (PATH)FILENAME
	FORMAT:		 FORMAT DISK IN ACTIVE DRIVE			- FORMAT (NAME)
	FORMATQ:	 FORMAT DISK QUICK						- FORMATQ (NAME)
	FORMATV:	 FORMAT DISK AND VERIFY FORMAT			- FORMATV (NAME)
	INSTALL:	 INSTALL DISK IN ACTIVE DRIVE			- INSTALL (BOOTBLOCKNR.)
	DISKCHECK:	 CHECKS DISK FOR ERRORS					- DISKCHECK (DRIVE)
	DISKWIPE:	 CLEARS A DISK VERY FAST				- DISKWIPE (DRIVE) 
	TYPE:		 TYPE FILE ON SCREEN					- TYPE (PATH)FILENAME 

FREEZER AND RIPPER COMMANDS:
	SA:			 SAVE CURRENT PROGRAM TO DISK			- SA (PATH)NAME(,CRATE)
	SR:			 SAVE CURRENT PROGRAM AND START			- SR (PATH)NAME(,CRATE)
	LA:			 LOAD FREEZEFILE FROM DISK				- LA (PATH)NAME
	LR:			 LOAD FREEZEFILE FROM DISK AND START	- LR (PATH)NAME
	SLOADER:	 SAVE LOADER TO ACTIVE DRIVE			- SLOADER
	LQ:			 LOAD ALL FROM RAMDISK					- LQ
	LQR:		 LOAD ALL FROM RAMDISK AND RESTART		- LQR
	SQ:			 SAVE ALL TO RAMDISK					- SQ
	SQR:		 SAVE ALL TO RAMDISK AND RESTART		- SQR
	TRACKER:	 RIPS SOUNDTRACKER-MODULS IN MEMORY		- TRACKER START
	SCAN:		 SCAN MEMORY FOR SAMPLES				- SCAN
	SP:			 SAVE CURRENT PICTURE TO DISK			- SP (PATH)NAME(,NR HEIGHT)
	P:			 SHOW CURRENT PICTURE/MEMPEEKER			- P (PICNR)
	SPM:		 SAVE PICTURE OF MEMPEEKER				- SPM NAME
	
DISKMONITOR COMMANDS:
	RT:			READ TRACKS FROM ACTIVE DRIVE			- RT STRACK (NUM DEST)
	WT:			WRITE TRACKS TO ACTIVE DRIVE			- WT STRACK NUM SOURCE
	DMON:		DISPLAY RANGE OF DISK-MON BUFFER		- DMON

CLRDMON: RESTORE DISK-MON BUFFER - CLRDMON
	BOOTCHK:	SET CORRECT BOOTBLOCKCHECKSUM			- BOOTCHK SECTORADDR.
	DATACHK:	SET CORRECT DATACHECKSUM				- DATACHK SECTORADDR.
	BAMCHK:		SET CORRECT BITMAPCHECKSUM				- BAMCHK SECTORADDR.

TRAINER COMMANDS: 
	TS:			START TRAINER/TRAINERMODE				- TS STARTLIVES
	T:			CONTINUE TRAINER						- T AKTLIVES
	TX:			EXIT TRAINERMODE						- TX
	TF:			SEARCH FOR DECREMENTING OPCODES			- TF ADDRESS
	TFD:		SEARCH AND REMOVE DECREMENT OPCODES		- TFD ADDRESS
	PC:			SHOW CURRENT PICTURE + ENERGY COUNT		- PC (PICNR)

MISC. COMMANDS
	RAMTEST:	CHECKS MEMORYBLOCK FOR HARDERRORS		- RAMTEST START END
	PACK:		PACKS MEMORY							- PACK START END DEST CRRATE
	UNPACK:		UNPACKS WITH PACK-COMMAND PACKED MEM	- UNPACK DEST END OF PACKED
	COLOR:		SET MODUL-EDITOR COLORS					- COLOR BACK PEN
	RCOLOR:		RESET MODUL-EDITOR COLORS				- RCOLOR
	TM:			SHOW REMARKS ABOUT CURR. PROGRAM		- TM
	TMS:		SET REMARK ABOUT CURR. PROGRAMADDR.		- TMS ADDR
	TMD:		DELETE REMARK ABOUT PROGRAM				- TMD ADDR
	SPR:		SHOW/EDIT SPRITES						- SPR NR¦ADDR (NR¦ADDR)

VIRUS COMMANDS: 
	VIRUS:		SEARCH VIRUS IN MEMORY					- VIRUS
	KILLVIRUS:	SEARCH AND REMOVE VIRUS IN MEMORY		- KILLVIRUS

MONITOR COMMANDS: 
	SETEXCEPT:	SET EXCEPTION HANDLER (NO MORE GURU)	- SETEXCEPT
	COMP:		COMPARE MEMORYBLOCKS					- COMP START END DEST
	LM:			LOAD FILE TO MEMORY						- LM (PATH)NAME, DEST
	SM:			SAVE MEMORY BLOCK TO DISK				- SM (PATH)NAME, START END
	SMDC:		SAVE MEMORY BLOCK TO DISK AS DC.B		- SMDC (PATH)NAME, START END
	SMDATA:		SAVE MEMORY BLOCK TO DISK AS DATA		- SMDATA (PATH)NAME, START END
	A:			START M68000 ASSEMBLER					- A ADDRESS
	B:			SHOW CURRENT BREAKPOINTS				- B ADDRESS
	BS:			SET BREAKPOINT							- BS ADDRESS
	BD:			DELETE BREAKPOINT						- BD ADDRESS
	BDA:		DELETE ALL BREAKPOINTS					- BDA
	X:			RESTART CURRENT PROGRAM					- X
	C:			COPPERASSEMBLER/DISASSEMBLER			- C 1¦2¦ADDRESS
	D:			M68000 DISASSEMBLER						- D (0¦ADDRESS)
	E:			SHOW/EDIT CHIPREGISTERS					- E (OFFSET)
	F:			SEARCH FOR STRING (CASESENSITIVE)		- F STRING(,START END)
	FA:			SEARCH FOR ADR ADDRESSING OPCODE		- FA ADDRESS (START END)
	FAQ:		FASTSEARCH FOR ADR ADDRESSING OPCODE	- FAQ ADR (START END)
	FR:			SEARCH FOR RELATIVE-STRING				- FR STRING(,START END)
	FS:			SEARCH STRING (NOT CASESENSITIVE)		- FS STRING(,START END)
	G:			RESTART PROGRAM AT ADDRESS				- G ADDRESS
	TRANS:		COPY MEMORYBLOCK						- TRANS START END DEST
	WS:			WRITE STRING TO MEMORY					- WS STRING, ADDRESS
	M:			SHOW/EDIT MEMORY AS BYTES				- M ADDRESS
	MEMCODE:	CODES MEMORY (EOR.B)					- MEMCODE START END CODE
	N:			SHOW/EDIT MEMORY AS ASCII				- N ADDRESS
	NO:			SHOW/SET ASCII-DUMP OFFSET				- NO (OFFSET)
	NQ:			DISPLAY MEMORY QUICK AS ASCII			- NQ ADDRESS
	O:			FILL MEMORYBLOCK WITH STRING			- O STRING, START END
	R:			SHOW/EDIT PROCESSOR REGISTERS			- R (REG VALUE)
	W:			SHOW/EDIT CIA'S							- W (REGISTER)
	Y:			SHOW/EDIT MEMORY AS BINARY				- Y ADDRESS
	YS:			SET DATAWIDTH IN Y COMMAND				- Y BYTES
	?:			CALCULATOR								- ? ( + ¦ - ¦ * ¦ / VALUE )

NUMBER FORMATS: 
	HEXADECIMAL:  $12AB OR 12AB
	DECIMAL:	  !15, !880
	BINARY:		  %001110101, %101
	DISKMONITOR (IF USING RT AND WT COMMANDS WITH DISKBUFFER): 
	A) T = TRACK (!0 - !159), S = SECTOR (!0 - !10), O = OFFSET (!0 - !511) 
	B) S = SECTOR (!0 - !1760), O = OFFSET (!0 - !511) 
	EXAMPLE TO READ/DISPLAY ROOTBLOCK: 
	RT !75 !10 
	M T!80 OR M T!80S0 OR M T$50S0O0 OR M T50S0O0 OR M S!880 OR M S370 

EDITOR-TOOLS: 
	HELP:	 THIS SHORT HELP 
	SHIFT:	 NO SCROLL/PAUSE 
	TAB:  INSERT SPACE(S) 
	ESC:  ESCAPES ANY COMMAND (NOT T/TS !) 
	F1:  CLR + HOME 
	F2:  HOME 
	F5:  PRINT SCREEN 
	F6:  SWITCH PRINTERDUMP ON/OFF 
	F7:  SWITCH OVERWRITE/INSERT MODE 
	F8:  SHOW INSTRUCTIONS OR MEMPEEKER 
	F9:  SWITCH GERMAN & US KEYBOARD 
	F10:  SWITCH SCREEN (BACK WITH SHIFT F10) 
	LED IS OFF = READY TO EXECUTE COMMANDS! 
	USE CURSORKEYS IN COMBINAION WITH SHIFT TOO 

;------------------------------------------------------------------------------
Action Replay - Referenzkarte - Vergleich zum WinUAE Debugger

COMMANDS FOR SYSTEM INFORMATION:
	INTERRUPTS:	 SHOW EXECBASE INTERRUPTLISTS			- INTERRUPTS
	EXCEPTIONS:	 SHOW EXCEPTION- AND INTERRUPTVECTORS	- EXCEPTIONS
	EXECBASE:	 SHOW WHOLE EXECBASESTRUCTURE			- EXECBASE
	AVAIL:		 SHOW FREE MEMORY						- AVAIL
	INFO:		 SHOW IMPORTANT SYSTEMPARAMETERS		- INFO
	LIBRARIES:	 SHOW EXECBASE LIBRARYLIST				- LIBRARIES
	RESOURCES:	 SHOW EXECBASE RESOURCELIST				- RESOURCES
	CHIPREGS:	 SHOW NAME + OFFSET OF CHIPREGISTERS	- CHIPREGS
	DEVICES:	 SHOW EXECBASE DEVICELIST				- DEVICES
	TASKS:		 SHOW EXECBASE TASKLISTS				- TASKS
	PORTS:		 SHOW EXECBASE PORTLIST					- PORTS

DISK AND DISKCODING COMMANDS
	BOOTCODE:	 SHOW/SET BOOTBLOCK CODENUMBER			- BOOTCODE (CODENUMBER)
	BOOTPROT:	 CODE BOOTBLOCK OF ACTIVE DRIVE			- BOOTPROT (CODENUMBER)
	CODE:		 SHOW/SET DISK CODENUMBERS			    - CODE (DRIVE CODENUMBER)
	DCOPY:		 BACKUP AMIGADOS DISKS					- DCOPY SOURCE DEST
	CODECOPY:	 DISKCOPY + DECODE SOURCE + CODE DEST	- CODECOPY SOURCE DEST
	CD:			 SHOW/CHANGE CURRENT MODULE-PATH		- CD (PATH)
	DIR:		 SHOW DISK-DIRECTORY					- DIR (PATH)
	DIRA:		 SHOW WHOLE DISK-DIRECTORY				- DIRA (PATH) 
	MAKEDIR:	 CREATE DIRECTORY						- MAKEDIR PATH
	DELETE:		 DELETE FILE							- DELETE (PATH)FILENAME
	FORMAT:		 FORMAT DISK IN ACTIVE DRIVE			- FORMAT (NAME)
	FORMATQ:	 FORMAT DISK QUICK						- FORMATQ (NAME)
	FORMATV:	 FORMAT DISK AND VERIFY FORMAT			- FORMATV (NAME)
	INSTALL:	 INSTALL DISK IN ACTIVE DRIVE			- INSTALL (BOOTBLOCKNR.)
	DISKCHECK:	 CHECKS DISK FOR ERRORS					- DISKCHECK (DRIVE)
																					; Bsp.: diskcheck 0
																					; Disk ok	
	DISKWIPE:	 CLEARS A DISK VERY FAST				- DISKWIPE (DRIVE) 
	TYPE:		 TYPE FILE ON SCREEN					- TYPE (PATH)FILENAME 

FREEZER AND RIPPER COMMANDS:
	SA:			 SAVE CURRENT PROGRAM TO DISK			- SA (PATH)NAME(,CRATE)
	SR:			 SAVE CURRENT PROGRAM AND START			- SR (PATH)NAME(,CRATE)
	LA:			 LOAD FREEZEFILE FROM DISK				- LA (PATH)NAME
	LR:			 LOAD FREEZEFILE FROM DISK AND START	- LR (PATH)NAME
	SLOADER:	 SAVE LOADER TO ACTIVE DRIVE			- SLOADER
	LQ:			 LOAD ALL FROM RAMDISK					- LQ
	LQR:		 LOAD ALL FROM RAMDISK AND RESTART		- LQR
	SQ:			 SAVE ALL TO RAMDISK					- SQ
	SQR:		 SAVE ALL TO RAMDISK AND RESTART		- SQR
	TRACKER:	 RIPS SOUNDTRACKER-MODULS IN MEMORY		- TRACKER START
	SCAN:		 SCAN MEMORY FOR SAMPLES				- SCAN
	SP:			 SAVE CURRENT PICTURE TO DISK			- SP (PATH)NAME(,NR HEIGHT)
	P:			 SHOW CURRENT PICTURE/MEMPEEKER			- P (PICNR)
	SPM:		 SAVE PICTURE OF MEMPEEKER				- SPM NAME
	
DISKMONITOR COMMANDS:
	RT:			READ TRACKS FROM ACTIVE DRIVE			- RT STRACK (NUM DEST)
																					; RT 0 2 $20000 ; Bootblock in Speicher kopieren
	WT:			WRITE TRACKS TO ACTIVE DRIVE			- WT STRACK NUM SOURCE
																					; WT 0 2 $20000 ; Speicher in Bootblock schreiben
	DMON:		DISPLAY RANGE OF DISK-MON BUFFER		- DMON

CLRDMON: RESTORE DISK-MON BUFFER - CLRDMON
	BOOTCHK:	SET CORRECT BOOTBLOCKCHECKSUM			- BOOTCHK SECTORADDR.
	DATACHK:	SET CORRECT DATACHECKSUM				- DATACHK SECTORADDR.
	BAMCHK:		SET CORRECT BITMAPCHECKSUM				- BAMCHK SECTORADDR.

TRAINER COMMANDS: 
	TS:			START TRAINER/TRAINERMODE				- TS STARTLIVES
	T:			CONTINUE TRAINER						- T AKTLIVES
	TX:			EXIT TRAINERMODE						- TX
	TF:			SEARCH FOR DECREMENTING OPCODES			- TF ADDRESS
	TFD:		SEARCH AND REMOVE DECREMENT OPCODES		- TFD ADDRESS
	PC:			SHOW CURRENT PICTURE + ENERGY COUNT		- PC (PICNR)

MISC. COMMANDS
	RAMTEST:	CHECKS MEMORYBLOCK FOR HARDERRORS		- RAMTEST START END
	PACK:		PACKS MEMORY							- PACK START END DEST CRRATE
	UNPACK:		UNPACKS WITH PACK-COMMAND PACKED MEM	- UNPACK DEST END OF PACKED
	COLOR:		SET MODUL-EDITOR COLORS					- COLOR BACK PEN
	RCOLOR:		RESET MODUL-EDITOR COLORS				- RCOLOR
	TM:			SHOW REMARKS ABOUT CURR. PROGRAM		- TM
	TMS:		SET REMARK ABOUT CURR. PROGRAMADDR.		- TMS ADDR
	TMD:		DELETE REMARK ABOUT PROGRAM				- TMD ADDR
	SPR:		SHOW/EDIT SPRITES						- SPR NR¦ADDR (NR¦ADDR)

VIRUS COMMANDS: 
	VIRUS:		SEARCH VIRUS IN MEMORY					- VIRUS
	KILLVIRUS:	SEARCH AND REMOVE VIRUS IN MEMORY		- KILLVIRUS

MONITOR COMMANDS: 
	SETEXCEPT:	SET EXCEPTION HANDLER (NO MORE GURU)	- SETEXCEPT
																					; installiert den Exception-Handler des Moduls, der bewirkt, daß bei den meisten
																					; Systemabstürzen (siehe unten) zunächst kein GURU ausgelöst wird, sondern das Modul
																					; aufgerufen wird. Es meldet sich dabei mit der Meldung, welche Exception den GURU
																					; verursacht hat und wo etwa der fehlerhafte Befehl steckt.
	COMP:		COMPARE MEMORYBLOCKS					- COMP START END DEST
																					; vergleicht den Speicherbereich von "start" bis "end" mit dem Speicherbereich ab "dest" und
																					; gibt Unterschiede anhand ihrer Adressen im "dest"-Bereich aus.
																					; Bsp.: M 100
																					; :000100 12 11 01 12 12 01 00 00 ........
																					; COMP 100 103 103
																					; 000104
																					; READY.
	LM:			LOAD FILE TO MEMORY						- LM (PATH)NAME, DEST
																					; lädt den unter dem Namen "name" im Unterverzeichnis "path" oder dem aktuellen
																					; Unterverzeichnis abgespeicherten Speicherbereich (normale Datei) ab der angegebenen
																					; Adresse "dest" in den Speicher.
																					; Bsp.: LM "MEM",100
	SM:			SAVE MEMORY BLOCK TO DISK				- SM (PATH)NAME, START END
																					; speichert den Speicherbereich von "start" bis "end" unter dem Namen "name" im aktuellen
																					; oder angegebenen Verzeichnis auf Diskette ab.
	SMDC:		SAVE MEMORY BLOCK TO DISK AS DC.B		- SMDC (PATH)NAME, START END
																					; gleiche Funktion wie SM-Befehl, jedoch wird ein File erzeugt, das den angegebenen
																					; Speicherbereich in Form von dc-Zeilen enthält.
	SMDATA:		SAVE MEMORY BLOCK TO DISK AS DATA		- SMDATA (PATH)NAME, START END
																					; gleiche Funktion wie SM-Befehl, jedoch wird ein File erzeugt, das den angegebenen
																					; Speicherbereich in Form von BASIC DATA-Zeilen enthält.
	A:			START M68000 ASSEMBLER					- A ADDRESS
																					; Bsp.: A 700000
																					; 070000 ADDQ.L #1,D0
																					; 070002 RTS
																					; 070004
	B:			SHOW CURRENT BREAKPOINTS				- B ADDRESS
																					; zeigt die derzeitig gesetzten Breakpoints an.
	BS:			SET BREAKPOINT							- BS ADDRESS
																					; setzt einen Breakpoint auf die angegebene Adresse. (max. 5 Breakpoints)
	BD:			DELETE BREAKPOINT						- BD ADDRESS
																					; löscht den Breakpoint auf der angegebenen Adresse.
	BDA:		DELETE ALL BREAKPOINTS					- BDA
																					; löscht alle gesetzten Breakpoints.
	X:			RESTART CURRENT PROGRAM					- X
																					; Action Replay verlassen (Programm fortsetzen)
	C:			COPPERASSEMBLER/DISASSEMBLER			- C 1¦2¦ADDRESS
																					; disassembliert die Copper-Liste ab der angegebenen Adresse.
																					; kann editiert werden
																					; Bsp.:
	D:			M68000 DISASSEMBLER						- D (0¦ADDRESS)
																					; d 506A0
																					; 0506A0 MOVE.W D1,(A1)+
	E:			SHOW/EDIT CHIPREGISTERS					- E (OFFSET)
																					; zeigt den Inhalt des mit "registeroffset" angegebenen Custom Chip-Registers
																					; E 180
																					; 180 000 %				; Color 0
	F:			SEARCH FOR STRING (CASESENSITIVE)		- F STRING(,START END)
																					; durchsucht den gesamten Speicher oder, falls angegeben, den Speicherbereich von "start"
																					; bis "end" nach dem angegebenen String und gibt die gefundenen Adressen der Reihe nach aus.
	FA:			SEARCH FOR ADR ADDRESSING OPCODE		- FA ADDRESS (START END)
																					; durchsucht den gesamten Speicher oder, falls angegeben, den Speicherbereich von "start"
																					; bis "end" nach Maschinenbefehlen, die in irgendeiner Weise auf die angegebene Adresse zugreifen.
	FAQ:		FASTSEARCH FOR ADR ADDRESSING OPCODE	- FAQ ADR (START END)
																					; wirkt wie der FA-Befehl, nur ist der FAQ-Befehl ca. doppelt so schnell.
	FR:			SEARCH FOR RELATIVE-STRING				- FR STRING(,START END)
																					; durchsucht den gesamten Speicher oder, falls angegeben, den Speicherbereich von "start"
																					; bis "end" nach dem angegebenen String, macht aber keine Unterscheidung zwischen Großund
																					; Kleinbuchstaben (dadurch besonders geeignet ASCII-Texte zu finden)
	FS:			SEARCH STRING (NOT CASESENSITIVE)		- FS STRING(,START END)
																					; durchsucht den gesamten Speicher oder, falls angegeben, den Speicherbereich von "start"
																					; bis "end" nach dem angegebenen String, jedoch relativ, d.h. wird beispielsweise der String
																					; 0A 03 0B angegeben, sucht er nach folgender Bytefolge: xx xx-7 xx+1, wobei xx beliebig ist!
																					; So findet der FR-Befehl auch die Bytefolge 15 0E 16 oder 38 31 39.
	G:			RESTART PROGRAM AT ADDRESS				- G ADDRESS
																					; setzt das unterbrochene Programm an der angegebenen Adresse
																					; G FC00D2 - springt in die Kickstart Reset-Routine -> es wird ein Soft-Reset ausgelöst.
	TRANS:		COPY MEMORYBLOCK						- TRANS START END DEST
																					; kopiert den Speicherbereich von "start" bis "end" in den Speicher des Amigas ab der Adresse "dest".
																					; Bsp.: TRANS 100 200 10000
																					; kopiert $100-$1FF (=$100 Bytes) nach $1000-$10FF
	WS:			WRITE STRING TO MEMORY					- WS STRING, ADDRESS
																					; 
	M:			SHOW/EDIT MEMORY AS BYTES				- M ADDRESS
																					; m 506A0	; jedoch nur eine Zeile 
																					; 00000420 0180 005A 00E2 0000 0120 0000 0122 0C80  ...Z..... ..."..
	MEMCODE:	CODES MEMORY (EOR.B)					- MEMCODE START END CODE
																					; kodiert den Speicherbereich von "start" bis "end" mit der Kodezahl "code" (0-$ffffffff).
																					; Der so kodierte Speicher kann wieder decodiert werden, indem man ihn nochmals mit
																					; demselben Kode zu kodieren versucht.
	N:			SHOW/EDIT MEMORY AS ASCII				- N ADDRESS
																					; gibt den Speicher ab der angegebenen Adresse als Text aus
	NO:			SHOW/SET ASCII-DUMP OFFSET				- NO (OFFSET)
																					; setzt den Offset beim N/NQ-Befehl auf den angegebenen Wert
																					; Bsp.: M 1234
																					; :001234 41 42 43 44 00 00 00 00 ABCD....
																					; N 1234
																					; 001234 ABCD............................
																					; NO 1
																					; N 1234
																					; 001234 BCDE.............................
	NQ:			DISPLAY MEMORY QUICK AS ASCII			- NQ ADDRESS
																					; gibt den Speicher ab der angegebenen Adresse als Text aus.
	O:			FILL MEMORYBLOCK WITH STRING			- O STRING, START END
																					; füllt den angegebenen Speicherbereich von "start" bis "end" mit dem angegebenen String.
																					; Bsp.: O "AMIGA",0 80000
																					; N 0
																					; 000000 AMIGAAMIGAAMIGAAMIGAAMIGAAMIGAAM
																					; O 0, 0 4
																					; M 0
																					; :000000 00 00 00 00 41 41 4D 49 ....AAMI
	R:			SHOW/EDIT PROCESSOR REGISTERS			- R (REG VALUE)
																					; setzt, falls angegeben, das CPU-Register auf den angegebenen Wert und gibt sämtliche
																					; Register auf dem Bildschirm aus. Für "register" schreibt man:
																					; r
																					; D0: 00009000 00006000 00000000 00000000 00000000 00000000 00000000 00000000
																					; A0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 07CA4F64
																					; PC=07CA7B52 USP=07CA4F64 SR=0010 T=0 S=0 I=000 X=1 N=0 Z=0 V=0 C=0

																					; Datenregister: D0, D1, D2, ..., D7
																					; Adressregister: A0, A1, ...A7
																					; User Stackpointer: SP
																					; Statusregister: SR
																					; Programcounter: PC
																					; Flags im SR: FT, FS, FV, FC, FZ oder FX
																					; Interruptmaske: FI
	W:			SHOW/EDIT CIA'S							- W (REGISTER)
																					; stellt den Inhalt des angegebenen Registers der beiden CIA's auf dem Bildschirm dar. Die
																					; Inhalte der Register können direkt im Listing verändert werden.
	Y:			SHOW/EDIT MEMORY AS BINARY				- Y ADDRESS
																					; gibt den Speicher ab der angegebenen Adresse binär aus und zwar soviele Bytes, wie mit
																					; Hilfe des YS-Befehls eingestellt worden sind.
	YS:			SET DATAWIDTH IN Y COMMAND				- Y BYTES
																					; setzt die Byteanzahl "bytes" für den Y-Befehl auf den angegebenen Wert. Es können Werte
																					; zwischen 1 und 8 angegeben werden.
																					; Bsp.: Y 100
																					; .000100 %0011001100110011
																					; YS 1
																					; Y 100
																					; .000100 %00110011
																					; .000101 %00110011
																					; YS
																					; CURRENT BIT WIDTH: !08
	?:			CALCULATOR								- ? ( + ¦ - ¦ * ¦ / VALUE )
																					; Mini-Taschenrechner

NUMBER FORMATS: 
	HEXADECIMAL:  $12AB OR 12AB
	DECIMAL:	  !15, !880
	BINARY:		  %001110101, %101
	DISKMONITOR (IF USING RT AND WT COMMANDS WITH DISKBUFFER): 
	A) T = TRACK (!0 - !159), S = SECTOR (!0 - !10), O = OFFSET (!0 - !511) 
	B) S = SECTOR (!0 - !1760), O = OFFSET (!0 - !511) 
	EXAMPLE TO READ/DISPLAY ROOTBLOCK: 
	RT !75 !10 
	M T!80 OR M T!80S0 OR M T$50S0O0 OR M T50S0O0 OR M S!880 OR M S370 

EDITOR-TOOLS: 
	HELP:	 THIS SHORT HELP 
	SHIFT:	 NO SCROLL/PAUSE 
	TAB:  INSERT SPACE(S) 
	ESC:  ESCAPES ANY COMMAND (NOT T/TS !) 
	F1:  CLR + HOME 
	F2:  HOME 
	F5:  PRINT SCREEN 
	F6:  SWITCH PRINTERDUMP ON/OFF 
	F7:  SWITCH OVERWRITE/INSERT MODE 
	F8:  SHOW INSTRUCTIONS OR MEMPEEKER 
	F9:  SWITCH GERMAN & US KEYBOARD 
	F10:  SWITCH SCREEN (BACK WITH SHIFT F10) 
	LED IS OFF = READY TO EXECUTE COMMANDS! 
	USE CURSORKEYS IN COMBINAION WITH SHIFT TOO 