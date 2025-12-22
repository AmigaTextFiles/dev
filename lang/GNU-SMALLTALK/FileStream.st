"======================================================================
|
|   FileStream Method Definitions
|
 ======================================================================"


"======================================================================
|
| Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
| Written by Steve Byrne.
|
| This file is part of GNU Smalltalk.
|
| GNU Smalltalk is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 1, or (at your option) any later version.
| 
| GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
| Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
|
 ======================================================================"


"
|     Change Log
| ============================================================================
| Author       Date       Change 
| sbb	     22 Sep 91	  Added #popen:dir:ifFail: and #open:mode:ifFail: so
|			  that open failures can be explicitly handled.  Thanks
|			  to Michael Richardson for the brilliant idea!
|
| sbb	      5 Jul 91	  Added fileIn:line:from:at: so that when Emacs sends
|			  out an expression or a method definition to Smalltalk
|			  the error messages accurately report the line number.
|
| sbb	      6 Jun 91	  Fixed open and popen to use self new instead of
|			  FileStream explicitly.
|
| sbb	      4 Mar 91	  Added verbose flag.
|
| sbyrne     19 May 90	  Rewrite contents to take advantage of the new
|			  FileStream>>size method.
|
| sbyrne     19 Dec 89	  added fileIn: and primitive file in.
|
| sbyrne     21 May 89	  created.
|
"

ReadWriteStream subclass: #FileStream
		instanceVariableNames: 'file name buffer'
		classVariableNames: 'verbose'
		poolDictionaries: ''
		category: nil
!

FileStream comment: 
'My instances are what conventional programmers think of as files.
My instance creation methods accept the name of a disk file (or any named
file object, such as /dev/rmt0 on UNIX or MTA0: on VMS).'
!


!FileStream class methodsFor: 'basic'!

open: fileName mode: fileMode
    ^self open: fileName mode: fileMode 
	  ifFail: [ ^self error: 'Failed to open ''', fileName, '''' ]
!

open: fileName mode: fileMode ifFail: aBlock
    | file |
    file _ self new.
    "Does it make sense to have the block be invoked with the file name as 
     an argument?"
    (file fileOp: 0 with: fileName with: fileMode)
	isNil ifTrue: [ ^aBlock value ].
    ^file
!

popen: commandName dir: direction
    ^self popen: commandName dir: direction
	  ifFail: [ ^self error: 'popen failed for command ''',
			commandName, '''' ]
!

popen: commandName dir: direction ifFail: aBlock
    | file |
    file _ self new.
    (file fileOp: 7 with: commandName with: direction)
	isNil ifTrue: [ ^aBlock value ].
    ^file
!

fileIn: aFileName
    | fileStream |
    verbose ifTrue: [ stdout nextPutAll: 'Loading ';
			  nextPutAll: aFileName; nl ].
    fileStream _ self open: aFileName mode: 'r'.
    fileStream fileIn.
    fileStream close.
!

fileIn: aFileName line: lineInteger from: realFileName at: aCharPos
    | fileStream |
    verbose ifTrue: [ stdout nextPutAll: 'Loading ';
			  nextPutAll: aFileName; nl ].
    fileStream _ self open: aFileName mode: 'r'.
    fileStream fileInLine: lineInteger fileName: realFileName at: aCharPos.
    fileStream close.
!

verbose: verboseFlag
    | oldVerbose |
    oldVerbose _ verbose.
    verbose _ verboseFlag.
    ^oldVerbose
!

require: aSymbol
    "If there is a class defined with the name 'aSymbol', do nothing, otherwise
     fileIn 'aSymbol'.st"
    Smalltalk at: aSymbol
	      ifAbsent:
		  [ self fileIn: aSymbol , '.st' ]
! !



!FileStream class methodsFor: 'initialization'!

initialize
    verbose _ false.
! !



!FileStream methodsFor: 'basic'!

close
    self fileOp: 1
!

next
    | ch |
    "Returns nil at eof"
    buffer isNil
	ifTrue: [ ^self fileOp: 2 ]
	ifFalse: [ ch _ buffer.
		   buffer _ nil.
		   ^ch ]
!

nextPut: aChar
    self fileOp: 3 with: aChar
!

peek
    buffer
	isNil ifTrue: [ buffer _ self next ].
    ^buffer
!

position: bytePosition
    self fileOp: 4 with: bytePosition
! 

position
    ^self fileOp: 5
!

contents
    ^self next: self size
!

size
    "Return the current size of the file, in bytes"
    ^self fileOp: 8

!!



!FileStream methodsFor: 'overriding inherited methods'!

reset
    self position: 0
!

setToEnd
    self position: self size
!

skip: anInteger
    | pos |
    pos _ ((self position + anInteger) max: 0) min: self size - 1.
    self position: pos
!

reverseContents
    ^(ReadStream on: self contents) reverseContents
!

isEmpty
    ^self size == 0
!

nextPutAll: aString		"only works for strings (species String)"
    ^self fileOp: 9 with: aString
!

next: anInteger
    "return the next 'anInteger' characters from the stream, as a String."
    ^self fileOp: 10 with: anInteger
!!



!FileStream methodsFor: 'testing'!

atEnd
    ^self fileOp: 6

!!

FileStream initialize!
