"======================================================================
|
|   Array Method Definitions
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
|
| sbb	     16 Mar 91	  Fixed class creation to be separate statement from
|			  class commenting.
|
| sbb	     21 Sep 90	  Added printOn: and storeOn: methods.
|
| sbyrne     25 Apr 89	  created.
|
"

ArrayedCollection variableSubclass: #Array
		  instanceVariableNames: ''
		  classVariableNames: ''
		  poolDictionaries: ''
		  category: nil
!

Array comment: 
'My instances are objects that have array-like properties: they are directly 
indexable by integers starting at 1, and they are fixed in size.  I inherit
object creation behavior messages such as #with:, as well as iteration
and general access behavior from SequenceableCollection.' !

!Array methodsFor: 'basic'!


!

!Array methodsFor: 'printing'!

printOn: aStream
    aStream nextPut: $(.
    self do:
	[ :elt | elt printOn: aStream.
		 aStream space ].
    aStream nextPut: $)
! !



!Array methodsFor: 'storing'!

storeOn: aStream
    | index |
    aStream nextPutAll: '((';
	nextPutAll: self classNameString;
	nextPutAll: ' basicNew: ';
	print: self basicSize;
	nextPut: $).
    index _ 1.
    self do:
    	[ :element | aStream nextPutAll: ' at: ';
			 print: index;
			 nextPutAll: ' put: ';
			 store: element; 
			 nextPut: $;.
		     index _ index + 1 ].
    index > 1 ifTrue: [ aStream nextPutAll: ' yourself' ].
    aStream nextPut: $)
! !

