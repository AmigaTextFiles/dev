 /* Stacker.e 20.07.2013
   by Chris Handley

This is a basic app for viewing the stack usage of any task running on an Amiga.

There are lots of ways this could be improved, but I wanted to keep it as simple
as possible.
*/
OPT POINTER, PREPROCESS
MODULE 'exec', 'dos/dosextens', 'dos/dos'
MODULE 'std/cApp', 'std/cGui'

STATIC     app_string =         'Stacker'
STATIC version_string =         'Stacker (20.07.2013)'
STATIC   title_string =         'Stacker (20.07.2013) - by Chris S Handley'
STATIC  hidden_string = '\0$VER: Stacker (20.07.2013) - by Chris S Handley'
STATIC  author_string =                                   'Chris S Handley'

PROC main()
	DEF list:/*OWNS*/ STRING, entry:STRING
	DEF refresh:BOOL, quit:BOOL, win:PTR TO cGuiWindow, item:PTR TO cGuiItem, listEntryLabel:ARRAY OF CHAR
	DEF guiList:PTR TO cGuiList,
	    guiName:PTR TO cGuiText, guiAddress:PTR TO cGuiText, guiSSize:PTR TO cGuiText, guiSPerc:PTR TO cGuiSlider, guiSUsed:PTR TO cGuiText,
	    guiRefreshTask:PTR TO cGuiButton, guiRefreshList:PTR TO cGuiButton
	DEF watchName:/*OWNS*/ STRING, watchTask, pos, temp:/*OWNS*/ STRING
	
	->define our app
	CreateApp(app_string).initVersion(version_string).initAuthor(author_string).initDescription('Basic app for viewing stack usage').build()
	
	->scan tasks & return as a list of strings suitable for use as GUI rows
	list := getListOfTasks()
	
	->create GUI to show list of tasks
	win := CreateGuiWindow(title_string).initSaveID("main")
	win.beginGroupVertical()
		guiList := win.beginList(/*columns*/ 7).initSelectableEntries()
		guiList.initColumnTitles('Name\tAddress\tType\tStack Used\tStack Size\tPri\tState')
		guiList.initColumnAlignment('LLLRRRL')
		guiList.initColumnSortType( 'ININNNI')
		guiList.setSortByUser(/*initialColumn*/ 0)
		/*
		guiList.setSortByFunction(fGuiListSortByFirstTwoColumns)	->a useful alternative to user sorting
		*/
			entry := list
			WHILE entry
				win.addListEntry(entry)
				entry := Next(entry)
			ENDWHILE
			END list
		win.endList()
		
		win.beginGroupVertical()
			guiName    := win.addText('Watching')
			guiAddress := win.addText('Address')
		win.endGroup()
		
		win.beginGroupVertical('Stack Usage')
			guiSSize := win.addText('Allocated')	->stack size
			guiSPerc := win.addSlider('', 0, 100).initUnit('\%').setGhosted(TRUE)	->a poor-man's fuel guage (read-only slider)
			guiSUsed := win.addText('Current')		->stack used
		win.endGroup()
		
		win.beginGroupHorizontal()
			guiRefreshTask := win.addButton('Refresh watched task').initPic('tbimages:/reloadimage').setGhosted(TRUE)
			guiRefreshList := win.addButton('Refresh list'        ).initPic('tbimages:/refresh_h')
		win.endGroup()
	win.endGroup()
	win.build()
	
	->main program loop
	refresh := FALSE
	REPEAT
		IF refresh
			list := getListOfTasks()
			guiList.update(PASS list)
		ENDIF
		
		->handle GUI events
		refresh := FALSE
		quit := FALSE
		REPEAT
			item := WaitForChangedGuiItem()
			IF item = NIL
				IF win.getCloseRequest() THEN quit := TRUE
				
			ELSE IF item = guiRefreshList
				refresh := TRUE
				
			ELSE IF item = guiRefreshTask
				IF updateWatchedTask(watchName, watchTask, guiList, guiName, guiAddress, guiSSize, guiSPerc, guiSUsed) = FALSE
					END watchName
					guiRefreshTask.setGhosted(watchName=NILS)
				ENDIF
				
			ELSE IF item = guiList
				->(an item was selected or unselected) so update GUI
				IF guiList.getEventSelectionChanged()
					listEntryLabel := guiList.infoSingleSelectionEntry()
					
					END watchName
					IF listEntryLabel
						->extract info from list about selected task
						pos := InStr(listEntryLabel, '\t')
						NEW watchName[pos]
						StrCopy(watchName, listEntryLabel)
						
						pos := InStr(listEntryLabel, '$')
						watchTask := Val(listEntryLabel + pos)
					ENDIF
					
					IF updateWatchedTask(watchName, watchTask, guiList, guiName, guiAddress, guiSSize, guiSPerc, guiSUsed) = FALSE
						END watchName
					ENDIF
					
					guiRefreshTask.setGhosted(watchName=NILS)
				ENDIF
			ENDIF
		UNTIL quit OR refresh
	UNTIL quit
FINALLY
	PrintException()
	
	END list
	END temp
ENDPROC

/*
->sort by the Name column, then the Address column
FUNC fGuiListSortByFirstTwoColumns(firstLabel:ARRAY OF CHAR, secondLabel:ARRAY OF CHAR, firstData=0, secondData=0, firstDataBox=NIL:/*OWNS*/ PTR TO class, secondDataBox=NIL:/*OWNS*/ PTR TO class) OF fGuiListSort RETURNS sign:RANGE -1 TO 1
	DEF firstTab,  secondTab
	DEF firstTab2, secondTab2
	
	->try sorting using the first column
	 firstTab := InStr( firstLabel, '\t')
	secondTab := InStr(secondLabel, '\t')
	sign := OstrCmpNoCase(firstLabel, secondLabel, Max(firstTab, secondTab))	->we are cheating slightly for the cases where the shorter label matches the beginning of the longer label (should use Min() instead of Max() plus some extra code in case sign=0) but this should work as the Tab character has a value less than normal characters
	
	->sort using the second column, if it was equal using the first column
	IF sign = 0
		 firstTab2 := InStr( firstLabel, '\t' , firstTab+1)
		secondTab2 := InStr(secondLabel, '\t', secondTab+1)
		sign := OstrCmpNoCase(firstLabel, secondLabel, Max(firstTab2-firstTab, secondTab2-secondTab), firstTab+1, secondTab+1)	->ditto
	ENDIF
ENDFUNC
*/


OBJECT taskcopy
	task
	spreg
	splower
	spupper
	state
	type
	pri
	name:ARRAY OF CHAR
ENDOBJECT

PROC copyTask(from:PTR TO tc, to:PTR TO taskcopy, string:PTR TO CHAR, send:PTR TO CHAR)
	DEF process:PTR TO process, cli:PTR TO commandlineinterface
	DEF nameLen, cmdStart:ARRAY OF CHAR, cmdLen
	
	to.task    := from
	to.spreg   := from.spreg
	to.splower := from.splower
	to.spupper := from.spupper
	to.state   := from.state
	to.type    := from.ln.type
	to.pri     := from.ln.pri
	
	to.name := string
	string := copyString(from.ln.name, string, send) ; nameLen := (string-1 - to.name) / SIZEOF CHAR
	
	IF from.ln.type = NT_PROCESS
		process := from!!PTR!!PTR TO process
		IF process.cli
			->(this task is a Shell or similar) so append the name of the program that the Shell is currently executing
			cli := Baddr(process.cli)
			
			IF bcplStringLength(cli.commandname) > 0
				string := copyString(               ' (', string, send, /*append*/ TRUE) ; cmdStart :=  string-1
				string := copyBcplString(cli.commandname, string, send, /*append*/ TRUE) ; cmdLen   := (string-1 - cmdStart) / SIZEOF CHAR
				string := copyString(                ')', string, send, /*append*/ TRUE)
				
				->avoid duplicate string
				IF nameLen = cmdLen
					IF StrCmp(to.name, cmdStart, cmdLen)
						string := to.name + (nameLen * SIZEOF CHAR)
						string[0] := 0
						string++
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDPROC string

PROC copyString(from:ARRAY OF CHAR, string:PTR TO CHAR, send:PTR TO CHAR, append=FALSE:BOOL)
	DEF chara:CHAR
	
	IF string = NIL THEN RETURN
	
	IF append THEN string--
	
	REPEAT
		chara := string[0] := from[0]
		string++
		from++
	UNTIL (chara = 0) OR (string >= send)
	
	IF string >= send THEN string := NIL
ENDPROC string

PROC copyBcplString(from:BSTR, string:PTR TO CHAR, send:PTR TO CHAR, append=FALSE:BOOL)
	DEF len, temp:ARRAY OF CHAR
	
	IF string = NIL THEN RETURN
	
	IF append THEN string--
	
	temp := Baddr(from) !!VALUE!!ARRAY
	len := CharToUnsigned(temp[0])
	temp++
	
	WHILE len > 0
		string[0] := temp[0]
		string++
		temp++
		len--
	ENDWHILE IF string >= send
	
	IF string < send
		string[0] := 0
		string++
	ENDIF
	
	IF string >= send THEN string := NIL
ENDPROC string

PROC bcplStringLength(from:BSTR) RETURNS len
	DEF temp:ARRAY OF CHAR
	
	temp := Baddr(from) !!VALUE!!ARRAY
	len := CharToUnsigned(temp[0])
ENDPROC

PROC getListOfTasks() RETURNS list:/*OWNS*/ STRING
	DEF sysbase:PTR TO execbase, success:BOOL, task:PTR TO tc
	DEF tbuffer:/*OWNS*/ ARRAY OF taskcopy, tsize, tlen
	DEF sbuffer:/*OWNS*/ ARRAY OF CHAR, ssize, string:PTR TO CHAR, send:PTR TO CHAR
	DEF i, row:/*OWNS*/ STRING, newHead:/*OWNS*/ STRING
	
	->fill buffer with list of tasks (while interrupts & multitasking are disabled)
	sysbase := execbase!!PTR
	tsize := 256
	ssize := tsize * 32
	REPEAT
		END tbuffer,        sbuffer
		NEW tbuffer[tsize], sbuffer[ssize]
		tlen := 0 ;         string := sbuffer ; send := sbuffer + (ssize * SIZEOF CHAR)
		success := TRUE
		
		Disable()
		
		->IF success
			task := sysbase.taskready.head!!PTR
			
			WHILE task.ln.succ
				string := copyTask(task, tbuffer[tlen++], string, send)
				IF string = NIL
					success := FALSE
					ssize := ssize * 2
				ENDIF
				
				task := task.ln.succ!!PTR
			ENDWHILE IF (tlen >= tsize) OR (success = FALSE)
			IF tlen >= tsize
				success := FALSE
				tsize := tsize * 2
			ENDIF
		->ENDIF
		
		IF success
			task := sysbase.taskwait.head!!PTR
			
			WHILE task.ln.succ
				string := copyTask(task, tbuffer[tlen++], string, send)
				IF string = NIL
					success := FALSE
					ssize := ssize * 2
				ENDIF
				
				task := task.ln.succ!!PTR
			ENDWHILE IF (tlen >= tsize) OR (success = FALSE)
			IF tlen >= tsize
				success := FALSE
				tsize := tsize * 2
			ENDIF
		ENDIF
		
		Enable()
	UNTIL success
	
	->store buffered task info as an UNsorted list of GUI row strings (ready for GUI creation)
	list := NILS
	NEW row[1024]
	FOR i := 0 TO tlen-1
		writeTaskLine(row, tbuffer[i])
		
		newHead := StrJoin(row)
		Link(newHead, PASS list)
		list := PASS newHead
		->Print('\s\n', row)
		->Print('task=$\h[8] state=\s type=\s priority=\d[4] stack size=\d[9] stack used=\d[9] name=\s\n', tbuffer[i].task, state, type, tbuffer[i].pri, stackSize, stackUsed, tbuffer[i].name)
	ENDFOR
	END row
FINALLY
	END tbuffer
	END sbuffer
	END row, newHead
	IF exception THEN END list
ENDPROC

PROC writeTaskLine(line:STRING, task:PTR TO taskcopy) RETURNS stackSize, stackUsed
	DEF state:ARRAY OF CHAR, type
	
	stackSize := task.spupper - task.splower + (2*SIZEOF LONG)
	stackUsed := task.spupper - task.spreg   + (2*SIZEOF LONG)	->maybe: IF task.state = TS_RUN THEN 0 /*spreg is invalid*/ ELSE ...
	
	SELECT task.state
	CASE TS_INVALID   ; state := 'invalid'
	CASE TS_ADDED     ; state := 'added'
	CASE TS_RUN       ; state := 'run'
	CASE TS_READY     ; state := 'ready'
	CASE TS_WAIT      ; state := 'wait'
	CASE TS_EXCEPT    ; state := 'except'
	CASE TS_REMOVED   ; state := 'removed'
	#ifdef pe_TargetOS_AmigaOS4
	CASE TS_CRASHED   ; state := 'crashed'
	CASE TS_SUSPENDED ; state := 'suspended'
	#endif
	DEFAULT           ; state := 'unknown'
	ENDSELECT
	
	type := IF task.type = NT_TASK THEN 'task' ELSE IF task.type = NT_PROCESS THEN 'process' ELSE 'CLI'
	
	->                                                Name,   Address, Type, Stack Used, Stack Size,      Pri, State
	StringF(line, '\s\t$\h\t\s\t\d\t\d\t\d\t\s', task.name, task.task, type,  stackUsed,  stackSize, task.pri, state)
ENDPROC

->NOTE: Returns FALSE if the task could not be found.
PROC updateWatchedTask(watchName:STRING, watchTask, guiList:PTR TO cGuiList, guiName:PTR TO cGuiText, guiAddress:PTR TO cGuiText, guiSSize:PTR TO cGuiText, guiSPerc:PTR TO cGuiSlider, guiSUsed:PTR TO cGuiText) RETURNS success:BOOL
	DEF task:PTR TO tc, taskcopy:taskcopy, row:/*OWNS*/ STRING, compareLen
	DEF stackSize, stackUsed, taskString[9]:STRING, sizeString[10]:STRING, usedString[10]:STRING
	
	DEF tbuffer:/*OWNS*/ ARRAY OF taskcopy
	DEF sbuffer:/*OWNS*/ ARRAY OF CHAR, ssize, string:PTR TO CHAR, send:PTR TO CHAR
	
	->examine watched task
	IF watchName
		->set-up temporary buffers for findTask()
		NEW tbuffer[1]
		ssize := StrLen(watchName)+2
		NEW       sbuffer[ssize]
		string := sbuffer ; send := sbuffer + (ssize * SIZEOF CHAR)
		
		->look for the named task
		Disable()
		->IF task := FindTask(watchName)
		task := NIL ; WHILE task := findTask(watchName, tbuffer[0], string, send, task) ; ENDWHILE IF task = watchTask
		IF task
			copyTask(task, taskcopy, NIL, NIL)
			taskcopy.name := watchName
		ELSE
			watchName := NILS
		ENDIF
		Enable()
	ENDIF
	
	->update GUI
	IF watchName
		NEW row[1000]
		stackSize, stackUsed := writeTaskLine(row, taskcopy)
		compareLen := InStr(row, '\t')+1 ; compareLen := InStr(row, '\t', compareLen)+1		->end of 2nd column (Address)
		IF guiList.cursor_find(row, FALSE, compareLen)
			guiList.cursor_setLabel(row)
		ENDIF
		
		StringF(taskString, '$\h', watchTask)
		StringF(usedString,  '\d', stackUsed)
		StringF(sizeString,  '\d', stackSize)
		
		guiName   .setState(watchName)
		guiAddress.setState(taskString)
		guiSSize  .setState(sizeString)
		guiSPerc  .setState(100 * stackUsed / stackSize)
		guiSUsed  .setState(usedString)
	ELSE
		guiName   .setState('')
		guiAddress.setState('')
		guiSSize  .setState('')
		guiSPerc  .setState( 0)
		guiSUsed  .setState('')
	ENDIF
	
	success := (watchName<>NILS)
FINALLY
	END row
	END tbuffer
	END sbuffer
ENDPROC

->similar to FindTask() but handles multiple tasks with the same name
->NOTE: It assumes it is called within a Disable()/Enable() pair.
PROC findTask(name:ARRAY OF CHAR, to:PTR TO taskcopy, string:PTR TO CHAR, send:PTR TO CHAR, after=NIL:PTR TO tc) RETURNS match:PTR TO tc
	DEF sysbase:PTR TO execbase, task:PTR TO tc, nextList:PTR TO tc
	
	sysbase := execbase!!PTR
	
	nextList := sysbase.taskwait.head!!PTR
	task := sysbase.taskready.head!!PTR
	IF task.ln.succ = NIL
		task := nextList ; nextList := NIL
	ENDIF
	WHILE task.ln.succ
		IF after
			IF task = after THEN after := NIL
			
		ELSE IF copyTask(task, to, string, send)
			->(buffer was not too small)
			IF StrCmp(name, to.name) THEN match := task
		ENDIF
		
		task := task.ln.succ!!PTR
		IF (nextList <> NIL) AND (task.ln.succ = NIL)
			task := nextList ; nextList := NIL
		ENDIF
	ENDWHILE IF match
ENDPROC
