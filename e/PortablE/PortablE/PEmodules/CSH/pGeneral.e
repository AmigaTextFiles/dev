/* pGeneral.e 10-08-2022
	A collection of useful general-purpose procedures, some of which are candidates to become a standard part of PortablE.


Copyright (c) 1999,2000,2002,2004,2005,2006,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2020,2022 Christopher Steven Handley ( http://cshandley.co.uk/email )
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* The source code must not be modified after it has been translated or converted
away from the PortablE programming language.  For clarification, the intention
is that all development of the source code must be done using the PortablE
programming language (as defined by Christopher Steven Handley).

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* Public procedures:
LinkAppend( complex:STRING, next:OWNS STRING) RETURNS newNext:STRING
LinkReplace(complex:STRING, next:OWNS STRING) RETURNS oldNext:OWNS STRING
StrClone( orig:NULL STRING)        RETURNS   clone:OWNS STRING
CopyStr(string:NULL ARRAY OF CHAR) RETURNS estring:OWNS STRING
StrListInsertSorted(head:STRING, add:OWNS STRING, order:RANGE -1 TO 1, tail=NILS:STRING) RETURNS newTail:STRING
Val2(string:ARRAY OF CHAR, startPos=0, errorValue=0) RETURNS value, afterPos

NewLineString() RETURNS newLine:ARRAY OF CHAR
splitLinesIntoLinkedStrings(string:ARRAY OF CHAR) RETURNS lines:OWNS STRING, numberOfLines, tail:STRING
splitIntoLinkedStrings(     string:ARRAY OF CHAR, separator:ARRAY OF CHAR) RETURNS nodes:OWNS STRING, numberOfNodes, tail:STRING
joinLinkedStringsIntoLines(list:STRING) RETURNS string:OWNS STRING
joinLinkedStrings(         list:STRING, separator=NILA:ARRAY OF CHAR) RETURNS string:OWNS STRING

roundUpToPowerOfTwo(  number) RETURNS value, power:BYTE
roundDownToPowerOfTwo(number) RETURNS value, power:BYTE
twoToPowerOf(power) RETURNS value
raiseToPower(x, y)  RETURNS value

 largestBitValue(number) RETURNS value, position:BYTE
smallestBitValue(number) RETURNS value, position:BYTE
bitPositionValue(position) RETURNS value
 largestBitPosition(number) RETURNS position:BYTE
smallestBitPosition(number) RETURNS position:BYTE

PowerModGet(d) RETURNS power
PowerMod(c, power) RETURNS a, b
FastMod2(c, d)     RETURNS a, b
ModInv(b, n) RETURNS x

gcd(a, b) RETURNS gcd
lcm(a, b) RETURNS lcm, gcd

bigMax(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE
bigMin(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE
bigMod(a:BIGVALUE, b) RETURNS c -># , d:BIGVALUE
bigModReversed(a:BIGVALUE, b) RETURNS d:BIGVALUE, c
bigSign(a:BIGVALUE) RETURNS sign:RANGE -1 TO 1
*/

OPT INLINE, POINTER
OPT NATIVE, PREPROCESS

PRIVATE

PROC main()
	Print('Started tests of CGeneral.  Errors will be reported.\n')
	
	test_largestbitposition()
	test_largestbitvalue()
ENDPROC

->checks comparisons are at right places (2^n boundaries)
PROC test_largestbitposition()
	DEF number, position
	
	IF largestBitPosition(0) <>-1 THEN Print('ERROR: largestBitPosition(0) <>-1\n')
	
	IF largestBitPosition(1) <> 0 THEN Print('ERROR: largestBitPosition(1) <> 0\n')
	IF largestBitPosition(2) <> 1 THEN Print('ERROR: largestBitPosition(2) <> 1\n')
	
	number:=4
	position:=2
	REPEAT
		IF largestBitPosition(number - 1) <> (position - 1) THEN Print('ERROR: largestBitPosition(\d) <> \d\n', number - 1, position - 1)
		IF largestBitPosition(number    ) <>  position      THEN Print('ERROR: largestBitPosition(\d) <> \d\n', number    , position    )
		IF largestBitPosition(number + 1) <>  position      THEN Print('ERROR: largestBitPosition(\d) <> \d\n', number + 1, position    )
		
		number := number SHL 1
		position := position + 1
	UNTIL position >= 32
	
	Print('Completed test of largestBitPosition().\n')
ENDPROC

->checks all CASE statements are correct
PROC test_largestbitvalue()
	DEF number, position
	
	IF largestBitValue(0) <> -1 THEN Print('ERROR: largestBitValue(0) <> -1\n')
	
	number:=1
	position:=0
	REPEAT
		IF largestBitValue(number) <> number THEN Print('ERROR: largestBitValue(\d) <> \d\n', number, number)
		
		number := number SHL 1
		position := position + 1
	UNTIL position >= 32
	
	Print('Completed test of largestBitValue().\n')
ENDPROC

PUBLIC

/*****************************/

PROC LinkAppend(complex:STRING, next:OWNS STRING) RETURNS newNext:STRING
	newNext := /*OWNS*/ next
	Link(complex, PASS next)
ENDPROC

PROC LinkReplace(complex:STRING, next:OWNS STRING) RETURNS oldNext:OWNS STRING
	oldNext := /*OWNS*/ Next(complex)
	Link(complex, PASS next)
ENDPROC

PROC StrClone(orig:NULL STRING) RETURNS clone:OWNS STRING
	IF orig = NILS THEN RETURN
	
	NEW clone[StrMax(orig)]
	StrCopy(clone, orig)
ENDPROC

PROC CopyStr(string:NULL ARRAY OF CHAR) RETURNS estring:OWNS STRING
	IF string = NILA THEN RETURN
	
	NEW estring[Max(1,StrLen(string))]
	StrCopy(estring, string)
ENDPROC

->Inserts the "add" string into the list, keeping the list sorted.  If the tail of the list changes, then it returns the newTail, otherwise it will will return "tail" (which defaults to NILS).
->NOTE: The list always starts with "head", which should be an empty string (although the actual contents is ignored).
->NOTE: order=1 makes it alphabetically sorted (a to z), order=-1 makes it reverse sorted (z to a), and the same "order" should always be used for a list.
->NOTE: BEWARE this is an O(n) algorithm, but it's tiny code size means it can be included as standard.  Use pString's mergeSort() for larger lists.
PROC StrListInsertSorted(head:STRING, add:OWNS STRING, order:RANGE -1 TO 1, tail=NILS:STRING) RETURNS newTail:STRING
	DEF prev:STRING, next:STRING, unownedAdd:STRING, temp:OWNS STRING
	
	->find where to insert the string
	prev := head
	IF next := Next(head)
		WHILE OstrCmp(next, add) = order
			prev := next
			next := Next(next)
		ENDWHILE IF next = NILS
	ENDIF
	
	->then insert it
	IF next
		unownedAdd := add
		temp := LinkReplace(prev, PASS add)
		IF temp <> next THEN Throw("BUG", 'StrListInsertSorted(); temp<>next')
		LinkAppend(unownedAdd, PASS temp)
		newTail := tail
	ELSE
		IF tail THEN IF prev <> tail THEN Throw("BUG", 'StrListInsertSorted(); prev<>tail')
		newTail := LinkAppend(prev, PASS add)
	ENDIF
FINALLY
	END add
	END temp
ENDPROC

->like Val() except that on an error it returns "errorValue" for value.
->NOTE: Normally the returned "afterPos" is the position just after the last read digit, but on an error it will equal "startPos".
PROC Val2(string:ARRAY OF CHAR, startPos=0, errorValue=0) RETURNS value, afterPos
	DEF read
	value, read := Val(string, NILA, startPos)
	IF read = 0
		value := errorValue
		afterPos := startPos
	ELSE
		afterPos := startPos + read
	ENDIF
ENDPROC

/*****************************/

PROC NewLineString() RETURNS newLine:ARRAY OF CHAR IS #ifndef pe_TargetOS_Windows '\n' #else '\b\n' #endif

PROC splitLinesIntoLinkedStrings(string:ARRAY OF CHAR) RETURNS lines:OWNS STRING, numberOfLines, tail:STRING
	lines, numberOfLines, tail := splitIntoLinkedStrings(string, NewLineString())
ENDPROC

->NOTE: If an empty string is supplied, then a single (empty) node will be returned.
PROC splitIntoLinkedStrings(string:ARRAY OF CHAR, separator:ARRAY OF CHAR) RETURNS list:OWNS STRING, numberOfNodes, tail:STRING
	DEF stringLen, separatorLen, pos, nextPos, nodeLen, node:OWNS STRING
	
	stringLen    := StrLen(string)
	separatorLen := StrLen(separator)
	
	->split string into list of nodes
	numberOfNodes := 0
	tail := NILS
	pos := 0
	REPEAT
		->find end of node
		nextPos := InStr(string, separator, pos)
		IF nextPos = -1 THEN nextPos := stringLen
		
		->extract node
		nodeLen := nextPos - pos
		NEW node[Max(1, nodeLen)]
		StrCopy(node, string, nodeLen, pos)
		
		->add node to end of list
		numberOfNodes++
		IF tail = NILS
			tail  := node
			list := PASS node
		ELSE
			tail := LinkAppend(tail, PASS node)
		ENDIF
		
		->move to start of next node
		pos := nextPos + separatorLen
	UNTIL pos >= stringLen
	
	IF pos = stringLen
		->create the final blank node
		NEW node[1]
		
		->add node to end of list
		numberOfNodes++
		IF tail = NILS
			tail  := node
			list := PASS node
		ELSE
			tail := LinkAppend(tail, PASS node)
		ENDIF
	ENDIF
FINALLY
	IF exception THEN END list
	END node
ENDPROC

PROC joinLinkedStringsIntoLines(list:NULL STRING) RETURNS string:OWNS STRING
	string := joinLinkedStrings(list, NewLineString())
ENDPROC

->NOTE: If list=NILS is supplied, then an empty string will be returned.
PROC joinLinkedStrings(list:NULL STRING, separator=NILA:ARRAY OF CHAR) RETURNS string:OWNS STRING
	DEF size, separatorLen, node:STRING
	
	->calculate size of final string
	separatorLen := IF separator THEN StrLen(separator) ELSE 0
	size := 0
	IF node := list
		REPEAT
			size := size + EstrLen(node) + separatorLen
			node := Next(node)
		UNTIL node = NILS
		size := size - separatorLen
	ENDIF
	
	->create string
	NEW string[Max(1,size)]
	node := list
	WHILE node
		StrAdd(string, node)
		IF separator THEN StrAdd(string, separator)
		
		node := Next(node)
	ENDWHILE
ENDPROC

/*****************************/

->returns number rounded up to the nearest 2^n (=value), as well as returning n itself (=power)
->NOTE:  if number=0 then value=1,power=0 is returned.
->NOTE:  if number<0 then value=-1,power=32 is returned.
PROC roundUpToPowerOfTwo(number) RETURNS value, power:BYTE
	IF number < 0
		->(negative indicates top bit is set, which is 2^31 if it was unsigned)
		->       %1 987654321 987654321 9876543210
		value := %11111111111111111111111111111111	->2^32 - 1 which is the closest to 2^32 we can manage
		power := 32
		
	ELSE IF number < 2
		->(number = 0 or 1) [0 is required, 1 is simply an optimisation]
		value := 1
		power := 0
	ELSE
		value, power := largestBitValue(number - 1)	->e.g. 5 to 8 gives value=4, power=2
		value := value SHL 1						->e.g.              value=8
		power := power + 1							->e.g.                       power=3
	ENDIF
ENDPROC

->returns number rounded down to the nearest 2^n (=value), as well as returning n itself (=power)
->NOTE:  if number=0 then value=-1,power=-1 is returned.
->NOTE:  if number<0 then value=-(2^31),power=31 is returned.
PROC roundDownToPowerOfTwo(number) IS largestBitValue(number)

->returns the value of 2^power
PROC twoToPowerOf(power) IS bitPositionValue(power)

->returns x^y
PROC raiseToPower(x, y) RETURNS value
	DEF i
	
	IF x = 2
		value := twoToPowerOf(y)
	ELSE
		value := 1
		FOR i := 1 TO y DO value := value * x
	ENDIF
ENDPROC

/*****************************/

->return the value of the largest bit set in the number, as well as returning the position of that bit (0=lowest bit).
->NOTE:  if no bits are set (i.e. number=0) then value=-1,position=-1 is returned.
->NOTE:  value is equivalent to 2^largestBitPosition(), and position = largestBitPosition().
PROC largestBitValue(number) RETURNS value, position:BYTE
	position := largestBitPosition(number)
	value := IF position >= 0 THEN bitPositionValue(position) ELSE -1
ENDPROC

->return the value of the smallst bit set in the number, as well as returning the position of that bit (0=lowest bit).
->NOTE:  if no bits are set (i.e. number=0) then value=-1,position=-1 is returned.
->NOTE:  value is equivalent to 2^smallestBitPosition(), and position = smallestBitPosition().
PROC smallestBitValue(number) RETURNS value, position:BYTE
	position := smallestBitPosition(number)
	value := IF position >= 0 THEN bitPositionValue(position) ELSE -1
ENDPROC

->return the value of the bit at the specified position
PROC bitPositionValue(position) RETURNS value IS IF (position >= 0) AND (position <= 31) THEN 1 SHL position ELSE (Throw("EPU",'General; bitPositionValue(); position<0 or position>31') BUT 0)

->return the position of the largest bit set in the number
->NOTE:  the smallest position is 0, and the largest is 31.
->NOTE:  if no bits are set (i.e. number=0) then -1 is returned.
->NOTE:  it requires no more than 6 comparisons to compute the answer.
PROC largestBitPosition(number) RETURNS position:BYTE
	IF number AND $FFFF0000
		IF number AND $FF000000
			IF number AND $F0000000
				IF number AND $C0000000
					IF number AND $80000000
						position := 31
					ELSE       ->($40000000)
						position := 30
					ENDIF
				ELSE       ->($30000000)
					IF number AND $20000000
						position := 29
					ELSE       ->($10000000)
						position := 28
					ENDIF
				ENDIF
			ELSE       ->($0F000000)
				IF number AND $0C000000
					IF number AND $08000000
						position := 27
					ELSE       ->($04000000)
						position := 26
					ENDIF
				ELSE       ->($03000000)
					IF number AND $02000000
						position := 25
					ELSE       ->($01000000)
						position := 24
					ENDIF
				ENDIF
			ENDIF
		ELSE       ->($00FF0000)
			IF number AND $00F00000
				IF number AND $00C00000
					IF number AND $00800000
						position := 23
					ELSE       ->($00400000)
						position := 22
					ENDIF
				ELSE       ->($00300000)
					IF number AND $00200000
						position := 21
					ELSE       ->($00100000)
						position := 20
					ENDIF
				ENDIF
			ELSE       ->($000F0000)
				IF number AND $000C0000
					IF number AND $00080000
						position := 19
					ELSE       ->($00040000)
						position := 18
					ENDIF
				ELSE       ->($00030000)
					IF number AND $00020000
						position := 17
					ELSE       ->($00010000)
						position := 16
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
	ELSE IF number AND $0000FFFF
		IF number AND $0000FF00
			IF number AND $0000F000
				IF number AND $0000C000
					IF number AND $00008000
						position := 15
					ELSE       ->($00004000)
						position := 14
					ENDIF
				ELSE       ->($00003000)
					IF number AND $00002000
						position := 13
					ELSE       ->($00001000)
						position := 12
					ENDIF
				ENDIF
			ELSE       ->($00000F00)
				IF number AND $00000C00
					IF number AND $00000800
						position := 11
					ELSE       ->($00000400)
						position := 10
					ENDIF
				ELSE       ->($00000300)
					IF number AND $00000200
						position := 9
					ELSE       ->($00000100)
						position := 8
					ENDIF
				ENDIF
			ENDIF
		ELSE       ->($000000FF)
			IF number AND $000000F0
				IF number AND $000000C0
					IF number AND $00000080
						position := 7
					ELSE       ->($00000040)
						position := 6
					ENDIF
				ELSE       ->($00000030)
					IF number AND $00000020
						position := 5
					ELSE       ->($00000010)
						position := 4
					ENDIF
				ENDIF
			ELSE       ->($0000000F)
				IF number AND $0000000C
					IF number AND $00000008
						position := 3
					ELSE       ->($00000004)
						position := 2
					ENDIF
				ELSE       ->($00000003)
					IF number AND $00000002
						position := 1
					ELSE       ->($00000001)
						position := 0
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
	ELSE ->IF number = 0
		->(no bits are set)
		position := -1
	ENDIF
ENDPROC

->return the position of the smallest bit set in the number
->NOTE:  the smallest position is 0, and the largest is 31.
->NOTE:  if no bits are set (i.e. number=0) then -1 is returned.
->NOTE:  it requires no more than 6 comparisons to compute the answer.
PROC smallestBitPosition(number) RETURNS position:BYTE
	IF number AND $0000FFFF
		IF number AND $000000FF
			IF number AND $0000000F
				IF number AND $00000003
					IF number AND $00000001
						position := 0
					ELSE       ->($00000002)
						position := 1
					ENDIF
				ELSE       ->($0000000C)
					IF number AND $00000004
						position := 2
					ELSE       ->($00000008)
						position := 3
					ENDIF
				ENDIF
			ELSE       ->($000000F0)
				IF number AND $00000030
					IF number AND $00000010
						position := 4
					ELSE       ->($00000020)
						position := 5
					ENDIF
				ELSE       ->($000000C0)
					IF number AND $00000040
						position := 6
					ELSE       ->($00000080)
						position := 7
					ENDIF
				ENDIF
			ENDIF
		ELSE       ->($0000FF00)
			IF number AND $00000F00
				IF number AND $00000300
					IF number AND $00000100
						position := 8
					ELSE       ->($00000200)
						position := 9
					ENDIF
				ELSE       ->($00000C00)
					IF number AND $00000400
						position := 10
					ELSE       ->($00000800)
						position := 11
					ENDIF
				ENDIF
			ELSE       ->($0000F000)
				IF number AND $00003000
					IF number AND $00001000
						position := 12
					ELSE       ->($00002000)
						position := 13
					ENDIF
				ELSE       ->($0000C000)
					IF number AND $00004000
						position := 14
					ELSE       ->($00008000)
						position := 15
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
	ELSE IF number AND $FFFF0000
		IF number AND $00FF0000
			IF number AND $000F0000
				IF number AND $00030000
					IF number AND $00010000
						position := 16
					ELSE       ->($00020000)
						position := 17
					ENDIF
				ELSE       ->($000C0000)
					IF number AND $00040000
						position := 18
					ELSE       ->($00080000)
						position := 19
					ENDIF
				ENDIF
			ELSE       ->($00F00000)
				IF number AND $00300000
					IF number AND $00100000
						position := 20
					ELSE       ->($00200000)
						position := 21
					ENDIF
				ELSE       ->($00C00000)
					IF number AND $00400000
						position := 22
					ELSE       ->($00800000)
						position := 23
					ENDIF
				ENDIF
			ENDIF
		ELSE       ->($FF000000)
			IF number AND $0F000000
				IF number AND $03000000
					IF number AND $01000000
						position := 24
					ELSE       ->($02000000)
						position := 25
					ENDIF
				ELSE       ->($0C000000)
					IF number AND $04000000
						position := 26
					ELSE       ->($08000000)
						position := 27
					ENDIF
				ENDIF
			ELSE       ->($F0000000)
				IF number AND $30000000
					IF number AND $10000000
						position := 28
					ELSE       ->($20000000)
						position := 29
					ENDIF
				ELSE       ->($C0000000)
					IF number AND $40000000
						position := 30
					ELSE       ->($80000000)
						position := 31
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
	ELSE ->IF number = 0
		->(no bits are set)
		position := -1
	ENDIF
ENDPROC

/*****************************/

->NOTE: Only d > 0 is acceptable.
PROC PowerModGet(d) RETURNS power
	DEF value
	
	IF d <= 0 THEN Throw("EPU", 'General; PowerModeGet(); d<=0')
	
	value, power := largestBitValue(d)
	IF value <> d
		->(can't represent d as a power of 2) so encode d as a 'negative power'
		power := -d
	ENDIF
ENDPROC

->returns the remainder "a" & division "b" of the calculation "c / 2^power"
->NOTE: power = 2^d should be calculated by PowerModGet(d)
PROC PowerMod(c,power) RETURNS a, b
	DEF d
	
	IF power >= 0
		IF c >= 0
			b := Shr(c,power!!BYTE)
		ELSE
			b := -Shr(-c,power!!BYTE)
		ENDIF
		a := c - Shl(b,power!!BYTE)
	ELSE
		d := -power
		a, b := Mod(c,d)
	ENDIF
ENDPROC

PROC FastMod2(c,d) RETURNS a, b
	DEF power
	
	power := PowerModGet(d)
	a,b := PowerMod(c,power)
ENDPROC

->Calculates the Modular Multiplicative Inverse. Evaluates to "x", such that (x * b) % n = 1.
->NOTE: Uses the part of the Extended Euclidean algorithm that calculates "x" (ignores "y"), as described here: http://www.di-mgt.com.au/euclidean.html#extendedeuclidean & https://en.wikibooks.org/wiki/Algorithm_Implementation/Mathematics/Extended_Euclidean_algorithm#Iterative_algorithm
->      With additional pre/post checks used by the C translation of Perl code: https://rosettacode.org/wiki/Modular_inverse#C
->NOTE: Returns -1 when there is no inverse.
PROC ModInv(b, n) RETURNS x
	DEF x1, x2, q, r, t, orig_n
	
	IF n = 0 THEN RETURN 1
	IF n < 0 THEN n := -n
	IF b < 0 THEN b := n - FastMod(-b, n)
	
	orig_n := n
	x2 := 1
	x1 := 0
	WHILE n <> 0
		r, q := Mod(b, n)
		b := n
		n := r
		
		t := x2 - (q*x1)
		x2 := x1
		x1 := t
	ENDWHILE
	
	IF b > 1 THEN RETURN -1		->there is no inverse
	
	IF x2 < 0 THEN x2 := x2 + orig_n
	x := x2
ENDPROC

/*****************************/

->Calculate the Greatest Common Divisor, and optionally the Lowest Common Multiple
->NOTE: Uses Euclid's algorithm, as described here: https://proprogramming.org/euclids-algorithm-gcd-lcm-cpp/
PROC gcd(a, b) RETURNS gcd
	DEF big, small, temp
	
	IF a > b
		big   := a
		small := b
	ELSE
		big   := b
		small := a
	ENDIF
	REPEAT
		temp  := FastMod(big, small)
		big   := small
		small := temp
	UNTIL small = 0
	
	gcd := big
ENDPROC

PROC lcm(a, b) RETURNS lcm, gcd
	gcd := gcd(a, b)
	lcm := a!!BIGVALUE * b / gcd !!VALUE
ENDPROC

/* ## untested, may need extra checks before/after for sensible behaviour (like ModInv() does).

->NOTE: Uses the Extended Euclidean algorithm, as described here: http://www.di-mgt.com.au/euclidean.html#extendedeuclidean & https://en.wikibooks.org/wiki/Algorithm_Implementation/Mathematics/Extended_Euclidean_algorithm#Iterative_algorithm
->NOTE: x is equal to ModInv(a,b) .
PROC xgcd(a, b) RETURNS gcd, x, y
	DEF x1, x2, y1, y2, q, r, orig_a, orig_b
	
	IF b > a THEN a, b := swap(a, b)	->ensure a >= b
	IF b = 0 THEN RETURN a, 1, 0
	
	orig_a := a
	orig_b := b
	x2 := 1 ; x1 := 0
	y2 := 0 ; y1 := 1
	WHILE b <> 0
		r, q := Mod(a, b)
		a := b
		b := r
		
		x := x2 - (q*x1)
		y := y2 - (q*y1)
		x2 := x1
		x1 := x
		y2 := y1
		y1 := y
	ENDWHILE
	
	->IF a > 1 THEN x2 := -1
	->IF a > 1 THEN y2 := -1	->or should this check the value of "b"?
	
	IF x2 < 0 THEN x2 := x2 + orig_b
	IF y2 < 0 THEN y2 := y2 + orig_a	-># is this correct?
	gcd := a ; x := x2 ; y := y2
ENDPROC
PRIVATE
PROC swap(a, b) IS b, a
PUBLIC
*/

/*****************************/

PROC bigMax(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE IS IF a > b THEN a ELSE b

PROC bigMin(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE IS IF a < b THEN a ELSE b

PROC bigAbs(a:BIGVALUE) IS IF a >= 0 THEN a ELSE -a

->WARNING: The returned "d" value is WRONG, due to a PortablE bug that truncates it to 32-bits.
PROC bigMod(a:BIGVALUE, b) RETURNS c ->#, d:BIGVALUE
DEF d:BIGVALUE->#
	d := a / b
	c := a - (d * b) !!VALUE
ENDPROC

->temporary work-around for PortablE bug
PROC bigModReversed(a:BIGVALUE, b) RETURNS d:BIGVALUE, c
	d := a / b
	c := a - (d * b) !!VALUE
ENDPROC

PROC bigSign(a:BIGVALUE) RETURNS sign:RANGE -1 TO 1 IS IF a=0 THEN 0 ELSE IF a<0 THEN -1 ELSE 1


/*****************************/
