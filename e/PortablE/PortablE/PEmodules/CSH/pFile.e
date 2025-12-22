/* pFile.e 10-11-2014
	A collection of useful file procedures.
	Copyright (c) 2010,2011,2012,2013,2014 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
MODULE 'std/cPath_File'

/*****************************/

->returns file contents as a linked-list of e-string lines
->NOTE: Expects a portable path for filePath.
->NOTE: Returns NILS if file does not exist.
PROC readLines(filePath:ARRAY OF CHAR) RETURNS lines:OWNS STRING, tail:STRING
	DEF file:OWNS PTR TO cHostFile, size, contents:OWNS STRING
	DEF next, len, start, node:OWNS STRING, temp:STRING
	
	lines := NILS
	tail  := NILS
	
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
			IF tail = NILS
				tail := node
				lines := PASS node
			ELSE
				temp := node
				Link(tail, PASS node)
				tail := temp
			ENDIF
		UNTIL next > size
	ENDIF
FINALLY
	IF exception THEN END lines
	END file, contents, node
ENDPROC

->create a file from a linked-list of e-string lines
->NOTE: Expects a portable path for filePath.
->NOTE: If lines = NILS then no file will be created (and any existing one will be deleted).
PROC writeLines(filePath:ARRAY OF CHAR, lines:NULL STRING) RETURNS success:BOOL
	DEF terminator:ARRAY OF CHAR, termLen
	DEF file:OWNS PTR TO cFile, node:STRING, next:STRING
	
	success := FALSE
	
	->choose end of line characters
	terminator := cFile_NewLine
	termLen := StrLen(terminator)
	
	->write lines
	NEW file.new()
	IF lines
		IF file.create(filePath)
			node := lines
			WHILE node
				next := Next(node)
				
				file.setPosition(file.write(node, EstrLen(node)))
				IF next THEN file.setPosition(file.write(terminator, termLen))
				
				node := next
			ENDWHILE
			
			file.close()
			success := TRUE
		ENDIF
	ENDIF
FINALLY
	END file
ENDPROC
