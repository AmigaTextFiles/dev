/* SimpleCalculator.e 18-07-2012 by Chris Handley

BEWARE that this calculator cannot show non-integer results, like 1÷2,
because I wanted to make this example code as simple as possible.
*/

MODULE 'std/cGui', 'std/cAppSimple'

PROC main()
	DEF win:PTR TO cGuiWindow
	DEF quit:BOOL, item:PTR TO cGuiItem
	DEF displayBox:PTR TO cGuiText,    displayNum, buttonLabel:ARRAY OF CHAR, buttonLetter:CHAR
	DEF  lastOpBox:PTR TO cGuiText, lastResultNum,   lastOpStr:ARRAY OF CHAR
	DEF temp[11]:STRING
	
	IsDesktopApp()
	
	->create the GUI
	win := CreateGuiWindow('Calculator')
	win.beginGroupVertical()
		win.beginGroupHorizontal()
			 lastOpBox := win.addText('').setState('=').initUseLeastSpace()
			displayBox := win.addText('').setState('0').initAlignRight()
		win.endGroup()
		
		win.beginGroupGrid(5).initEqualSizedItems()
			win.addButton('7') ; win.addButton('8') ; win.addButton('9') ; win.addButton('Del') ; win.addButton('Clr')
			win.addButton('4') ; win.addButton('5') ; win.addButton('6') ; win.addButton('×')   ; win.addButton('÷')
			win.addButton('1') ; win.addButton('2') ; win.addButton('3') ; win.addButton('+')   ; win.addButton('-')
			win.addButton('0') ; win.addLabel('')   ; win.addLabel('')   ; win.addButton('±')   ; win.addButton('=')
		win.endGroup()
	win.endGroup()
	win.build()
	
	->handle GUI events
	lastResultNum := 0
	displayNum    := 0
	quit := FALSE
	REPEAT
		item := WaitForChangedGuiItem()
		IF item = NIL
			->(a non-item event occured) so check if user tried to close the window
			IF win.getCloseRequest() THEN quit := TRUE
			
		ELSE IF item.IsOfClassType(TYPEOF cGuiButton)
			->(a button was pressed)
			->we cheat here(!), by reading the button's label, rather identify each button item individually
			buttonLabel  := item::cGuiButton.infoLabel()
			buttonLetter := buttonLabel[0]		->first character of label
			
			IF (buttonLetter >= "0") AND (buttonLetter <= "9")
				->append digit
				StringF(temp, '\d\c', displayNum, buttonLetter)
				displayNum := Val(temp)
				
				setDisplay(displayBox, displayNum)
				
			ELSE IF buttonLetter = "D"	->Del
				->delete last digit
				IF displayNum <> 0
					StringF(temp, '\d', displayNum)
					SetStr(temp, Max(0, EstrLen(temp) - 1))
					displayNum := Val(temp)
					
					setDisplay(displayBox, displayNum)
				ENDIF
				
			ELSE IF buttonLetter = "C"	->Clr
				->clear display & all calculation results
				lastResultNum := 0
				displayNum    := 0
				setDisplay(displayBox, displayNum)
				lastOpBox.setState('=')
				
			ELSE IF buttonLetter = "±"
				->negate the current number
				IF displayNum = 0 THEN displayNum := lastResultNum
				displayNum := -displayNum
				setDisplay(displayBox, displayNum)
				
			ELSE	->"×","÷","+","-","="
				->calculate result of last operation
				lastOpStr := lastOpBox.getState()
				IF      lastOpStr[0] = "=" ; IF displayNum = 0 THEN displayNum := lastResultNum
				ELSE IF lastOpStr[0] = "×" ; displayNum := lastResultNum * displayNum
				ELSE IF lastOpStr[0] = "÷" ; displayNum := lastResultNum / displayNum
				ELSE IF lastOpStr[0] = "+" ; displayNum := lastResultNum + displayNum
				ELSE IF lastOpStr[0] = "-" ; displayNum := lastResultNum - displayNum
				ENDIF
				setDisplay(displayBox, displayNum)
				
				->prepare for next calculation
				lastResultNum := displayNum
				displayNum    := 0
				lastOpBox.setState(buttonLabel)
			ENDIF
		ENDIF
	UNTIL quit
	
	win.close()
FINALLY
	PrintException()
	END temp
ENDPROC

->update the given text box with the given number
PROC setDisplay(displayBox:PTR TO cGuiText, displayNum)
	DEF displayStr[11]:STRING
	StringF(displayStr, '\d', displayNum)
	displayBox.setState(displayStr)
ENDPROC
