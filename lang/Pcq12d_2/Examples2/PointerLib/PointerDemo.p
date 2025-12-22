program PointerDemo;

{ *	PointerDemo.p							   * }
{ *	Ein kleines Beispielprogramm zur Benutzung der pointer.library .   * }
{ *	Dieses Programm ist Public Domain !				   * }
{ *	Coded 11/11/1992 by "Diesel" B. Künnen				   * }

{$I "Include:libraries/Dos.i"}
{$I "Include:intuition/intuition.i"}
{$I "Include:libraries/Pointerlib.i"}
{$I "Include:Utils/stringlib.i"}
{$I "Include:exec/libraries.i"}
{$I "Include:exec/ports.i"}


CONST	breit   = 500;	{ * werden für die Gadgets gebraucht * }
	gadleft = 20;

	MyNewWindow : NewWindow = ( 0,10,breit,150,  0,1,
	GADGETUP_f + MENUPICK_f,
	ACTIVATE + WINDOWDRAG + WINDOWDEPTH,
	NIL,NIL, "Pointer.lib/PCQ-Demo/Diesel - Rechte Maustaste = Exit",
	NIL,NIL, 0,0,0,0, WBENCHSCREEN_f);

	Ptrname : Array[1..6] of String = ("Standard.ilbm",
					   "CrossHair.ilbm",
	{ * hier die Namen der * }	   "GhostPointer.ilbm",
	{ * Pointer, die im    * }	   "HourGlass.ilbm",
	{ * Verzeichnis        * }	   "StopWatch.ilbm",
	{ * :pointers/ stehen  * }	   "ZZBubble.ilbm");
	{ * sollten ...        * }

VAR
	MyWindow : WindowPtr;
	new_Point,
	zZ_Point : MousePointerPtr;
	I_Msg	 : IntuiMessagePtr;
	slect	 : GadgetPtr;
	Pgad	 : Array[1..6] of GadgetPtr;
	MyPort	 : Address;		{ MessagePortPtr }
	ilbm	 : String;
	class	 : Integer;
	i	 : Short;


{ * Wir wollen ja auch alles sauber hinterlassen ... * }

Procedure CleanExit( why: String; rt : Integer );
Begin
	if zZ_Point	<> NIL then  FreePointer (  zZ_Point );
	if MyWindow	<> NIL then  CloseWindow (  MyWindow );
	if PointerBase	<> NIL then  CloseLibrary( PointerBase );

	if why <> NIL then begin
	  write( why );
	  Delay(150);
	End;

	Exit( rt );
End;


{ * Fkt., um die Gadgets einzurichten * }

Function MakeGadget( next: gadgetPtr; id : Short ): gadgetPtr;
var
	gad   : GadgetPtr;
	gadIT : IntuiTextPtr;
Begin

	New( gadIT );			{ * IntuiText einrichten * }
	With gadIT^ do begin
	  FrontPen := 3;
	  BackPen  := 0;
	  DrawMode := jam1;
	  IText    := Ptrname[id];
	  LeftEdge := ((breit-2*gadleft) div 2) - ( IntuiTextLength(gadIT) DIV 2 );
	  TopEdge  := 3;
	end;

	New( Gad );			{ * Gadget einrichten * }
	With Gad^ Do Begin
	  NextGadget   := next;
	  LeftEdge     := gadleft;
	  TopEdge      := id * 18;
	  Width        := breit - ( 2 * gadleft );
	  Height       := 12;
	  Flags        := gadgHBox;
	  Activation   := relverify;
	  gadgetType   := BoolGadget;
	  gadgetText   := gadIT;
	  gadgetRender := NIL;
	  gadgetID     := id;
	end;

	MakeGadget := Gad;		{ * GadgetPtr zurückgeben * }
end;




{ * Hauptschleife * }

BEGIN
	ilbm:=AllocString(80);

	{ *	Pointer.library öffnen     * }

	PointerBase := OpenLibrary( PointerName, 33 );
	if PointerBase = NIL  then
	    CleanExit( "Kann pointer.librarynicht öffnen\n", 20 );

	{ * 6 Gadgets einrichten * }

	Pgad[6] := MakeGadget( NIL, 6 );
	For i:=6 downto 1 do
	    Pgad[i]:=MakeGadget( Pgad[i+1], i );

	{ * Window öffnen * }

	MyNewWindow.FirstGadget := Pgad[1];
	MyWindow := OpenWindow( Adr(MyNewWindow) );
	if( MyWindow = NIL ) then
	    Cleanexit( "Kann Window nicht öffnen\n", 10 );


	MyPort := MyWindow^.userPort;			{ * get MsgPort   * }

	REPEAT
			{ * Msg`s abholen und beantworten * }
	  REPEAT
	    I_Msg := IntuiMessagePtr( WaitPort(MyPort) ); { * wait4 message * }
	    I_Msg := IntuiMessagePtr( GetMsg(MyPort) );	  { * Get IntuiMsg  * }
	  UNTIL I_Msg <> NIL;

	  class := I_Msg^.class;
	  slect := GadgetPtr( I_Msg^.iAddress );
	  ReplyMsg( MessagePtr( I_Msg) );		{ * OK to sender  * } 

	  CASE class OF

	  GADGETUP_F :
	  Begin					{ * da sind die Dateien * }
		strcpy( ilbm, "Purity 8:PCQ-Programme/Pointers/" );
		strcat( ilbm, Ptrname[slect^.gadgetID] );

		{ * neuen Pointer laden, alten löschen, neuen setzen *}

		new_Point := LoadPointer( ilbm );
		If new_Point = NIL then DisplayBeep( NIL ) else
		Begin
		  FreePointer( zZ_Point );
		  zZ_Point := new_Point;
		  SetPointer( MyWindow,
			      zZ_Point^.Data,
			      zZ_Point^.Height,
			      zZ_Point^.Width,
			      zZ_Point^.XOff,
			      zZ_Point^.YOff );
		End;
	  end;

	  MENUPICK_F:		{ * EXIT * }
	  Begin
	    CleanExit( "PointerDemo, 1992 by Diesel", 0 );
	  End;

	  ELSE END;

	UNTIL FALSE;

END.

