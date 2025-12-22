/* PE/AmigaE/EList.e */
OPT NATIVE, INLINE
MODULE 'target/PE/base', 'PE/AmigaE/EString'

PROC NewList(maxLen) IS NATIVE {List(} maxLen {)} ENDNATIVE !!LIST
PROC DisposeList(list:LIST) IS NATIVE {DisposeLink(} list {)} ENDNATIVE BUT NILL
PROC ListCopy(list: LIST, other:ILIST, len=ALL) IS NATIVE {ListCopy(} list {,} other {,} len {)} ENDNATIVE !!LIST
PROC ListAdd( list: LIST, other:ILIST, len=ALL) IS NATIVE {ListAdd(} list {,} other {,} len {)} ENDNATIVE !!LIST
PROC ListCmp( list:ILIST, other:ILIST, len=ALL) IS NATIVE {ListCmp(} list {,} other {,} len {)} ENDNATIVE !!BOOL
PROC ListMax( list: LIST) IS NATIVE {ListMax(} list {)} ENDNATIVE !!VALUE
PROC ListLen( list:ILIST) IS NATIVE {ListLen(} list {)} ENDNATIVE !!VALUE
PROC ListItem(list:ILIST, index) IS NATIVE {ListItem(} list {,} index {)} ENDNATIVE !!VALUE
PROC SetList( list: LIST, newLen) IS NATIVE {SetList(} list {,} newLen {)} ENDNATIVE


PROC PrintL(fmtString:ARRAY OF CHAR, args=NILL:ILIST) REPLACEMENT
	DEF alen
	alen := IF args THEN ListLen(args) ELSE 0
	IF alen > 20 THEN Throw("EPU", 'PrintL(); args has too many items')
	NATIVE {PrintF(} fmtString {,} IF alen >= 1 THEN args[0] ELSE 0 {,} IF alen >= 2 THEN args[1] ELSE 0 {,} IF alen >= 3 THEN args[2] ELSE 0 {,} IF alen >= 4 THEN args[3] ELSE 0 {,} IF alen >= 5 THEN args[4] ELSE 0 {,} IF alen >= 6 THEN args[5] ELSE 0 {,} IF alen >= 7 THEN args[6] ELSE 0 {,} IF alen >= 8 THEN args[7] ELSE 0 {,} IF alen >= 9 THEN args[8] ELSE 0 {,} IF alen >= 10 THEN args[9] ELSE 0 {,} IF alen >= 11 THEN args[10] ELSE 0 {,} IF alen >= 12 THEN args[11] ELSE 0 {,} IF alen >= 13 THEN args[12] ELSE 0 {,} IF alen >= 14 THEN args[13] ELSE 0 {,} IF alen >= 15 THEN args[14] ELSE 0 {,} IF alen >= 16 THEN args[15] ELSE 0 {,} IF alen >= 17 THEN args[16] ELSE 0 {,} IF alen >= 18 THEN args[17] ELSE 0 {,} IF alen >= 19 THEN args[18] ELSE 0 {,} IF alen >= 20 THEN args[19] ELSE 0 {)} ENDNATIVE
ENDPROC

PROC StringFL(eString:STRING, fmtString:ARRAY OF CHAR, args=NILL:ILIST) REPLACEMENT
	DEF alen, len
	alen := IF args THEN ListLen(args) ELSE 0
	IF alen > 20 THEN Throw("EPU", 'StringFL(); args has too many items')
	eString, len := StringF2(eString, fmtString, IF alen >= 1 THEN args[0] ELSE 0, IF alen >= 2 THEN args[1] ELSE 0, IF alen >= 3 THEN args[2] ELSE 0, IF alen >= 4 THEN args[3] ELSE 0, IF alen >= 5 THEN args[4] ELSE 0, IF alen >= 6 THEN args[5] ELSE 0, IF alen >= 7 THEN args[6] ELSE 0, IF alen >= 8 THEN args[7] ELSE 0, IF alen >= 9 THEN args[8] ELSE 0, IF alen >= 10 THEN args[9] ELSE 0, IF alen >= 11 THEN args[10] ELSE 0, IF alen >= 12 THEN args[11] ELSE 0, IF alen >= 13 THEN args[12] ELSE 0, IF alen >= 14 THEN args[13] ELSE 0, IF alen >= 15 THEN args[14] ELSE 0, IF alen >= 16 THEN args[15] ELSE 0, IF alen >= 17 THEN args[16] ELSE 0, IF alen >= 18 THEN args[17] ELSE 0, IF alen >= 19 THEN args[18] ELSE 0, IF alen >= 20 THEN args[19] ELSE 0)
ENDPROC eString, len

PRIVATE
PROC StringF2(eString:STRING, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0, arg9=0, arg10=0, arg11=0, arg12=0, arg13=0, arg14=0, arg15=0, arg16=0, arg17=0, arg18=0, arg19=0, arg20=0) 
->REPLACEMENT
	DEF len
	{} eString {,} len {:= StringF(} eString {,} fmtString {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {,} arg6 {,} arg7 {,} arg8 {,} arg9 {,} arg10 {,} arg11 {,} arg12 {,} arg13 {,} arg14 {,} arg15 {,} arg16 {,} arg17 {,} arg18 {,} arg19 {,} arg20 {)}
ENDPROC eString, len
PUBLIC
