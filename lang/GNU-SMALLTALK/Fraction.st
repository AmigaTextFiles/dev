"======================================================================
|
| Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
| Written by David Duke.
| Slightly modified by Steve Byrne.
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

Number subclass: #Fraction
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	category: nil!

Fraction comment:
' I represent rational numbers in the form (p/q) where p and q are integers.
The arithmetic operations  *, +, -, /,  on fractions, all return a reduced 
fraction.'!


!Integer methodsFor: 'basic math'!

/ arg 			"from changes.st"
    <primitive: 10>
    (arg isMemberOf: Integer) & (self isMemberOf: Integer) 
	ifTrue: [ ^(Fraction numerator: self denominator: arg)]. 
    ^self retry: #/ coercing: arg
! !



!Integer methodsFor: 'converting'!

asFraction
    ^Fraction numerator: self denominator: 1
!!






!Fraction methodsFor: 'accessing'!
denominator
	^denominator!
numerator
	^numerator 
!!


!Fraction methodsFor: 'arithmetic'!
* aNumber 
	"I implement * for fractions."

	(aNumber isMemberOf: Fraction)
		ifTrue: [^(Fraction numerator: numerator * aNumber numerator denominator: denominator * aNumber denominator) reduced]
		ifFalse: [^self retry: #* coercing: aNumber]!
+ aNumber 
	"I implement + for fractions."

	(aNumber isMemberOf: Fraction)
		ifTrue: [^(Fraction numerator: (numerator * aNumber denominator) + (aNumber numerator * denominator) denominator: denominator * aNumber denominator) reduced]
		ifFalse: [^self retry: #+ coercing: aNumber]!
- aNumber 
	"I implement - for fractions."

	(aNumber isMemberOf: Fraction)
		ifTrue: [^self + (aNumber negated)]
		ifFalse: [^self retry: #- coercing: aNumber]!
/ aNumber 
	"I implement / for fractions."

	(aNumber isMemberOf: Fraction)
		ifTrue: [^self * (aNumber reciprocal)]
		ifFalse: [^self retry: #/ coercing: aNumber] !
// aNumber
    "Return the integer quotient of dividing the receiver by aNumber with
    truncation towards negative infinity."
    ^(self / aNumber) floor !
\\ aNumber
    "Return the remainder from dividing the receiver by aNumber, (using //)."
    ^(self - (self // aNumber * aNumber)) !
negated
	^Fraction numerator: numerator negated denominator: denominator !
reciprocal
	denominator < 0
		ifTrue: [^Fraction numerator: denominator negated denominator: numerator negated]
		ifFalse: [^Fraction numerator: denominator denominator: numerator]

!!


!Fraction methodsFor: 'coercing'!
coerce: aNumber 
	^aNumber asFraction!
generality
	^3!
truncated
	^numerator quo: denominator
!!

!Fraction methodsFor: 'comparing'!
< arg 
	"I test if the receiver is less than arg."

	(arg isMemberOf: Fraction)
		ifTrue: [^arg denominator * numerator < (denominator * arg numerator)]
		ifFalse: [^self retry: #< coercing: arg]!
> arg 
	"I test if the receiver is more than arg."

	(arg isMemberOf: Fraction)
		ifTrue: [^arg denominator * numerator > (denominator * arg numerator)]
		ifFalse: [^self retry: #> coercing: arg]!
= arg 
	"I test if the receiver is equals arg."

	(arg isMemberOf: Fraction)
		ifTrue: [^arg denominator * numerator = (denominator * arg numerator)]
		ifFalse: [^self retry: #= coercing: arg]!
hash
	^numerator bitXor: denominator
!!

!Fraction methodsFor: 'converting'!
asFloat
	^numerator asFloat / denominator asFloat!
asFraction
	^self 
!!


!Fraction methodsFor: 'printing'!
printOn: aStream

	" Fractions print as (numerator/denominator) eg (3/4) ."

	aStream nextPut: $(; 
	    print: numerator;
	    nextPut: $/;
	    print: denominator;
	    nextPut: $) 
!!


!Fraction methodsFor: 'private'!
reduced
	| gcd |
	numerator = 1 ifTrue: [^self].
	denominator = 1 ifTrue: [^numerator].
	numerator = 0 ifTrue: [^0].
	numerator = denominator ifTrue: [^1].
	gcd _ numerator gcd: denominator.
	gcd = 1 ifTrue: [^self].
	denominator = gcd ifTrue: [^numerator // gcd].
	^Fraction numerator: numerator // gcd denominator: denominator // gcd !
setNumerator: numInteger setDenominator: denInteger 
	denInteger = 0
		ifTrue: [^self error: 'The denominator can not be zero'].
	denInteger < 0
		ifTrue: [numerator _ numInteger negated.
			denominator _ denInteger negated]
		ifFalse: [numerator _ numInteger.
			denominator _ denInteger]
!!


!Fraction class methodsFor: 'instance creation'!

numerator: nInteger denominator: dInteger 
	" Answer a new instance of fraction (nInteger/dInteger)"

	^self new setNumerator: nInteger setDenominator: dInteger 
!!

