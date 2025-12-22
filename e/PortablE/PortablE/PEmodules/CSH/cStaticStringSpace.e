/* cStaticStringSpace.e 24-05-2014
	A fast name-space class for static strings.

Copyright (c) 2010,2014  Christopher Steven Handley ( http://cshandley.co.uk/email )
*/ /*
WARNING:  Replacing, removing or deleting a key will temporarily cause this
class to be no faster than cStringSpace.  This could be fixed, at the expense of
some memory overhead (an extra node per item).
*//* Public methods of cStaticStringSpace class:
infoAutoDealloc() RETURNS autoDealloc:BOOL
infoCaseSensitive() RETURNS caseSensitive
delete(key:ARRAY OF CHAR) RETURNS existed:BOOL
set(key:ARRAY OF CHAR, data:POSSIBLY OWNS PTR TO class, doNotReplace=FALSE:BOOL) RETURNS unstoredData:PTR TO class, alreadyExisted:BOOL
get(key:ARRAY OF CHAR, remove=FALSE:BOOL, keyNotStatic=FALSE:BOOL) RETURNS data:POSSIBLY OWNS PTR TO class
NEW new(autoDealloc=FALSE:BOOL, caseSensitive=NORMAL)

itemGotoFirst() RETURNS success:BOOL
itemGotoNext() RETURNS success:BOOL
itemInfo() RETURNS data:PTR TO class, key:ARRAY OF CHAR
*//*****************************/

PUBLIC MODULE 'CSH/cStringSpace'
MODULE 'CSH/cNumberSpace'
PRIVATE
CLASS q;PRIVATE;q:LONG;ENDCLASS
PUBLIC
CLASS cStaticStringSpace;PRIVATE;q:PTR TO cStringSpace;qq:PTR TO cNumberSpace;ENDCLASS
PRIVATE
DEF q:ARRAY OF CHAR,qq:ARRAY OF CHAR,qqp:ARRAY OF CHAR,qqq:ARRAY OF CHAR,qqpp:ARRAY OF CHAR,qqpq:ARRAY OF CHAR,qqqp:ARRAY OF CHAR
PROC main();DEF qqqq:PTR TO cStaticStringSpace,qqppp:ARRAY OF CHAR,qqppq:ARRAY OF CHAR,qqpqp:PTR TO q,qqpqq:PTR TO q,qqqpp:PTR TO q,qqqpq:PTR TO q; qqppp := q ; qqppq := qq ; NEW qqqq.new(8577676 XOR -$82E28D , 1977671340 XOR -$A1F2154); qqpqq := qqqq.set(qqppp, NEW qqpqp.q(65786 XOR $10081), 2016542360 XOR $7831FE98)::q; Print(qqp , IF qqpqq THEN qqpqq .q ELSE -(471566 XOR $731E9)); qqqpp := qqqq.set(qqppq, NEW qqpqp.q(8198851 XOR $7D1B0B), 580833620 XOR $229ED154)::q; Print(qqq , IF qqqpp THEN qqqpp .q ELSE -(471566 XOR $731E9)); qqqpq := qqqq.get(qqppp, 918898992 XOR $36C54930)::q; Print(qqpp , IF qqqpq THEN qqqpq .q ELSE -(471566 XOR $731E9)); Print(qqpq );FINALLY; PrintException(); END qqqq;ENDPROC
PROC new() ;; q := 'test string'; qq := 'test string'; qqp := '\d (set 123)\n\n'; qqq := '\d (set 456)\n\n'; qqpp := '\d (get)\n\n'; qqpq := 'Done\n'; qqqp := 'END \d\n';ENDPROC
PROC q(qqqq:LONG) NEW OF q;; self.q := qqqq;ENDPROC
PROC end() OF q;; Print(qqqp , self.q);ENDPROC
PUBLIC
PROC new(qqqq=918898992 XOR $36C54930:BOOL, qqppp=1977671340 XOR -$A1F2154) NEW OF cStaticStringSpace;; NEW self.q.new(qqqq, qqppp); NEW self.qq.new(1880172104 XOR $70112648);ENDPROC
PROC end() OF cStaticStringSpace;; END self.q; END self.qq; SUPER self.end();ENDPROC
PROC infoAutoDealloc() OF cStaticStringSpace RETURNS qqqq:BOOL  IS self.q.infoAutoDealloc()
PROC infoCaseSensitive() OF cStaticStringSpace RETURNS qqqq IS self.q.infoCaseSensitive()
PRIVATE
PROC q() OF cStaticStringSpace;; IF self.qq.itemGotoFirst(); END self.qq; NEW self.qq.new(155153 XOR $25E11); ENDIF;ENDPROC
PUBLIC
PROC get(qqqq:ARRAY OF CHAR, qqppp=124678924 XOR $76E730C:BOOL, qqppq=3973987 XOR $3CA363:BOOL) OF cStaticStringSpace;DEF qqpqp:PTR TO class; IF qqppp = (1500200112 XOR $596B3CB0)  AND (qqppq = (474792 XOR $73EA8)); qqpqp := self.qq.get(qqqq); ELSE; qqpqp := NIL; ENDIF; IF qqpqp = (404272 XOR $62B30); qqpqp := self.q.get(qqqq, qqppp); IF qqppp = (49105958 XOR $2ED4C26); IF qqpqp THEN IF qqppq = (3057998 XOR $2EA94E) THEN self.qq.set(qqqq, qqpqp); ELSE; self.q(); ENDIF; ENDIF;ENDPROC qqpqp 
PROC set(qqqq:ARRAY OF CHAR, qqppp:PTR TO class, qqppq=303236 XOR $4A084:BOOL) OF cStaticStringSpace;DEF qqpqp:PTR TO class,qqpqq:BOOL; qqpqp, qqpqq := self.q.set(qqqq, qqppp, qqppq); IF qqpqq = (25649723 XOR $187623B); self.qq.set(qqqq, qqppp); ELSE; self.q() ; ENDIF;ENDPROC qqpqp ,qqpqq 
PROC delete(qqqq:ARRAY OF CHAR) OF cStaticStringSpace;DEF qqppp:BOOL; qqppp := self.q.delete(qqqq); IF qqppp THEN self.q();ENDPROC qqppp 
PROC itemGotoFirst() OF cStaticStringSpace RETURNS qqqq:BOOL  IS self.q.itemGotoFirst()
PROC itemGotoNext() OF cStaticStringSpace RETURNS qqqq:BOOL  IS self.q.itemGotoNext()
PROC itemInfo() OF cStaticStringSpace;DEF qqqq:PTR TO class,qqppp:ARRAY OF CHAR; qqqq, qqppp := self.q.itemInfo();ENDPROC qqqq ,qqppp 
