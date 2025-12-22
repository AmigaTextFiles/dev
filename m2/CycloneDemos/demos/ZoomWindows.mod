(*#-- BEGIN AutoRevision header, please do NOT edit!
*
*   Program         :   ZoomWindows.mod
*   Copyright       :   Marcel Timmermans (C) 1996
*   Author          :   Marcel Timmermans
*   Email           :   mtimmerm@worldaccess.nl
*   Address         :   A. Dekenstr 22, ZIPCODE 6852 JH, ARNHEM, HOLLAND
*   Creation Date   :   19-08-1996
*   Current version :   1.0
*   Translator      :   Cyclone 0.80
*
*
*   PROGRAM INFO
*   This program is written to demostrate how you can make a patch in Cyclone.
*   Ofcourse the program is not complete to make a real nice patch
*   Also there are a few not nice programming styles f.e. the wait loop
*   This program is P.D. 
*
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   19-08-1996     0.1            Test version                              
*   17-09-1996     1.0            Made also a OpenWindowTagList patch       
*
*-- END AutoRevision header --*)

MODULE ZoomWindows;

FROM SYSTEM IMPORT ASSEMBLE,SETREG,REG,ADDRESS,CAST,ADR;
IMPORT Reg,id:IntuitionD,il:IntuitionL,gd:GraphicsD,gl:GraphicsL,
           el:ExecL,ed:ExecD,DosL,Break,ud:UtilityD,InOut,ml:ModulaLib;

CONST
 Tmax=11;

TYPE
    tproc  = PROCEDURE;

VAR
 OldOpenWindow,OldOpenWindowTag,OldCloseWindow:tproc;
 OldOpenWin,OldOpenWinTag,OldCloseWin:ADDRESS;
 ax1,ay1,ax2,ay2:INTEGER;
 bx1,by1,bx2,by2:INTEGER;
 x1,y1,x2,y2,t:INTEGER;
 rp:gd.RastPortPtr;


PROCEDURE Zoom;
(* EntryExitCode- *)
BEGIN
(* Must be done quick; So in assembler 
 * A4 still loaded correctly; Done in ZoomIn
 *
 *)
 ASSEMBLE(
	MOVEM.L	D0-D7/A0-A6,-(A7)
        MOVE.L  $4,A6
        JSR     el.Forbid(A6) 
        MOVE.L  gl.graphicsBase(A4),A6
        MOVEQ   #2,D0                   (* RP_COMPLEMENT *)
        MOVE.L  rp(A4),A1
        JSR     gl.SetDrMd(A6)
        MOVE.L  rp(A4),A1
        MOVEQ   #1,D0
        JSR     gl.SetAPen(A6)

        MOVE.W  #1,D0
        MOVE.W  D0,t(A4)
        BSR     calcCoord
        BSR     rectangle

(* WaitTOF (the graphics.library function would permit multitasking now) *)
waitVPOS:
	JSR     gl.VBeamPos(A6)
	CMP.W	#15,D0
	BGT	waitVPOS
(* erase old rectangle *)
	BSR	rectangle
(* next t *)
	MOVE.W	t(A4),D0
	CMP.W	#Tmax,D0
	BEQ	zoomready
	ADDQ.W	#1,D0
	MOVE.W	D0,t(A4)
(* draw new rectangle *)
	BSR	calcCoord
	BSR	rectangle
	BRA	waitVPOS
zoomready:
(* multitasking on *)
        MOVE.L  $4,A6
        JSR     el.Permit(A6)
	MOVEM.L	(A7)+,D0-D7/A0-A6
        RTS

rectangle:
	MOVE.L	rp(A4),A1
	MOVEQ	#0,D0
	MOVE.W	x1(A4),D0
	MOVEQ	#0,D1
	MOVE.W	y1(A4),D1
	JSR	gl.Move(A6)
	MOVE.L	rp(A4),A1
	MOVEQ	#0,D0
	MOVE.W	x2(A4),D0
	MOVEQ	#0,D1
	MOVE.W	y1(A4),D1
	JSR     gl.Draw(A6)
	MOVE.L	rp(A4),A1
	MOVEQ	#0,D0
	MOVE.W	x2(A4),D0
	MOVEQ	#0,D1
	MOVE.W	y2(A4),D1
	JSR     gl.Draw(A6)
	MOVE.L	rp(A4),A1
	MOVEQ	#0,D0
	MOVE.W	x1(A4),D0
	MOVEQ	#0,D1
	MOVE.W	y2(A4),D1
	JSR     gl.Draw(A6)
	MOVE.L	rp(A4),A1
	MOVEQ	#0,D0
	MOVE.W	x1(A4),D0
	MOVEQ	#0,D1
	MOVE.W	y1(A4),D1
	JSR     gl.Draw(A6)
	RTS

calcCoord:
	MOVE.W	ax1(A4),D1
	MOVE.W	bx1(A4),D3
	BSR	formula
	MOVE.W	D2,x1(A4)
	MOVE.W	ay1(A4),D1
	MOVE.W	by1(A4),D3
	BSR	formula
	MOVE.W	D2,y1(A4)
	MOVE.W	ax2(A4),D1
	MOVE.W	bx2(A4),D3
	BSR	formula
	MOVE.W	D2,x2(A4)
	MOVE.W	ay2(A4),D1
	MOVE.W	by2(A4),D3
	BSR	formula
	MOVE.W	D2,y2(A4)
	RTS

(* CALCULATE VALUE OF Z
 * d0 = t
 * d1 = a
 * d3 = b
 * return: d2 = z = a*t/Tmax + b
*)
formula:
	MOVE.W	D1,D2
	BMI	aisnegative
	MULS	D0,D2
	DIVS	#Tmax,D2
	ADD.W	D3,D2
	RTS
aisnegative:
	NEG.W	D2
	MULS	D0,D2
	DIVS	#Tmax,D2
	SUB.W	D2,D3
	MOVE.W	D3,D2
	RTS

 END);
END Zoom;


PROCEDURE ZoomIn(win{Reg.A0}:ADDRESS);
(*$ LoadA4+ *)
VAR
 scr:id.ScreenPtr;
 w:id.NewWindowPtr;
BEGIN
 w:=win;
 scr:=w^.screen; 
 IF scr=NIL THEN
   scr:=il.intuitionBase^.firstScreen;
   WHILE ~(id.wbenchScreen IN scr^.flags) DO
     scr:=scr^.nextScreen;
   END;
 END;
 IF scr#NIL THEN
   rp:=ADR(scr^.rastPort);
   bx1:=scr^.mouseX;
   bx2:=bx1;
   ax1:=w^.leftEdge - bx2;
   by1:=scr^.mouseY;
   by2:=by1;
   ay1:=w^.topEdge - by2;
   ax2:=ax1 + w^.width - 1;
   ay2:=ay1 + w^.height - 1; 
   SETREG(Reg.A0,w);
   Zoom;  
 END;
 SETREG(Reg.A0,w);
 OldOpenWindow;
END ZoomIn;

PROCEDURE ZoomIn2(win{Reg.A0},tags{Reg.A1}:ADDRESS);
(*$ LoadA4+ *)
VAR
 scr:id.ScreenPtr;
 wp:id.NewWindowPtr;
 tp,tagPtr{10}:ud.TagItemPtr;
 l,t,w,h:INTEGER;
BEGIN
 wp:=win; scr:=NIL; tp:=tags;
 IF wp#NIL THEN
  scr:=wp^.screen; 
 END;
 IF scr=NIL THEN
    scr:=il.intuitionBase^.firstScreen;
    WHILE ~(id.wbenchScreen IN scr^.flags) DO
      scr:=scr^.nextScreen;
    END;
 END;
 IF (scr#NIL) & (wp#NIL) THEN
   rp:=ADR(scr^.rastPort);
   bx1:=scr^.mouseX;
   bx2:=bx1;
   ax1:=wp^.leftEdge - bx2;
   by1:=scr^.mouseY;
   by2:=by1;
   ay1:=wp^.topEdge - by2;
   ax2:=ax1 + wp^.width - 1;
   ay2:=ay1 + wp^.height - 1; 
   SETREG(Reg.A0,wp);
   SETREG(Reg.A1,tp);
   Zoom;  
 ELSIF scr#NIL THEN
   rp:=ADR(scr^.rastPort);
   WITH scr^ DO
     l:=leftEdge; t:=topEdge; 
     w:=width; h:=height;
   END;
   tagPtr:=tp;
// examine taglist
// Could also with FindTagItem
   WHILE tagPtr^.tag>0 DO               
     CASE id.WaTags(tagPtr^.tag) OF
      | id.waLeft   : l:=tagPtr^.data;
      | id.waTop    : t:=tagPtr^.data;
      | id.waHeight : h:=tagPtr^.data;
      | id.waWidth  : w:=tagPtr^.data;
     END;
     INC(tagPtr,SIZE(tagPtr^));
   END;
   bx1:=scr^.mouseX;
   bx2:=bx1;
   ax1:=l - bx2;
   by1:=scr^.mouseY;
   by2:=by1;
   ay1:=t - by2;
   ax2:=ax1 + w - 1;
   ay2:=ay1 + h - 1; 
   SETREG(Reg.A1,tp);
   SETREG(Reg.A0,wp);
   Zoom;  
 END;
 SETREG(Reg.A0,wp); // to be sure the registers has the correct value! 
 SETREG(Reg.A1,tp);
 OldOpenWindowTag;
END ZoomIn2;


PROCEDURE ZoomOut(win{Reg.A0}:ADDRESS);
(*$ LoadA4+ *)
VAR
 scr:id.ScreenPtr;
 w:id.WindowPtr;
BEGIN
 w:=win;
 rp:=ADR(w^.wScreen^.rastPort);
 bx1:=w^.leftEdge;
 by1:=w^.topEdge;
 ax1:=w^.wScreen^.mouseX - bx1;
 ay1:=w^.wScreen^.mouseY - by1;
 ax2:=ax1 - w^.width + 1;
 ay2:=ay1 - w^.height + 1; 
 bx2:=bx1 + w^.width - 1;
 by2:=by1 + w^.height - 1; 
 OldCloseWindow;
 Zoom;
END ZoomOut;


BEGIN
    Break.InstallException;
    IGNORE el.SetTaskPri(ml.thisTask,-10);
    InOut.WriteString('ZoomWindows V1.0  ');
    el.Forbid;
    OldOpenWin:=el.SetFunction(CAST(ed.LibraryPtr,il.intuitionBase), -204, ADR(ZoomIn));
    OldOpenWindow:=CAST(tproc, OldOpenWin);

    OldOpenWinTag:=el.SetFunction(CAST(ed.LibraryPtr,il.intuitionBase), -606, ADR(ZoomIn2));
    OldOpenWindowTag:=CAST(tproc, OldOpenWinTag);

    OldCloseWin:=el.SetFunction(CAST(ed.LibraryPtr,il.intuitionBase), -72, ADR(ZoomOut));
    OldCloseWindow:=CAST(tproc, OldCloseWin);
    el.Permit;

    InOut.WriteString('Patch installed.\nPress CTRL-C to remove patch!\n');

    LOOP (* A simple bad programmed loop *)
     DosL.Delay(2);
     Break.TestBreak();
    END;

CLOSE
    el.Forbid;
    OldOpenWin:=el.SetFunction(CAST(ed.LibraryPtr,il.intuitionBase), -204, OldOpenWin);
    OldOpenWinTag:=el.SetFunction(CAST(ed.LibraryPtr,il.intuitionBase), -606, OldOpenWinTag);
    OldCloseWin:=el.SetFunction(CAST(ed.LibraryPtr,il.intuitionBase), -72, OldCloseWin);
    el.Permit;
    InOut.WriteString('Patch removed!\n');

END ZoomWindows.
