/* NativeGuiExample.e 14-11-2012 by Chris Handley

This is an example for advanced users, showing how to embed native GUI (in this
case MUI) elements inside a GUI created using 'std/cGui'.

Beware that doing this will prevent your program from being portable to other
OSes (that use different GUI systems), unless you take great care to separate
your native GUI implementation from your program.
*/
OPT PREPROCESS, POINTER
MODULE 'std/cApp', 'std/cGui'
MODULE 'CSH/pAmigaMui', 'utility/hooks'

STATIC title_string = 'NativeGuiExample'

PROC main()
	DEF quit:BOOL, win:PTR TO cGuiWindow, item:PTR TO cGuiItem
	DEF guiText:PTR TO cGuiNativeSimple, guiTick1:PTR TO cGuiNativeSimple, guiTick2:PTR TO cGuiNativeTick, guiTick3:PTR TO cGuiTick, guiQuit:PTR TO cGuiButton
	DEF ticked:BOOL
	
	CreateApp(title_string).build()
	
	->create GUI to show list of tasks
	win := CreateGuiWindow(title_string)
	win.beginGroupVertical()
		->how to add a simple output-only MUI object
		guiText := AddNativeSimple(win, (TextObject, TextFrame, MUIA_Background,MUII_TextBack, MUIA_Text_Contents,'This is a native text object', MUIA_Text_SetVMax,MUI_FALSE, End), MUIA_Text_Contents, MUIV_NotTriggerValue, /*label*/ NIL, /*isFixedWidth*/ TRUE, /*isFixedHeight*/ FALSE, /*useInCycleChain*/ FALSE)
		
		->how to add a simple input MUI object
		guiTick1 := AddNativeSimple(win, CheckMark(MUI_TRUE), MUIA_Selected, MUIV_EveryTime, Label2('Native tick object 1'), /*isFixedWidth*/ TRUE, /*isFixedHeight*/ TRUE)
		
		->how to add a native input MUI object (see how much simpler it is to use!)
		guiTick2 := addNativeTick(win, 'Native tick object 2').setState(TRUE)
		
		->for comparison, this is how you'd add a portable GUI tick object. It doesn't exactly align with the native tick objects, due to having some built-in padding (which would have made the native examples more complex).
		guiTick3 := win.addTick('Portable tick object 3').setState(TRUE)
		
		guiQuit := win.addButton('Quit').initPic('tbimages:/quit')
	win.endGroup()
	win.build()
	
	->handle GUI events
	quit := FALSE
	REPEAT
		item := WaitForChangedGuiItem()
		IF item = NIL
			IF win.getCloseRequest() THEN quit := TRUE
			IF win.getQuitRequest()  THEN quit := TRUE
			
		ELSE IF item = guiQuit
			quit := TRUE
			
		ELSE IF item = guiTick1
			ticked := guiTick1.getState() <> MUI_FALSE
			guiText.setState(IF ticked THEN 'Object 1 was ticked' ELSE 'Object 1 was UNticked')
			
		ELSE IF item = guiTick2
			ticked := guiTick2.getState()
			guiText.setState(IF ticked THEN 'Object 2 was ticked' ELSE 'Object 2 was UNticked')
			
		ELSE IF item = guiTick3
			ticked := guiTick3.getState()
			guiText.setState(IF ticked THEN 'Object 3 was ticked' ELSE 'Object 3 was UNticked')
		ENDIF
	UNTIL quit
FINALLY
	PrintException()
ENDPROC

/*****************************/		->this is used for "guiTick2", but it could be re-used for many tick objects
/*
This is how to declare a "native GUI class", which can be used almost the same as a normal cGui class.
If you expect to use a lot of a particular native GUI element (very likely!), then you should do it this way, as it will simplify your main program's GUI code.
It would also allow you to implement the same class for several different GUI systems, and not have to change your main program's GUI code.

OTOH, if you want to quickly try-out a native GUI element, then you may prefer to use AddNativeSimple() instead.
*/

PROC addNativeTick(win:PTR TO cGuiWindow, label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiNativeTick
	DEF newItem:OWNS PTR TO cGuiNativeTick
	IF win.infoCurrentBuildGroup() = NIL THEN Throw("EPU", 'addNativeTick(); must be done inside a group')
	
	NEW newItem.new(label)
	item := newItem
	win.addNative(PASS newItem)
ENDPROC


CLASS cGuiNativeTick OF cGuiNativeHost
	initialState:BOOL
	label :OWNS STRING
ENDCLASS

PROC new(label:ARRAY OF CHAR) OF cGuiNativeTick
	self.initialState := FALSE
	self.label := StrJoin(label)
	
	self.initShared()	->this is required
ENDPROC

PROC end() OF cGuiNativeTick
	END self.label
	SUPER self.end()
ENDPROC

PROC build() OF cGuiNativeTick RETURNS muiItems:OWNS LIST, object:PTIO, label:PTIO
	muiItems := NEW [Child, label := Label2(self.label), Child, object := CheckMark(IF self.initialState THEN MUI_TRUE ELSE MUI_FALSE)]
ENDPROC

PROC setupNotify(watchObject:PTIO, actionHook:PTR TO hook, param:ILIST) OF cGuiNativeTick
	muim_Notify_action(watchObject, MUIA_Selected, MUIV_EveryTime, actionHook, param)
ENDPROC

PROC infoIsFixedWidth()  OF cGuiNativeTick RETURNS isFixedWidth :BOOL IS TRUE

PROC infoIsFixedHeight() OF cGuiNativeTick RETURNS isFixedHeight:BOOL IS TRUE

PROC infoUseInCycleChain() OF cGuiNativeTick RETURNS useInCycleChain:BOOL IS TRUE

PROC getState() OF cGuiNativeTick RETURNS ticked:BOOL
	DEF object:PTIO, muiBool
	
	object := self.infoObject()
	IF object = NIL
		ticked := self.initialState
	ELSE
		get(object, MUIA_Selected, ADDRESSOF muiBool)
		ticked := (muiBool = MUI_TRUE)
	ENDIF
ENDPROC

PROC setState(ticked:BOOL) OF cGuiNativeTick
	DEF object:PTIO, muiBool
	
	object := self.infoObject()
	IF object = NIL
		self.initialState := ticked
	ELSE
		muiBool := IF ticked THEN MUI_TRUE ELSE MUI_FALSE
		set(object, MUIA_Selected, muiBool)
	ENDIF
ENDPROC self
