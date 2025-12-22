#drinc:graphics/gfx.g
#drinc:graphics/view.g
#drinc:graphics/gfxbase.g
#drinc:graphics/copper.g
#drinc:graphics/rastport.g

uint
    SCREEN_HEIGHT = 200,

    GRAPHICS_DEPTH = 5,
    GRAPHICS_COLORS = 1 << GRAPHICS_DEPTH,
    GRAPHICS_WIDTH = 320,
    GRAPHICS_HEIGHT = 128,

    TEXT_DEPTH = 1,
    TEXT_COLORS = 1 << TEXT_DEPTH,
    TEXT_WIDTH = 640,
    TEXT_HEIGHT = SCREEN_HEIGHT;

View_t View;
ViewPort_t GraphicsViewPort, TextViewPort;
RasInfo_t GraphicsRasInfo, TextRasInfo;
RastPort_t GraphicsRastPort, TextRastPort;

uint TextTopLine;

proc makeView()void:

    GraphicsRasInfo.ri_RyOffset := GRAPHICS_HEIGHT + 1 - TextTopLine;
    GraphicsViewPort.vp_DHeight := TextTopLine - 1;
    TextRasInfo.ri_RyOffset := TextTopLine;
    TextViewPort.vp_DHeight := TEXT_HEIGHT - TextTopLine;
    TextViewPort.vp_DyOffset := TextTopLine;
    MakeVPort(&View, &TextViewPort);
    MakeVPort(&View, &GraphicsViewPort);
    MrgCop(&View);
    WaitTOF();
    LoadView(&View);
corp;

proc doit()void:
    uint i, j;
    [GRAPHICS_COLORS]uint colorTable;

    SetAPen(&TextRastPort, 1);
    for i from 7 by 8 upto 7 + 8 * (TEXT_HEIGHT / 8 - 2) do
	Move(&TextRastPort, 0, i);
	Text(&TextRastPort, "Hello there world!", 18);
    od;

    for i from 0 upto GRAPHICS_COLORS - 1 do
	SetAPen(&GraphicsRastPort, i);
	RectFill(&GraphicsRastPort,
	    i * (GRAPHICS_WIDTH / GRAPHICS_COLORS / 2),
	    i * (GRAPHICS_HEIGHT / GRAPHICS_COLORS / 2),
	    GRAPHICS_WIDTH - 1 - i * (GRAPHICS_WIDTH / GRAPHICS_COLORS / 2),
	    GRAPHICS_HEIGHT - 1 - i * (GRAPHICS_HEIGHT / GRAPHICS_COLORS / 2));
    od;

    for i from 1 upto GRAPHICS_HEIGHT - 10 do
	TextTopLine := TextTopLine - 1;
	makeView();
    od;
    for i from 1 upto GRAPHICS_HEIGHT - 10 do
	TextTopLine := TextTopLine + 1;
	makeView();
    od;
corp;

proc main()void:
    BitMap_t graphicsBitMap, textBitMap;
    *GfxBase_t gfxBase;
    *View_t oldView;
    uint i;
    bool failing;

    gfxBase := OpenGraphicsLibrary(0);
    if gfxBase ~= nil then
	TextTopLine := GRAPHICS_HEIGHT + 1;
	failing := false;
	oldView := gfxBase*.gb_ActiView;

	InitView(&View);
	View.v_ViewPort := &GraphicsViewPort;
	
	InitBitMap(&graphicsBitMap, GRAPHICS_DEPTH,
		    GRAPHICS_WIDTH, GRAPHICS_HEIGHT);
	for i from 0 upto GRAPHICS_DEPTH - 1 do
	    graphicsBitMap.bm_Planes[i] :=
		AllocRaster(GRAPHICS_WIDTH, GRAPHICS_HEIGHT);
	    if graphicsBitMap.bm_Planes[i] = nil then
		failing := true;
	    fi;
	od;
	InitBitMap(&textBitMap, TEXT_DEPTH, TEXT_WIDTH, TEXT_HEIGHT);
	for i from 0 upto TEXT_DEPTH - 1 do
	    textBitMap.bm_Planes[i] :=
		AllocRaster(TEXT_WIDTH, TEXT_HEIGHT);
	    if textBitMap.bm_Planes[i] = nil then
		failing := true;
	    fi;
	od;
	
	GraphicsRasInfo.ri_BitMap := &graphicsBitMap;
	GraphicsRasInfo.ri_RxOffset := 0;
	GraphicsRasInfo.ri_RyOffset := GRAPHICS_HEIGHT + 1 - TextTopLine;
	GraphicsRasInfo.ri_Next := nil;
	TextRasInfo.ri_BitMap := &textBitMap;
	TextRasInfo.ri_RxOffset := 0;
	TextRasInfo.ri_RyOffset := TextTopLine;
	TextRasInfo.ri_Next := nil;
	
	InitVPort(&GraphicsViewPort);
	GraphicsViewPort.vp_DWidth := GRAPHICS_WIDTH;
	GraphicsViewPort.vp_DHeight := TextTopLine - 1;
	GraphicsViewPort.vp_DxOffset := 0;
	GraphicsViewPort.vp_DyOffset := 0;
	GraphicsViewPort.vp_RasInfo := &GraphicsRasInfo;
	GraphicsViewPort.vp_ColorMap := GetColorMap(GRAPHICS_COLORS);
	if GraphicsViewPort.vp_ColorMap = nil then
	    failing := true;
	fi;
	GraphicsViewPort.vp_Next := &TextViewPort;
	InitVPort(&TextViewPort);
	TextViewPort.vp_Modes := HIRES;
	TextViewPort.vp_DWidth := TEXT_WIDTH;
	TextViewPort.vp_DHeight := TEXT_HEIGHT - TextTopLine;
	TextViewPort.vp_DxOffset := 0;
	TextViewPort.vp_DyOffset := TextTopLine;
	TextViewPort.vp_RasInfo := &TextRasInfo;
	TextViewPort.vp_ColorMap := GetColorMap(TEXT_COLORS);
	if TextViewPort.vp_ColorMap = nil then
	    failing := true;
	fi;

	InitRastPort(&GraphicsRastPort);
	GraphicsRastPort.rp_BitMap := &graphicsBitMap;
	InitRastPort(&TextRastPort);
	TextRastPort.rp_BitMap := &textBitMap;
	
	if not failing then
	    SetAPen(&GraphicsRastPort, 0);
	    RectFill(&GraphicsRastPort, 0, 0,
		GRAPHICS_WIDTH - 1, GRAPHICS_HEIGHT - 1);
	    SetAPen(&TextRastPort, 0);
	    RectFill(&TextRastPort, 0, 0, TEXT_WIDTH - 1, TEXT_HEIGHT - 1);

	    MakeVPort(&View, &TextViewPort);
	    MakeVPort(&View, &GraphicsViewPort);
	    MrgCop(&View);
	    LoadView(&View);
	
	    doit();
	
	    LoadView(oldView);

	    FreeVPortCopLists(&GraphicsViewPort);
	    FreeVPortCopLists(&TextViewPort);
	    FreeCprList(View.v_LOFCprList);
	fi;
	
	for i from 0 upto GRAPHICS_DEPTH - 1 do
	    if graphicsBitMap.bm_Planes[i] ~= nil then
		FreeRaster(graphicsBitMap.bm_Planes[i],
		    GRAPHICS_WIDTH, GRAPHICS_HEIGHT);
	    fi;
	od;
	for i from 0 upto TEXT_DEPTH - 1 do
	    if textBitMap.bm_Planes[i] ~= nil then
		FreeRaster(textBitMap.bm_Planes[i], TEXT_WIDTH, TEXT_HEIGHT);
	    fi;
	od;

	if GraphicsViewPort.vp_ColorMap ~= nil then
	    FreeColorMap(GraphicsViewPort.vp_ColorMap);
	fi;
	if TextViewPort.vp_ColorMap ~= nil then
	    FreeColorMap(TextViewPort.vp_ColorMap);
	fi;
	
	CloseGraphicsLibrary();
    fi;
corp;
