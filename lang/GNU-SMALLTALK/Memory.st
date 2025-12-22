"======================================================================
|
|   Memory definitions
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
| sbb	     16 Mar 91	  Class creation now separate statement.
|
| sbyrne     29 May 89	  created.
|
"
Object variableWordSubclass: #Memory
       instanceVariableNames: ''
       classVariableNames: ''
       poolDictionaries: ''
       category: nil
!

Memory comment:
'I provide access to actual machine addresses of OOPS and objects.  I
have no instances; you send messages to my class to map between an object
and the address of its OOP or object.'  !


!Memory class methodsFor: 'accessing'!

"Note that the types could be given symbolic names and installed in a 
class variable, or could be methods that return the proper values (such as
the priorities for processes)."

charAt: anAddress
    ^self type: 0 at: anAddress
!

unsignedCharAt: anAddress
    ^self type: 1 at: anAddress
!

shortAt: anAddress
    ^self type: 2 at: anAddress
!

unsignedShortAt: anAddress
    ^self type: 3 at: anAddress
!

intAt: anAddress
    ^self type: 4 at: anAddress
!

unsignedIntAt: anAddress
    ^self type: 5 at: anAddress
!

floatAt: anAddress
    ^self type: 6 at: anAddress
!

doubleAt: anAddress
    ^self type: 7 at: anAddress
!

stringAt: anAddress
    ^self type: 8 at: anAddress
!

deref: anAddress
    ^self intAt: anAddress
! 


"Storing methods"

charAt: anAddress put: aValue
    ^self type: 0 at: anAddress put: aValue
!

unsignedCharAt: anAddress put: aValue
    ^self type: 1 at: anAddress put: aValue
!

shortAt: anAddress put: aValue
    ^self type: 2 at: anAddress put: aValue
!

unsignedShortAt: anAddress put: aValue
    ^self type: 3 at: anAddress put: aValue
!

intAt: anAddress put: aValue
    ^self type: 4 at: anAddress put: aValue
!

unsignedIntAt: anAddress put: aValue
    ^self type: 5 at: anAddress put: aValue
!

floatAt: anAddress put: aValue
    ^self type: 6 at: anAddress put: aValue
!

doubleAt: anAddress put: aValue
    ^self type: 7 at: anAddress put: aValue
!

stringAt: anAddress put: aValue
    ^self type: 8 at: anAddress put: aValue
!!


!Memory methodsFor: 'basic'!

!
