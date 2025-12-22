/* SimpleGameLauncher.e 06-04-2013 by Chris Handley
*/
OPT PREPROCESS
MODULE 'std/cGUI', 'std/cPath', 'std/pBox', 'std/pShell'
MODULE 'CSH/pFile'		->for readLines() & writeLines()
MODULE 'CSH/pGeneral'	->for LinkReplace() & LinkAppend()

STATIC app_name  = 'SimpleGameLauncher'
STATIC app_prefs = 'SimpleGameLauncher.list'

PROC main()
	DEF win:PTR TO cGuiWindow, guiList:PTR TO cGuiList, guiRename:PTR TO cGuiButton, guiRemove:PTR TO cGuiButton
	DEF quit:BOOL, item:PTR TO cGuiItem
	DEF droppedFile:ARRAY OF CHAR
	DEF path:STRING, name:STRING, head:STRING, node:STRING, next:STRING
	DEF hostPath:STRING, oldName:ARRAY OF CHAR
	
	->describe our app
	CreateApp(app_name).build()
	
	->load list of games (as a list of linked e-strings)
	head := readLines(app_prefs)
	IF head
		->check file format version, and get to first entry
		IF StrCmp(head, '1')
			node := LinkReplace(head, NILS)
		ELSE
			END head
		ENDIF
	ENDIF
	
	->build the GUI
	win := CreateGuiWindow(app_name).initAllowDropFiles().initSaveID("MAIN")
	win.beginGroupVertical()
		guiList := win.beginList().initSelectableEntries()
		guiList.setPopupHint('Drop a game here to add it to the list')
		guiList.setSortByColumn(0)
			->step through the e-string list of games, adding them to the GUI list
			WHILE node
				->extract next game from e-string list
				next := LinkReplace(node, NILS) ; name := node ; node := next ; IF node = NIL THEN Throw("list", 'simpleGameLauncher.list ended unexpectedly')
				next := LinkReplace(node, NILS) ; path := node ; node := next ; IF node = NIL THEN Throw("list", 'simpleGameLauncher.list ended unexpectedly')
				
				IF StrCmp(node, '') = FALSE THEN Throw("list", 'simpleGameLauncher.list is corrupt')
				next := LinkReplace(node, NILS) ;     END node ; node := next
				
				->add game to GUI list
				addGame(guiList, name, ImportFilePath(path)) ; END path
			ENDWHILE
		win.endList()
		
		win.beginGroupHorizontal()
			guiRename := win.addButton('Rename entry').initPic('tbimages:/rename')	->uses an AISS image (if present)
			guiRemove := win.addButton('Remove entry').initPic('tbimages:/delete')
		win.endGroup()
		
	win.endGroup()
	win.build()
	
	->just in case an entry is (not) already selected on some GUI systems
	IF guiList.infoSelectionCount() = 0
		guiRename.setGhosted(TRUE)
		guiRemove.setGhosted(TRUE)
	ENDIF
	
	->handle user interaction with GUI
	quit := FALSE
	REPEAT
		item := WaitForChangedGuiItem()
		IF item = NIL
			IF win.getCloseRequest() THEN quit := TRUE
			IF win.getQuitRequest()  THEN quit := TRUE
			
			IF droppedFile := win.getDroppedFile()
				->(a file or folder was dropped on the window)
				IF IsFile(droppedFile)
					addGame(guiList, StrJoin(FindName(droppedFile)), StrJoin(droppedFile), /*moveCursorToEntry*/ TRUE)
					guiList.cursor_setState(TRUE)
				ENDIF
			ENDIF
			
		ELSE IF item = guiRename
			->(the Rename button was clicked)
			IF guiList.cursor_gotoFirstSelected()
				win.setBusy(TRUE)
				
				oldName := guiList.cursor_getLabel()
				IF name := requestString(app_name, 'Rename entry:', oldName)
					guiList.cursor_setLabel(name)
					END name
				ENDIF
				
				win.setBusy(FALSE)
			ENDIF
			
		ELSE IF item = guiRemove
			->(the Remove button was clicked)
			IF guiList.cursor_gotoFirstSelected() THEN guiList.cursor_destroy()
			
		ELSE IF item = guiList
			->(one or more things changed on the list) so handle all possibilities
			
			IF guiList.getEventSelectionChanged()
				->(the user (de)selected an entry in the list) so enable/disable buttons according to whether anything is selected or not
				guiRename.setGhosted(guiList.infoSelectionCount() = 0)
				guiRemove.setGhosted(guiList.infoSelectionCount() = 0)
			ENDIF
			
			IF guiList.getEventDoubleClickedEntry(/*moveCursorToEntry*/ TRUE)
				->(user double-clicked on an entry in the list) so run the relevant game
				hostPath := ExportPath(UnboxSTRING(guiList.cursor_getDataBox()))		->the path string is retrieved from dataBox by 'unboxing' it
				wbRun(hostPath)
				END hostPath
			ENDIF
		ENDIF
	UNTIL quit
	
	->save list of games
	saveList(guiList)
	
	win.close()
FINALLY
	PrintException()
	
	END head
ENDPROC

->adds the named game to the given GUI list, and optionally moving the list's cursor to the added game entry
PROC addGame(guiList:PTR TO cGuiList, name:STRING, path:STRING, moveCursorToEntry=FALSE:BOOL)
	guiList.addEntry(name, FALSE, FALSE, 0, /*dataBox*/ BoxSTRING(path), moveCursorToEntry)		->the path string is stored in dataBox by 'boxing' it
ENDPROC

->saves the GUI list of games to a file
PROC saveList(guiList:PTR TO cGuiList) RETURNS success:BOOL
	DEF head:STRING, tail:STRING, path:STRING, name:STRING
	
	->create a list of linked e-strings from the GUI list of games
	head := NEW '1'	->file format version
	tail := head
	IF guiList.cursor_gotoStart()
		->(list is not empty) 
		REPEAT
			path := ExportPath(UnboxSTRING(guiList.cursor_getDataBox()))
			name := StrJoin(guiList.cursor_getLabel())
			tail := LinkAppend(tail, name)
			tail := LinkAppend(tail, path)
			tail := LinkAppend(tail, NEW '')	->marks end of entry, in case we later add more lines to an entry
		UNTIL guiList.cursor_gotoNext() = 0
	ENDIF
	
	->write that list of e-strings to a file
	success := writeLines(app_prefs, head)
FINALLY
	END head
ENDPROC

->use the Amiga "WbRun" command to asynchronously start a game
PROC wbRun(hostPath:ARRAY OF CHAR)
	DEF wbRun:ARRAY OF CHAR, command:STRING
	
	wbRun := #ifdef pe_TargetOS_AROS 'Open' #else 'WbRun' #endif	->AROS has Open instead of the WbRun command used on AmigaOS4 & MorphOS
	command := StrJoin(wbRun, ' "', hostPath, '"')
	ExecuteCommand(command)
FINALLY
	END command
ENDPROC

->get the user to enter a string, optionally with a default string already supplied
PROC requestString(title:ARRAY OF CHAR, message:ARRAY OF CHAR, defString=NILA:ARRAY OF CHAR) RETURNS result:STRING
	DEF win:PTR TO cGuiWindow, guiString:PTR TO cGuiString
	DEF guiOK, guiCancel
	DEF done:BOOL, item:PTR TO cGuiItem
	
	->create GUI
	win := CreateGuiWindow(title)
	win.beginGroupVertical()
		guiString := win.addString(message)
		IF defString THEN guiString.setState(defString)
		
		win.beginGroupHorizontal()
			guiOK     := win.addButton('OK')
			guiCancel := win.addButton('Cancel')
		win.endGroup()
	win.endGroup()
	win.build()
	
	->handle GUI events
	done := FALSE
	REPEAT
		item := WaitForChangedGuiItem()
		IF item = NIL
			IF win.getCloseRequest() THEN done := TRUE	->(the window's close button was clicked)
			
		ELSE IF item = guiOK
			->(the OK button was clicked)
			result := StrJoin(guiString.getState())
			IF EstrLen(result) = 0		->reject empty strings
				END result
			ELSE
				done := TRUE
			ENDIF
			
		ELSE IF item = guiCancel
			->(the Cancel button was clicked)
			done := TRUE
		ENDIF
	UNTIL done
	
	win.close()
FINALLY
	DestroyGuiWindow(win)
ENDPROC
