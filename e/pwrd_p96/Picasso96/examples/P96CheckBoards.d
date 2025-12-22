/***********************************************************************
* This is example shows how to use p96GetRTGDataTagList and p96GetBoardDataTagList
*
* tabt (Sat Sep 12 23:06:28 1998)
*
* converted by Martin <MarK> Kuchinka, 13.9.2001
***********************************************************************/

MODULE	'picasso96','libraries/picasso96'
MODULE	'utility/tagitem'

DEF	P96Base

PROC main()
	IF P96Base:=OpenLibrary(P96NAME, 2)
		DEFUL	NumBoards

		IF p96GetRTGDataTags(P96RD_NumberOfBoards, &NumBoards, TAG_END)=1
			DEF	i

			PrintF('Looking through all boards installed for Picasso96\n')
			FOR i:=0 TO NumBoards-1
				DEF	BoardName:PTR TO UB
				DEFUL	RGBFormats,
						MemorySize,
						FreeMemory,
						LargestFreeMemory,
						MemoryClock,
						MoniSwitch
				DEF	clock

				p96GetBoardDataTags(i,
						P96BD_BoardName,         &BoardName,
						P96BD_RGBFormats,        &RGBFormats,
						P96BD_TotalMemory,       &MemorySize,
						P96BD_FreeMemory,        &FreeMemory,
						P96BD_LargestFreeMemory, &LargestFreeMemory,
						P96BD_MemoryClock,       &MemoryClock,
						P96BD_MonitorSwitch,     &MoniSwitch,
						TAG_END)
				PrintF('--------------------------------------------------\n')
				PrintF('Board %ld:                   %s\n', i, BoardName)
				PrintF('Total size of memory:     %8ld\n', MemorySize)
				PrintF('Size of free memory:      %8ld\n', FreeMemory)
				PrintF('Largest free chunk:       %8ld\n', LargestFreeMemory)
				PrintF('Monitor switch:            %s\n',   IF MoniSwitch THEN 'set' ELSE 'not set')

				PrintF('\nThis board supports:\n')
				PrintF('\tfollowing rgb formats:\n')
				IF RGBFormats & RGBFF_NONE 		THEN PrintF('\t\tPLANAR\n')
				IF RGBFormats & RGBFF_CLUT 		THEN PrintF('\t\tCHUNKY\n')
				IF RGBFormats & RGBFF_R5G5B5 		THEN PrintF('\t\tR5G5B5\n')
				IF RGBFormats & RGBFF_R5G5B5PC 	THEN PrintF('\t\tR5G5B5PC\n')
				IF RGBFormats & RGBFF_B5G5R5PC 	THEN PrintF('\t\tB5G5R5PC\n')
				IF RGBFormats & RGBFF_R5G6B5 		THEN PrintF('\t\tR5G6B5\n')
				IF RGBFormats & RGBFF_R5G6B5PC 	THEN PrintF('\t\tR5G6B5PC\n')
				IF RGBFormats & RGBFF_B5G6R5PC 	THEN PrintF('\t\tB5G6R5PC\n')
				IF RGBFormats & RGBFF_R8G8B8 		THEN PrintF('\t\tR8G8B8\n')
				IF RGBFormats & RGBFF_B8G8R8 		THEN PrintF('\t\tB8G8R8\n')
				IF RGBFormats & RGBFF_A8R8G8B8 	THEN PrintF('\t\tA8R8G8B8\n')
				IF RGBFormats & RGBFF_A8B8G8R8 	THEN PrintF('\t\tA8B8G8R8\n')
				IF RGBFormats & RGBFF_R8G8B8A8 	THEN PrintF('\t\tR8G8B8A8\n')
				IF RGBFormats & RGBFF_B8G8R8A8 	THEN PrintF('\t\tB8G8R8A8\n')
				IF RGBFormats & RGBFF_Y4U2V2 		THEN PrintF('\t\tY4U2V2\n')
				IF RGBFormats & RGBFF_Y4U1V1 		THEN PrintF('\t\tY4U1V1\n')
				clock:=(MemoryClock+50000)/100000
				PrintF('\tmemory clock set to %ld.%1ld MHz\n',clock/10,clock\10)
			ENDFOR
		ENDIF
		CloseLibrary(P96Base)
	ENDIF
ENDPROC
