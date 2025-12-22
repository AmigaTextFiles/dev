"======================================================================
|
| Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
| Written by David Duke.
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
| sbb	     16 Feb 92	  Created by David Duke.
|
"

"This is loaded later, after the Fraction Class has been created.  Logically
 it belongs in builtins."

!Integer methodsFor: 'built ins'!

/ arg
    <primitive: 10>
    (arg isMemberOf: Integer) & (self isMemberOf: Integer) 
	ifTrue: [ ^(Fraction numerator: self denominator: arg)]. 
    ^self retry: #/ coercing: arg
!!

!Integer methodsFor: 'converting'!

asFraction
	^Fraction numerator: self denominator: 1
!!

