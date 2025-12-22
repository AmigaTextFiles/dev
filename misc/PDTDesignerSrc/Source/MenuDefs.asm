	opt	c+,d+,l+

	incdir	sys:include/
	include	intuition/intuition.i

	output	MapDesignerV2.0:Modules/MenuDefs.o

;   This file contains the static declarations for the menus used in the
; Map Designer V2.xx Utility.

	section	Menus,Data

	xdef	DesignerMenus
	xdef	ProjectMenu,TilesMenu,MapMenu,BlocksMenu,PrefsMenu
	xdef	Project.1,Project.2,Project.3,Project.4,Project.5,Project.6
	xdef	Tiles.1,Tiles.2,Tiles.2.1,Tiles.2.2,Tiles.3,Tiles.3.1
	xdef	Tiles.3.2,Tiles.3.3,Tiles.3.4,Tiles.4
	xdef	Map.1,Map.2,Map.3,Map.3.1,Map.3.2,Map.4,Map.5,Blocks.1
	xdef	Blocks.2,Blocks.3,Blocks.4,Blocks.5,Prefs.1,Prefs.2,Prefs.3
	xdef	Prefs.4,Prefs.5

;   All structure labels start with a name, this tells which menu the struct.
; is associated with.  The name is followed by index numbers these show the
; menu item number...

; EG1:	Project.1	-	Project menu item 1.

; EG2:	Tiles3.2	-	Tiles menu item 3, sub-item 2.

DesignerMenus:

;	Here they are!!

ProjectMenu:
	dc.l	TilesMenu
	dc.w	0,0,112,8
	dc.w	MENUENABLED
	dc.l	ProjectASCII
	dc.l	Project.1
	ds.w	4
ProjectASCII:
	dc.b	"   Project",0
	even

TilesMenu:
	dc.l	MapMenu
	dc.w	112,0,96,8
	dc.w	MENUENABLED
	dc.l	TilesASCII
	dc.l	Tiles.1
	ds.w	4
TilesASCII:
	dc.b	"   Tiles",0
	even

MapMenu:
	dc.l	BlocksMenu
	dc.w	208,0,80,8
	dc.w	MENUENABLED
	dc.l	MapASCII
	dc.l	Map.1
	ds.w	4
MapASCII:
	dc.b	"   Map",0
	even

BlocksMenu:
	dc.l	PrefsMenu
	dc.w	288,0,104,8
	dc.w	MENUENABLED
	dc.l	BlocksASCII
	dc.l	Blocks.1
	ds.w	4
BlocksASCII:
	dc.b	"   Blocks",0
	even

PrefsMenu:
	dc.l	0
	dc.w	392,0,96,8
	dc.w	MENUENABLED
	dc.l	PrefsASCII
	dc.l	Prefs.1
	ds.w	4
PrefsASCII:
	dc.b	"   Prefs",0
	even

Project.1:			** Clear All **
	dc.l	Project.2
	dc.w	0,0
	dc.w	128,8
	dc.w	(ITEMTEXT!HIGHCOMP)
	dc.l	0
	dc.l	Project.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Project.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Project.1ASCII
	dc.l	0
Project.1ASCII:
	dc.b	" Clear All",0
	even

Project.2:			** Load Map... **
	dc.l	Project.3
	dc.w	0,8
	dc.w	128,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Project.2Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Project.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Project.2ASCII
	dc.l	0
Project.2ASCII:
	dc.b	" Load Map...",0
	even

Project.3:			** Save Map **
	dc.l	Project.4
	dc.w	0,16
	dc.w	128,8
	dc.w	(ITEMTEXT!HIGHCOMP)
	dc.l	0
	dc.l	Project.3Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Project.3Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Project.3ASCII
	dc.l	0
Project.3ASCII:
	dc.b	" Save Map",0
	even

Project.4:			** Save Map As... **
	dc.l	Project.5
	dc.w	0,24
	dc.w	128,8
	dc.w	(ITEMTEXT!HIGHCOMP)
	dc.l	0
	dc.l	Project.4Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Project.4Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Project.4ASCII
	dc.l	0
Project.4ASCII:
	dc.b	" Save Map As...",0
	even

Project.5:			** About... **
	dc.l	Project.6
	dc.w	0,32
	dc.w	128,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Project.5Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Project.5Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Project.5ASCII
	dc.l	0
Project.5ASCII:
	dc.b	" About...",0
	even

Project.6:			** Quit **
	dc.l	0
	dc.w	0,40
	dc.w	128,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Project.6Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Project.6Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Project.6ASCII
	dc.l	0
Project.6ASCII:
	dc.b	" Quit",0
	even


Tiles.1:			** Load IFF Tiles... **
	dc.l	Tiles.2
	dc.w	0,0
	dc.w	152,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Tiles.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.1ASCII
	dc.l	0
Tiles.1ASCII:
	dc.b	" Load IFF Tiles...",0
	even

Tiles.2:			** Save Tiles   » **
	dc.l	Tiles.3
	dc.w	0,8
	dc.w	152,8
	dc.w	(ITEMTEXT!HIGHCOMP)
	dc.l	0
	dc.l	Tiles.2Text
	dc.l	0
	dc.b	0
	dc.l	Tiles.2.1
	dc.w	MENUNULL
Tiles.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.2ASCII
	dc.l	0
Tiles.2ASCII:
	dc.b	" Save Tiles      »",0
	even

Tiles.2.1:			** IFF Format... **
	dc.l	Tiles.2.2
	dc.w	152,0
	dc.w	120,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Tiles.2.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.2.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.2.1ASCII
	dc.l	0
Tiles.2.1ASCII:
	dc.b	" IFF Format...",0
	even

Tiles.2.2:			** Raw Format... **
	dc.l	0
	dc.w	152,8
	dc.w	120,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Tiles.2.2Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.2.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.2.2ASCII
	dc.l	0
Tiles.2.2ASCII:
	dc.b	" Raw Format...",0
	even

Tiles.3:			** Set Tile Size   » **
	dc.l	Tiles.4
	dc.w	0,16
	dc.w	152,8
	dc.w	(ITEMTEXT!HIGHCOMP)
	dc.l	0
	dc.l	Tiles.3Text
	dc.l	0
	dc.b	0
	dc.l	Tiles.3.1
	dc.w	MENUNULL
Tiles.3Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.3ASCII
	dc.l	0
Tiles.3ASCII:
	dc.b	" Set Tile Size   »",0
	even

Tiles.3.1:			** 32 x 32 **
	dc.l	Tiles.3.2
	dc.w	152,0
	dc.w	72,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Tiles.3.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.3.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.3.1ASCII
	dc.l	0
Tiles.3.1ASCII:
	dc.b	" 32 x 32 ",0
	even

Tiles.3.2:			** 32 x 16 **
	dc.l	Tiles.3.3
	dc.w	152,8
	dc.w	72,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Tiles.3.2Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.3.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.3.2ASCII
	dc.l	0
Tiles.3.2ASCII:
	dc.b	" 32 x 16 ",0
	even

Tiles.3.3:			** 16 x 32 **
	dc.l	Tiles.3.4
	dc.w	152,16
	dc.w	72,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Tiles.3.3Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.3.3Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.3.3ASCII
	dc.l	0
Tiles.3.3ASCII:
	dc.b	" 16 x 32 ",0
	even

Tiles.3.4:			** 16 x 16 **
	dc.l	0
	dc.w	152,24
	dc.w	72,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Tiles.3.4Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.3.4Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.3.4ASCII
	dc.l	0
Tiles.3.4ASCII:
	dc.b	" 16 x 16 ",0
	even

Tiles.4:			** Pick Tile... **
	dc.l	0
	dc.w	0,24
	dc.w	152,8
	dc.w	(ITEMTEXT!HIGHCOMP)
	dc.l	0
	dc.l	Tiles.4Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Tiles.4Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Tiles.4ASCII
	dc.l	0
Tiles.4ASCII:
	dc.b	" Pick Tile...",0
	even

Map.1:				** Clear Map **
	dc.l	Map.2
	dc.w	0,0
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Map.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Map.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Map.1ASCII
	dc.l	0
Map.1ASCII:
	dc.b	" Clear Map",0
	even

Map.2:				** Set Map Size... **
	dc.l	Map.3
	dc.w	0,8
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Map.2Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Map.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Map.2ASCII
	dc.l	0
Map.2ASCII:
	dc.b	" Set Map Size...",0
	even

Map.3:				** Set Map Res   » **
	dc.l	Map.4
	dc.w	0,16
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Map.3Text
	dc.l	0
	dc.b	0
	dc.l	Map.3.1
	dc.w	MENUNULL
Map.3Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Map.3ASCII
	dc.l	0
Map.3ASCII:
	dc.b	" Set Map Res   »",0
	even

Map.3.1:			** Low Res Screen **
	dc.l	Map.3.2
	dc.w	136,0
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Map.3.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Map.3.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Map.3.1ASCII
	dc.l	0
Map.3.1ASCII:
	dc.b	" Low Res Screen",0
	even

Map.3.2:			** High Res Screen **
	dc.l	0
	dc.w	136,8
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Map.3.2Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Map.3.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Map.3.2ASCII
	dc.l	0
Map.3.2ASCII:
	dc.b	" High Res Screen",0
	even

Map.4:				** Save Raw Map... **
	dc.l	Map.5
	dc.w	0,24
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Map.4Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Map.4Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Map.4ASCII
	dc.l	0
Map.4ASCII:
	dc.b	" Save Raw Map...",0
	even

Map.5:				** Discard Map **
	dc.l	0
	dc.w	0,32
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Map.5Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Map.5Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Map.5ASCII
	dc.l	0
Map.5ASCII:
	dc.b	" Discard Map",0
	even


Blocks.1:			** Get Map Block **
	dc.l	Blocks.2
	dc.w	0,0
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Blocks.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Blocks.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Blocks.1ASCII
	dc.l	0
Blocks.1ASCII:
	dc.b	" Get Map Block",0
	even

Blocks.2:			** Get Tiles Block **
	dc.l	Blocks.3
	dc.w	0,8
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Blocks.2Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Blocks.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Blocks.2ASCII
	dc.l	0
Blocks.2ASCII:
	dc.b	" Get Tiles Block",0
	even

Blocks.3:			** Use Last Block **
	dc.l	Blocks.4
	dc.w	0,16
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Blocks.3Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Blocks.3Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Blocks.3ASCII
	dc.l	0
Blocks.3ASCII:
	dc.b	" Use Last Block",0
	even

Blocks.4:			** Discard Block **
	dc.l	Blocks.5
	dc.w	0,24
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Blocks.4Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Blocks.4Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Blocks.4ASCII
	dc.l	0
Blocks.4ASCII:
	dc.b	" Discard Block",0
	even

Blocks.5:			** Filled Box **
	dc.l	0
	dc.w	0,32
	dc.w	136,8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED)
	dc.l	0
	dc.l	Blocks.5Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Blocks.5Text:
	dc.b	1,2,RP_JAM2
	dc.w	0,0
	dc.l	0
	dc.l	Blocks.5ASCII
	dc.l	0
Blocks.5ASCII:
	dc.b	" Filled Box",0
	even

Prefs.1:			** Paint Mode **
	dc.l	Prefs.2
	dc.w	0,0
	dc.w	(128+CHECKWIDTH),8
	dc.w	(ITEMTEXT!HIGHCOMP!ITEMENABLED!CHECKIT!MENUTOGGLE)
	dc.l	0
	dc.l	Prefs.1Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Prefs.1Text:
	dc.b	1,2,RP_JAM2
	dc.w	CHECKWIDTH,0
	dc.l	0
	dc.l	Prefs.1ASCII
	dc.l	0
Prefs.1ASCII:
	dc.b	" Paint Mode",0
	even
Prefs.2:			** Include Tiles **
	dc.l	Prefs.3
	dc.w	0,8
	dc.w	(128+CHECKWIDTH),8
	dc.w	(ITEMTEXT!HIGHCOMP!CHECKIT!MENUTOGGLE)
	dc.l	0
	dc.l	Prefs.2Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Prefs.2Text:
	dc.b	1,2,RP_JAM2
	dc.w	CHECKWIDTH,0
	dc.l	0
	dc.l	Prefs.2ASCII
	dc.l	0
Prefs.2ASCII:
	dc.b	" Include Tiles",0
	even
Prefs.3:			** Create Icon **
	dc.l	Prefs.4
	dc.w	0,16
	dc.w	(128+CHECKWIDTH),8
	dc.w	(ITEMTEXT!HIGHCOMP!CHECKIT!MENUTOGGLE)
	dc.l	0
	dc.l	Prefs.3Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Prefs.3Text:
	dc.b	1,2,RP_JAM2
	dc.w	CHECKWIDTH,0
	dc.l	0
	dc.l	Prefs.3ASCII
	dc.l	0
Prefs.3ASCII:
	dc.b	" Create Icon",0
	even
Prefs.4:			** Workbench **
	dc.l	Prefs.5
	dc.w	0,24
	dc.w	(128+CHECKWIDTH),8
	dc.w	(ITEMTEXT!HIGHCOMP!CHECKIT!MENUTOGGLE)
	dc.l	0
	dc.l	Prefs.4Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Prefs.4Text:
	dc.b	1,2,RP_JAM2
	dc.w	CHECKWIDTH,0
	dc.l	0
	dc.l	Prefs.4ASCII
	dc.l	0
Prefs.4ASCII:
	dc.b	" Workbench",0
	even
Prefs.5:			** Change Palette **
	dc.l	0
	dc.w	0,32
	dc.w	(128+CHECKWIDTH),8
	dc.w	(ITEMTEXT!HIGHCOMP)
	dc.l	0
	dc.l	Prefs.5Text
	dc.l	0
	dc.b	0
	dc.l	0
	dc.w	MENUNULL
Prefs.5Text:
	dc.b	1,2,RP_JAM2
	dc.w	CHECKWIDTH,0
	dc.l	0
	dc.l	Prefs.5ASCII
	dc.l	0
Prefs.5ASCII:
	dc.b	" Change Palette",0
	even
	end
