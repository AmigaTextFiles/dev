/*
Simple test of database-like caching.
*/

OPT INLINE, PREPROCESS
MODULE 'std/cPath', 'std/pShell'

STATIC path = 'Code:/PE/eNewsReader/database.soup'
CONST NUM_OBJ_PARTS = 5
CONST OBJ_PART_SIZE = 16

PROC main()
	DEF quit:BOOL, buffer[OBJ_PART_SIZE]:ARRAY OF BYTE, i
	DEF file:OWNS PTR TO cFile, pos:BIGVALUE, size:BIGVALUE
	
	NEW file.new()
	IF file.open(path, /*readOnly*/ TRUE) = FALSE THEN Throw("FILE", 'Failed to open file')
	
	pos := 0
	size := file.getSize()
	REPEAT
->		Print('pos = \d (\d%)\n', pos!!VALUE, 100*pos/size!!VALUE)
		file.setPosition(pos)
		file.readPrecache(NUM_OBJ_PARTS * OBJ_PART_SIZE, 0, /*isItemInList*/ TRUE)
		FOR i := 1 TO NUM_OBJ_PARTS
			pos := file.read(buffer, OBJ_PART_SIZE)
			file.setPosition(pos)
			quit := CtrlC()
		ENDFOR IF quit
	UNTIL quit OR (pos >= size)
	
	file.close()
	Print('Finished\n')
FINALLY
	PrintException()
	END file
ENDPROC

PROC infoChunkSize(self:PTR TO cFile) IS self.queryExtra("CSiz")
