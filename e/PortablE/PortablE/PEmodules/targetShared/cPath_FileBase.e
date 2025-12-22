/* cPath_FileBase.e 05-08-20222
	Abstract classes & host-independant procedures/methods for portable file access.


Copyright (c) 2007,2008,2009,2012,2014,2015,2020,2022 Christopher Steven Handley ( http://cshandley.co.uk/email )
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* The source code must not be modified after it has been translated or converted
away from the PortablE programming language.  For clarification, the intention
is that all development of the source code must be done using the PortablE
programming language (as defined by Christopher Steven Handley).

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

->Basically completed 03-01-09, restarted 15-11-08, stopped 10-11-07, started 07-11-07.

OPT POINTER, INLINE
MODULE 'std/pShell'		->for CtrlC()
MODULE 'targetShared/cPath_sharedBase'

/*
OPT PREPROCESS, NATIVE	->#work-around#

->#work-around# for 64-bit values not handled correctly by AmiDevCpp GCC for some PPC processors
TYPE BIGVALUE2 IS NATIVE {long} BIGVALUE
#private
#define BIGVALUE BIGVALUE2
#public
*/

CONST CPATH_FILE_BUFFER_SIZE = 8*1048576	->(8MB) must be a power of 2

PRIVATE
PROC bigMax(a:BIGVALUE, b:BIGVALUE) IS IF a > b THEN a ELSE b
PROC bigMin(a:BIGVALUE, b:BIGVALUE) IS IF a < b THEN a ELSE b
PUBLIC

/*****************************/ ->cBaseFile class is the file abstract interface
CLASS cBaseFile ABSTRACT OF cPath
ENDCLASS
PROC new(padByte=0:BYTE) OF cBaseFile IS EMPTY
PROC open(filePath:ARRAY OF CHAR, readOnly=FALSE:BOOL, forceOpen=FALSE:BOOL, atPastEndNotStart=FALSE:BOOL) OF cBaseFile RETURNS success:BOOL IS EMPTY
PROC create(filePath:ARRAY OF CHAR, doNotReplace=FALSE:BOOL, forceOpen=FALSE:BOOL) OF cBaseFile RETURNS success:BOOL
	success := SUPER self.create(filePath, doNotReplace, forceOpen)
	IF success AND NOT doNotReplace THEN self.setSize(0)
ENDPROC
PROC make() OF cBaseFile RETURNS object:OWNS PTR TO cBaseFile IS EMPTY
PROC infoPadByte() OF cBaseFile RETURNS padByte:BYTE IS EMPTY
PROC write(buffer:ARRAY, lengthInBytes, offsetInBytes=0, noAutoExtend=FALSE:BOOL) OF cBaseFile RETURNS nextPos:BIGVALUE, numOfLostBytes IS EMPTY
PROC read(buffer:ARRAY, lengthInBytes, offsetInBytes=0, toByte=-1:INT) OF cBaseFile RETURNS nextPos:BIGVALUE, numOfPadBytes IS EMPTY
PROC setPosition(pos:BIGVALUE) OF cBaseFile IS EMPTY
PROC getPosition(fromEnd=FALSE:BOOL) OF cBaseFile RETURNS pos:BIGVALUE IS EMPTY
PROC setSize(sizeInBytes:BIGVALUE) OF cBaseFile IS EMPTY
PROC getSize() OF cBaseFile RETURNS sizeInBytes:BIGVALUE IS EMPTY
PROC setTime(time:BIGVALUE) OF cBaseFile RETURNS success:BOOL IS EMPTY
PROC getTime() OF cBaseFile RETURNS time:BIGVALUE IS EMPTY

->creates a precise copy of a file, even for info not supported by the cFile class, returning a file opened in write mode
->NOTE: Will not overwrite an existing file.
PROC makeCopy(path:ARRAY OF CHAR) OF cBaseFile RETURNS copy:OWNS PTR TO cBaseFile
	DEF origPos:BIGVALUE, alreadyExisted:BOOL
	DEF buffer:OWNS ARRAY OF BYTE, bufferSize, readFileSize:BIGVALUE, pos:BIGVALUE, len, numOfPadBytes, bytesLost
	DEF time:BIGVALUE, attr, ftpMountKludge:BOOL
	
	origPos := self.getPosition()
	alreadyExisted := TRUE
	
	->use check
	IF path = NILA THEN Throw("EMU", 'cBaseFile.makeCopy(); path=NILA')
	
	->check if FTP Mount kludge is needed
	ftpMountKludge := StrCmpPath(path, 'FTPMount:/', STRLEN) OR StrCmpPath(path, 'FTP:/', STRLEN)
	
	->run-time check
	IF ftpMountKludge
		alreadyExisted := FALSE
		DeletePath(path)
	ELSE
		IF alreadyExisted := ExistsPath(path)
			self.failureReason := 'destination file already exists'
			->END copy
			RETURN
		ENDIF
	ENDIF
	
	->create file
	copy := self.make()
	copy.new()
	IF copy.open(path, FALSE, /*forceOpen*/ TRUE) = FALSE
		self.failureReason := copy.infoFailureReason()
		END copy
		RETURN
	ENDIF
	self.makeCopy_afterOpen(copy)
	
	->allocate buffer
	readFileSize := self.getSize()
	bufferSize := Max(1, bigMin(CPATH_FILE_BUFFER_SIZE/10, readFileSize)!!VALUE)
	NEW buffer[bufferSize]
	
	->copy file contents (data)
	copy.setSize(readFileSize)
	pos := 0
	WHILE pos < readFileSize
		self.setPosition(pos)
		copy.setPosition(pos)
		
		len := bigMin(bufferSize, readFileSize - pos)!!VALUE
		pos, numOfPadBytes := self.read(buffer, len)	->returned pos is ignored
		IF numOfPadBytes <> 0 THEN Throw("BUG", 'cBaseFile.makeCopy(); numOfPadBytes<>0')
		pos, bytesLost := copy.write(buffer, len /*was: bufferSize - numOfPadBytes*/)
		IF bytesLost <> 0
			self.failureReason := 'incorrect number of bytes written to host file'
			END copy
			RETURN
		ENDIF
		
		IF CtrlC() THEN Throw("BRK", 'Ctrl-C received')
	ENDWHILE
	
	->copy attributes
	attr := self.getAttributes()
	IF copy.setAttributes(attr) = FALSE
		IF ftpMountKludge = FALSE
			self.failureReason := copy.infoFailureReason()
			END copy
			RETURN
		ENDIF
	ENDIF
	
	->copy extra stuff
	IF ftpMountKludge = FALSE		->## move inside if MODE_READWRITE is supported by FTP Mount
		IF copy.setExtra(self) = FALSE
			self.failureReason := copy.infoFailureReason()
			END copy
			RETURN
		ENDIF
	ENDIF
	
	->copy time
	time := self.getTime()
	IF copy.setTime(time) = FALSE
		IF ftpMountKludge = FALSE
			self.failureReason := copy.infoFailureReason()
			END copy
			RETURN
		ENDIF
	ENDIF
	
	->another kludge	->## remove when MODE_READWRITE is supported by FTP Mount
/*	IF ftpMountKludge
		copy.close()
		IF copy.open(path, TRUE, TRUE) = FALSE	->readOnly=TRUE, forceOpen=TRUE
			self.failureReason := copy.infoFailureReason()
			END copy
			RETURN
		ENDIF
	ENDIF
*/	
	->tidy up
	copy.setPosition(origPos)
FINALLY
	END buffer
	self.setPosition(origPos)
	IF copy = NIL
		self.failureOrigin := 'cBaseFile.makeCopy()'
	ENDIF
	
	IF exception THEN END copy
	IF (copy = NIL) AND (alreadyExisted = FALSE) THEN DeletePath(path, TRUE)	->remove partially created file
ENDPROC
->PROTECTED
PROC makeCopy_afterOpen(copy:PTR TO cBaseFile) OF cBaseFile IS EMPTY
->PUBLIC

->return clone of current object, with same file open, but in read-only mode unless writeNotRead=TRUE
->NOTE: Will return clone=NIL if there is a problem.
PROC clone(writeNotRead=FALSE:BOOL) OF cBaseFile RETURNS clone:OWNS PTR TO cBaseFile
	->use check
	IF self.infoIsOpen() = FALSE THEN Throw("EMU", 'cBaseFile.clone(); file not open')
	
	clone := self.make()
	clone.new(self.infoPadByte())
	IF (self.infoReadOnly() = FALSE) AND (writeNotRead = TRUE)
		->(opening two files in write mode) which is not allowed, so fail without trying
		END clone
		
	ELSE IF clone.open(self.getPath(), NOT writeNotRead) = FALSE
		->(failed to open file)
		END clone
	ELSE
		->duplicate r/w position
		clone.setPosition(self.getPosition())
	ENDIF
ENDPROC
