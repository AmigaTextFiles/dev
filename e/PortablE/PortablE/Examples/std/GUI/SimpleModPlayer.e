/* SimpleModPlayer.e 18-07-2012 by Chris Handley
*/

MODULE 'std/cGui', 'std/cMusic', 'std/cAppSimple'

PROC main()
	DEF win:PTR TO cGuiWindow
	DEF guiFile:PTR TO cGuiPathString, guiLength:PTR TO cGuiText, guiVolume:PTR TO cGuiSlider
	DEF guiPlay:PTR TO cGuiButton, guiStop:PTR TO cGuiButton
	
	DEF quit:BOOL, item:PTR TO cGuiItem, music:PTR TO cMusic
	DEF temp[30]:STRING
	
	IsDesktopApp()
	
	->create the GUI
	win := CreateGuiWindow('MOD player')
	win.beginGroupVertical()
		guiFile   := win.addPathString('File')
		guiLength := win.addText('Length')
		guiVolume := win.addSlider('Volume', 0, 100).setState(100)
		win.beginGroupHorizontal()
			guiPlay := win.addButton('Play')
			guiStop := win.addButton('Stop')
		win.endGroup()
	win.endGroup()
	win.build()
	
	->handle GUI events
	quit := FALSE
	REPEAT
		item := WaitForChangedGuiItem()
		SELECT item
		CASE NIL
			->(a non-item event occured) so check if user tried to close the window
			IF win.getCloseRequest() THEN quit := TRUE
			
		CASE guiFile
			IF music
				music := DestroyMusic(music)
				guiLength.setState('')
			ENDIF
			
			music := LoadMusic(guiFile.getState(), TRUE)
			IF music
				music.setVolume(guiVolume.getState())
				music.play(0)
				
				StringF(temp, '\d seconds', music.infoLength() / 1000)
				guiLength.setState(temp)
			ENDIF
			
		CASE guiVolume
			IF music THEN music.setVolume(guiVolume.getState())
			
		CASE guiPlay
			IF music THEN music.play()
			
		CASE guiStop
			IF music THEN music.stop()
			
		ENDSELECT
	UNTIL quit
	
	win.close()
FINALLY
	PrintException()
ENDPROC
