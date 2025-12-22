/* std/cPath_FileMeta.e 01-08-2020
	Meta-data write-back caching class layer for portable file access.


Copyright (c) 2007,2008,2009,2010,2011,2012,2013,2014,2015,2020 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
->Rewrite basically finished 28-03-14, started 04-03-14.
->Separated meta-data caching from data-content caching 01-08-2020.

OPT INLINE
MODULE 'target/std/pTime'
PUBLIC MODULE 'target/std/cPath_File'
MODULE 'target/std/cPath_shared'

PRIVATE
CONST DEBUG = FALSE

PUBLIC

/*****************************/
PRIVATE
SET CACHEDIRTY_ATTR, CACHEDIRTY_TIME, CACHEDIRTY_EXTRA
SET SUPPORTS_SETTIME, SUPPORTS_SETATTR, SUPPORTS_SETEXTRA_FULLY

DEF fileDiskSupports:BYTE, fileDiskName:OWNS STRING
PUBLIC

PROC new()
	fileDiskSupports := 0
	fileDiskName := NILS
ENDPROC

PROC end()
	END fileDiskName
ENDPROC

CLASS cFileMeta OF cHostFile
	cacheAttr
	cacheTime:BIGVALUE
	cacheExtra:OWNS PTR TO cHostExtra
	cacheExtraValid:BOOL		->only TRUE after open() has finished setting cacheExtra
	cacheDirty:BYTE				->flags indicating which elements need flushing
	
	diskSupports:BYTE			->which elements are supported by the current device
	diskName:OWNS STRING		->name of the device
ENDCLASS

PROC new(padByte=0:BYTE) OF cFileMeta
	SUPER self.new(padByte)
	NEW self.cacheExtra.new()
	
	self.diskSupports := 0
	self.diskName := NILS
ENDPROC

PROC end() OF cFileMeta
	SUPER self.end()	->this should automatically close() the file if it is open
	END self.cacheExtra
	
	END self.diskName
ENDPROC

PROC open(filePath:ARRAY OF CHAR, readOnly=FALSE:BOOL, forceOpen=FALSE:BOOL, atPastEndNotStart=FALSE:BOOL) OF cFileMeta RETURNS success:BOOL
	IF success := SUPER self.open(filePath, readOnly, forceOpen, atPastEndNotStart)
		->cache file's state
		self.cacheAttr := SUPER self.getAttributes()
		self.cacheTime := SUPER self.getTime()
		self.cacheExtraValid := FALSE
		self.cacheExtra.setExtra(self)
		self.cacheExtraValid := TRUE
		self.cacheDirty := 0
		
		self.evaluateDisk(filePath, readOnly)
	ENDIF
ENDPROC

PROC close() OF cFileMeta
	IF self.readOnly = FALSE
		IF self.cacheExtra.queryExtra("LINK") = NILA THEN self.setTime(self.getTime())	->force file's time to be correctly set by final flush
		self.flush()
	ENDIF
	
	SUPER self.close()
ENDPROC

PRIVATE
PROC evaluateDisk(path:ARRAY OF CHAR, readOnly:BOOL) OF cFileMeta
	DEF openDiskName:OWNS STRING, expandedPath:OWNS STRING, success:BOOL, unknown:BOOL
	
	expandedPath := ExpandPath(path)
	openDiskName := ExtractDevice(expandedPath)
	IF EstrLen(openDiskName) = 0
		END openDiskName
		openDiskName := NEW ':/'
	ENDIF
	
	IF StrCmpPath(openDiskName, IF self.diskName THEN self.diskName ELSE '')
		->(already evaluated disk) so do nothing, thus reusing disk evaluation
		
	ELSE IF StrCmpPath(openDiskName, IF fileDiskName THEN fileDiskName ELSE '')
		->(global cache holds disk evaluation) so use it
		END self.diskName
		self.diskName := StrJoin(fileDiskName)
		self.diskSupports := fileDiskSupports
		
	ELSE IF readOnly
		->(disk evaluation not cached) but read-only, so only store basic evaluation (which will not be re-used)
		END self.diskName
		self.diskName := PASS openDiskName
		
		self.diskSupports := 0
		END self.diskName	->destroy this so incomplete diskSupports will not be reused
	ELSE
		->(disk evaluation not cached) so evaluate & store it
		END self.diskName
		self.diskName := PASS openDiskName
		
		self.diskSupports := 0
		IF SUPER self.setAttributes(self.cacheAttr) THEN self.diskSupports := self.diskSupports OR SUPPORTS_SETATTR
		IF SUPER self.setTime(self.cacheTime)       THEN self.diskSupports := self.diskSupports OR SUPPORTS_SETTIME
		
		success, unknown := SUPER self.changeExtra("COMM", 'anything')	->work-around SMBFS issue (setting the same (empty?) comment doesn't seem to fail)
		IF success OR unknown
			self.cacheExtraValid := FALSE
			IF SUPER self.setExtra(self.cacheExtra) THEN self.diskSupports := self.diskSupports OR SUPPORTS_SETEXTRA_FULLY
			self.cacheExtraValid := TRUE
		ENDIF
		
		->also store in global cache
		END fileDiskName
		fileDiskName := StrJoin(self.diskName)
		fileDiskSupports := self.diskSupports
		
		IF DEBUG
			IF self.diskSupports AND SUPPORTS_SETATTR        THEN Print('Disk "\s" supports setAttributes()\n', self.diskName)
			IF self.diskSupports AND SUPPORTS_SETTIME        THEN Print('Disk "\s" supports setTime()\n', self.diskName)
			IF self.diskSupports AND SUPPORTS_SETEXTRA_FULLY THEN Print('Disk "\s" supports setExtra()\n', self.diskName)
		ENDIF
	ENDIF
FINALLY
	END openDiskName, expandedPath
ENDPROC
PUBLIC

PROC flush() OF cFileMeta
	DEF success:BOOL, temp:BOOL
	
	IF self.readOnly = FALSE
		success := TRUE
		IF self.cacheDirty AND CACHEDIRTY_EXTRA
			->(user has previously used setExtra()) so need to flush it
			self.cacheExtraValid := FALSE
			IF self.diskSupports AND SUPPORTS_SETEXTRA_FULLY
				success := success AND (temp := SUPER self.setExtra(self.cacheExtra))
				IF DEBUG THEN IF temp = FALSE THEN Print('flush() FAILED to setExtra() because "\s"; support=\d, file="\s"\n', self.infoFailureReason(), self.diskSupports AND SUPPORTS_SETEXTRA_FULLY, self.getPath() /*leak*/)
			ELSE
				IF SUPER self.setExtra(self.cacheExtra) = FALSE THEN self.cacheExtra.setExtra(self)		->update cache since didn't fully set everything
			ENDIF
			self.cacheExtraValid := TRUE
		ENDIF
		IF self.cacheDirty AND CACHEDIRTY_ATTR
			IF self.diskSupports AND SUPPORTS_SETATTR
				success := success AND (temp := SUPER self.setAttributes(self.cacheAttr))	->Attr will only be dirty if disk supports it
				IF DEBUG THEN IF temp = FALSE THEN Print('flush() FAILED to setAttributes() because "\s"; support=\d, file="\s"\n', self.infoFailureReason(), self.diskSupports AND SUPPORTS_SETATTR, self.getPath() /*leak*/)
			ENDIF
		ENDIF
		IF self.cacheDirty AND CACHEDIRTY_TIME
			IF self.diskSupports AND SUPPORTS_SETTIME
				success := success AND (temp := SUPER self.setTime(self.cacheTime))		->ditto for Time	->do Time last to ensure it does not get changed
				IF DEBUG THEN IF temp = FALSE THEN Print('flush() FAILED to setTime() because "\s"; support=\d, file="\s"\n', self.infoFailureReason(), self.diskSupports AND SUPPORTS_SETTIME, self.getPath() /*leak*/)
			ENDIF
		ENDIF
		self.cacheDirty := 0
		IF DEBUG THEN success := TRUE
		IF success = FALSE THEN Throw("FILE", 'cFile.flush(); failed to set one of more of: time, attributes & extra')
	ENDIF
	
	SUPER self.flush()
	
	self.cacheAttr := SUPER self.getAttributes()
	self.cacheTime := SUPER self.getTime()
	self.cacheExtraValid := FALSE
	self.cacheExtra.setExtra(self)
	self.cacheExtraValid := TRUE
ENDPROC

PROC setAttributes(attr, mask=-1) OF cFileMeta RETURNS success:BOOL
	DEF newAttr
	
	->use check
	IF self.readOnly THEN Throw("EMU", 'cFile.setAttributes(); file opened in read only mode')
	
	IF self.diskSupports AND SUPPORTS_SETATTR
		->calculate new attributes
		mask := mask AND self.getAttributesSupported()
		attr := attr AND mask		->clear any bits that the mask excludes (mistakes?)
		
		newAttr := self.cacheAttr
		newAttr := newAttr AND NOT mask		->clear any bits that will be changed; i.e. only copy bits that are not changing
		newAttr := newAttr OR attr			->add changed bits
		
		->store new attributes
		self.cacheAttr := newAttr
		self.cacheDirty := self.cacheDirty OR CACHEDIRTY_ATTR
		success := TRUE
	ELSE
		success := FALSE
		self.failureReason := 'not supported by disk'
		self.failureOrigin := 'cFile.setAttributes()'
	ENDIF
ENDPROC

PROC getAttributes() OF cFileMeta RETURNS attr IS self.cacheAttr


PROC setExtra(extra:PTR TO cExtra) OF cFileMeta RETURNS success:BOOL
	success := self.cacheExtra.setExtra(extra)
	self.cacheDirty := self.cacheDirty OR CACHEDIRTY_EXTRA
	
	IF success = FALSE
		self.failureReason := 'not supported by host'
		self.failureOrigin := 'cFile.setExtra()'
	ENDIF
ENDPROC

PROC getExtra() OF cFileMeta RETURNS extra:OWNS PTR TO cExtra IS self.cacheExtra.getExtra()

PROC changeExtra(specific:QUAD, value) OF cFileMeta RETURNS success:BOOL, unknown:BOOL
	IF self.cacheExtraValid = FALSE
		->(self.cacheExtra should not be used) so pass query to super class
		success, unknown := SUPER self.changeExtra(specific, value)
	ELSE
		IF (specific = "SLNK") OR (specific = "HLNK") THEN self.flush()		->a link may be created or destroyed, so ensure all pending changes are flushed first
		
		success, unknown := self.cacheExtra.changeExtra(specific, value)
		self.cacheDirty := self.cacheDirty OR CACHEDIRTY_EXTRA
		
		IF (specific = "SLNK") OR (specific = "HLNK") THEN self.flush()		->ensure any link change is performed immediately, and the cache knows about any changes
		
		IF success = FALSE
			self.failureReason := 'not supported by host'
			self.failureOrigin := 'cFile.changeExtra()'
		ENDIF
	ENDIF
ENDPROC

PROC queryExtra(specific:QUAD) OF cFileMeta RETURNS value, unknown:BOOL
	IF self.cacheExtraValid = FALSE
		->(open() has not yet set-up self.cacheExtra) so pass query to super class
		value, unknown := SUPER self.queryExtra(specific)
	ELSE
		value, unknown := self.cacheExtra.queryExtra(specific)
	ENDIF
ENDPROC

PROC setTime(time:BIGVALUE) OF cFileMeta RETURNS success:BOOL
	->use check
	IF self.readOnly THEN Throw("EMU", 'cFile.setTime(); file opened in read only mode')
	
	IF self.diskSupports AND SUPPORTS_SETTIME
		self.cacheTime := time
		self.cacheDirty := self.cacheDirty OR CACHEDIRTY_TIME
		success := TRUE
	ELSE
		success := FALSE
		self.failureReason := 'not supported by disk'
		self.failureOrigin := 'cFile.setTime()'
	ENDIF
ENDPROC

PROC getTime() OF cFileMeta RETURNS time:BIGVALUE IS self.cacheTime
