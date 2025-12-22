/* DirList.e 06-04-2013 by Chris Handley

A small demo which lists the files in EnvArc:, allows the user to select them,
and then outputs which files were chosen by the user.
*/

MODULE 'std/cGUI', 'std/cPath'

STATIC app_name = 'DirList'

PROC main()
	DEF dirPath:STRING, dir:PTR TO cDir, dirList:PTR TO cDirEntryList
	DEF win:PTR TO cGuiWindow, guiList:PTR TO cGuiList, guiInfo:PTR TO cGuiText, guiOK, selectionCount:STRING
	DEF quit:BOOL, item:PTR TO cGuiItem
	
	->describe our app
	CreateApp(app_name).initDescription('This is a little PortablE demo.').build()
	
	->scan directory
	dirPath := ImportDirPath('EnvArc:')
	NEW dir.new()
	IF dir.open(dirPath, /*readOnly*/ TRUE) = FALSE THEN Throw("ERR", 'Failed to open directory')
	dirList := dir.makeEntryList()
	dir.close()
	
	->build the GUI
	win := CreateGuiWindow(app_name)
	win.beginGroupVertical()
		win.addText('').setState('Choose some files inside EnvArc:')
		
		guiList := win.beginList().initSelectableEntries(/*multiSelect*/ TRUE)
		guiList.initColumnTitles('Filename').setSortByUser()
			->step through each file
			IF dirList.gotoFirst(/*any0file1dir2*/ 1)
				REPEAT
					->add list entry for file
					win.addListEntry(dirList.infoName())
				UNTIL dirList.gotoNext(1) = FALSE
			ENDIF
		win.endList()
		
		guiInfo := win.addText('Number of selected files:').setState('0')
		
		guiOK := win.addButton('OK')
		
	win.endGroup()
	win.build()
	
	->handle user interaction with the GUI
	NEW selectionCount[5]
	quit := FALSE
	REPEAT
		item := WaitForChangedGuiItem()
		IF item = NIL
			IF win.getCloseRequest() THEN quit := TRUE
			
		ELSE IF item = guiList
			->(something changed on the list)
			IF guiList.getEventSelectionChanged()
				->(the user (de)selected an entry in the list) so enable/disable buttons according to whether anything is selected or not
				StringF(selectionCount, '\d', guiList.infoSelectionCount())
				guiInfo.setState(selectionCount)
			ENDIF
			
		ELSE IF item = guiOK
			->(the OK button was clicked)
			quit := TRUE
			
			->output the selected files before quitting
			IF guiList.cursor_gotoStart()
				Print('The following files were selected:\n')
				REPEAT
					IF guiList.cursor_getState() THEN Print('\s\n', guiList.cursor_getLabel())
				UNTIL guiList.cursor_gotoNext() = 0
			ENDIF
		ENDIF
	UNTIL quit
	
	win.close()
FINALLY
	PrintException()
	
	END dirPath, dir
	END selectionCount
ENDPROC
