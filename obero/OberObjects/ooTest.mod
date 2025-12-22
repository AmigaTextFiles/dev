MODULE ooTest;

IMPORT oo:=OberObjects, SYS:= SYSTEM, Dos, i:=Intuition, gt := GadTools;

TYPE
	MyOberWin       = POINTER TO MyOberWinDesc;
	MyOberWinDesc   = RECORD (oo.OberWindowDesc) END;

VAR
	TestWindow : MyOberWin;
	TestTags : oo.ObjTags;
	NW : oo.OberWindow;
	gady : oo.OberObject;
	Active, Processed : LONGINT;
	canvas : oo.OberCanvas;

PROCEDURE (ob : MyOberWin) OnCloseWindow (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN
	oo.ReplyMsg(msg);
	RETURN oo.StopAll;
END OnCloseWindow;

PROCEDURE Cancel * (ob : oo.OberObject; code : INTEGER);
VAR obgad : oo.OberObject;
BEGIN
	Dos.PrintF("Cancel callback\n", NIL); 
	obgad := oo.GetObject("Group1");
	obgad.Show;
	TestWindow.RefreshWindow;
END Cancel;

PROCEDURE DblClk * (ob: oo.OberObject; code : INTEGER);
BEGIN
	HALT(0);
END DblClk;

PROCEDURE OK * (ob : oo.OberObject; code : INTEGER);
VAR obgad : oo.OberObject;
	text : ARRAY 50 OF CHAR;
BEGIN
	Dos.PrintF("OK callback, Special Code = %ld\n", code);
	ob.GetText(text);
	Dos.PrintF("Gadget Text = %s\n", SYS.ADR(text));
	obgad := oo.GetObject("Group1");
	obgad.Hide;
	TestWindow.RefreshWindow;
END OK;

PROCEDURE GadHelp * (ob : oo.OberObject; code : INTEGER);
VAR text : ARRAY 255 OF CHAR;
BEGIN
	Dos.PrintF("GadHelp callback, code = %ld\n", code);
	(* ob(oo.OberGadget).GetText(text); *)
	Dos.PrintF("Gadget Name = %s\n", ob.Name);
END GadHelp;

PROCEDURE (ob : MyOberWin) OnCreate;

VAR
	msgad : oo.OberListView;
	hjgad : oo.OberPushButton;
	megrp : oo.OberGroupBox;
BEGIN
	ob.SetTitle("Booo!");
	ob.SetDimensions(100, 200, 200, 200);
	ob.SetMinSize(50, 50);
	ob.SetMaxSize(300, 300);

(*    NEW(msgad); NEW(hjgad); NEW(megrp);
	megrp.Init("Group1", NIL, ob);
	msgad.Init("Button1", NIL, megrp);
	hjgad.Init("Button2", NIL, ob);

	Dos.PrintF("Creating Gads\n", NIL);
	megrp.SetDimensions(20,40,100,100);
	megrp.SetText("MyGroup");
	megrp.Show;

	msgad.SetDimensions(6,5,60,40);
	msgad.SetAttr(gt.lvShowSelected, 0);
	msgad.AddLabel("_Hello");
	msgad.AddLabel("_good");
	msgad.AddLabel("Boo!");
	msgad.SetText("_good");
	msgad.Show;

	hjgad.SetText("_Can");
	hjgad.SetDimensions(20,150,60,20);
	hjgad.Show;

	msgad.SetCallback(OK);
	hjgad.SetCallback(Cancel);
	hjgad.SetDblClkCallback(DblClk);
	msgad.SetGadHelpCallback(GadHelp);
	hjgad.SetGadHelpCallback(GadHelp);

	ob.SetHelpGroup(NIL);
	ob.SetGadHelpCallback(GadHelp);
*)
END OnCreate;


BEGIN
	NEW(TestWindow);
	TestWindow.Init("Main Window", NIL, NIL);
	TestWindow.Show;

	NEW(canvas);
	canvas.Init("Canvas", NIL, TestWindow);
	canvas.Show;
	canvas.MoveTo(20,20);
	canvas.WriteText("Hello World");
	TestWindow.Activate;
	Dos.Delay(50);
	canvas.Scroll(0,10);


	oo.Do;
END ooTest.
