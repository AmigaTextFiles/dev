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
| sbb	     16 Feb 92	  Created in the 1.1 timeframe
|
"

Object subclass: #Autoload
       instanceVariableNames: 'className fileName'
       classVariableNames: ''
       poolDictionaries: ''
       category: 'Cool hacks'
!

Autoload comment:
'I am not a part of the normal Smalltalk kernel class system.  I provide the
ability to do late-loading or "on demand loading" of class definitions.
Through me, you can define any class to be loaded when any message is sent to
the class itself (such as to create an instance).' !

!Autoload class methodsFor: 'instance creation'!

class: classNameString from: fileNameString
    ^Autoload new autoloadInitClass: classNameString 
		  initFile: fileNameString
!!


!Autoload methodsFor: 'accessing'!

doesNotUnderstand: aMessage
    | s |
    Smalltalk removeKey: className.
    FileStream fileIn: fileName.
    ^aMessage reinvokeFor: (Smalltalk at: className
				      ifAbsent: [ ^Autoload error: 
'Autoloaded file should have defined class "', className, '" but didn''t' ])
!!



!Autoload methodsFor: 'private'!

autoloadInitClass: aClassName initFile: aFileName
    className _ aClassName asSymbol.
    Smalltalk at: className put: self.
    fileName _ aFileName.
!!

Autoload superclass: nil!	"force undefined methods"
