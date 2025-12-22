/* pFileList.e 05-12-2015
	A collection of useful file procedures.
	Copyright (c) 2010,2011,2013,2014,2015 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
PUBLIC MODULE 'CSH/cMegaList_STRING'
MODULE 'std/cPath_File'

/*
PROC main()
	DEF lines:OWNS PTR TO cMegaList_STRING
	
	Print('Reading...\n')
	lines := readLines('S:/User-Startup')
	
	Print('Writing...\n')
	writeLines('RAM:/User-Startup', lines)
	
	Print('Done\n')
FINALLY
	PrintException()
	END lines
ENDPROC
*/

/*****************************/

->returns file contents as a list of e-string lines
->NOTE: Expects a portable path for filePath.
PROC readLines(filePath:ARRAY OF CHAR, returnNILforNoFile=FALSE:BOOL) RETURNS lines:OWNS PTR TO cMegaList_STRING
	DEF file:OWNS PTR TO cHostFile, size, contents:OWNS STRING
	DEF next, len, start, node:OWNS STRING
	
	NEW lines.new()
	
	NEW file.new()
	IF file.open(filePath, TRUE)	->readOnly = TRUE
		->read file into memory
		size := file.getSize() !!VALUE
		NEW contents[size + 1]
		file.read(contents, size)
		file.close()
		
		SetStr(contents, size)
		StrAdd(contents, '\n')
		
		->split into lines
		next := 0
		REPEAT
			->find end of line
			start := next
			next := InStr(contents, '\n', start)
			IF next = -1 THEN next := size		->this is the last line to be stored
			
			->copy line
			len := next - start
			NEW node[Max(1,len)]
			StrCopy(node, contents, len, start)
			
			IF len > 0
				IF node[len - 1] = "\b" THEN SetStr(node, len - 1)		->strip CR (as line may end in a CRLF)
			ENDIF
			
			next++
			
			->append to list
			lines.infoPastEnd().beforeInsert(lines.makeNode(PASS node))
		UNTIL next > size
		
	ELSE IF returnNILforNoFile
		END lines
	ENDIF
FINALLY
	IF exception THEN END lines
	END file, contents, node
ENDPROC

->create a file from a linked-list of e-string lines
->NOTE: Expects a portable path for filePath.
PROC writeLines(filePath:ARRAY OF CHAR, lines:PTR TO cMegaList_STRING) RETURNS success:BOOL
	DEF terminator:ARRAY OF CHAR, termLen, first:BOOL
	DEF file:OWNS PTR TO cFile, cursor:OWNS PTR TO cMegaCursor_STRING, node:STRING
	
	success := FALSE
	
	->choose end of line characters
	terminator := cFile_NewLine
	termLen := StrLen(terminator)
	
	->write lines
	NEW file.new()
	IF file.create(filePath)
		first := TRUE
		IF lines.infoIsEmpty() = FALSE
			cursor := lines.infoStart().clone()
			REPEAT
				IF NOT first THEN file.setPosition(file.write(terminator, termLen)) ; first := FALSE
				node := cursor.read()
				file.setPosition(file.write(node, EstrLen(node)))
			UNTIL cursor.next()
		ENDIF
		
		file.close()
		success := TRUE
	ENDIF
FINALLY
	END file, cursor
ENDPROC
