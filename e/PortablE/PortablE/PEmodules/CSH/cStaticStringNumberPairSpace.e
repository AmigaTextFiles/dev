/* cStaticStringNumberPairSpace.e 13-02-14
	A combined name & number space class, for use by the cGfx, cGfxSprites, cSnd & cMusic modules.

Copyright (c) 2010,2011,2014 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

/* WARNING: The interface of this class is likely to change, so do not rely on it! */

MODULE 'CSH/cStaticStringSpace', 'CSH/cNumberSpaceLite', 'CSH/cNumberSpace'

CLASS cStaticStringNumberPairSpace PRIVATE
	autoDealloc:BOOL
	strings      :OWNS PTR TO cStaticStringSpace/*<cNumberSpaceLite>*/
	reverseLookup:OWNS PTR TO cNumberSpace/*<itemNameNumber>*/		->takes "data" as the key, needed for remove()
ENDCLASS

PROC new(autoDealloc=FALSE:BOOL) OF cStaticStringNumberPairSpace
	self.autoDealloc := autoDealloc
	NEW self.strings.new(TRUE, FALSE)	->autoDealloc=TRUE, caseSensitive=FALSE
	NEW self.reverseLookup.new(TRUE)	->autoDealloc=TRUE
ENDPROC

PROC end() OF cStaticStringNumberPairSpace
	END self.strings
	END self.reverseLookup
	SUPER self.end()
ENDPROC

PROC set(name:ARRAY OF CHAR, number, data:/*POSSIBLY OWNS*/ PTR TO class) OF cStaticStringNumberPairSpace RETURNS replacementFailed:BOOL
	DEF numSpace:PTR TO cNumberSpaceLite, newNumSpace:OWNS PTR TO cNumberSpaceLite, unownedData:PTR TO class, unstoredData:POSSIBLY OWNS PTR TO class
	DEF nameNum:OWNS PTR TO itemNameNumber
	
	IF data = NIL THEN Throw("EMU", 'cStaticStringNumberPairSpace.set(); data=NIL')
	->IF self.reverseLookup.get(data) <> NIL THEN Throw("EMU", 'cStaticStringNumberPairSpace.set(); data is already stored')
	
	numSpace := self.strings.get(name)::cNumberSpaceLite
	IF numSpace = NIL
		NEW newNumSpace.new(self.autoDealloc)
		numSpace := newNumSpace
		self.strings.set(name, PASS newNumSpace)
	ENDIF
	
	unownedData := data
	unstoredData, replacementFailed := numSpace.set(number, PASS data, TRUE)		->doNotReplace=TRUE
	
	IF replacementFailed = FALSE
		->(successfully stored) so add a reverse-lookup item
		NEW nameNum.new(name, number)
		self.reverseLookup.set(unownedData, PASS nameNum)
	ENDIF
FINALLY
	END newNumSpace
	END nameNum
ENDPROC

PROC get(name:ARRAY OF CHAR, number=0, quiet=FALSE:BOOL) OF cStaticStringNumberPairSpace RETURNS data:PTR TO class
	DEF numSpace:PTR TO cNumberSpaceLite
	
	IF numSpace := self.strings.get(name)::cNumberSpaceLite
		data := numSpace.get(number)
		IF data = NIL
			IF quiet = FALSE THEN Print('ERROR: No item with name=\'\s\' matches number=\d.\n', name, number)
		ENDIF
	ELSE
		data := NIL
		IF quiet = FALSE THEN Print('ERROR: No item matches name=\'\s\'.\n', name)
	ENDIF
ENDPROC

PROC remove(data:PTR TO class) OF cStaticStringNumberPairSpace RETURNS existed:BOOL
	DEF nameNum:PTR TO itemNameNumber, numSpace:PTR TO cNumberSpaceLite
	/*DEF name:OWNS STRING*/
	
	nameNum := self.reverseLookup.get(data)::itemNameNumber
	IF nameNum = NIL THEN RETURN FALSE
	
	numSpace := self.strings.get(nameNum.name, FALSE, /*keyNotStatic*/ TRUE)::cNumberSpaceLite
	IF numSpace = NIL THEN Throw("BUG", 'cStaticStringNumberPairSpace.remove(); no string match')
	
	existed := numSpace.delete(nameNum.number)
	IF existed = FALSE THEN Throw("BUG", 'cStaticStringNumberPairSpace.remove(); no number match')
	
	/*name := PASS nameNum.name*/
	self.reverseLookup.delete(data)
	
	/*
	IF numSpace.itemGotoFirst() = FALSE
		->(cNumberSpaceLite is empty) so delete it from cStaticStringSpace
		self.strings.delete(name)	->using a non-static name does not matter in the current implementation of cStaticStringSpace
	ENDIF
FINALLY
	END name
	*/
ENDPROC


PRIVATE
CLASS itemNameNumber
	name:OWNS STRING
	number
ENDCLASS
PROC new(name:ARRAY OF CHAR, number) OF itemNameNumber
	self.name   := StrJoin(name)
	self.number := number
ENDPROC
PROC end() OF itemNameNumber
	END self.name
	SUPER self.end()
ENDPROC
PUBLIC
