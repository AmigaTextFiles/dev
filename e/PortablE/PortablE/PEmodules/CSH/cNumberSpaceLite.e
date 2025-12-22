/* cNumberSpaceLite.e 06-12-2010
	A number-space class, which efficiently stores a single item.

Copyright (c) 2010 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

/* Public methods of cNumberSpaceLite class:
infoAutoDealloc() RETURNS autoDealloc:BOOL
delete(key) RETURNS existed:BOOL
set(key, data:POSSIBLY OWNS PTR TO class, doNotReplace=FALSE:BOOL) RETURNS unstoredData:PTR TO class, alreadyExisted:BOOL
get(key, remove=FALSE:BOOL) RETURNS data:POSSIBLY OWNS PTR TO class
NEW new(autoDealloc=FALSE:BOOL)

itemGotoFirst() RETURNS success:BOOL
itemGotoNext() RETURNS success:BOOL
itemInfo() RETURNS data:PTR TO class, key
*/

MODULE 'CSH/cNumberSpace'


CLASS cNumberSpaceLite
	autoDealloc:BOOL
	
	singleKey
	singleData:POSSIBLY OWNS PTR TO class	->NIL unless storing 1 item
	
	numbers:OWNS PTR TO cNumberSpace		->NIL if only storing 0 or 1 items
ENDCLASS

PROC new(autoDealloc=FALSE:BOOL) OF cNumberSpaceLite
	self.autoDealloc := autoDealloc
	self.singleData := NIL
	self.numbers := NIL
ENDPROC

PROC end() OF cNumberSpaceLite
	IF self.autoDealloc THEN END self.singleData
	END self.numbers
	SUPER self.end()
ENDPROC

PROC infoAutoDealloc() OF cNumberSpaceLite RETURNS autoDealloc:BOOL IS self.autoDealloc

PROC get(key, remove=FALSE:BOOL) OF cNumberSpaceLite RETURNS data:POSSIBLY OWNS PTR TO class
	IF self.numbers
		data := self.numbers.get(key, remove)
	ELSE
		IF key = self.singleKey
			data := self.singleData
			IF remove THEN self.singleData := NIL
		ELSE
			data := NIL
		ENDIF
	ENDIF
ENDPROC

PROC set(key, data:POSSIBLY OWNS PTR TO class, doNotReplace=FALSE:BOOL) OF cNumberSpaceLite RETURNS unstoredData:PTR TO class, alreadyExisted:BOOL
	DEF itemData:POSSIBLY OWNS PTR TO class
	
	IF data = NIL THEN Throw("EMU", 'cNumberSpaceLite.set(); data=NIL')
	
	IF self.numbers
		unstoredData, alreadyExisted := self.numbers.set(key, PASS data, doNotReplace)
		
	ELSE IF (self.singleData = NIL) OR (self.singleKey = key)
		IF doNotReplace AND (self.singleData <> NIL)
			itemData := PASS data
		ELSE
			itemData := PASS self.singleData
			self.singleKey  := key
			self.singleData := PASS data
		ENDIF
		
		alreadyExisted := itemData <> NIL
		IF self.autoDealloc THEN END itemData
		unstoredData := itemData
	ELSE
		NEW self.numbers.new(self.autoDealloc)
		self.numbers.set(self.singleKey, PASS self.singleData)
		unstoredData, alreadyExisted := self.numbers.set(key, PASS data, doNotReplace)
	ENDIF
ENDPROC

PROC delete(key) OF cNumberSpaceLite RETURNS existed:BOOL
	IF self.numbers
		existed := self.numbers.delete(key)
		
	ELSE IF self.singleData
		IF existed := (key = self.singleKey)
			IF self.autoDealloc THEN END self.singleData ELSE self.singleData := NIL
		ENDIF
	ELSE
		existed := FALSE
	ENDIF
ENDPROC


PROC itemGotoFirst() OF cNumberSpaceLite RETURNS success:BOOL
	IF self.numbers
		success := self.numbers.itemGotoFirst()
	ELSE
		success := (self.singleData <> NIL)
	ENDIF
ENDPROC

PROC itemGotoNext() OF cNumberSpaceLite RETURNS success:BOOL
	IF self.numbers
		success := self.numbers.itemGotoNext()
	ELSE
		success := FALSE
	ENDIF
ENDPROC

PROC itemInfo() OF cNumberSpaceLite RETURNS data:PTR TO class, key
	IF self.numbers
		data, key := self.numbers.itemInfo()
	ELSE
		data := self.singleData
		key  := self.singleKey
	ENDIF
ENDPROC
