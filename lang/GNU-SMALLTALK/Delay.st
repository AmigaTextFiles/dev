"======================================================================
|
|   Delay Method Definitions
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
| sbb	     18 May 91	  Actually implemented the thing.
|
| sbyrne     25 Apr 89	  created.
|
"

Object subclass: #Delay
       instanceVariableNames: 'resumptionTime isRelative'
       classVariableNames: 'DelayQueue DelayTimeout DelayIdle'
       poolDictionaries: ''
       category: nil
!

Delay comment: 
'I am the ultimate agent for frustration in the world.  I cause things to wait 
(typically much more than is appropriate).  When a process sends one of my instances a wait message, that process goes to sleep for the interval specified 
when the instance was created.'
!
	   

!Delay class methodsFor: 'instance creation'!

forMilliseconds: millisecondCount
    ^self new init: millisecondCount isRelative: true
!

forSeconds: secondCount
    ^self forMilliseconds: secondCount * 1000
!

untilMilliseconds: millisecondCount
    ^self new init: millisecondCount isRelative: false
! !



!Delay class methodsFor: 'general inquiries'!

millisecondClockValue
    ^Time millisecondClockValue
! !



!Delay class methodsFor: 'initialization'!

initialize
    DelayQueue _ SortedCollection sortBlock:
	[ :a :b | (a key) <= (b key) ].
    DelayIdle _ Semaphore forMutualExclusion.
    DelayTimeout _ Semaphore new.
    self startDelayLoop
!

startDelayLoop
    [ [ true ] whileTrue: 
	  [ DelayTimeout wait.
	    DelayIdle critical: 
		[ DelayQueue removeFirst value signal.
		  DelayQueue isEmpty
		      ifFalse: [ Processor signal: DelayTimeout
					   atMilliseconds: 
					       (DelayQueue first key) 
				     - self millisecondClockValue ]
		      ]
		]
	  ] forkAt: Processor timingPriority
! !



!Delay methodsFor: 'accessing'!

resumptionTime
    isRelative
	ifTrue: [ ^Delay millisecondClockValue + resumptionTime ] 
	ifFalse: [ ^resumptionTime ] 
! !



!Delay methodsFor: 'process delay'!

wait
    | elt sem |
    DelayQueue isNil
	ifTrue: [ Delay initialize ].
    sem _ Semaphore new.
    elt _ Association key: self resumptionTime
		      value: sem.
    DelayIdle critical: [ DelayQueue add: elt.
			  "If we've become the head of the list, we need to
			   alter the interrupt time"
			  DelayQueue first == elt
			      ifTrue: [ Processor signal: DelayTimeout 
						  atMilliseconds: 
						      (DelayQueue first key) -
					              Delay millisecondClockValue.
					    ]
			      ].
    sem wait
! !



!Delay methodsFor: 'comparing'!

= aDelay
    ^(isRelative = aDelay isRelative)
	and: [ resumptionTime = aDelay internalResumptionTime ]
!

hash
    ^resumptionTime
! !



!Delay methodsFor: 'private'!

init: milliseconds isRelative: aBoolean
    isRelative _ aBoolean.
    resumptionTime _ milliseconds
!

isRelative
    ^isRelative
!

internalResumptionTime
    ^resumptionTime
! !
