{--- Tags para Gengine ---};

Type
 Tag = Integer;
 TagPtr = ^Tag;

 TagItem = Record
	ti_Tag	: Tag;
	ti_Data : Integer;
 end;
 TagItemPtr= ^TagItem;

Const

{--Main Objects tags--}
 TAG_DONE = 0;
 TAG_END  = TAG_DONE;
 TAG_IGNORE = 1;
 TAG_SKIP = 2;
 TAG_MORE = 3;
 GE_Start = $80000000;


 GE_WinObj = GE_Start+1;
 GE_ReqObj = GE_Start+2;
 GE_GadObj = GE_Start+3;
 GE_ImgObj = GE_Start+4;
 GE_TxtObj = GE_Start+5;
 GE_PrgObj = GE_Start+6;
 GE_ScrObj = GE_Start+7;
 GE_GUIObj = GE_Start+8;
 GE_FrmObj = GE_Start+9;

 GE_SldGad = GE_Start+20; {Slider}
 GE_PrpGad = GE_Start+21; {Proportional}
 GE_BooGad = GE_Start+22; {Boolean}
 GE_PopGad = GE_Start+23; {Pop-up/cycle}
 GE_StrGad = GE_Start+24; {String}
 GE_RadGad = GE_Start+25; {Radio buttons}
 GE_ChkGad = GE_Start+26; {Check box}

{----}

{--Common Tags--}

 CT_Start  = GE_Start+100;

 CT_Top      = GE_Start+100; {Object Top position}
 CT_Left     = GE_Start+101; {Object Left position}
 CT_PTop     = GE_Start+102; {Object Percentual Top position}
 CT_PLeft    = GE_Start+103; {Object Percentual Left position}
 CT_Width    = GE_Start+104; {Object width}
 CT_Height   = GE_Start+105; {Object height}
 CT_ID       = GE_Start+106; {Object ID (0..255)}
 CT_Link     = GE_Start+107; {Object property that is shared with same ID objects}
 CT_Tip	     = GE_Start+108; {Object ToolTip}

{----}

{--WinObj--}

 Wi_Start    = GE_Start+110;

 Wi_Drag     = GE_Start+110;
 Wi_Depth    = GE_Start+111;
 Wi_Close    = GE_Start+112;
 Wi_Size     = GE_Start+113;
 Wi_Position = GE_Start+114;
 Wi_STitle   = GE_Start+115;
 Wi_Border   = GE_Start+116;
 Wi_Title    = GE_Start+117;
 Wi_SizeR    = GE_Start+118;
 Wi_IDCMP    = GE_Start+119;
 Wi_Left     = GE_Start+120;
 Wi_Top      = GE_Start+121;
 Wi_Width    = GE_Start+122;
 Wi_Height   = GE_Start+123;
 
{--Wi_Position definitions--}

 Pos_TL      = 0; {Top-Left of screen}
 Pos_Center  = 1; {Centered on screen}
 Pos_OnMouse = 2; {Centered under the mouse}
 Pos_TR      = 3; {Top-Right of screen}
 Pos_BL      = 4; {Bottom-Left of screen}
 Pos_BR      = 5; {Bottom-Right of screen}
{----}

{--GadObj--}

 Gg_Start      = GE_Start+130;

 Gg_Activation = GE_Start+130;
 Gg_Frame      = GE_Start+131;
 Gg_Label      = GE_Start+132;
 Gg_Type       = GE_Start+133;
 Gg_SpecialI   = GE_Start+134;
 Gg_Render     = GE_Start+135;
 Gg_HRender    = GE_Start+136;
{----}

{--GE_SldGad--}

 Sl_Start      = GE_Start+140;

 Sl_Top        = GE_Start+140;
 Sl_Bottom     = GE_Start+141;
 Sl_Current    = GE_Start+142;
 Sl_Vertical   = GE_Start+143;
 Sl_Text       = GE_Start+144;

{----}

{--GE_PrpGad--}

 Pp_Start      = GE_Start+150;

 Pp_Total      = GE_Start+150;
 Pp_Visible    = GE_Start+151;
 Pp_Current    = GE_Start+152;
 Pp_Arrows     = GE_Start+153;
 Pp_Vertical   = GE_Start+154;

{----}

{-- Methods --}

 GEM_Start	= $000F0000;
 
 GEM_Add	= GEM_Start+1;
 GEM_Delete	= GEM_Start+2;
 GEM_Modify	= GEM_Start+3;