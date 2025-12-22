"======================================================================
|
|   Bag Method Definitions
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
| sbb	     28 Jul 91	  #= now checks args better.
|
| sbb	     16 Mar 91	  Class creation now separate statement.
|
| sbb	     21 Sep 90	  Removed printOn: method; the one from Collection does
|			  the right thing.
|
| sbyrne     25 Apr 89	  created.
|
"

Collection subclass: #Bag
	   instanceVariableNames: 'contents'
	   classVariableNames: ''
	   poolDictionaries: ''
	   category: nil
!

Bag comment:
'My instances are unordered collections of objects.  You can think
of me as a set with a memory; that is, if the same object is added to me
twice, then I will report that that element has been stored twice.'!


!Bag class methodsFor: 'basic'!

new
    ^super new initContents
!!



!Bag methodsFor: 'Adding to a collection'!

add: newObject withOccurrences: anInteger
    contents at: newObject
	     put: (self occurrencesOf: newObject) + anInteger.
    ^newObject
!

add: newObject
    self add: newObject withOccurrences: 1.
    ^newObject 
!

at: index
    self error: 'at: is not allowed for a Bag'
!

at: index put: value
    self error: 'at:put: is not allowed for a Bag'
!!



!Bag methodsFor: 'Removing from a collection'!

remove: oldObject ifAbsent: anExceptionBlock
    | count |
    "Remove oldObject from the collection and return it.  Since we're using
    a dictionary, we need decrement the value until it's zero, in which case
    we can then remove the object from the dictionary"
    count _ self occurrencesOf: oldObject.
    count = 0 ifTrue: [ ^anExceptionBlock value ].
    count = 1 ifTrue: [ contents removeKey: oldObject ]
    	      ifFalse: [ contents at: oldObject
	      	    	    	  put: count - 1 ].
    ^oldObject
!!



!Bag methodsFor: 'testing collections'!

occurrencesOf: anObject
    ^contents at: anObject ifAbsent: [ ^0 ]
!

size
    | count |
    count _ 0.
    contents do: [ :element | count _ count + element ].
    ^count
!

hash
    ^contents hash
!

= aBag
    self class == aBag class
	ifFalse: [ ^false ].
    ^contents = aBag contents
!!



!Bag methodsFor: 'enumerating the elements of a collection'!

do: aBlock
    "Perform the block for all members in the collection.  For Bags, we need
    to go through the contents dictionary, and perform the block for as many
    occurrences of the objects as there are."
    contents associationsDo:
      [ :assoc |  assoc value timesRepeat: [ aBlock value: assoc key ] ]
!!



!Bag methodsFor: 'storing'!

storeOn: aStream
    | noElements |
    aStream nextPut: $(;
	nextPutAll: self classNameString;
	nextPutAll: ' new'.
    noElements _ true.
    contents associationsDo:
      [ :assoc | aStream nextPutAll: ' add: ';
		     store: assoc key;
		     nextPutAll: ' withOccurrences: ';
		     store: assoc value;
		     nextPut: $;.
		 noElements _ false ].
    noElements ifFalse: [ aStream nextPutAll: '; yourself' ].
    aStream nextPut: $)
!!



!Bag methodsFor: 'private'!

initContents
    contents _ Dictionary new
!

contents
    ^contents
!!

