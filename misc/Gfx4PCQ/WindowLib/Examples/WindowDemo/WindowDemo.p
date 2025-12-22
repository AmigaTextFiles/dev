Program WindowDemo;
{This is a program that demonstrates some features of THOR's windowlib.
 For more information on how this works read the include file
 utils/windowlib.i
 © 1997 THOR - Software}

{Include some useful stuff, and the windowlib itself}
{$I "include:utils/windowlib.i"}
{$I "include:utils/stringlib.i"}
  
{This is the demonstration part...}
PROCEDURE Demo;
	
CONST
	{Setup a menu bar in an simple way. The menu is created out of them.
	 The entries in this array are of a structure called MenuCommand,
	 each of them describing one menu item, a menu bar or controlling
	 the generation. The structure itself consists of:
		1) the type of entry to be created:
			a MC_MENU (menubar), an MC_ITEM (an item of the menu)
			or an MC_SUBITEM (subitem of an item).
			The last item or subitem of a menu must be a
			MC_LASTSUBITEM/MC_LASTITEM or MC_LASTMENU resp.
			to tell windowlib that one element of the menu is
			now complete.
		2)	some flags describing how this should look like.
			They are either MC_NORMALMENU (ordinary menu bar)
			or MC_NORMAL for a select-action menu item, or
			MC_CHECKABLE to get a menu item that can be turned
			on or off. MC_BAR is special in the sense that it
			creates a separation bar.
		3)	One character consisting of a shortcut (Amiga + key)
		4)	A string to be appear in the menu itself.}	
		
	menubar : ARRAY[1..8] OF MenuCommand=(
		(MC_MENU,MC_NORMALMENU,'\0',0,"Menu 1"),
		 (MC_ITEM,MC_NORMAL,'\0',0,"Item 1"),
		 (MC_ITEM,MC_NORMAL,'\0',0,"Item 2"),
		 (MC_ITEM,MC_CHECKABLE,'\0',0,"Onoff"),
		 (MC_ITEM,MC_BAR,'\0',0,""),
		 (MC_ITEM,MC_NORMAL,'Q',0,"Exit"),
		 (MC_LASTITEM,0,'\0',0,""),
		(MC_LASTMENU,0,'\0',0,""));
		
VAR
	x,y	:	SHORT;
	i	:	SHORT;
	s	:	ScreenPtr;
	w	:	WindowPtr;
	g1,g2,g3,g4,g5:	GadgetPtr;
	t	:	INTEGER;
	b	:	BOOLEAN;
	buf	:	ARRAY[0..15] OF CHAR;
	ex	:	BOOLEAN;
	menu,item,subitem : SHORT;

	
BEGIN
	InitGraphics;		{setup gfx system}

	{open a custom screen. Arguments are:
		left and top edge of the screen, width, height and
		depth of bitplanes (2^depth=# of colors)
		the monitor ID - here in HIRES
		and a title}
	s:=OpenAScreen(0,0,640,300,2,MON_HIRES,"Test screen");
	IF s<>NIL THEN BEGIN

	{choose the pen 3 to be fire-brigade red. Arguments are
	 the screen, the number of the pen and the red,green and blue
	 components of the new color, on a range from 0 (min) to 15 (max).
	 The windowlib does not support 16 bit colors...}
	SetColor(s,3,15,0,0);
	{please note that this is bad style since we haven't tested if the
	 screen did open. Sigh}
		
	{open a window on this screen. The arguments are
	 the screen, the position (left/top coordinates) the
	 width and heights and some flags which should be left to
	 14 for almost all reasons, and a string giving the title.}
	w:=OpenScreenWindow(s,0,20,640,240,2+4+8,"A Test");
	
	IF w<>NIL THEN BEGIN
		{setup a font to be used in this window. In this case,
		 it's topaz.9. Choose something better if you like...}
		b:=SetWindowFont(w,"topaz.font",9);

		SetStyle(w,4);	{Set the style for the text to be printed:
			1 is underlined, 2 is bold, 4 is italic.
			Add the values for style combinations}

		Color(w,1);	{chose a pen to be used}

		{draw a nifty graphics}		
		FOR i:=0 TO 10 DO BEGIN
			Plot(w,0,i*24);		{plot a point}
			DrawTo(w,i*64,240);	{draw a line from it to this position}
		END;
	
		{wait until the user clicks into the window}
		WaitForClick(w);

		{clear the window}
		ClearWindow(w);

		{draw an ellipse. Arguments are the center and the two
		 radii}
		Ellipse(w,320,120,300,150);

		{fill it in a different color}
		Color(w,2);
		Fill(w,320,120);
	

		{wait until the user clicks into the window}
		WaitForClick(w);
		ClearWindow(w);		{clear it}
	
		Color(w,1);		{choose pen}
		{another nice gfx with ellipses}	
		FOR i:=0 TO 10 DO
			Ellipse(w,320,120,i*20,100-i*10);		

		WaitForClick(w);
		ClearWindow(w);		{wait and clear}

		{turn on boundary drawing. This affects filled boxes
		 and ellipses.}
		Boundary(w,TRUE);
		OlColor(w,1);			{choose the pen for the boundary}
		FOR i:=0 TO 10 DO BEGIN
			Color(w,i);		{choose the pen for the interiour}
			PBox(w,i*32,i*12,640-i*32,240-i*12);	{draw a filled, framed rectangle}
		END;
	
		Boundary(w,FALSE);		{turn off boundary drawing again}
		WaitForClick(w);		{wait until the user clicks into the window}
		ClearWindow(w);			{clear it}
	
		{draw the same, but not filled}
		FOR i:=0 TO 10 DO BEGIN
			Color(w,i);		{chose color}
			Box(w,i*32,i*12,640-i*32,240-i*12);	{draw a frame}
		END;

		WaitForClick(w);
		ClearWindow(w);		{wait and clear}

		Boundary(w,TRUE);	{again boundary mode}	
		OlColor(w,1);		{color for the boundary}	
	
		FOR i:=0 TO 10 DO BEGIN
			Color(w,i);	{color for the interiour}
			PEllipse(w,320,120,i*20,100-i*10);	{draw a filled, framed ellipse}		
		END;

		{some interactive selection functions}

		{let the user select one point of the window with a cross}
		SelectPoint(w,x,y);

		{let the user select a region of the window by "dragging" it}
		DragBox(w,x,y,x,y);	

		{we do actually nothing with them, just for demonstration}


		{tell the windowlib we want to hear if the user presses a
		 mouse button}		
		RequestStart(w,MOUSEBUTTONS_F);
		REPEAT
			Mouse(w,x,y);	{read the mouse position}
			Plot(w,x,y);	{plot a point at this position}
		UNTIL NextRequest(w)=MOUSEBUTTONS_F;	{until the mouse button gets pressed}
		{turn off notification}
		RequestEnd(w,MOUSEBUTTONS_F);
			
		{create some gadgets. A text button is just a button with
		 some text in it. It is called a "bool gadget" in intution
		 terms. The user can press it to force some action.
		 Arguments are: the window, the x and y coordinates of its
		 position, the width and height - beeing zero here to tell
		 the windowlib to calculate them by the text they should
		 contain and the text itself}
		g1:=CreateTextButton(w,4,04,0,0,"Demo gadget");
		g2:=CreateTextButton(w,4,20,0,0,"Another one");

		{create a string field: This is a rectangular area where
		 the user may insert text. These are called "string gadgets"
		 by the intuition part of the OS.
		 The arguments are the window, the position x and y and the
		 width and height. The height is set to zero to tell window
		 lib to fiddle this out by itself - the window's font is
		 used here.}
		g3:=CreateStringField(w,4,40,100,0);

		{create a slider. They are called "prop gadgets" in intuition
		 language and let users select a choise out of a list of
		 items. Arguments are the window, the position x,y, the
		 width and height, and a flag beeing FALSE for horizontal and
		 TRUE for vertical movement. The size of the list = the number
		 of choices is setup later.}
		g4:=CreateSlider(w,4,60,100,8,FALSE);

		{create a toggle gadget. This is also a "bool gadget" in
		 intuition notation. This is a gadget that can be toggled
		 "on" or "off" by the user by pressing it.}
		g5:=CreateTextToggle(w,4,80,0,0,"Toggle");

		{note that we did some bad style above since we never
		 checked if the gadgets could have been created}	

		{create a menu and attach it to the window. The definition
		 of the menu is done by a structure you see on top of this
		 procedure}
		CreateMenu(w,@menubar);

		{setup the slider g4 to describe a list of 16 items (=16
		 possible choices), one beeing visible at a time, with 0
		 beeing the initial choice. The choices returned by window-
		 lib are numbered from 0 to 16}
		SetSlider(g4,16,1,0);

		{display the cursor in the string field created on top
		 and let the user enter something}
		b:=ActivateField(g3);


		{tell the windowlib we want to get informed if:
			the user wants to close the window
			the user releases a gadget,i.e. the sliders, the buttons
			or the text field
			the user presses a mouse button.
			the user selected a menu.
			the user pressed a key}		
		RequestStart(w,CLOSEWINDOW_f OR GADGETUP_f OR MOUSEBUTTONS_F OR MENUPICK_f OR RAWKEY_f);

		Color(w,1);	{choose the pen}
		ex:=FALSE;	{flag if we should exit}
		REPEAT
			{if the mouse button is pressed, read the
			 mouse position and draw a point at it.
			 read the next event in this case}
			IF MouseButton(w) THEN BEGIN
				Mouse(w,x,y);
				Plot(w,x,y);
				t:=NextRequest(w);
			END ELSE BEGIN
				{else redraw the gadgets since the
				 user might have drawn over them}
				RefreshButton(g1);
				RefreshButton(g2);
				RefreshButton(g3);
				RefreshButton(g4);
				RefreshButton(g5);
				{and wait for something to be happen}
				t:=WaitRequest(w);
			END;
				
			{now look what has happend, if at all}

			IF t=GADGETUP_f THEN BEGIN
				{a gadget has been released}
				
				{setup a drawing position}
				Position(w,50,120);

				{get the number of the gadget that has been
				 pressed. They are numbered from one
				 in increasing order of their creation}
				CASE LastGadgetID(w) OF
				1:	{draw some text if one of the buttons has been released}
					DrawText(w,"Gadget 1");	
				2:
					DrawText(w,"Gadget 2");
				3:	{get the contents of the string field and draw it}
					DrawText(w,BufferFromField(g3));
				4:	BEGIN	{read the position of the slider, convert it to text and draw it}
						t:=IntToStr(@buf,FirstFromSlider(g4));
						DrawText(w,@buf);
					END;
				5:	BEGIN	{the on/off gadget has changed its state. Read it and display it}
						IF GetToggle(g5) THEN BEGIN
							DrawText(w,"On ");
						END ELSE
							DrawText(w,"Off");
					END;
				END;
			END;
			IF t=CLOSEWINDOW_f THEN
				{if we got the message that the user wants to
				 shutdown, set a flag}
				ex:=TRUE;
			IF t=RAWKEY_f THEN BEGIN
				{read the key that has been pressed into a buffer,
				 and print this buffer.}
				LastKey(w,@buf,i);
				Position(w,50,90);
				DrawText(w,@buf);
			END;
			IF t=MENUPICK_f THEN BEGIN
				{a menu has been selected, read which one.
				 The number returned is the menu number, the item
				 number and the subitem number resp.
			 	 They are numbered from 0 increasing in the
				 order in the menu bar or menu. The item or
				 subitem is -1 if it has not been selected}
				LastMenu(w,menu,item,subitem);
				IF item=4 THEN
					ex:=TRUE;	{"exit" choosen?}
				IF item=2 THEN BEGIN
					{check the state of the checkmark item.
					 The numbers given here are again the
					 number of the menu, of the item and of
					 the subitem as described above. -1 means
					 that this item has no subitem}				
					IF CheckMarkOfMenu(w,0,2,-1) THEN BEGIN
						{enable the menu item #1, i.e.
						 make it selectable}
						OnMenuPoint(w,0,1,-1);
					END ELSE
						{disable menu item #1 in the first
						 menu, i.e. forbid selection}
						OffMenuPoint(w,0,1,-1);
					{set the state of the toggle gadget by the
					 state of this gadget}
					SetToggle(g5,CheckMarkOfMenu(w,0,2,-1));
				END;
			END;
		UNTIL ex;		{repeat until the user had enough}

		{tell windowlib we no longer want to receive messages
		 from this window}
		RequestEnd(w,CLOSEWINDOW_f OR GADGETUP_f);
	
		{close this window}
		CloseAWindow(w);
	END;
	{close the screen}
	CloseAScreen(s);
	END;
	{quit the gfx system}
	ExitGraphics;
END;

{a tiny main program}
BEGIN
	Demo;
END.
