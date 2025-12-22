/*
Stress-test the read/write cache of cFile.
*/

OPT INLINE, PREPROCESS
->MODULE '*cPath' ->causes PE cache problem
MODULE 'std/cPath', 'std/pShell'

CONST MIN_CHUNKS = 4
CONST MIN_CHUNK_SIZE = SIZEOF LONG * 2
CONST MAX_CHUNK_SIZE = CPATH_FILE_BUFFER_SIZE / MIN_CHUNKS
CONST READ_ONLY   = FALSE	->don't write into file (except for initially filling with random data)
CONST AUTOEXTEND  = FALSE	->auto-extension prevents the file from being auto-filled, which is bad for testing reading, but good for testing auto-extension
CONST DONOTCACHE  = FALSE	->test read()'s doNotCache parameter
CONST PRECACHE    = FALSE	->test readPrecache()
STATIC cachedPath = 'cPath_test_cached'		->'RAM:/cPath_test_cached'
STATIC directPath = 'cPath_test_direct'		->'RAM:/cPath_test_direct'

PROC main()
	DEF seed, quit:BOOL
	DEF direct:OWNS PTR TO cHostFile, cached:OWNS PTR TO cFile
	DEF buffer:OWNS ARRAY OF BYTE, i, fileSize
	DEF filePos :BIGVALUE, chunkSize, read:BOOL, length, offset, phase, bytesAccessed, chunkSizeAtZeroFilePos, temp, loopCount
	DEF filePosD:BIGVALUE, padLostBytesD, bufferD:OWNS ARRAY OF BYTE
	DEF filePosC:BIGVALUE, padLostBytesC, bufferC:OWNS ARRAY OF BYTE
	
	->specify test
	Rnd(seed := -123)
	Print('Setting-up... (Rnd seed=\d)\n', seed)
	
	->create test files
	NEW direct.new()
	NEW cached.new()
	
	DeletePath(directPath)
	DeletePath(cachedPath)
	
	->simulate test to estimate max required file size
	fileSize := 0
	chunkSize := MIN_CHUNK_SIZE
	REPEAT
		fileSize := fileSize + (chunkSize + chunkSize)
		chunkSize := chunkSize * 2
	UNTIL chunkSize > MAX_CHUNK_SIZE
	
	->create test files
	NEW buffer[fileSize]
	FOR i := 0 TO fileSize-1 DO buffer[i] := randByte()
	
	IF direct.create(cachedPath) = FALSE	->create it with cHostFile, so that chunk size is not affected
		Print('Failed to create "\s" because \s in \s.\n', cachedPath, direct.infoFailureReason(), direct.infoFailureOrigin())
		RETURN
	ENDIF
	IF AUTOEXTEND = FALSE THEN direct.write(buffer, fileSize)
	direct.close()
	IF cached.open(cachedPath) = FALSE THEN Throw("FILE", 'Failed to re-open cached file')
	
	IF direct.create(directPath) = FALSE
		Print('Failed to create "\s" because \s in \s.\n', directPath, direct.infoFailureReason(), direct.infoFailureOrigin())
		RETURN
	ENDIF
	IF AUTOEXTEND = FALSE THEN direct.write(buffer, fileSize)
	direct.flush()
	
	->perform tests
	loopCount := 1
	->seed := $9e40ca06		->last test that was run (without autoextension)
	->seed := $c513fc66 ; loopCount := 394		->last test that was run (with autoextension)
	Rnd(seed)
	Print('Started tests (Rnd seed=\d). Press Ctrl-C to stop.\n', seed)
	quit := FALSE
	NEW bufferD[fileSize], bufferC[fileSize]
	chunkSize := infoChunkSize(cached)
	phase := 1
	filePos := 0
	->offset := 0
	bytesAccessed := 0
	REPEAT
		->calculate read/write length & offset (from the current "filePos")
		IF phase = 1
			->length := Rnd(chunkSize*2) + 1
			->offset := Rnd(chunkSize)
			
			->offset := offset + Rnd(chunkSize/2)
			->length := Rnd(Max(1, 2*chunkSize - offset)) + 1
			
			length := Rnd(chunkSize) + 1
			temp := IF AUTOEXTEND = FALSE THEN chunkSize ELSE chunkSize*9/8
			offset := (chunkSize - length) + ((bytesAccessed/temp)*temp)
			bytesAccessed := bytesAccessed + length
			
		ELSE IF phase = 2
			->length := Max(1, (chunkSize-4)/(12))	->needs to be /12 or larger divisor (although in theory anything above /6 should work)
			->offset := offset+Max(8,chunkSize-4)	->NEEDS to be -4 or more negative, but overall jump must not go below 8
			
			length := 1 + Rnd((chunkSize-4)/6)
			->offset := offset + Max(Min(length*8,262144 *0+16), chunkSize-4)
			offset := offset + Max(Min(length*8,Rnd(262144-16)+16), chunkSize-4)
			
			->cFile_DEBUG := TRUE
		ENDIF
		
		->perform read OR write, starting from filePos
		IF length > fileSize THEN Throw("BUG", 'length>fileSize')
		read := (Rnd(256) >= 128)
		IF read OR READ_ONLY
			IF READ_ONLY THEN IF read = FALSE THEN FOR i := 0 TO length-1 DO randByte()		->ensure same behavior if READ_ONLY has been enabled, by calling randByte() same number of times as if had written
			FOR i := 0 TO length-1 DO bufferD[i] := bufferC[i] := -1
			filePosD, padLostBytesD := read(direct, filePos + offset, bufferD, length)
			filePosC, padLostBytesC := read(cached, filePos + offset, bufferC, length)
			
			IF      filePosD <>      filePosC THEN error('read() filePos', filePosD!!VALUE, filePosC!!VALUE)
			IF padLostBytesD <> padLostBytesC THEN error('read() padLostBytes', padLostBytesD, padLostBytesC)
			FOR i := 0 TO length-1
				IF bufferD[i] <> bufferC[i] ; error('read() buffer', bufferD[i], bufferC[i], i) ; #ifdef DEBUG_PROC cached.reportChunk(filePos + offset + i) #else Print('Buffer index \d = File position \d\n', i, filePos + offset + i !!VALUE) #endif ; ENDIF
			ENDFOR IF errors <> 0
		ELSE
			FOR i := 0 TO length-1 DO buffer[i] := randByte()
			filePosD, padLostBytesD := write(direct, filePos + offset, buffer, length)
			filePosC, padLostBytesC := write(cached, filePos + offset, buffer, length)
			
			IF      filePosD <>      filePosC THEN error('write() filePos', filePosD!!VALUE, filePosC!!VALUE)
			IF padLostBytesD <> padLostBytesC THEN error('write() padLostBytes', padLostBytesD, padLostBytesC)
		ENDIF
		IF CtrlC() THEN quit := TRUE
		
		->move filePos & reset some variables, if the chunk size has changed (or have gone past the end of the file)
		IF errors = 0
			IF chunkSize = infoChunkSize(cached)
				->(chunk size is unchanged)
				IF phase = 2
					IF (filePos + offset) > fileSize
						->(phase 2 has gone past end of file) so go back to the start
						IF chunkSizeAtZeroFilePos = chunkSize THEN cached.sleep()
						filePos := 0
						chunkSizeAtZeroFilePos := chunkSize
						offset := 0
					ENDIF
				ENDIF
			ELSE
				->(chunk size has changed)
				chunkSize := infoChunkSize(cached)
				Print('Chunk size now \d, filePos=\d\n', chunkSize, filePos!!VALUE)
				
				IF phase = 1
					IF chunkSize < MAX_CHUNK_SIZE
						filePos := filePos + (2 * chunkSize)
						bytesAccessed := 0
					ELSE
						->(reached max chunk size) so change to phase 2
						phase := 2
						filePos := 0
						chunkSizeAtZeroFilePos := chunkSize
						->bytesAccessed := 0
						cached.sleep()		->get rid of existing cache chunks
						Print('Started phase 2.\n')
					ENDIF
					->offset := 0
					
				ELSE IF phase = 2
					filePos := filePos + offset -> + ???
					offset := 0
					IF filePos > fileSize
						filePos := 0
						chunkSizeAtZeroFilePos := chunkSize
						cached.sleep()		->get rid of existing cache chunks
					ENDIF
					
					IF chunkSize <= MIN_CHUNK_SIZE
						->(reached min chunk size) so change to phase 1
						phase := 1
						filePos := 0
						bytesAccessed := 0
						
						->compare resultant files
						compareFiles(direct, cached)
						IF errors = 0
							Rnd(seed := -Rnd($7FFFFFFF))
							Print('\nRestarting test.  (Rnd seed=$\h, loop count=\d)\n', seed, loopCount++)
						ENDIF
						
						cached.sleep()		->get rid of existing cache chunks
					ENDIF
				ENDIF
				->end of (chunk size has changed)
			ENDIF
		ENDIF
	UNTIL quit OR (errors <> 0)
	
	IF errors
		Print('Errors occured while filePos=\d, length=\d, offset=\d\n', filePos!!VALUE, length, offset)
	ENDIF
	
	Print('Test finished with errors=\d, filePos=\d, chunkSize=\d, actual chunk size=\d, loopCount=\d\n', errors, filePos!!VALUE, chunkSize, infoChunkSize(cached), loopCount)
	
	cached.close()
	direct.close()
	IF errors = 0
		DeletePath(directPath)
		DeletePath(cachedPath)
	ENDIF
	
	Print('Finished.\n')
FINALLY
	PrintException()
	END cached, direct
	END buffer
	END bufferD
	END bufferC
ENDPROC

PROC randByte() IS Rnd(256) - 128 !!BYTE

PROC bigMod(a:BIGVALUE, b) RETURNS c, d:BIGVALUE
	d := a / b
	c := a - (d * b) !!VALUE
ENDPROC


PROC infoChunkSize(self:PTR TO cFile) IS self.queryExtra("CSiz")

DEF errors=0
PROC error(what:ARRAY OF CHAR, valueD, valueC, at=-999)
	errors++
	Print('ERROR: \s mismatch, where \d<>\d', what, valueD, valueC)
	IF at <> -999 THEN Print(' at \d', at)
	Print('\n')
ENDPROC

PROC read(file:PTR TO cHostFile, pos:BIGVALUE, buffer:ARRAY, length)
	DEF padBytes
	file.setPosition(pos)
	IF file.IsOfClassType(TYPEOF cFile) = FALSE
		pos, padBytes := file.read(buffer, length)
	ELSE
		IF PRECACHE THEN file::cFile.readPrecache(length, 0, /*isItemInList*/ FALSE)
		pos, padBytes := file::cFile.read(buffer, length, 0, -1, DONOTCACHE)
	ENDIF
ENDPROC pos, padBytes

PROC write(file:PTR TO cHostFile, pos:BIGVALUE, buffer:ARRAY, length)
	DEF lostBytes
	file.setPosition(pos)
	pos, lostBytes := file.write(buffer, length, 0, NOT AUTOEXTEND)
ENDPROC pos, lostBytes

PROC compareFiles(direct:PTR TO cHostFile, cached:PTR TO cFile)
	DEF i
	DEF sizeD, bufferD:OWNS ARRAY OF BYTE
	DEF sizeC, bufferC:OWNS ARRAY OF BYTE
	
	direct.flush() ; sizeD := direct.getSize() !!VALUE
	cached.flush() ; sizeC := direct.getSize() !!VALUE
	IF sizeC <> sizeD
		error('getFileSize()', sizeD, sizeC)
	ELSE
		NEW bufferD[sizeD] ; read(direct, 0, bufferD, sizeD)
		NEW bufferC[sizeC] ; read(cached, 0, bufferC, sizeC)
		
		FOR i := 0 TO sizeD-1
			IF bufferD[i] <> bufferC[i] THEN error('compare files', bufferD[i], bufferC[i], i)
		ENDFOR IF errors <> 0
	ENDIF
FINALLY
	END bufferD
	END bufferC
ENDPROC
