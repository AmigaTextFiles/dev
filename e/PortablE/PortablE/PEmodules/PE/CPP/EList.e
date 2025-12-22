/* PE/CPP/EList.e 14-10-11
   A re-implementation of AmigaE's E-list functions.
   
   By Christopher S Handley:
   27-07-06 - Started coding it for PortablE.
   30-07-06 - Completed.
   14-08-06 - Updated to use the ILIST type.
   07-01-08 - Fixed DisposeList() bug.
   18-08-09 - Rewrote to store everything in it's array, rather than using an object as a header.
   06-02-11 - Added PrintL() & StringFL() functions (limited to lists of up to 8 items).
   25-05-11 - Improved PrintL() & StringFL() to handle lists of up to 20 items.
   14-10-11 - Fixed a potential threading issue.
*/
OPT INLINE, POINTER
OPT NATIVE
MODULE 'target/PE/base', 'PE/CPP/EString'

/* Emulated procedures:
NewList(maxLen) RETURNS list:LIST
DisposeList(list:LIST) RETURNS NILL
ListCopy(list: LIST, other:ILIST, len=ALL) RETURNS list:LIST
ListAdd( list: LIST, other:ILIST, len=ALL) RETURNS list:LIST
ListCmp( list:ILIST, other:ILIST, len=ALL) RETURNS match:BOOL
ListMax( list: LIST) RETURNS max:VALUE
ListLen( list:ILIST) RETURNS len:VALUE
ListItem(list:ILIST, index) RETURNS value
SetList( list: LIST, newLen)

PrintL(fmtString:ARRAY OF CHAR, args=NILL:ILIST)
*/

PRIVATE

CONST INDEX_LENGTH = -1
CONST INDEX_SIZE   = -2

CONST ITEM_SIZE = SIZEOF VALUE
CONST HEADER_SIZE   = 2			->PortablE is hard-coded to use a value of 2 for static ILISTs
CONST HEADER_OFFSET = HEADER_SIZE * ITEM_SIZE

PUBLIC

PROC InitList(array:ARRAY OF VALUE, maxLen) RETURNS list:LIST
	list := array + HEADER_OFFSET !!ARRAY!!LIST
	list[INDEX_LENGTH] := 0
	list[INDEX_SIZE]   := maxLen
ENDPROC

PROC NewList(maxLen) RETURNS list:LIST
	->use check
	IF maxLen < 0 THEN Throw("EPU", 'EList; NewList(); maxLen<0')
	
	->allocate e-list
	list := FastNew(maxLen + HEADER_SIZE * ITEM_SIZE, TRUE) + HEADER_OFFSET !!ARRAY!!LIST		->noClear=TRUE
	
	->init
	list[INDEX_LENGTH] := 0
	list[INDEX_SIZE]   := maxLen
ENDPROC

PROC DisposeList(list:LIST)
	IF list THEN FastDispose(list - HEADER_OFFSET, -999)	->could use "list[INDEX_SIZE] + HEADER_SIZE * ITEM_SIZE" instead of -999
ENDPROC NILL

PROC ListCopy(list:LIST, other:ILIST, len=ALL)
	->use check
	IF  list = NILL THEN Throw("EPU", 'EList; ListCopy(); list=NILL')
	IF other = NILL THEN Throw("EPU", 'EList; ListCopy(); other=NILL')
	IF (len < 0) AND (len <> ALL) THEN Throw("EPU", 'EList; ListCopy(); len<0')
	
	->empty e-list before appending to it
	list[INDEX_LENGTH] := 0
	ListAdd(list, other, len)
ENDPROC list

PROC ListAdd(list:LIST, other:ILIST, len=ALL)
	DEF readIndex, maxReadIndex
	DEF writeIndex, maxWriteIndex
	
	->use check
	IF  list = NILL THEN Throw("EPU", 'EList; ListAdd(); list=NILL')
	IF other = NILL THEN Throw("EPU", 'EList; ListAdd(); other=NILL')
	IF (len < 0) AND (len <> ALL) THEN Throw("EPU", 'EList; ListAdd(); len<0')
	
	->calc end of list reading from & writing to
	maxReadIndex  := IF len=ALL THEN other[INDEX_SIZE] ELSE Min(len, other[INDEX_SIZE])
	maxWriteIndex := list[INDEX_SIZE]
	
	->copy all characters that will fit
	readIndex  := 0
	writeIndex := list[INDEX_LENGTH]		->start writing past end of list
	WHILE (writeIndex < maxWriteIndex) AND (readIndex < maxReadIndex)
		list[writeIndex] := other[readIndex]
		
		writeIndex++
		readIndex++
	ENDWHILE
	
	->update list's stored length
	list[INDEX_LENGTH] := writeIndex
ENDPROC list

PROC ListCmp(list:ILIST, other:ILIST, len=ALL) RETURNS match:BOOL
	DEF index, maxIndex
	
	->use check
	IF  list = NILL THEN Throw("EPU", 'EList; ListCmp(); list=NILL')
	IF other = NILL THEN Throw("EPU", 'EList; ListCmp(); other=NILL')
	IF (len < 0) AND (len <> ALL) THEN Throw("EPU", 'EList; ListCmp(); len<0')
	
	IF list[INDEX_LENGTH] <> other[INDEX_LENGTH]
		match := FALSE
	ELSE
		->calc where should stop comparison
		maxIndex := Min(list[INDEX_SIZE], other[INDEX_SIZE])
		IF len <> ALL THEN maxIndex := Min(len, maxIndex)
		
		->compare all characters
		match := TRUE
		index := 0
		WHILE index < maxIndex
			IF list[index] <> other[index] THEN match := FALSE
			
			index++
		ENDWHILE IF match = FALSE
	ENDIF
ENDPROC

PROC ListMax(list:LIST) RETURNS max
	->use check
	IF list = NILL THEN Throw("EPU", 'EList; ListMax(); list=NILL')
	
	max := list[INDEX_SIZE]
ENDPROC

PROC ListLen(list:ILIST) RETURNS len
	->use check
	IF list = NILL THEN Throw("EPU", 'EList; ListLen(); list=NILL')
	
	len := list[INDEX_LENGTH]
ENDPROC

PROC ListItem(list:ILIST, index) RETURNS value
	->use check
	IF list = NILL THEN Throw("EPU", 'EList; ListLen(); list=NILL')
	
	->additional use check
	IF (index < 0) OR (index >= list[INDEX_LENGTH]) THEN Throw("EPU", 'EList; ListLen(); index exceeds list bounds')
	
	value := list[index]
ENDPROC

PROC SetList(list:LIST, newLen)
	->use check
	IF list = NILL THEN Throw("EPU", 'EList; SetList(); list=NILL')
	IF newLen < 0  THEN Throw("EPU", 'EList; SetList(); newLen<0')
	
	->additional use check
	IF newLen > list[INDEX_SIZE] THEN Throw("EPU", 'EList; SetList(); newLen exceeds list size')
	
	->set length
	list[INDEX_LENGTH] := newLen
ENDPROC


PROC PrintL(fmtString:ARRAY OF CHAR, args=NILL:ILIST) REPLACEMENT
	DEF alen
	alen := IF args THEN ListLen(args) ELSE 0
	IF alen > 20 THEN Throw("EPU", 'PrintL(); args has too many items')
	NATIVE {printf(} fmtString {,} IF alen >= 1 THEN args[0] ELSE 0 {,} IF alen >= 2 THEN args[1] ELSE 0 {,} IF alen >= 3 THEN args[2] ELSE 0 {,} IF alen >= 4 THEN args[3] ELSE 0 {,} IF alen >= 5 THEN args[4] ELSE 0 {,} IF alen >= 6 THEN args[5] ELSE 0 {,} IF alen >= 7 THEN args[6] ELSE 0 {,} IF alen >= 8 THEN args[7] ELSE 0 {,} IF alen >= 9 THEN args[8] ELSE 0 {,} IF alen >= 10 THEN args[9] ELSE 0 {,} IF alen >= 11 THEN args[10] ELSE 0 {,} IF alen >= 12 THEN args[11] ELSE 0 {,} IF alen >= 13 THEN args[12] ELSE 0 {,} IF alen >= 14 THEN args[13] ELSE 0 {,} IF alen >= 15 THEN args[14] ELSE 0 {,} IF alen >= 16 THEN args[15] ELSE 0 {,} IF alen >= 17 THEN args[16] ELSE 0 {,} IF alen >= 18 THEN args[17] ELSE 0 {,} IF alen >= 19 THEN args[18] ELSE 0 {,} IF alen >= 20 THEN args[19] ELSE 0 {)} ENDNATIVE
ENDPROC

PROC StringFL(eString:STRING, fmtString:ARRAY OF CHAR, args=NILL:ILIST) REPLACEMENT
	DEF alen, len
	alen := IF args THEN ListLen(args) ELSE 0
	IF alen > 20 THEN Throw("EPU", 'StringFL(); args has too many items')
	eString := StringF2(eString, fmtString, IF alen >= 1 THEN args[0] ELSE 0, IF alen >= 2 THEN args[1] ELSE 0, IF alen >= 3 THEN args[2] ELSE 0, IF alen >= 4 THEN args[3] ELSE 0, IF alen >= 5 THEN args[4] ELSE 0, IF alen >= 6 THEN args[5] ELSE 0, IF alen >= 7 THEN args[6] ELSE 0, IF alen >= 8 THEN args[7] ELSE 0, IF alen >= 9 THEN args[8] ELSE 0, IF alen >= 10 THEN args[9] ELSE 0, IF alen >= 11 THEN args[10] ELSE 0, IF alen >= 12 THEN args[11] ELSE 0, IF alen >= 13 THEN args[12] ELSE 0, IF alen >= 14 THEN args[13] ELSE 0, IF alen >= 15 THEN args[14] ELSE 0, IF alen >= 16 THEN args[15] ELSE 0, IF alen >= 17 THEN args[16] ELSE 0, IF alen >= 18 THEN args[17] ELSE 0, IF alen >= 19 THEN args[18] ELSE 0, IF alen >= 20 THEN args[19] ELSE 0, ADDRESSOF len)
ENDPROC eString, len

PRIVATE
PROC StringF2(eString:STRING, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0, arg9=0, arg10=0, arg11=0, arg12=0, arg13=0, arg14=0, arg15=0, arg16=0, arg17=0, arg18=0, arg19=0, arg20=0, returnLen=NILA:ARRAY OF VALUE)
->REPLACEMENT
	DEF max, len
	
	max := StrMax(eString)
	len := NATIVE {snprintf(} eString {,} max+1 {,} fmtString {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {,} arg6 {,} arg7 {,} arg8 {,} arg9 {,} arg10 {,} arg11 {,} arg12 {,} arg13 {,} arg14 {,} arg15 {,} arg16 {,} arg17 {,} arg18 {,} arg19 {,} arg20 {)} ENDNATIVE !!VALUE
	len := Min(len, max)
	SetStr(eString, len)
FINALLY
	IF returnLen THEN returnLen[0] := len
ENDPROC eString ->, len
PUBLIC
