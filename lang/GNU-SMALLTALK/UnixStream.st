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
| sbb	     23 Feb 92	  Also added readShort and friends.
|
| sbb	     23 Feb 92	  Added direction constants
|
| sbb	     17 Nov 90	  added read:numBytes:
|
| sbb	     17 Nov 90	  Added skip: method.
|
| sbb	     17 Nov 90	  Installed as a built-in class.
|
"

PositionableStream subclass: #UnixStream
		   instanceVariableNames: 'fd'
		   classVariableNames: ''
		   poolDictionaries: ''
		   category: 'Unix integration'
!
    
UnixStream comment:
'I provide an interface to Unix file descriptors, so that Smalltalk methods
may perform most of the I/O operations that C programs can.  I am quite proud
of my contribution to the GNU Smalltalk project, and look forward to serving
the project better in the future.'
!


Behavior defineCFunc: 'open'
         withSelectorArgs: 'open: aFileName flags: flagsInteger 
			    mode: anInteger'
	 forClass: UnixStream
	 returning: #int
	 args: #(string int int)
!

Behavior defineCFunc: 'close'
	 withSelectorArgs: 'close: fileDescriptor'
	 forClass: UnixStream
	 returning: #int
	 args: #(int)
!

Behavior defineCFunc: 'read'
	 withSelectorArgs: 'read: fileDescriptor into: buf bytes: anInteger'
	 forClass: UnixStream
	 returning: #int
	 args: #(int byteArrayOut int)
!

Behavior defineCFunc: 'read'
	 withSelectorArgs: 'read: fileDescriptor into: buf chars: anInteger'
	 forClass: UnixStream
	 returning: #int
	 args: #(int stringOut int)
!

Behavior defineCFunc: 'write'
	 withSelectorArgs: 'write: fileDescriptor from: buf bytes: anInteger'
	 forClass: UnixStream
	 returning: #int
	 args: #(int byteArray int)
!

Behavior defineCFunc: 'ioctl'
	 withSelectorArgs: 'ioctl: fileDescriptor request: anInteger 
			    arg: cObject'
	 forClass: UnixStream
	 returning: #int
	 args: #(int cObject unknown)
!

Behavior defineCFunc: 'lseek'
	 withSelectorArgs: 'lseek: fileDescriptor offset: anInteger 
			    whence: cObject'
	 forClass: UnixStream
	 returning: #int
	 args: #(int int int)
!

Behavior defineCFunc: 'tell'
	 withSelectorArgs: 'tell: fileDescriptor'
	 forClass: UnixStream
	 returning: #int
	 args: #(int)
!

"======================================================================
|
|   Type specific I/O routines
|
 ======================================================================"

Behavior defineCFunc: 'readChar'
	 withSelectorArgs: 'readChar: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!

Behavior defineCFunc: 'readUChar'
	 withSelectorArgs: 'readUChar: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!

Behavior defineCFunc: 'readShort'
	 withSelectorArgs: 'readShort: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!

Behavior defineCFunc: 'readUShort'
	 withSelectorArgs: 'readUShort: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!

Behavior defineCFunc: 'readLong'
	 withSelectorArgs: 'readLong: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!

Behavior defineCFunc: 'readULong'
	 withSelectorArgs: 'readULong: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!

Behavior defineCFunc: 'readFloat'
	 withSelectorArgs: 'readFloat: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!

Behavior defineCFunc: 'readDouble'
	 withSelectorArgs: 'readDouble: fileDescriptor'
	 forClass: UnixStream
	 returning: #smalltalk
	 args: #(int)
!


Behavior defineCFunc: 'writeChar: aChar'
	 withSelectorArgs: 'write: fileDescriptor char: aChar'
	 forClass: UnixStream
	 returning: #void
	 args: #(int char)
!

Behavior defineCFunc: 'writeShort: aShort'
	 withSelectorArgs: 'write: fileDescriptor short: aShort'
	 forClass: UnixStream
	 returning: #void
	 args: #(int int)
!

Behavior defineCFunc: 'writeLong: aLong'
	 withSelectorArgs: 'write: fileDescriptor long: aLong'
	 forClass: UnixStream
	 returning: #void
	 args: #(int long)
!

Behavior defineCFunc: 'writeFloat: aFloat'
	 withSelectorArgs: 'write: fileDescriptor float: aFloat'
	 forClass: UnixStream
	 returning: #void
	 args: #(int double)
!

Behavior defineCFunc: 'writeDouble: aDouble'
	 withSelectorArgs: 'write: fileDescriptor double: aDouble'
	 forClass: UnixStream
	 returning: #void
	 args: #(int double)
!





!UnixStream class methodsFor: 'instance creation'!

open: fileName dir: anInteger
    ^self open: fileName dir: anInteger mode: 0
!

open: fileName dir: anInteger mode: intMode
    ^self new init: fileName dir: anInteger mode: intMode
!

on: fd
    ^self new initFd: fd
!!



!UnixStream class methodsFor: 'constants'!

readOnly
    ^0
!

writeOnly
    ^1
!

readWrite
    ^2
!

"Other modifiers (like O_APPEND) may be added in the future as needs warrant"
!



!UnixStream methodsFor: 'basic accessing'!

close
    ^self close: fd
!

read: byteArray
    | val |
    ^self read: fd into: byteArray bytes: byteArray size
!

read: byteArray numBytes: anInteger
    | val |
    ^self read: fd into: byteArray bytes: anInteger
!

read: string numChars: anInteger
    ^self read: fd into: string chars: anInteger
!

write: byteArray
    ^self write: byteArray numBytes: byteArray size
!

write: byteArray numBytes: anInteger
    ^self write: fd from: byteArray bytes: anInteger
!

tell
    ^self tell: fd
!

position: anInteger
    ^self lseek: fd offset: anInteger whence: 0 "Set"
!

ioctl: number arg: randomArg
    ^self ioctl: fd request: number arg: randomArg
!

readChar
    ^self readChar: fd
!

readUChar
    ^self readUChar: fd
!

readShort
    ^self readShort: fd
!

readUShort
    ^self readUShort: fd
!

readLong
    ^self readLong: fd
!

readULong
    ^self readULong: fd
!

readFloat
    ^self readFloat: fd
!

readDouble
    ^self readDouble: fd
!

writeChar: aChar
    ^self write: fd char: aChar
!

writeShort: aShort		"really an integer"
    ^self write: fd short: aShort
!

writeLong: aLong
    ^self write: fd long: aLong
!

writeFloat: aFloat
    ^self write: fd float: aFloat
!

writeDouble: aDouble
    ^self write: fd double: aDouble
! !



!UnixStream methodsFor: 'accessing'!

readString: numChars
    | byteArray numRead str |
    byteArray _ ByteArray new: numChars.
    (numRead _ self read: byteArray) <= 0 "failed for some reason"
	ifTrue: [ ^nil ].
    str _ String new: numRead.
    1 to: numRead do:
	[ :i | str at: i
		   put: (Character value: (byteArray at: i)) ].
    ^str
!

next
    self notYetImplemented
!

next: anInteger
    self self notYetImplemented
!


nextPut: aValue
    self notYetImplemented
!

contents
    self notYetImplemented
!

atEnd
    self notYetImplemented
!

size
    "Poor man's size function"
    | curPos size |
    curPos _ self tell.
    self lseek: fd offset: 0 whence: 2. "To end"
    size _ self tell.
    self position: curPos.
    ^size
!

skip: anInteger
    "Skip n bytes on the file.  N can be positive or negative"
    ^self lseek: fd offset: anInteger whence: 1 "Cur"
!!



!UnixStream methodsFor: 'private'!

init: fileName dir: anInteger mode: intMode
    fd _ self open: fileName flags: anInteger mode: intMode.
    fd < 0
	ifTrue: [ ^nil ]
!

initFd: anFd
    fd _ anFd
!!

