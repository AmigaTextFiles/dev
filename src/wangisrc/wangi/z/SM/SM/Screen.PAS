{ close the Screen }
Procedure Close_Screen;

VAR OK : Boolean;

Begin
	OK := CloseScreen(TheScreen);
	While NOT OK do begin
		Delay(1000);
		OK := CloseScreen(TheScreen);
	end;
	CloseFont(mytextfont);
End;


Function Open_Screen;

CONST
	PubName : String[13] = 'SUPMENU'#0;
	
Var 
	Tgs    : Array[0..14] Of tTagItem;
	Screen : pScreen;
	err    : LONG;
   
Begin

	{ Make sure w've got an openable TextAttr }
	MyTextFont := OpenDiskFont(@CD.cd_Font);
	If MyTextFont = NIL then begin  { default to topaz 8 if unsuccesful }
		With CD.cd_Font do begin
			ta_Name := CSCPAR(@RememberKey, 'topaz.font');
			ta_YSize := 8;
			ta_Style := 0;
			ta_Flags := FPF_ROMFONT;
		end;
		MyTextFont^.tf_XSize := 6;
	end;
	
	{ Tags for the screen }
	 Tgs[0].ti_Tag  := SA_Type;
   Tgs[0].ti_Data := PUBLICSCREEN;
   Tgs[1].ti_Tag  := SA_Title;
   Tgs[1].ti_Data := LONG(CSCPAR( @RememberKey, CD.cd_ScrTit));
   Tgs[2].ti_Tag  := SA_OverScan;
   Tgs[2].ti_Data := OSCAN_TEXT;
   Tgs[3].ti_Tag  := SA_Depth;
   Tgs[3].ti_Data := CD.cd_ScrDepth;
   Tgs[4].ti_Tag  := SA_Font;
   Tgs[4].ti_Data := LONG(@CD.cd_Font);
   Tgs[5].ti_Tag  := SA_DisplayID;
   Tgs[5].ti_Data := CD.cd_ModeID; 
   Tgs[6].ti_Tag  := SA_Width;
   Tgs[6].ti_Data := CD.cd_ScrW;
   Tgs[7].ti_Tag  := SA_Height;
   Tgs[7].ti_Data := CD.cd_ScrH;
   Tgs[8].ti_Tag  := SA_Pens;
   Tgs[8].ti_Data := LONG(@MyPens);
   Tgs[9].ti_Tag  := SA_AutoScroll;
   Tgs[9].ti_Data := True_;
   Tgs[10].ti_Tag := SA_PubName;
   Tgs[10].ti_Data:= LONG(@PubName[1]);
   Tgs[11].ti_Tag := SA_Interleaved;
   Tgs[11].ti_Data:= True_;
   Tgs[12].ti_Tag := SA_SharePens;
   Tgs[12].ti_Data:= True_;
   Tgs[13].ti_Tag := SA_ErrorCode;
   Tgs[13].ti_Data:= LONG(@err);
   Tgs[14].ti_Tag := TAG_END;
   
(*
 * Open screen and exit with appropriate msg if unsuccessful.
 *)
   Screen := OpenScreenTagList(NIL, @Tgs);
   IF Screen <> NIL then begin
		LoadRGB4(@Screen^.ViewPort, @CD.cd_Pal[0], 4);
		err := PubScreenStatus(Screen, 0);
	 end;
	
	Open_Screen := Screen;
end;

