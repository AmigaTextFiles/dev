/* cPath_DirBase.e 24-02-2017
	Abstract classes & host-independant procedures/methods for portable dir access.


Copyright (c) 2007,2008,2009,2012,2016,2017 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
MODULE 'targetShared/cPath_sharedBase'
MODULE 'target/std/pTime'
MODULE 'CSH/pString'

/*
OPT PREPROCESS, NATIVE	->#work-around#

->#work-around# for 64-bit values not handled correctly by AmiDevCpp GCC for some PPC processors
TYPE BIGVALUE2 IS NATIVE {long} BIGVALUE
#private
#define BIGVALUE BIGVALUE2
#public
*/

PROC new()
	->for makeUniqueName() & makeUniquePath()
	cPath_randomSeed := CurrentTime(/*zone0local1utc2quick*/ 2)!!VALUE
ENDPROC

/*****************************/ ->cBaseDir class is the directory abstract interface
CLASS cBaseDir ABSTRACT OF cPath
ENDCLASS
PROC new() OF cBaseDir IS EMPTY

->closes the current dir & opens the parent dir
PROC openParent(forceOpen=FALSE:BOOL) OF cBaseDir RETURNS success:BOOL
	DEF currentPath:OWNS STRING, parentPath:OWNS STRING
	
	currentPath := ExpandPath(self.getPath())
	parentPath  := ExtractSubPath(currentPath)
	
	self.close()
	success := self.open(parentPath, self.readOnly, forceOpen)
	IF success = FALSE
		IF self.open(currentPath, self.readOnly, TRUE) = FALSE	->forceOpen=TRUE
			Throw("BUG", 'cBaseDir.openParent(); failed to reopen current dir, after failed to open parent')
		ENDIF
	ENDIF
FINALLY
	END currentPath, parentPath
ENDPROC

PROC openChild(relativePath:ARRAY OF CHAR, forceOpen=FALSE:BOOL) OF cBaseDir RETURNS success:BOOL IS EMPTY

PROC makeEntryList() OF cBaseDir RETURNS list:OWNS PTR TO cDirEntryList IS EMPTY


/*****************************/ ->cDirEntryList class
CLASS cDirEntryList PRIVATE
	head:OWNS STRING
	prev   :STRING
	current:STRING
ENDCLASS

->PRIVATE, do not use!
PROC new() OF cDirEntryList
	self.head := NILS
	self.prev    := NILS
	self.current := NILS
ENDPROC

PROC end() OF cDirEntryList
	END self.head
	->  self.prev
	->  self.current
ENDPROC

PROC make() OF cDirEntryList RETURNS object:OWNS PTR TO cDirEntryList
	NEW object
ENDPROC

PROC clone() OF cDirEntryList RETURNS clone:OWNS PTR TO cDirEntryList
	clone := self.make()
	clone.new()
	clone.addList(self)
ENDPROC

->go to first name in list, returning if it exists
->NOTE: For any0file1dir2, supply 1 for the first file name, or 2 for the first dir name.
PROC gotoFirst(any0file1dir2=0) OF cDirEntryList RETURNS exists:BOOL
	DEF match:BOOL
	
	->use check
	IF (any0file1dir2 < 0) OR (any0file1dir2 > 2) THEN Throw("EMU", 'cDirEntryList.gotoFirst(); any0file1dir2 <> 0 or 1 or 2')
	
	self.prev    := NILS
	self.current := self.head
	WHILE exists := (self.current <> NILS)
		SELECT 3 OF any0file1dir2
		CASE 0 ; match := TRUE
		CASE 1 ; match := IsFile(self.current)
		CASE 2 ; match :=  IsDir(self.current)
		ENDSELECT
		IF match = FALSE THEN self.current := Next(self.prev := self.current)
	ENDWHILE IF match
ENDPROC

->go to next name in list, returning if it exists
->NOTE: For any0file1dir2, supply 1 for the next file name, or 2 for the next dir name.
PROC gotoNext(any0file1dir2=0) OF cDirEntryList RETURNS exists:BOOL
	DEF match:BOOL
	
	->use check
	IF (any0file1dir2 < 0) OR (any0file1dir2 > 2) THEN Throw("EMU", 'cDirEntryList.gotoNext(); any0file1dir2 <> 0 or 1 or 2')
	
	self.current := Next(self.prev := self.current)
	WHILE exists := (self.current <> NILS)
		SELECT 3 OF any0file1dir2
		CASE 0 ; match := TRUE
		CASE 1 ; match := IsFile(self.current)
		CASE 2 ; match :=  IsDir(self.current)
		ENDSELECT
		IF match = FALSE THEN self.current := Next(self.prev := self.current)
	ENDWHILE IF match
ENDPROC

->return the current name, or '' if there are no more names
->NOTE: The returned string is valid for the life of the list, unless it is removed.
PROC infoName() OF cDirEntryList RETURNS path:ARRAY OF CHAR IS IF self.current THEN self.current ELSE ''

->find name in list, stopping at it's location, or otherwise returning FALSE
PROC findName(name:ARRAY OF CHAR, fileOrDir=FALSE:BOOL) OF cDirEntryList RETURNS success:BOOL
	DEF nameLen
	
	IF success := (self.head <> NIL)
		IF fileOrDir
			nameLen := StrLen(name) - IF IsDir(name) THEN 1 ELSE 0
		ELSE
			nameLen := ALL
		ENDIF
		
		self.prev    := NILS
		self.current := self.head
		WHILE (success := StrCmpPath(name, self.current, nameLen)) = FALSE
			self.current := Next(self.prev := self.current)
		ENDWHILE IF self.current = NILS
		
		IF fileOrDir AND success
			->verify that match is correct
			IF StrCmpPath(name, self.current) = FALSE
				IF StrLen(self.current) = (nameLen + 1)
					success := self.current[nameLen] = "/"
				ELSE
					success := FALSE
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDPROC

->remove the current path, and move to the next one
PROC remove() OF cDirEntryList RETURNS nextExists:BOOL
	DEF remove:OWNS STRING
	
	IF self.current = NILS THEN Throw("EMU", 'cDirEntryList.remove(); not on a list item')
	
	remove := self.current /*!!OWNS*/
	self.current := Next(self.current)
	
	IF self.prev THEN Link(self.prev, self.current)
	IF self.head = remove THEN self.head := self.current
	
	Link(remove, NILS)
	END remove
	
	nextExists := (self.current <> NILS)
ENDPROC

->add a name to the list, keeping it sorted
->NOTE: If the path already existed, then it is not added, and FALSE is returned.
PROC add(name:ARRAY OF CHAR, toStartOfList=FALSE:BOOL) OF cDirEntryList RETURNS success:BOOL
	DEF copy:OWNS STRING
	
	NEW copy[StrLen(name)]
	StrCopy(copy, name)
	
	success := self.addString(PASS copy, toStartOfList)
FINALLY
	END copy
ENDPROC

->same as add(), but the name is an e-string, which the list will deallocate itself
->NOTE: If toStartOfList=TRUE, then the list is NOT SORTED, which is an illegal state state (except temporarily), and so you MUST call the sort() method when you are finished.
PROC addString(name:OWNS STRING, toStartOfList=FALSE:BOOL) OF cDirEntryList RETURNS success:BOOL
	DEF before:STRING, after:STRING, order
	
	->find sorted insertion point
	before := NILS
	after  := self.head
	IF (after = NIL) OR toStartOfList
		order := 1
	ELSE
		WHILE (order := OstrCmpPath(name, after)) < 0
			before := after
			after  := Next(after)
		ENDWHILE IF after = NILS
		IF after = NILS THEN order := 1
	ENDIF
	
	->perform insertion
	IF success := (order > 0)
		Link(name, after /*!!OWNS*/)
		IF (after = self.current) AND (self.current <> NILS) THEN self.prev := name
		IF before = NILS
			self.head := PASS name
		ELSE
			Link(before, PASS name)
		ENDIF
	ENDIF
FINALLY
	END name
ENDPROC

->add all names in a list, keeping it sorted
->NOTE: Returns the number of duplicate entries which were not added.
PROC addList(list:PTR TO cDirEntryList) OF cDirEntryList RETURNS numOfSameEntries
	DEF name:STRING
	
	numOfSameEntries := 0
	name := list.head
	WHILE name
		IF self.add(name) = FALSE THEN numOfSameEntries++
		name := Next(name)
	ENDWHILE
ENDPROC

->sorts the list, which is only necessary if you have added entries using toStartOfList=TRUE.
->NOTE: The current position in the list will be lost, as if you have gone past the end of the list.
->NOTE: Normally it will return numOfSameEntries, the number of removed duplicates, but you can prevent it doing this using doNotCheckForDuplicates=TRUE.
PROC sort(doNotCheckForDuplicates=FALSE:BOOL) OF cDirEntryList RETURNS numOfSameEntries
	DEF current:STRING, prev:STRING
	
	self.head := mergeSort(PASS self.head, fMergeSort_NoCase)	->case-insensitive sort
	self.prev    := NILS
	self.current := NILS
	
	numOfSameEntries := 0
	IF doNotCheckForDuplicates = FALSE
		prev    := self.head
		current := Next(prev)
		WHILE current
			IF StrCmpPath(self.current, self.prev)
				self.prev    := prev
				self.current := current
				self.remove()
				current := self.current
				numOfSameEntries++
			ELSE
				prev    := current
				current := Next(current)
			ENDIF
		ENDWHILE
		
		self.prev    := NILS
		self.current := NILS
	ENDIF
ENDPROC


PRIVATE
DEF cPath_randomSeed=123
PUBLIC

->creates a file/dir name which does not exist in the list
->NOTE: For file1dir2, supply 1 for a file name, or 2 for a dir name.
->NOTE: If base is not specified then it will default to 'TMP'.
PROC makeUniqueName(file1dir2, base=NILA:ARRAY OF CHAR) OF cDirEntryList RETURNS name:OWNS STRING
	DEF format:ARRAY OF CHAR
	
	->use check
	IF (file1dir2 < 1) OR (file1dir2 > 2) THEN Throw("EMU", 'cDirEntryList.makeUniqueName(); file1dir2 <> 1 or 2')
	
	IF base = NILS THEN base := 'TMP'
	format := IF file1dir2 = 1 THEN '\s\h' ELSE '\s\h/'
	NEW name[StrLen(base) + 8 + 1]
	
	REPEAT
		cPath_randomSeed := RndQ(cPath_randomSeed)
		StringF(name, format, base, cPath_randomSeed)
	UNTIL self.findName(name, TRUE) = FALSE
FINALLY
	IF exception THEN END name
ENDPROC
