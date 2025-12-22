USES 
	Intuition, Exec, GadTools, Graphics, Utility, 
	Amiga, Asl, AmigaDos, Icon, Workbench, DOS;

{$F-,I-,R-,S-,V-,M 5,1,1,15}


Type
	pPreset = ^tPreset;
	tPreset = Array[1..9] of byte;
	
CONST	
	MAX_COLOURS = 207; { max. used by AmigaGuide }
	
	Version : String[40] = '$VER: AmigaGuide_Prefs 36.144 (03.12.94)'#0;

	{ gadget identifiers                   }
	G_NI    = 0;  { Null init. gadget      }
	G_PATH  = 1;  { Path listview gadget   }
	G_PATHT = 2;  { Path string gadget     }
	G_FR    = 3;  { File requester gadget  }
	G_TEXT  = 4;  { Text cycle gadget      }
	G_PENS  = 5;  { Pen listview gadget    }
	G_PENP  = 6;  { Pen palette gadget     }
	G_NEW   = 7;  { New path gadget        }
	G_REM   = 8;  { Path reove gadget      }
	G_SAVE  = 9;  { Save gadget            }
	G_USE   = 10; { Use gadget             }
	G_CAN   = 11; { Cancel gadget          }
	G_CC    = 12; { CreateContext() gadget }

	{ identifiers used to refer to the pen array }
	P_BG   = 0; { Background                     }
	P_BT   = 1; { button text                    }
	P_BBG  = 2; { button background              }
	P_HBT  = 3; { highlighted button text        }
	P_HBBG = 4; { highlighted button background  }
	P_OP   = 5; { outline pen                    }
	P_HOP  = 6; { highlighted outline pen        }
	P_TBGP = 7; { Text on background pen         }
	
	{ identifiers for text gadget           }
	T_BUTTON    = 0; { button link point    }
	T_HIGHLIGHT = 1; { highlight link point }
	T_UNDERLINE = 2; { underline link point }
	T_BOLD      = 3; { bold link point      }
	T_ITALIC    = 4; { italic link point    }
	T_NULL      = 5;
	
	{ identifiers for the menu items          }

	M_OPEN  = 0; { Open... item               }
	M_SAVAS = 1; { Save As... item            }
	M_ABOUT = 2; { About item                 }
	M_QUIT  = 3; { quit item                  }

	M_DEF   = 4; { restore to defaults item   }
	M_LASTS = 5; { restore to last saved item }
	M_REST  = 6; { restore item               }
	M_PRE   = 8; { presets submenu            }
	M_PRE1  = 9;
	M_PRE2  = 10;
	M_PRE3  = 11;
	M_PRE4  = 12;
	M_PRE5  = 13;
	M_PRE6  = 14;
	M_PRE7  = 15;
	M_PRE8  = 16;
	M_PRE9  = 17;
	M_PREA  = 18;
	M_PREB  = 19;
	M_PREM  = 20;
	M_PREMAX= 20;
	
	M_ICON  = 20; { Create Icons? item         }
	
	Presets : Array[1..12] of tPreset = 
		((2,1,2,1,3,0,0,1,T_BOLD  ), { Sharp            }
		 (0,2,3,1,7,0,0,1,T_BUTTON), { Wangi            }
		 (1,2,1,5,1,0,0,2,T_ITALIC), { Strappado        }
		 (5,6,3,7,2,0,0,1,T_BUTTON), { Skerza           }
		 (0,1,0,1,3,0,0,1,T_BUTTON), { Default          }
		 (0,1,0,0,1,0,0,1,T_BUTTON), { Monochrome       }
		 (0,2,0,2,3,0,0,2,T_BUTTON), { Light & Easy     }
		 (7,1,7,1,4,0,0,1,T_BUTTON), { Baked Beans      }
		 (7,2,3,5,2,0,0,1,T_BUTTON), { Sadad            }
		 (3,1,5,2,4,0,0,2,T_BUTTON), { heterophyte      }
		 (5,1,5,4,7,0,0,1,T_ITALIC), { Alcohol Results  }
		 (4,1,5,7,3,0,0,1,T_BUTTON));{ MagicWB          }
	
	curpathord : Integer = -1;
	curpen : Integer = 0;
	
TYPE 
	tPens = Array[P_BG..P_TBGP] of Integer;
	tGD = Record
		gd_Path : pList;
		gd_Text : T_BUTTON..T_ITALIC;
		gd_Pens : tPens;
	end;
	tProgVars = Record
		arg_Edit,
		arg_Use,
		arg_Save,
		arg_SIcons    : Boolean;
		arg_From,
		arg_PubScreen : String;
	End;
	
VAR
	RememberKey : pRemember;
	gads        : Array[G_NI..G_CC] of pGadget;
	vi          : Pointer;
	TheWindow   : pWindow;
	menustrip   : pMenu;
	OK          : Boolean;
	TextLabs    : Array[T_BUTTON..T_NULL] of STRPTR;
	PenLabs     : Array[P_BG..P_TBGP] of STRPTR;
	PenList     : pList;
	n           : P_BG..P_TBGP;
	Topaz8      : tTextAttr;
	GD          : tGD;
	t           : Array[0..22] of LONG;
	ZoomS       : Array[0..3] of Integer;
	v           : tProgVars;
	TBS         : LONG;
	HighLightPen: Integer;
	


function CStrConstPtrAR(rk : ppRemember; s : String) : STRPTR;

VAR
	p : STRPTR;
	
begin
  s := s + #0;                                   { Make "C" string               }
  p := AllocRemember(rk, length(s), MEMF_CLEAR); { Get some mem for it           }
  move(s[1], p^, length(s));                     { Move s into newly alloc'd mem }
  CStrConstPtrAR := p;                           { Return the pointer            }
end;

{$I ToolType.Pas }

Function UpperStr(s : String) : String;
Var
	X : Byte;
Begin
  For X := 1 To Length(S) Do
    S[X] := UpCase(S[X]);
  UpperStr := S;
End;

Function GetDir(dir : String; Drawer, Save : Boolean) : String;
	
VAR
	fr : pFileRequester;
	buf : String;
	dirpart, filepart, ext : String;

Begin
	GetDir := '';
	t[0] := ASLFR_TitleText;
	If drawer then
		t[1] := LONG(CStrConstPtrAR(@RememberKey, 'Select a directory'))
	else
		t[1] := LONG(CStrConstPtrAR(@RememberKey, 'Select a file'));
	t[2] := ASLFR_DrawersOnly;
	If drawer then
		t[3] := True_
	else
		t[3] := False_;
	t[4] := ASLFR_InitialDrawer;
	If Drawer then begin
		t[5] := LONG(CStrConstPtrAR(@RememberKey, dir));
		t[6] := TAG_IGNORE;
	End else begin
		FSplit(dir, dirpart, filepart, ext);
		dirpart := dirpart + #0;
		filepart := filepart + ext + #0;
		t[5] := LONG(@dirpart[1]);
		t[6] := ASLFR_InitialFile;
		t[7] := LONG(@filepart[1]);
	End;
	t[8] := ASLFR_Window;
	t[9] := long(TheWindow);
	t[10] := ASLFR_Flags1;
	if save then
		t[11] := FRF_DOSAVEMODE
	else
		t[11] := 0;
	t[12] := TAG_DONE;
	fr := AllocASLRequest(ASL_FileRequest, @t);
	if fr <> NIL then begin
		if AslRequest(fr, NIL) then begin
			buf := PtrToPas(STRPTR(fr^.fr_Drawer));
			buf := buf + #0;
			if NOT drawer then begin
				OK := AddPart(@buf[1], STRPTR(fr^.fr_File), 255);
			End;
			GetDir := PtrToPas(@buf[1]); 
		end;
		FreeAslRequest(fr);
	End;
End;

Procedure SetDefault;

begin
	{ Clear path                      }
	NewList(GD.gd_Path);
	{ default for pens is:            }
	{ SetEnv AmigaGuide/Pens 01013001 }
	GD.gd_Pens[P_BG]   := 0;
	GD.gd_Pens[P_BT]   := 1;
	GD.gd_Pens[P_BBG]  := 0;
	GD.gd_Pens[P_HBT]  := 1;
	GD.gd_Pens[P_HBBG] := 3;
	GD.gd_Pens[P_OP]   := 0;
	GD.gd_Pens[P_HOP]  := 0;
	GD.gd_Pens[P_TBGP] := 1;
	{ default for text is:            }
	{ SetEnv AmigaGuide/Text BUTTON   }
	GD.gd_Text := T_BUTTON;
end;

Procedure SetPrefs(destination : String; ToFile : Boolean);

TYPE
	pBuf = ^tBuf;
	tBuf = packed Array[0..1000] of char;
	
VAR
	flags       : LONG;
	len         : Integer;
	ch          : char;
	s,s2        : String;
	inq         : Boolean;
	node        : pNode;
	pathvarname,
	textvarname,
	penvarname,
	drwname,
	pathptr,
	textptr,
	penptr,
	olddt       : STRPTR;
	tt          : Array[0..1] of STRPTR;
	oldtt       : ppByte;
	l,f         : BPTR;
	offset      : 0..1002;
	err         : LONG;
	dobj : pDiskObject;
	
	
Function MakePath : STRPTR;

Var
	b : pBuf;
	
Begin
	b := AllocVec(Sizeof(tBuf), MEMF_CLEAR);
	if b <> NIL then begin
		offset := 0;
		node := GD.gd_Path^.lh_Head;
		While (node^.ln_Succ <> NIL) and (offset < 1000) do begin
			S := '"'+PtrToPas(node^.ln_Name)+'" ';
			if S <> '"" ' then begin
				move(s[1], b^[offset], Length(s));
				offset := offset + Length(s);
			end;			
			node := node^.ln_Succ;
		end;
		if ToFile then begin
			b^[offset-1] := ''#10;
			inc(offset);
		End;
		b^[offset-1] := ''#0;
	End;
	MakePath := STRPTR(b);
End;

Procedure FreePath(t : STRPTR);

Begin
	FreeVec(t);
End;

Function MakeText : STRPTR;

Begin
	Case GD.gd_Text of
		T_BUTTON : s := 'BUTTON';
		T_HIGHLIGHT : s := 'HIGHLIGHT';
		T_UNDERLINE : s := 'UNDERLINE';
		T_BOLD : s := 'BOLD';
		T_ITALIC : s := 'ITALIC';
	end;
	if ToFile then
		s := s + #10;
	s := s + #0; 
	MakeText := STRPTR(@s[1]);
End;

Function MakePens : STRPTR;

Var
	n : Integer;

begin
	With GD do begin
		s2 := '';
		for n := P_BG to P_TBGP do
			s2 := s2 + chr(gd_Pens[n]+48);
		if ToFile then
			s2 := s2 + #10;
		S2 := s2 + #0;
	End;
	MakePens := STRPTR(@s2[1]);
end;
	
begin
	pathptr := MakePath;
	textptr := MakeText;
	penptr  := MakePens;
	drwname := CStrConstPtrAR(@RememberKey, destination);

	If ToFile then begin
		f := Open(drwname, MODE_NEWFILE);
		if f <> NULL then begin
			err := FPuts(f,pathptr);
			err := FPuts(f,textptr);
			err := FPuts(f,penptr);
			OK := Close_(f);
			Ok := SetProtection(drwname, FIBF_EXECUTE);
			Ok := SetComment(drwname, CStrConstPtrAR(@RememberKey, 
			  'Preferences for Amigaguide. Written by Amigaguide Prefs, ©Lee Kindness'));
			If v.arg_SIcons then begin
				{ if DDTI has been installed to default location then use default prefs icon }
				dobj := GetDiskObject(CStrConstPtrAR(@RememberKey, 'DEVS:Icons/def_pref'));
				if dobj = NIL then
					dobj := GetDefDiskObject(WBPROJECT);
				if dobj <> NIL then begin
					olddt := dobj^.do_DefaultTool;
					oldtt := dobj^.do_ToolTypes;
					dobj^.do_DefaultTool := CStrConstPtrAR(@RememberKey, FExpand(ParamStr(0)));
					s := 'ACTION=USE'#0;
					tt[0] := @s[1];
					tt[1] := NIL;
					dobj^.do_ToolTypes := @tt;
					Ok := PutDiskObject(drwname,dobj);
					dobj^.do_DefaultTool := olddt;
					dobj^.do_ToolTypes := oldtt;
					FreeDiskObject(dobj);
				End;
			End;			
		End;
	End else begin
		if NOT (destination[length(destination)] = ':') then begin
			if NOT (destination[length(destination)] = '/') then
				destination := destination + '/';
		End;
		pathvarname := CStrConstPtrAR(@RememberKey, destination+'Path');
		textvarname := CStrConstPtrAR(@RememberKey, destination+'Text');
		penvarname  := CStrConstPtrAR(@RememberKey, destination+'Pens');
		l := CreateDir(drwname);
		UnLock(l);
		flags := GVF_GLOBAL_ONLY;
		OK := SetVar(pathvarname, pathptr, -1, flags);
		OK := SetVar(textvarname, textptr, -1, flags);
		OK := SetVar(penvarname, penptr, -1, flags);
	End;
	FreePath(pathptr);
end;

Procedure GetPrefs(dir : String);

TYPE
	pBuf = ^tBuf;
	tBuf = packed Array[0..1000] of char;
	
VAR
	flags       : LONG;
	buf         : pBuf;
	len         : Integer;
	ch          : char;
	s           : String;
	n           : Integer;
	inq         : Boolean;
	node        : pNode;
	pathvarname,
	textvarname,
	penvarname  : STRPTR;
	l, f : BPTR;
	fib : pFileInfoBlock;
	
Procedure ParsePath(b : pBuf);

Begin
	Begin
		n := 0;
		ch := b^[n];
		s := '';
		inq := False;
		OK := True;
		While OK do begin
			if not (ch in ['"',' ',''#0,''#10]) then begin
				s := s + ch;
				inc(n);
				ch := b^[n];
			end else begin
				if ch = '"' then begin
					if inq = True then
						inq := False
					else
						inq := True;
				end else begin
					if NOT (ch = ''#0) then begin
						if  NOT (ch = ''#10) then begin
							if NOT inq then begin
								node := AllocRemember(@RememberKey, Sizeof(tNode), MEMF_CLEAR);
								if node <> NIL then begin
									node^.ln_Name := CStrConstPtrAR(@RememberKey, s);
									AddTail(GD.gd_Path, node);
									s := '';
								end;
							end else begin
								s:= s + ' ';
							End;
						end;
					end else begin
						if s <> '' then begin
							node := AllocRemember(@RememberKey, Sizeof(tNode), MEMF_CLEAR);
							if node <> NIL then begin
								node^.ln_Name := CStrConstPtrAR(@RememberKey, s);
								AddTail(GD.gd_Path, node);
							end;
						end;
						OK := False;
					end;
				end;
				inc(n);
				ch := b^[n];
			end;
		end;	
	end;
End;

Procedure ParseText(b : pBuf);

Begin
	s := UpperStr(PtrToPas(STRPTR(b)));
	if s[length(s)] = ''#10 then
		s := Copy(s,1,length(s)-1);
	GD.gd_Text := T_BUTTON;
	if s = 'HIGHLIGHT' then
		GD.gd_Text := T_HIGHLIGHT;
	if s = 'UNDERLINE' then
		GD.gd_Text := T_UNDERLINE;
	if s = 'BOLD' then
		GD.gd_Text := T_BOLD;
	if s = 'ITALIC' then
		GD.gd_Text := T_ITALIC; 
end;

Procedure ParsePens(b : pBuf);

Begin
	s := PtrToPas(STRPTR(b));
	GD.gd_Pens[P_BG] := ord(s[P_BG+1])-48;
	GD.gd_Pens[P_BT] := ord(s[P_BT+1])-48; 
	GD.gd_Pens[P_BBG] := ord(s[P_BBG+1])-48;
	GD.gd_Pens[P_HBT] := ord(s[P_HBT+1])-48;
	GD.gd_Pens[P_HBBG] := ord(s[P_HBBG+1])-48;
	GD.gd_Pens[P_OP] := ord(s[P_OP+1])-48;
	GD.gd_Pens[P_HOP] := ord(s[P_HOP+1])-48;
	GD.gd_Pens[P_TBGP] := ord(s[P_TBGP+1])-48;
end;


begin
	l := Lock(CStrConstPtrAR(@RememberKey, dir), ACCESS_READ);
	if l <> NULL then begin
		fib := AllocDosObject(DOS_FIB, NIL);
		if fib <> NIL then begin
			If Examine(l, fib) then begin
				buf := AllocVec(Sizeof(tBuf), MEMF_CLEAR);
				if buf <> NIL then begin
					if fib^.fib_DirEntryType > 0 then begin
						{dir}
						if NOT (dir[length(dir)] = ':') then begin
							if NOT (dir[length(dir)] = '/') then
								dir := dir + '/';
						End;
						pathvarname := CStrConstPtrAR(@RememberKey, dir+'Path');
						textvarname := CStrConstPtrAR(@RememberKey, dir+'Text');
						penvarname  := CStrConstPtrAR(@RememberKey, dir+'Pens');
						flags := GVF_GLOBAL_ONLY;
						len := GetVar(pathvarname, STRPTR(buf), Sizeof(buf^), flags);
						if len <> -1 then
							ParsePath(buf);
						len := GetVar(textvarname, STRPTR(buf), Sizeof(buf^), flags);
						if len <> -1 then
							ParseText(buf);
						len := GetVar(penvarname, STRPTR(buf), Sizeof(buf^), flags);
						if len <> -1 then
							ParsePens(buf);
						UnLock(l);
					End;
					if fib^.fib_DirEntryType < 0 then begin
						{file}
						f := OpenFromLock(l);
						if f <> NULL then begin
							flags := AmigaDos.Seek_(f,0, OFFSET_BEGINNING);
							buf := pBuf(FGets(f,STRPTR(buf),Sizeof(tBuf)));
							if buf <> NIL then
								ParsePath(buf);
							buf := pBuf(FGets(f,STRPTR(buf),Sizeof(tBuf)));
							if buf <> NIL then
								ParseText(buf);
							buf := pBuf(FGets(f,STRPTR(buf),Sizeof(tBuf)));
							if buf <> NIL then
								ParsePens(buf);
							Ok := Close_(f);
						end else
							UnLock(l);
					End;
					FreeVec(buf);
				End;
			End;
			FreeDosObject(DOS_FIB, fib);
		End;
	End;
end;


{ draw a sample of how the current settings would look }
Procedure DrawSample(rp : pRastPort);

Var
	t     : Array[0..6] of LONG;
	it    : pIntuiText;
	dtext : String;

Begin
	{ fill background colour }
	SetAPen(rp, GD.gd_Pens[P_BG]);
	RectFill(rp, 226, TBS+65, 345, TBS+144);
	
	{ fill link point box }
	SetAPen(rp, GD.gd_Pens[P_BBG]);
	RectFill(rp, 245, TBS+75, 326, TBS+84);
	
	{ fill selected link point box }
	SetAPen(rp, GD.gd_Pens[P_HBBG]);
	RectFill(rp, 245, TBS+85, 326, TBS+94);
	
	If GD.gd_Text = T_BUTTON then begin
		{ draw bevelboxes around the link points }
		t[0] := GT_VisualInfo;
		t[1] := LONG(vi);
		t[2] := GTBB_FrameType;
		t[3] := 0;
		t[4] := TAG_END;
		DrawBevelBoxA(rp, 245, TBS+75, 82, 10, @t);
		t[4] := GTBB_Recessed;
		t[5] := True_;
		t[6] := TAG_END;
		DrawBevelBoxA(rp, 245, TBS+85, 82, 10, @t);
	End;
	
	it := AllocVec(Sizeof(tIntuiText), MEMF_CLEAR);
	if it <> NIL then begin
	
		{ set link text style }
		Case GD.gd_Text of
			T_HIGHLIGHT : Topaz8.ta_Style := FSF_EXTENDED;
			T_UNDERLINE : Topaz8.ta_Style := FSF_UNDERLINED;
			T_BOLD      : Topaz8.ta_Style := FSF_BOLD;
			T_ITALIC    : Topaz8.ta_Style := FSF_ITALIC; 
			else Topaz8.ta_Style := 0; 
		End;
		
		{ link point text }
		dtext := 'node'#0;
		it^.FrontPen  := GD.gd_Pens[P_BT];
		it^.BackPen := GD.gd_Pens[P_BBG]; 
		it^.LeftEdge := 270;
		it^.TopEdge  := TBS+76;
		it^.ITextFont:= @topaz8;
		it^.IText    := @dtext[1];
		it^.NextText := NIL;
		PrintIText(rp, it, 0, 0);
		
		{ selected link point text }
		dtext := 'Selected'#0;
		it^.FrontPen := GD.gd_Pens[P_HBT];
		it^.BackPen  := GD.gd_Pens[P_HBBG]; 
		it^.LeftEdge := 255;
		it^.TopEdge  := TBS+86;
		PrintIText(rp, it, 0, 0);
		
		Topaz8.ta_Style := 0;
		
		{ sample text }
		dtext := 'A wee bit of'#0;
		it^.FrontPen := GD.gd_Pens[P_TBGP];
		it^.BackPen  := GD.gd_Pens[P_BG]; 
		it^.LeftEdge := 235;
		it^.TopEdge  := TBS+96;
		PrintIText(rp, it, 0, 0);
		
		dtext := 'text.'#0;
		it^.TopEdge  := TBS+106;
		PrintIText(rp, it, 0, 0);
		
		dtext := 'Wangi!'#0;
		it^.TopEdge  := TBS+126;
		PrintIText(rp, it, 0, 0);
		
		{ label above the sample area }
		dtext := 'Sample'#0;
		it^.FrontPen := highlightpen;
		it^.BackPen  := 0; 
		it^.LeftEdge := 262;
		it^.TopEdge  := TBS+53;
		PrintIText(rp, it, 0, 0);
		 
		FreeVec(it);
	End;
	
	{ bevler around the sample area }
	t[0] := GT_VisualInfo;
	t[1] := LONG(vi);
	t[2] := GTBB_Recessed;
	t[3] := True_;
	t[4] := TAG_END;
	DrawBevelBoxA(rp, 226, TBS+65, 120, 80, @t);
End;


(*
 * A little routine to fill in the members of a NewMenu struct
 *
 * Cheat & use a bit of assembler to get direct access to the embedded
 * string constants
 *)
procedure nm(var mnm: tNewMenu;
	nmType: byte;
	nmLabel: string;
	nmCommKey: string;
	nmFlags: word;
	nmMutualExclude: longint;
	nmUserData: LONG); assembler;
asm
	move.l	mnm,a0						{ address of the element }
	move.b	nmType,tNewMenu.nm_Type(a0)	{ copy the type }

	move.l	nmLabel,a1					{ the address of the Pascal string }
	tst.b	(a1)+						{ check for zero length & skip length byte }
	bne		@1							{ if not zero, nothing to do }
	move.l	#NM_BARLABEL,a1				{ substitute empty strings with a bar }
@1:	move.l	a1,tNewMenu.nm_Label(a0)	{ store the C string }

	move.l	nmCommKey,a1				{ same for the CommKey }
	tst.b	(a1)+
	bne		@2
	suba.l	a1,a1						{ use nil if the empty string }
@2:	move.l	a1,tNewMenu.nm_CommKey(a0)

{ the remaining fields }
	move.w	nmFlags,tNewMenu.nm_Flags(a0)
	move.l	nmMutualExclude,tNewMenu.nm_MutualExclude(a0)
	move.l	nmUserData,tNewMenu.nm_UserData(a0)
end;



Function Open_Window : Boolean;

Type
	pPenList = ^tPenList;
	tPenList = Array[0..9] of Integer;
	
VAR
	ng               : tNewGadget;
	WindowIDCMP, 
	Depth, ModeID,
	Flg8             : LONG;
	ScreenDef        : pScreen;
	node             : pNode;
	dri              : pDrawInfo;
	Handle           : Pointer;
	pubname          : Boolean;
	mm               : Array[0..26] of tNewMenu;
	di               : pDrawInfo;

Begin
	Open_Window := False;	
	
	{ set up topaz font for window and gadgets }
	Topaz8.ta_Name  := CStrConstPtrAR(@RememberKey, 'topaz.font');
	Topaz8.ta_YSize := 8;
	Topaz8.ta_Style := 0;
	Topaz8.ta_Flags := 0;

	{ the IDCMP Classes we want to be told about }
	WindowIDCMP := IDCMP_REFRESHWINDOW|BUTTONIDCMP|LISTVIEWIDCMP|PALETTEIDCMP|IDCMP_MENUPICK|IDCMP_CLOSEWINDOW;
	
	gads[G_NI]  := NIL;
   
  { get details of the screen we are going to open on }

	pubname := False;
  if v.arg_PubScreen = '' then
		ScreenDef := LockPubScreen(NIL)
	Else begin	
		pubname := True;
		ScreenDef := LockPubScreen(CStrConstPtrAR(@RememberKey, v.arg_PubScreen));
	end;
	if screendef = NIL then begin
		pubname := False;
		ScreenDef := LockPubScreen(NIL);
	End;
	
	di := GetScreenDrawInfo(ScreenDef);
	if di <> NIL then begin
		highlightpen := pPenList(di^.dri_Pens)^[HIGHLIGHTTEXTPEN];
		FreeScreenDrawInfo(ScreenDef, di);
	End else
		highlightpen := 1;

	TBS := screendef^.WBorTop + (screendef^.Font^.ta_YSize + 1);
	
	Depth := -1;
	dri := GetScreenDrawInfo(Screendef);
	if dri <> NIL then
		depth := dri^.dri_Depth;
	FreeScreenDrawInfo(ScreenDef, dri);
	If Depth < 2 then depth := 2;
	if depth > 8 then depth := 8;
	
	if depth >=3 then
		flg8 := 0
	else
		flg8 := NM_ITEMDISABLED;
	
	{ init. menu structs. }
	nm(mm[ 0], NM_TITLE, 'Project'#0, '', 0, 0, 0);
	nm(mm[ 1], NM_ITEM , 'Open...'#0, 'O'#0, 0, 0, M_OPEN);
	nm(mm[ 2], NM_ITEM , 'Save As...'#0, 'A'#0, 0, 0, M_SAVAS);
	nm(mm[ 3], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[ 4], NM_ITEM , 'About'#0, '?'#0, 0, 0, M_ABOUT);
	nm(mm[ 5], NM_ITEM , '', '', 0, 0, 0);
	nm(mm[ 6], NM_ITEM , 'Quit'#0, 'Q'#0, 0, 0, M_QUIT);
	
	nm(mm[ 7], NM_TITLE, 'Edit'#0, '', 0, 0, 0);
	nm(mm[ 8], NM_ITEM , 'Reset To Defaults'#0, 'D'#0, 0, 0, M_DEF);
	nm(mm[ 9], NM_ITEM , 'Last Saved'#0, 'L'#0, 0, 0, M_LASTS);
	nm(mm[10], NM_ITEM , 'Restore'#0, 'R'#0, 0, 0, M_REST);
	nm(mm[11], NM_ITEM , 'Presets'#0, '', 0, 0, M_PRE);
	nm(mm[12], NM_SUB  , 'Sharp'#0, '1'#0, 0, 0, M_PRE1);
	nm(mm[13], NM_SUB  , 'Wangi'#0, '2'#0, flg8, 0, M_PRE2);
	nm(mm[14], NM_SUB  , 'Strappado'#0, '3'#0, flg8, 0, M_PRE3);
	nm(mm[15], NM_SUB  , 'Skerza'#0, '4'#0, flg8, 0, M_PRE4);
	nm(mm[16], NM_SUB  , 'Default'#0, '5'#0, 0, 0, M_PRE5);
	nm(mm[17], NM_SUB  , 'Monochrome'#0, '6'#0, 0, 0, M_PRE6);
	nm(mm[18], NM_SUB  , 'Light & Easy'#0, '7'#0, 0, 0, M_PRE7);
	nm(mm[19], NM_SUB  , 'Baked Beans'#0, '8'#0, flg8, 0, M_PRE8);
	nm(mm[20], NM_SUB  , 'Sadad'#0, '9'#0, flg8, 0, M_PRE9);
	nm(mm[21], NM_SUB  , 'heterophyte'#0, '0'#0, flg8, 0, M_PREA);
	nm(mm[22], NM_SUB  , 'Alcohol Results'#0, 'B'#0, flg8, 0, M_PREB);
	nm(mm[23], NM_SUB  , 'MagicWB'#0, 'M'#0, flg8, 0, M_PREM);
	
	nm(mm[24], NM_TITLE, 'Settings'#0, '', 0, 0, 0);
	flg8 := CHECKIT|MENUTOGGLED;
	if v.arg_SIcons then
		flg8 := flg8 | CHECKED;
	nm(mm[25], NM_ITEM , 'Create Icons?'#0, 'I'#0, flg8, 0, M_ICON);
	nm(mm[26], NM_END  , ''#0, '', 0, 0, 0);
	
	ZoomS[0] := -1;
	ZoomS[1] := -1;
	ZoomS[2] := 200;
	ZoomS[3] := TBS;

	{ Get visual info and create context }
	vi := GetVisualInfoA(screendef, NIL);
	If vi <> NIL Then begin
		Gads[G_CC] := CreateContext(@gads[G_NI]);
		If Gads[G_CC] <> NIL Then begin

			{ mak' the gads. }
			With ng do begin
				ng_LeftEdge := 16;
				ng_TopEdge := 0;
				ng_Width := 202;
				ng_Height := 14;
				ng_GadgetText := NIL;
				ng_TextAttr := @Topaz8;
				ng_GadgetID := G_PATHT;
				ng_Flags := 0;
				ng_VisualInfo := vi;
				ng_UserData := NIL;
			end;
			Gads[G_PATHT] := CreateGadgetA(STRING_KIND, gads[G_CC], @ng, NIL);
			
			With ng do begin
				ng_TopEdge := TBS+18;
				ng_Height := 100;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Paths');
				ng_GadgetID := G_PATH;
				ng_Flags := PLACETEXT_ABOVE|NG_HIGHLABEL;
			end;
			t[0] := GTLV_Labels;
			t[1] := LONG(GD.gd_Path);
			t[2] := GTLV_ShowSelected;
			t[3] := LONG(Gads[G_PATHT]);
			t[4] := GTLV_Selected;
			t[5] := -1;
			t[6] := TAG_END;
			Gads[G_PATH] := CreateGadgetA(LISTVIEW_KIND, gads[G_PATHT], @ng, @t);
			
			With ng do begin
				ng_TopEdge := Gads[G_PATHT]^.TopEdge+Gads[G_PATHT]^.Height+4;
				ng_Height := 14;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Directory...');
				ng_GadgetID := G_FR;
				ng_Flags := PLACETEXT_IN;
			end;
			Gads[G_FR] := CreateGadgetA(BUTTON_KIND, gads[G_PATH], @ng, NIL);
			
			With ng do begin
				ng_TopEdge := ng_TopEdge+ng_Height;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'New');
				ng_GadgetID := G_NEW;
				ng_Width := 100;
			end;
			Gads[G_NEW] := CreateGadgetA(BUTTON_KIND, gads[G_FR], @ng, NIL);
			
			With ng do begin
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Remove');
				ng_GadgetID := G_REM;
				ng_LeftEdge := ng_LeftEdge+100+2;
			end;
			Gads[G_REM] := CreateGadgetA(BUTTON_KIND, gads[G_NEW], @ng, NIL);
			
			TextLabs[T_BUTTON]    := CStrConstPtrAR(@RememberKey, 'Button');
			TextLabs[T_HIGHLIGHT] := CStrConstPtrAR(@RememberKey, 'Highlight');
			TextLabs[T_UNDERLINE] := CStrConstPtrAR(@RememberKey, 'Underline');
			TextLabs[T_BOLD]      := CStrConstPtrAR(@RememberKey, 'Bold');
			TextLabs[T_ITALIC]    := CStrConstPtrAR(@RememberKey, 'Italic');
			TextLabs[T_NULL]      := NIL;
			
			t[0] := GTCY_Labels;
			t[1] := LONG(@TextLabs);
			t[2] := GTCY_Active;
			t[3] := GD.gd_Text;
			t[4] := TAG_END;
			With ng do begin
				ng_LeftEdge := ng_LeftEdge+ng_Width+8;
				ng_TopEdge := TBS+18;
				ng_Height := 14;
				ng_Width := 120;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Text');
				ng_GadgetID := G_TEXT;
				ng_Flags := PLACETEXT_ABOVE|NG_HIGHLABEL;
			end;
			Gads[G_TEXT] := CreateGadgetA(CYCLE_KIND, gads[G_REM], @ng, @t);
			
			PenLabs[P_BG]   := CStrConstPtrAR(@RememberKey, 'Background');
			PenLabs[P_BT]   := CStrConstPtrAR(@RememberKey, 'Button text');
			PenLabs[P_BBG]  := CStrConstPtrAR(@RememberKey, 'Button Background');
			PenLabs[P_HBT]  := CStrConstPtrAR(@RememberKey, 'Highlighted button text');
			PenLabs[P_HBBG] := CStrConstPtrAR(@RememberKey, 'Highlighted button backround');
			PenLabs[P_OP]   := CStrConstPtrAR(@RememberKey, 'Outline pen');
			PenLabs[P_HOP]  := CStrConstPtrAR(@RememberKey, 'Highlighted outline pen');
			PenLabs[P_TBGP] := CStrConstPtrAR(@RememberKey, 'Text on Background pen');
			 
			PenList := AllocRemember(@RememberKey, Sizeof(tList), MEMF_CLEAR);
			NewList(PenList);
			For n := P_BG to P_TBGP do begin
				node := AllocRemember(@RememberKey, Sizeof(tNode), MEMF_CLEAR);
				if Node <> NIL then begin
					node^.ln_Name := PenLabs[n];
					AddTail(PenList, node);
				end;
			end;

			t[0] := GTLV_Labels;
			t[1] := LONG(PenList);
			t[2] := GTLV_ShowSelected;
			t[3] := 0;
			t[4] := GTLV_Selected;
			t[5] := 0;
			t[6] := TAG_END;
			With ng do begin
				ng_LeftEdge := ng_LeftEdge+ng_Width+8;
				ng_TopEdge := TBS+18;
				ng_Height := 70;
				ng_Width := 250;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Pens');
				ng_GadgetID := G_PENS;
				ng_Flags := PLACETEXT_ABOVE|NG_HIGHLABEL;
			end;
			Gads[G_PENS] := CreateGadgetA(LISTVIEW_KIND, gads[G_TEXT], @ng, @t);
			
			t[0] := GTPA_Depth;
			t[1] := Depth;
			t[2] := GTPA_Color;
			t[3] := GD.gd_Pens[0];
			t[4] := GTPA_IndicatorWidth;
			t[5] := 20;
			t[6] := GTPA_NumColors;
			if depth >= 8 then
				t[7] := MAX_COLOURS
			else
				t[7] := 1 shl depth; 
			t[8] := TAG_END;
			With ng do begin
				ng_TopEdge := Gads[G_PENS]^.TopEdge+Gads[G_PENS]^.Height+1;
				if GadToolsBase^.lib_Version < 38 then
					ng_TopEdge := ng_TopEdge + 12;
				ng_Height := (Gads[G_REM]^.TopEdge+Gads[G_REM]^.Height)-(Gads[G_PENS]^.TopEdge+Gads[G_PENS]^.Height);
				if GadToolsBase^.lib_Version < 38 then
					ng_Height := ng_Height - 12;
				ng_Width := 250;
				ng_GadgetText := NIL;
				ng_GadgetID := G_PENP;
				ng_Flags := 0;
			end;
			Gads[G_PENP] := CreateGadgetA(PALETTE_KIND, gads[G_PENS], @ng, @t);
			
			With ng do begin
				ng_LeftEdge := 16;
				ng_Width := 86;
				ng_Height := 14;
				ng_TopEdge := gads[G_REM]^.TopEdge+gads[G_REM]^.Height+8;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Save');
				ng_GadgetID := G_SAVE;
			end;
			Gads[G_SAVE] := CreateGadgetA(BUTTON_KIND, gads[G_PENP], @ng, NIL);
			
			With ng do begin
				ng_LeftEdge := gads[G_PENS]^.LeftEdge+gads[G_PENS]^.Width-ng_Width;
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Cancel');
				ng_GadgetID := G_CAN;
			end;
			Gads[G_CAN] := CreateGadgetA(BUTTON_KIND, gads[G_SAVE], @ng, NIL);
			
			With ng do begin
				ng_LeftEdge := (ng_LeftEdge div 2) {- (ng_Width div 2)};
				ng_GadgetText := CStrConstPtrAR(@RememberKey, 'Use');
				ng_GadgetID := G_USE;
			end;
			Gads[G_USE] := CreateGadgetA(BUTTON_KIND, gads[G_CAN], @ng, NIL);

			
			t[0]  := WA_Flags;
			t[1]  := WFLG_ACTIVATE|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_SIMPLE_REFRESH|WFLG_NEWLOOKMENUS;
			t[2]  := WA_Title;
			t[3]  := LONG(CStrConstPtrAR(@RememberKey, 'AmigaGuide Preferences'));
			t[4]  := WA_Gadgets;
			t[5]  := Long(Gads[G_NI]);
			t[6]  := WA_IDCMP;
			t[7]  := WindowIDCMP;
			t[8]  := WA_Left;
			t[9]  := 0;
			t[10] := WA_Top;
			t[11] := TBS;
			t[12] := WA_Width;
			t[13] := gads[G_CAN]^.Width+gads[G_CAN]^.LeftEdge+16;
			t[14] := WA_Height;
			t[15] := ng.ng_Height+ng.ng_TopEdge+8;
			t[16] := WA_Zoom;
			t[17] := LONG(@ZoomS);
			if v.arg_PubScreen <> '' then begin
				t[18] := WA_PubScreenName;
				t[19] := LONG(CStrConstPtrAR(@RememberKey, v.arg_PubScreen));
				t[20] := WA_PubScreenFallBack;
				t[21] := True_;
				t[22] := TAG_END;
			End else
				t[18] := TAG_END;
			
			TheWindow := OpenWindowTagList(NIL, @t);
			if TheWindow <> NIL then begin
			
				t[0] := GTMN_NewLookMenus;
				t[1] := True_;
				t[2] := TAG_END;
				menustrip := CreateMenusA(@mm, NIL);
				if menustrip <> NIL then
					if LayoutMenusA(menustrip,vi,@t) then
						OK := SetMenuStrip(TheWindow,MenuStrip);

				DrawSample(TheWindow^.RPort);
				GT_RefreshWindow(TheWindow, NIL);
				Open_Window := True;
			end;
		end;
	end;
	UnLockPubScreen(NIL, Screendef);
end;

Procedure Close_Window;

Begin
	if MenuStrip <> NIL then begin
		ClearMenuStrip(TheWindow);
		FreeMenus(MenuStrip);
	end;
	CloseWindow(TheWindow);
	FreeGadgets(gads[G_NI]);
	FreeVisualInfo(vi);
End;

Procedure DetachPathList;

VAR 
	Tag_Array : array[0..2] of LONG;

begin
	Tag_Array[0] := GTLV_Labels;
	Tag_Array[1] := $FFFFFFFF;
	Tag_Array[2] := TAG_END;
	GT_SetGadgetAttrsA(gads[G_PATH], TheWindow, NIL, @Tag_Array);
end;

Procedure AttachPathList;

VAR 
	Tag_Array : array[0..4] of LONG;

begin
	Tag_Array[0] := GTLV_Labels;
	Tag_Array[1] := LONG(GD.gd_Path);
	Tag_Array[2] := GTLV_Selected; 
	Tag_Array[3] := CurpathOrd;
	Tag_Array[4] := TAG_END;
	GT_SetGadgetAttrsA(gads[G_PATH], TheWindow, NIL, @Tag_Array);
end;

Procedure RemakeWindow;

begin
	t[0] := GTCY_Active;
	t[1] := GD.gd_Text;
	t[2] := TAG_END;
	GT_SetGadgetAttrsA(gads[G_TEXT], TheWindow, NIL, @t);
	
	t[0] := GTPA_Color;
	t[1] := GD.gd_Pens[curpen];
	t[2] := TAG_END;
	GT_SetGadgetAttrsA(gads[G_PENP], TheWindow, NIL, @t);
end;


Procedure HandleWindow;

CONST
	Exitflag : Boolean = False;
	
VAR 
	dummy      : LONG;
	message    : pIntuiMessage;
	MsgClass   : LONG;
	MsgCode, y : Word;
	Gadcode    : pGadget;
	StrInfo    : pStringInfo;
	menunumber : Word;
	item       : pMenuItem;
	curpathnode, 
	node       : pNode;
	RK         : pRemember;
	ez         : pEasyStruct;
	s, s2      : String;
	tga        : STRPTR;
	updatesamp : Boolean;

Procedure SetPresets(pres : tPreset);

Begin
	GD.gd_Pens[P_BG]   := pres[1];
	GD.gd_Pens[P_BT]   := pres[2];
	GD.gd_Pens[P_BBG]  := pres[3];
	GD.gd_Pens[P_HBT]  := pres[4];
	GD.gd_Pens[P_HBBG] := pres[5];
	GD.gd_Pens[P_OP]   := pres[6];
	GD.gd_Pens[P_HOP]  := pres[7];
	GD.gd_Pens[P_TBGP] := pres[8];
	GD.gd_Text         := pres[9];
	RemakeWindow;
	updatesamp := True;
End;



begin
	s2 := 'SYS:Prefs/Presets/AmigaGuide';
	curpathnode := NIL;
	While Not exitflag Do Begin
		dummy    := Wait(BitMask(TheWindow^.UserPort^.MP_SIGBIT));
		message  := GT_GetIMsg(TheWindow^.userPort);
		while message <> NIL do begin
			updatesamp := False;
			MsgClass := message^.Class;
			MsgCode  := message^.Code;
			GadCode  := pGadget(message^.IAddress);			
			GT_ReplyIMsg(message);
			Case MsgClass Of
		
				IDCMP_CLOSEWINDOW : ExitFlag := True;
				
				IDCMP_REFRESHWINDOW : begin
					GT_BeginRefresh(TheWindow);
					DrawSample(TheWindow^.RPort);
					GT_EndRefresh(TheWindow, True);
				end;
				
				IDCMP_MENUPICK : Begin
					MenuNumber := MsgCode;
					While (menunumber <> MENUNULL) and (ExitFlag = False) do begin
						item := ItemAddress(menustrip, menunumber);
						CASE LONG(GTMENUITEM_USERDATA(item)) of
							M_OPEN : Begin
								s := GetDir(s2, False, False);
								if s <> '' then begin
									DetachPathList;
									SetDefault;
									GetPrefs(s);
									RemakeWindow;
									updatesamp := True;
									CurPathNode := NIL;
									CurPathOrd := -1;
									AttachPathList;
								End;
							End;
							M_SAVAS : Begin
								s := GetDir(s2, False, True);
								if s <> '' then begin
									s2 := s;
									SetPrefs(s, TRUE);
								End;
							End;
							M_ABOUT : Begin
								RK := NIL;
								ez := AllocRemember(@RK, Sizeof(tEasyStruct), MEMF_CLEAR);
								if ez <> NIL then begin
									With ez^ do begin
										es_StructSize :=  Sizeof(tEasyStruct);
										es_Title := NIL;
										es_TextFormat := 
											CStrConstPtrAR(@RK, 'Amigaguide Preferences Copyright ©Lee Kindness.'#10+
											                    '%s'#10+
											                    ''#10+
									                        'Preference editor for the Amigaguide hypertext system.'#10+
									                        'See "AGPrefs.doc" for more information.'#10+
									                        ''#10+
									                        'Comments to:'#10+
									                        ' Lee Kindness'#10+
									                        ' 8 Craigmarn Road'#10+
									                        ' Portlethen Village'#10+
									                        ' Aberdeen AB1 4QR'#10+
									                        ' SCOTLAND');
										es_GadgetFormat := CStrConstPtrAR(@RK, 'Ok');
										tga := @Version[7];
										n := EasyRequestArgs(TheWindow, ez, NIL, @tga);
									End;
								End;
								FreeRemember(@RK, True);
							end;
							M_QUIT : ExitFlag := True;
									
							M_DEF : Begin
								DetachPathList;
								SetDefault;
								RemakeWindow;
								updatesamp := True;
								CurPathNode := NIL;
								CurPathOrd := -1;
								AttachPathList;
							end;
							M_LASTS : Begin
								DetachPathList;
								SetDefault;
								GetPrefs('ENVARC:AmigaGuide/');
								RemakeWindow;
								updatesamp := True;
								CurPathNode := NIL;
								CurPathOrd := -1;
								AttachPathList;
							end;
							M_REST : Begin
								DetachPathList;
								SetDefault;
								GetPrefs(v.arg_From);
								RemakeWindow;
								updatesamp := True;
								CurPathNode := NIL;
								CurPathOrd := -1;
								AttachPathList;
							End;
							M_PRE1..M_PREMAX : SetPresets(presets[LONG(GTMENUITEM_USERDATA(item))-8]);
							M_ICON : Begin
								if (item^.Flags and CHECKED) <> 0 then
									v.arg_SIcons := True
								else
									v.arg_SIcons:= False;
							End;
						end;
						menunumber := item^.NextSelect;
					end;
				end;       
				
				IDCMP_GADGETUP : Begin  
					StrInfo  := gadcode^.SpecialInfo;     
					Case gadcode^.GadgetID Of 
						G_SAVE : begin
							ExitFlag := True;
							SetPrefs('ENVARC:AmigaGuide/',FALSE);
							SetPrefs('ENV:AmigaGuide/',FALSE);
						end;
						G_USE : begin
							ExitFlag := True;
							SetPrefs('ENV:AmigaGuide/',FALSE);
						end;
						G_CAN : ExitFlag := True;
						G_PENS : begin
							t[0] := GTPA_Color;
							t[1] := GD.gd_Pens[msgcode];
							t[2] := TAG_END;
							GT_SetGadgetAttrsA(Gads[G_PENP], TheWindow, NIL, @t);
							curpen := msgcode;
						end;
						G_PENP : begin
							if msgcode > MAX_COLOURS then begin
								DisplayBeep(NIL);
								t[0] := GTPA_Color;
								t[1] := GD.gd_Pens[curpen];
								t[2] := TAG_END;
								GT_SetGadgetAttrsA(gads[G_PENP], TheWindow, NIL, @t);
							End else
								GD.gd_Pens[curpen] := msgcode;
							updatesamp := True;
						End;
						G_TEXT : begin
							GD.gd_Text := msgcode;
							updatesamp := True;
						End;
						G_PATH : Begin
							curpathord := msgcode;
							CurpathNode := GD.gd_Path^.lh_Head;
							For y := 1 to curpathord do
								CurpathNode := CurpathNode^.ln_Succ;
						end;
						G_REM : if curpathnode <> NIL then begin
							DetachPathList;
							Remove(curpathnode);
							curpathnode := NIL;
							curpathord := -1; 
							AttachPathList;
						end;
						G_NEW : Begin
							curpathnode := AllocRemember(@RememberKey, Sizeof(tNode), MEMF_CLEAR);
							if curpathnode <> NIL then begin
								curpathnode^.ln_Name := CStrConstPtrAR(@RememberKey, 'SYS:');
								DetachPathList;
								AddTail(GD.gd_Path, curpathnode);
								node := GD.gd_Path^.lh_Head;
								curpathord := 0;
								While node <> curpathnode do begin
									node := node^.ln_Succ;
									Inc(curpathord);
								end;
								AttachPathList;
							end;
						end;
						G_FR : if curpathnode <> NIL then Begin
							s := GetDir(PtrToPas(curpathnode^.ln_Name),True,False);
							if s <> '' then begin
								DetachPathList;
								curpathnode^.ln_Name := CStrConstPtrAR(@RememberKey, s);
								AttachPathList;
							end;
						end;
						G_PATHT : if curpathnode <> NIL then begin
							DetachPathList;
							curpathnode^.ln_Name := CStrConstPtrAR(@RememberKey, PtrToPas(STRPTR(StrInfo^.Buffer)));
							AttachPathList;
						end;
					End; {case}
				end;
			End; {case}
			if updatesamp then
				DrawSample(TheWindow^.RPort);
				
			message  := GT_GetIMsg(TheWindow^.userPort);
		end;
	End; {while}
end;

Begin
	RememberKey := NIL;
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',36));
	GadToolsBase := OpenLibrary('gadtools.library',36);
	AslBase := OpenLibrary('asl.library', 0);
	IconBase := OpenLibrary('icon.library', 0);
	GfxBase := pGfxBase(OpenLibrary('graphics.library',0));
	
	if (IntuitionBase <> NIL) and (IconBase <> NIL) and 
	   (GadtoolsBase <> NIL) and (AslBase <> NIL) and (GfxBase <> NIL) then begin
		GD.gd_Path := AllocRemember(@RememberKey, Sizeof(tList), MEMF_CLEAR);
		if GD.gd_Path <> NIL then begin
			GetToolTypes(v);
			SetDefault;
			GetPrefs(v.arg_From);
			if v.arg_Use then
				SetPrefs('ENV:AmigaGuide/',FALSE);
			if v.arg_Save then
				SetPrefs('ENVARC:AmigaGuide/',FALSE);
			if (v.arg_Edit = True) then begin
				if Open_Window then begin
					HandleWindow;
					Close_Window;
				end;
			End;
		end;
	
		FreeRemember(@RememberKey, True);
		
		CloseLibrary(pLibrary(GfxBase));
		CloseLibrary(IconBase);
		CloseLibrary(AslBase);
		CloseLibrary(GadToolsBase);
		CloseLibrary(pLibrary(IntuitionBase));
	end;
end.
