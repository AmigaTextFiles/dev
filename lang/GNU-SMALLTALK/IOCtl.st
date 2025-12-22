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
| sbb	     16 Feb 92	  created summer 90.
|
"

CObject variableWordSubclass: #IOCtl
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C interface hacking'
!

IOCtl comment:
'I am a gross hack.  I exist because there is no LargeInteger support
currently in GNU Smalltalk, and certain IO operations need to perform
IOCtls.  I fully expect to be removed in the forseeable future'!

!IOCtl class methodsFor: 'instance creation'!

new
    ^self new: 1		"leave room for the pointer"
!

voidType: typeChar index: intIndex
    ^self new init: 16r20 type: typeChar index: intIndex size: 0
!

readType: typeChar index: intIndex struct: cStruct
    ^self readType: typeChar index: intIndex size: cStruct sizeof
!

readType: typeChar index: intIndex size: nBytes
    ^self new init: 16r40 type: typeChar index: intIndex size: nBytes
!
    
writeType: typeChar index: intIndex struct: cStruct
    ^self writeType: typeChar index: intIndex size: cStruct sizeof
!

writeType: typeChar index: intIndex size: nBytes
    ^self new init: 16r80 type: typeChar index: intIndex size: nBytes
!

readWriteType: typeChar index: intIndex struct: cStruct
    ^self readWriteType: typeChar index: intIndex size: cStruct sizeof
!

readWriteType: typeChar index: intIndex size: nBytes
    ^self new init: 16rC0 type: typeChar index: intIndex size: nBytes
!!


!IOCtl methodsFor: 'private'!

init: magic type: typeChar index: intIndex size: nBytes
    | lowBits highBits addr |
    lowBits _ intIndex bitOr: ((typeChar asciiValue) bitShift: 8).
    highBits _ (magic bitShift: 8) bitOr: (nBytes bitAnd: 16rFF).
    " compute the address of where the pointer that the CObject contains
      lives."
    addr _ (Memory addressOf: self) + 8.
    Bigendian
	ifTrue: [ ByteMemory at: addr + 0 put: (highBits bitShift: -8).
		  ByteMemory at: addr + 1 put: (highBits bitAnd: 16rFF).
		  ByteMemory at: addr + 2 put: (lowBits bitShift: -8).
		  ByteMemory at: addr + 3 put: (lowBits bitAnd: 16rFF) ]
	ifFalse: [ ByteMemory at: addr + 3 put: (highBits bitShift: -8).
		  ByteMemory at: addr + 2 put: (highBits bitAnd: 16rFF).
		  ByteMemory at: addr + 1 put: (lowBits bitShift: -8).
		  ByteMemory at: addr + 0 put: (lowBits bitAnd: 16rFF) ]
! !


