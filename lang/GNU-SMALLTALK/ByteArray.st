"======================================================================
|
|   ByteArray Method Definitions
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
| sbb	     14 Dec 91	  Added asString -- generally useful functionality, but
|			  especially for STIX.
|
| sbb	     28 Nov 91	  Added growSize method -- 10 wasn't right, and we
|			  should probably base the grow size on the size of the
|			  object in question.
|
| sbb	     28 Nov 91	  Switched shallowCopy to use faster primitives.
|
| sbb	     16 Mar 91	  Class creation now separate statement.
|
| sbyrne     25 Apr 89	  created.
|
"

ArrayedCollection variableByteSubclass: #ByteArray
		  instanceVariableNames: ''
		  classVariableNames: ''
		  poolDictionaries: ''
		  category: nil
!

ByteArray comment: 
'My instances are similar to strings in that they are both represented as
a sequence of bytes, but my individual elements are integers, where as
a String''s elements are characters.' !

!ByteArray methodsFor: 'copying'!

shallowCopy
    | newArray |
    newArray _ self species new: self size.
    newArray replaceFrom: 1 to: self size with: self.
    " Off the top of my head, I can't think why we need to use the code below
      instead of the faster code above
	  1 to: self size do:
	      [ :i | newArray at: i put: (self at: i) ].
    "
    ^newArray
!

deepCopy
    ^self shallowCopy

! !



!ByteArray methodsFor: 'converting'!

asString
    | string size |
    size _ self size.
    string _ String new: size.
    string replaceFrom: 1 to: size withByteArray: self startingAt: 1.
    ^string
! !



"!ByteArray methodsFor: 'replacing'!

replaceFrom: start to: stop with: replacementByteArray startingAt: repStart
    ^self primReplaceFrom: start to: stop with: replacementByteArray
	  startingAt: repStart
! !

"

!ByteArray methodsFor: 'private'!

growSize
    ^40
! !
