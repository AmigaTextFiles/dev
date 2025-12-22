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

CObject variableWordSubclass: #CStruct
	instanceVariableNames: ''
	classVariableNames: 'typeMap'
	poolDictionaries: ''
	category: 'C structures'
!


!Integer methodsFor: 'extension'!

alignTo: anInteger
    "Like ceilingTo (if there were one)"
    "^(self + anInteger - 1) // anInteger * anInteger"
    ^(self + anInteger - 1) truncateTo: anInteger
! !



!CStruct class methodsFor: 'instance creation'!

initialize
    typeMap _ Dictionary new.
    typeMap at: #long put: #CLongType; 
	    at: #uLong put: #CULongType;
	    at: #char put: #CCharType;
	    at: #uChar put: #CUCharType;
	    at: #short put: #CShortType;
	    at: #uShort put: #CUShortType;
	    at: #float put: #CFloatType;
	    at: #double put: #CDoubleType;
	    at: #string put: #CStringType.
!


newStruct: structName declaration: array
    | type name newClass offset maxAlignment str inspStr |
    newClass _ CStruct variableWordSubclass: structName asSymbol
		       instanceVariableNames: ''
		       classVariableNames: ''
		       poolDictionaries: ''
		       category: 'Synthetic Class'.

    offset _ 0.
    maxAlignment _ 1.
    inspStr _ WriteStream on: (String new: 8).
    inspStr nextPutAll: 'inspect'; nl.
    "Iterate through each member, doing alignment, size calculations,
     and creating accessor methods"
    array do:
	[ :dcl | name _ dcl at: 1.
		 type _ dcl at: 2.
		 self emitInspectTo: inspStr for: name.
   "stdout nextPutAll: 'name is '; nextPutAll: name; nl;
       nextPutAll: 'type is '; nextPutAll: type printString; nl."
		 self computeTypeString: type block:
		     [ :size :alignment 
		       :typeString | 
    "offset printNl."
				     
				     offset _ offset alignTo: alignment.
    "stdout nextPutAll: 'size '.  size printNl.
    stdout nextPutAll: 'offset: '; nextPutAll: offset printString; 
	nextPutAll: ' alignment '; nextPutAll: alignment printString; nl."
    "stdout nextPutAll: 'typestring '; nextPutAll: typeString; nl."
				     maxAlignment _ alignment max: 
					 maxAlignment.
				     str _ WriteStream on: (String new: 20).
				     str nextPutAll: name;
					 nextPutAll: '
    ^self at: '; nextPutAll: offset printString;
				     nextPutAll: ' type: ', typeString.
" str contents printNl.
    stdout nextPutAll: 'size '.  size printNl."
				     newClass compile: str contents.
				     offset _ offset + size
					 ]
		     ].
    newClass compile: inspStr contents.
    self compileSize: offset align: maxAlignment for: newClass.
    newClass class compile: 'new
    ^self alloc: self sizeof'
!				    
			
			
computeTypeString: type block: aBlock
    | typeClass typeClassName |
    type class == Array
	ifTrue: [ self computeAggregateType: type block: aBlock ]
	ifFalse:		"must be a type name, either built in or 
				 struct"
	    [ typeClassName _ typeMap at: type
				  ifAbsent: [ nil ].
	      typeClassName notNil
		  ifTrue: [ typeClass _ Smalltalk at: typeClassName.
			    aBlock value: typeClass subType sizeof
				   value: typeClass subType alignof
				   value: typeClassName ]
		  ifFalse: [ typeClass _ Smalltalk at: type.
			     aBlock value: typeClass sizeof
				    value: typeClass alignof
				    value: '(CType baseType: ', type, ')' ]
		  ]
!

computeAggregateType: type block: aBlock
    "Format:
    	(array int 3)
    	(ptr FooStruct)
    "
    | structureType |
    " ### Should check for 2 or 3 elts only "
    structureType _ type at: 1.
    structureType == #array 
	ifTrue: [ ^self computeArrayType: type block: aBlock ].
    structureType == #ptr
	ifTrue: [ ^self computePtrType: type block: aBlock ].
!
	
computeArrayType: type block: aBlock
    | numElts subType |
    subType _ type at: 2.
    numElts _ type at: 3.
    self computeTypeString: subType
	 block: [ :size :alignment 
		  :typeString | aBlock value: size * numElts
				       value: alignment
				       value: '(CType baseType: CArray ',
				           'subType: ', typeString,
    	    	    	    	    	   ' numElements: ',
		                           (numElts printString),
				    	      ')' ]
!

computePtrType: type block: aBlock
    | subType |
    subType _ type at: 2.
    self computeTypeString: subType
	 block: [ :size :alignment 
		  :typeString | aBlock value: CPtr sizeof
				       value: CPtr alignof
				       value: '(CType baseType: CPtr
						      subType: ', typeString,
				    	      ')' ]
!


compileSize: size align: alignment for: aClass
    size _ size alignTo: alignment.
    aClass compile: 'sizeof
    ^self class sizeof'.
    aClass compile: 'alignof
    ^self class alignof'.
    aClass class compile: 'sizeof
    ^', (size printString).
    aClass class compile: 'alignof
    ^', (alignment printString)
!

emitInspectTo: str for: name
    str nextPutAll: '    stdout nextPutAll: ''';
	nextPutAll: name;
	nextPutAll: ':''.'; nl.
    str nextPutAll: '    self ';
	nextPutAll: name;
	nextPutAll: ' inspect.'; nl
!!

CStruct initialize!

