/***********************************************************************************
* This is example shows how to use p96GetRTGDataTagList and p96GetBoardDataTagList
*
* Translated to E language by: Jean-Marie COAT (23.06.2006) <agalliance@wanadoo.fr>
*
************************************************************************************/

OPT PREPROCESS

MODULE	'utility/tagitem',
	'libraries/picasso96',
	'picasso96API'

ENUM ER_NONE, ER_NP96

PROC main() HANDLE
DEF	numboards:PTR TO LONG,
	rgbformats:PTR TO LONG,
	memorysize:PTR TO LONG,
	freememory:PTR TO LONG,
	largestfreememory:PTR TO LONG,
	memoryclock:PTR TO LONG,
	moniswitch:PTR TO LONG,
	i, bufclock[8]:STRING,
	boardname:PTR TO CHAR,
	clock,tags, getopt:LONG,hertz


	IF (p96base := OpenLibrary(P96NAME, 2)) = NIL THEN Raise(ER_NP96)

	tags := [P96RD_NumberOfBoards,{numboards},TAG_END]: tagitem

	getopt:= p96getrtgdatataglist(tags)

	IF (getopt = 1)

		WriteF('Looking through all boards installed for Picasso96\n')

		FOR i := 0 TO numboards
			IF ( i < numboards )
				
				p96getboarddatataglist(i,
						[P96BD_BoardName, {boardname},
						P96BD_RGBFormats, {rgbformats},
						P96BD_TotalMemory, {memorysize},
						P96BD_FreeMemory, {freememory},
						P96BD_LargestFreeMemory, {largestfreememory},
						P96BD_MemoryClock, {memoryclock},
						P96BD_MonitorSwitch, {moniswitch},
						TAG_END])
				WriteF('\e[1m--------------------------------------------------\e[0m\n')
				WriteF('\e[1mBoard \e[0m\e[32m\d \e[0m:\t\e[32m\s \e[0m\n', i, boardname)
				WriteF('\e[1m--------------------------------\e[0m\n')
				WriteF('Total size of memory:\t\e[32m\d[8] \e[0m\n', memorysize)
				WriteF('Size of free memory:\t\e[32m\d[8] \e[0m\n', freememory)
				WriteF('Largest free chunk:\t\e[32m\d[8] \e[0m\n', largestfreememory)
				WriteF('\e[1m--------------------------------\e[0m\n')
				WriteF('Monitor switch:\t\s\n', IF moniswitch THEN '\e[32mSet\e[0m' ELSE  '\e[32mNot set\e[0m')

				WriteF('\nThis board supports:\n')
				WriteF('\tfollowing rgb formats:\n\n')

				IF (rgbformats AND RGBFF_NONE)		THEN	WriteF('\t\tPLANAR\n')
				IF (rgbformats AND RGBFF_CLUT)		THEN	WriteF('\t\tCHUNKY\n')
				IF (rgbformats AND RGBFF_R5G5B5)	THEN	WriteF('\t\tR5G5B5\n')
				IF (rgbformats AND RGBFF_R5G5B5PC)	THEN	WriteF('\t\tR5G5B5PC\n')
				IF (rgbformats AND RGBFF_B5G5R5PC)	THEN	WriteF('\t\tB5G5R5PC\n')
				IF (rgbformats AND RGBFF_R5G6B5)	THEN	WriteF('\t\tR5G6B5\n')
				IF (rgbformats AND RGBFF_R5G6B5PC)	THEN	WriteF('\t\tR5G6B5PC\n')
				IF (rgbformats AND RGBFF_B5G6R5PC)	THEN	WriteF('\t\tB5G6R5PC\n')
				IF (rgbformats AND RGBFF_R8G8B8)	THEN	WriteF('\t\tR8G8B8\n')
				IF (rgbformats AND RGBFF_B8G8R8)	THEN	WriteF('\t\tB8G8R8\n')
				IF (rgbformats AND RGBFF_A8R8G8B8)	THEN	WriteF('\t\tA8R8G8B8\n')
				IF (rgbformats AND RGBFF_A8B8G8R8)	THEN	WriteF('\t\tA8B8G8R8\n')
				IF (rgbformats AND RGBFF_R8G8B8A8)	THEN	WriteF('\t\tR8G8B8A8\n')
				IF (rgbformats AND RGBFF_B8G8R8A8)	THEN	WriteF('\t\tB8G8R8A8\n')
				IF (rgbformats AND RGBFF_Y4U2V2)	THEN	WriteF('\t\tY4U2V2\n')
				IF (rgbformats AND RGBFF_Y4U1V1)	THEN	WriteF('\t\tY4U1V1\n')
				clock := Div((memoryclock+50000),100000)

				StringF(bufclock,'\d',clock)

				hertz:=proc_FindHertz(bufclock) -> ** Replace from C: printf("\tmemory clock set to %ld.%1ld MHz,\n",clock/10,clock%10)

				WriteF('\n\tMemory clock set to: \e[32m\d\e[0m.\e[32m\s\e[0m MHz\n', clock/10, hertz)
			ENDIF
			i++
		ENDFOR
	ELSE
		WriteF('something merdouille!!!\n')
	ENDIF
EXCEPT DO
   SELECT exception
	CASE ER_NP96
		WriteF('Libary \s no found!\n',P96NAME)
  ENDSELECT
  IF p96base THEN CloseLibrary(p96base)
  IF exception THEN CleanUp(20)
ENDPROC 0

PROC proc_FindHertz(buffer)
DEF	scan
	scan:=RightStr(buffer,buffer,1)

ENDPROC scan
