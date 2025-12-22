	opt	c+,d+,l+

	xdef	ExtCodes,ExtFuncs,MenuCodes,MenuFuncs,ButtonCodes,ButtonFuncs
	xdef	AscCodes,AscFuncs

	xref	NewMap,LoadMap,SaveMap,SaveMapAs,About,Quit,LoadTiles
	xref	SaveIFFTiles,SaveRawTiles,Tiles32x32,Tiles32x16,Tiles16x32
	xref	Tiles16x16,PickTile,NextTile,PreviousTile,ClearMap,SetMapSize
	xref	SetLoRes,SetHiRes,SaveRawMap,GetMBlock,GetTilesBlock
	xref	UseOldBlock,EraseBlock,ScrollUp,ScrollDown,ScrollLeft
	xref	ScrollRight,StartPaint,EndPaint,ChangePaint,PlaceTile
	xref	DiscardMap,ChangeIncTiles,ChangeIcon,ToggleWBench,FilledBox
	xref	ChangePalette
	xref	Project.1,Project.2,Project.3,Project.4,Project.5,Project.6
	xref	Tiles.1,Tiles.2.1,Tiles.2.2,Tiles.3.1,Tiles.3.2,Tiles.3.3
	xref	Tiles.3.4,Tiles.4,Map.1,Map.2,Map.3.1,Map.3.2
	xref	Map.4,Map.5,Blocks.1,Blocks.2,Blocks.3,Blocks.4,Prefs.1
	xref	Prefs.2,Prefs.3,Prefs.4,Prefs.5,Blocks.5

	output	MapDesignerV2.0:Modules/InputTables.o

;   These are the code / function tables for all the inputs...

	section	ProgStuff,data
AscCodes:
	dc.l	"l","L","t","T","s","S","r","R"," ","x","X","m","M","d","D"
	dc.l	"b","B","f","F",$7f,"p","i","I","P",27,13,0

ExtCodes:
	dc.l	"6","7","0","1","2","3","4","5","8","9","?","A","B","C","D",0

MenuCodes:
	dc.l	Project.1,Project.2,Project.3,Project.4,Project.5,Project.6
	dc.l	Tiles.1,Tiles.2.1,Tiles.2.2,Tiles.3.1,Tiles.3.2,Tiles.3.3
	dc.l	Tiles.3.4,Tiles.4,Map.1,Map.2,Map.3.1,Map.3.2
	dc.l	Map.4,Blocks.1,Blocks.2,Blocks.3,Blocks.4
	dc.l	Prefs.1,Map.5,Prefs.2,Prefs.3,Prefs.4,Blocks.5,Prefs.5,0

ButtonCodes:
	dc.l	$68,$69,$e8,0	; SELECTDOWN,MENUDOWN,SELECTUP

AscFuncs:
	dc.l	LoadMap,LoadMap,LoadTiles,LoadTiles,SaveMapAs,SaveMap
	dc.l	SaveRawMap,SaveRawMap,PickTile,ClearMap,ClearMap,SetMapSize
	dc.l	SetMapSize,DiscardMap,DiscardMap,GetMBlock,GetTilesBlock
	dc.l	FilledBox,FilledBox,NewMap,ChangePaint,ChangeIncTiles
	dc.l	ChangeIcon,ChangePalette,Quit,PlaceTile

ExtFuncs:
	dc.l	SaveIFFTiles,SaveRawTiles,Tiles32x32,Tiles32x16,Tiles16x32
	dc.l	Tiles16x16,SetLoRes,SetHiRes,UseOldBlock,EraseBlock,About
	dc.l	ScrollUp,ScrollDown,ScrollRight,ScrollLeft	

MenuFuncs:
	dc.l	NewMap,LoadMap,SaveMap,SaveMapAs,About,Quit,LoadTiles
	dc.l	SaveIFFTiles,SaveRawTiles,Tiles32x32,Tiles32x16,Tiles16x32
	dc.l	Tiles16x16,PickTile,ClearMap,SetMapSize
	dc.l	SetLoRes,SetHiRes,SaveRawMap,GetMBlock,GetTilesBlock
	dc.l	UseOldBlock,EraseBlock,ChangePaint,DiscardMap,ChangeIncTiles
	dc.l	ChangeIcon,ToggleWBench,FilledBox,ChangePalette

ButtonFuncs:
	dc.l	StartPaint,PickTile,EndPaint

	end
