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

!CObject methodsFor: 'inspection'!

inspect
    ^self value printNl
!!


" ### Should keep scalar types from doing at: -- rehack to be basicAt:
 and remove at: from class CScalar"

CObject variableWordSubclass: #CLong
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CLong class methodsFor: 'accessing'!

sizeof
    ^4
!

alignof
    ^4
!!
    
!CLong methodsFor: 'accessing'!

value
    ^super at: 0 type: 4		"should be symbolic, but I want SPEED!"
!

value: aValue
    super at: 0 put: aValue type: 4
!

sizeof
    ^4
!

alignof
    ^4
!!


CObject variableWordSubclass: #CULong
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CULong class methodsFor: 'accessing'!

sizeof
    ^4
!

alignof
    ^4
!!
    


!CULong methodsFor: 'accessing'!

value
    ^self at: 0 type: 5		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 5
!

sizeof
    ^4
!

alignof
    ^4
!!


CObject variableWordSubclass: #CShort
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CShort class methodsFor: 'accessing'!

sizeof
    ^2
!

alignof
    ^2
!!
    


!CShort methodsFor: 'accessing'!

value
    ^self at: 0 type: 2		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 2
!

sizeof
    ^2
!

alignof
    ^2
!!


CObject variableWordSubclass: #CUShort
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CUShort class methodsFor: 'accessing'!

sizeof
    ^2
!

alignof
    ^2
!!
    
!CUShort methodsFor: 'accessing'!

value
    ^self at: 0 type: 3		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 3
!

sizeof
    ^2
!

alignof
    ^2
!!



CObject variableWordSubclass: #CChar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CChar class methodsFor: 'accessing'!

sizeof
    ^1
!

alignof
    ^1
!!
    
!CChar methodsFor: 'accessing'!

value
    ^self at: 0 type: 0		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 0
!

sizeof
    ^1
!

alignof
    ^1
!!




CObject variableWordSubclass: #CUChar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CUChar class methodsFor: 'getting info'!

sizeof
    ^1
!

alignof
    ^1
!!

!CUChar methodsFor: 'accessing'!

value
    ^self at: 0 type: 1		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 1
!

sizeof
    ^1
!

alignof
    ^1
!!



CObject variableWordSubclass: #CFloat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CFloat class methodsFor: 'accessing'!

sizeof
    ^4
!

alignof
    ^4
!!
    
!CFloat methodsFor: 'accessing'!

value
    ^self at: 0 type: 6		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 6
!

sizeof
    ^4
!

alignof
    ^4
!!



CObject variableWordSubclass: #CDouble
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CDouble class methodsFor: 'accessing'!

sizeof
    ^8
!

alignof
    ^8				"### should ask system"
!!
    
!CDouble methodsFor: 'accessing'!

value
    ^self at: 0 type: 7		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 7
!

sizeof
    ^8
!

alignof
    ^8
!!


CObject variableWordSubclass: #CString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CString class methodsFor: 'getting info'!

sizeof
    ^4
!

alignof
    ^4
!!

!CString methodsFor: 'accessing'!

value
    ^self at: 0 type: 8		"should be symbolic, but I want SPEED!"
!

value: aValue
    self at: 0 put: aValue type: 8
!

sizeof
    ^4
!

alignof
    ^4
!!




CObject variableWordSubclass: #CArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!

!CArray methodsFor: 'accessing'!

at: anIndex
    | type |
"'in carray' printNl."
    type _ self type.
"'type is ' print. type inspect.
'index is ' print. anIndex printNl.
'subtype is ' print. type subType printNl.
'sizeof says ' print. type subType sizeof printNl."
    ^self at: (anIndex * type subType sizeof) type: type subType
"??? use baseType to hold component type info?"
!

at: anIndex put: aValue
    " ### Is this the right implementation?"
    ^self at: 0 type: self type subType
!

sizeof
    | type |
    type _ self type.
    ^type numElements * type subType sizeof
!

alignof
    ^self type subType alignof
!

inspect
    | type |
    type _ self type.
    stdout nextPutAll: '['; nl.
    1 to: type numElements do: 
	[ :i | stdout nextPutAll: '    '.
	       self at: i inspect ].
    stdout nextPutAll: ']'; nl
!!

CObject variableWordSubclass: #CPtr
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'C variable access'!


!CPtr class methodsFor: 'accessing'!

sizeof
    ^4
!

alignof
    ^4
! !



!CPtr methodsFor: 'accessing'!

deref
    ^self value
!

at: anIndex
    | type |
    type _ self type.
    ^self at: (anIndex * type subType sizeof) type: 9
!

value
    ^self at: 0
!

value: aValue
    ^self at: 0 put: aValue type: nil
	"Type doesn't matter"
!

sizeof
    ^4
!

alignof
    ^4
!

inspect
    stdout nextPutAll: '--> '.
    self value inspect
!!



CUChar variableWordSubclass: #CByte
       instanceVariableNames: ''
       classVariableNames: ''
       poolDictionaries: ''
       category: 'C variable access'
!

CByte comment: 'You''re a marine.
You adapt -- you improvise -- you overcome

    	    	    	- Gunnery Sgt. Thomas Highway
    	    	    	  Heartbreak Ridge'!

!CByte methodsFor: 'accessing'!

value
    ^super value asciiValue
!

value: anInteger
    ^super value: (Character value: anInteger)
!!

Smalltalk at: #CCharType
	  put: (CType baseType: CChar subType: CChar "0").
Smalltalk at: #CUCharType
	  put: (CType baseType: CUChar subType: CUChar "1").
Smalltalk at: #CShortType
	  put: (CType baseType: CShort subType: CShort "2").
Smalltalk at: #CUShortType
	  put: (CType baseType: CUShort subType: CUShort "3").
Smalltalk at: #CLongType
	  put: (CType baseType: CLong subType: CLong "4").
Smalltalk at: #CULongType
	  put: (CType baseType: CULong subType: CULong "5").
Smalltalk at: #CFloatType
	  put: (CType baseType: CFloat subType: CFloat "6").
Smalltalk at: #CDoubleType
	  put: (CType baseType: CDouble subType: CDouble "7").
Smalltalk at: #CStringType
	  put: (CType baseType: CString subType: CString).
Smalltalk at: #CByteType
	  put: (CType baseType: CByte subType: CByte "0")
!

