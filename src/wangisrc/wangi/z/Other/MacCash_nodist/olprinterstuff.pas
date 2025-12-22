(****************************************************************************)
Function InitPrinterGfxStuff(VAR rp : pRastPort;
                             VAR cm : pColorMap) : Boolean;

Const
	ct : Array[0..1] of Word = ($000, $FFF);
	
Var
	bm : pBitMap;
	rc : Boolean;
	
Begin
	rc := False;
	bm := NIL;
	rp := NIL;
	cm := NIL;
	bm := AllocVec(Sizeof(tBitMap), MEMF_CLEAR);
	If bm <> NIL then begin
		InitBitMap(bm, 1, BM_WID, BM_LEN);
		bm^.Planes[0] := AllocRaster(BM_WID, BM_LEN);
		If bm^.Planes[0] <> NIL then begin
			rp := AllocVec(Sizeof(tRastPort), MEMF_CLEAR);
			If rp <> NIL then begin
				InitRastPort(rp);
				rp^.BitMap := bm;
				SetRast(rp, 0);
				SetAPen(rp, 1);
				SetBPen(rp, 0);
				SetDrMd(rp, JAM1);
				cm := GetColorMap(2);
				If cm <> NIL then begin
					SetRGB4CM(cm, 0, $F, $F, $F);
					SetRGB4CM(cm, 1, $0, $0, $0);
					rc := True;
				End {cm <> NIL};
			End {rp <> NIL};
		End {bm^.Planes[0] <> NIL};
	End {bm <> NIL};
	
	If NOT rc then begin
		If bm <> NIL then begin
			If bm^.Planes[0] <> NIL then
				FreeRaster(bm^.Planes[0], BM_WID, BM_LEN);
			If rp <> NIL then
				FreeVec(rp);
			FreeVec(bm);
		End;
		If cm <> NIL Then 
			FreeColorMap(cm);
	End;
	
	InitPrinterGfxStuff := rc;
End;


(****************************************************************************)
Procedure FreePrinterGfxStuff(VAR rp : pRastPort;
                              VAR cm : pColorMap);

Begin
	FreeRaster(rp^.BitMap^.Planes[0], BM_WID, BM_LEN);
	FreeVec(rp^.BitMap);
	FreeVec(rp);
	FreeColorMap(cm);
End;


(****************************************************************************)
Procedure DrawCouponBitMap(VAR rp   : pRastPort;
                           VAR b    : tBoards;
                           VAR w    : pWindow;
                               test : Boolean);
                           
Const
	S_BOARDD : Array[1..5] Of Integer = (12, 49, 84, 126, 163);
	S_NODD   =  0; { "Number of draws" from top          }
	S_NODA   = 43; { "Number of draws" across            }
	S_WIBA   =  4; { distance between week boxes, across }
	S_BFL    = 15;
	S_IBD    =  2; { distance between boxes, down        }
	S_IBA    =  3; { distance between boxes, across      }
	S_BUD    =  1; { upper box down                      }
	S_BLD    =  1; { lower box down                      }
	S_BA     =  6; { width of box, across                }

Var
	left, 
	top, 
	n, i, j : Integer;
	pa      : Array[1..8] Of Integer;
	
Function GetRow(num : Integer) : Integer;

Begin
	Case num Of
		1, 6,11,16,21,26,31,36,41,46 : GetRow := 0;
		2, 7,12,17,22,27,32,37,42,47 : GetRow := 1;
		3, 8,13,18,23,28,33,38,43,48 : GetRow := 2;
		4, 9,14,19,24,29,34,39,44,49 : GetRow := 3;
		5,10,15,20,25,30,35,40,45    : GetRow := 4;
	End;
End;

Function GetCol(num : Integer) : Integer;

Begin
	Case num of
		46,47,48,49    : GetCol := 0;
		41,42,43,44,45 : GetCol := 1;
		36,37,38,39,40 : GetCol := 2;
		31,32,33,34,35 : GetCol := 3;
		26,27,28,29,30 : GetCol := 4;
		21,22,23,24,25 : GetCol := 5;
		16,17,18,19,20 : GetCol := 6;
		11,12,13,14,15 : GetCol := 7;
		 6, 7, 8, 9,10 : GetCol := 8;
		 1, 2, 3, 4, 5 : GetCol := 9;
	End;
End;
	
Begin
	b.bo_Weeks := 8;
	
	If b.bo_Weeks > 1 then begin
		Top := S_NODD;
		Left := S_NODA;
		For n := 7 Downto b.bo_Weeks do Begin
			Left := Left + S_BA + S_WIBA;
		End;
		Move_(rp, Left, top);
		Draw(rp, Left + S_BA, Top);
	End;
	
	For n := 1 To 5 do begin
		If b.bo_Nums[n,1] <> 0 then begin
			For i := 1 to 6 do begin
				Top := S_BOARDD[n];
				left := S_BFL;
				For j := 1 to GetRow(b.bo_Nums[n,i]) do
					Top := Top + S_IBD + 3;
				For j := 1 to GetCol(b.bo_Nums[n,i]) do
					Left := Left + S_IBA + S_BA;
				Top := Top + S_BUD;
				Move_(rp, Left, top);
				Draw(rp, Left + S_BA, Top);
			End;
		End;
	End;
	If test then begin
		move_(rp, 0, 0);
		pa[ 1] := BM_WID; pa[2] := 0;
		pa[ 3] := BM_WID; pa[4] := BM_LEN-1;
		pa[ 5] := 0;      pa[6] := BM_LEN-1;
		pa[ 7] := 0;      pa[8] := 0;
		PolyDraw(rp, 4, @pa);
	End;		
End;


(****************************************************************************)
Procedure Handle_Print(VAR w    : pWindow;
                       VAR b    : tBoards;
                           test : Boolean;
                       VAR rk   : pRemember);

Var
	rp    : pRastPort;
	cm    : pColorMap;
	mp    : pMsgPort;
	iodrp : pIODRPReq;
	err   : LONG;
	
Begin
	err := -1;
	If InitPrinterGfxStuff(rp, cm) Then begin
		DrawCouponBitMap(rp, b, w, test);
		
		mp := CreateMsgPort;
		If mp <> NIL then begin
			iodrp := pIODRPReq(CreateIORequest(mp, Sizeof(tIODRPReq)));
			If iodrp <> NIL then begin
				err := OpenDevice('printer.device',0,pIORequest(iodrp),0);
				If err = 0 Then Begin
					With iodrp^ do begin
						io_Command   := PRD_DUMPRPORT;
						io_RastPort  := rp;
						io_ColorMap  := cm;
						io_Modes     := 0;
						io_SrcX      := 0;
						io_SrcY      := 0;
						io_SrcWidth  := BM_WID; 
						io_SrcHeight := BM_LEN;
						io_DestCols  := PR_WID;
						io_DestRows  := PR_LEN;
						io_Special   := SPECIAL_MILCOLS|
						                SPECIAL_MILROWS|
						                SPECIAL_TRUSTME; 
					End;
					err := DoIO(pIORequest(iodrp));
					CloseDevice(pIORequest(iodrp));
				End {OpenDevice};
			DeleteIORequest(pIORequest(iodrp));	
			End {iodrp <> NIL};
			DeleteMsgPort(mp);
		End {mp <> NIL};
		FreePrinterGfxStuff(rp, cm);
	End;
	If err <> 0 then 
		DisplayBeep(NIL);
End;
