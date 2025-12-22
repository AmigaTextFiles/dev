-> MODULE for lc17.e
-> AUTHOR : leif_salomonsson@swipnet.se

OPT MODULE

OPT LARGE

-> 991205 : added support for '//', skips rest of line
-> 991220 : removing above, added support for ; comment..
-> sometime.. : added support for transforming ( ) ,
-> to SPACEs... IF they are NOT inside " " .
-> turn it off with ew.setMode(EW_MODE2)

EXPORT OBJECT extractwords
   PRIVATE
   nrofwords
   wordptrs:PTR TO LONG
   buffer:PTR TO CHAR
   bufsize
   maxnrofwords
   mode:CHAR
ENDOBJECT

EXPORT CONST EW_MODE1=1, EW_MODE2=2

PROC setMode(mode) OF extractwords
   self.mode := mode
ENDPROC

PROC getWord(num) OF extractwords IS self.wordptrs[num]

PROC getNrOfWords() OF extractwords IS self.nrofwords

PROC getArray() OF extractwords IS self.wordptrs

PROC new(maxnrofwords, bufsize) OF extractwords
   bufsize := bufsize + 10
   maxnrofwords++
   self.buffer := FastNew(bufsize)
   self.bufsize := bufsize
   self.maxnrofwords := maxnrofwords
   self.wordptrs := FastNew(maxnrofwords * 4)
   self.mode := EW_MODE1
ENDPROC

PROC extract(line:PTR TO CHAR) OF extractwords
   DEF buf:REG PTR TO CHAR
   DEF a:REG
   DEF insen=FALSE
   self.nrofwords := NIL
   AstrCopy(self.buffer+1, line, (self.bufsize)-2)

   buf := self.buffer
   buf++
   WHILE (buf[] <> 10) AND (buf[] <> NIL)
     buf++
   ENDWHILE
   buf[] :=NIL
   buf[1]:= NIL

   buf := self.buffer
   FOR a := 0 TO (self.maxnrofwords)-1
      self.wordptrs[a] := NIL
   ENDFOR
   REPEAT          -> 34 = "
      buf++
      IF buf[] = 34
         IF insen = FALSE THEN insen := TRUE ELSE insen := FALSE
      ENDIF
      IF insen = FALSE
         IF      buf[] = " "
            buf[] := NIL
         ELSEIF (buf[] = ",") AND (self.mode = EW_MODE1)
            buf[] := NIL
         ELSEIF (buf[] = "(") AND (self.mode = EW_MODE1)
            buf[] := NIL
         ELSEIF (buf[] = ")") AND (self.mode = EW_MODE1)
            buf[] := NIL
         ENDIF
      ENDIF
      IF buf[] = ";" THEN RETURN self.nrofwords
      IF (buf[-1] = NIL) AND (buf[] <> NIL)
         IF self.nrofwords = self.maxnrofwords THEN RETURN self.nrofwords
         self.wordptrs[self.nrofwords] := buf
         self.nrofwords := (self.nrofwords) + 1
      ENDIF
   UNTIL (buf[] = NIL) AND (buf[1] = NIL)
ENDPROC self.nrofwords

PROC end() OF extractwords
   FastDispose(self.buffer, self.bufsize)
   FastDispose(self.wordptrs, (self.maxnrofwords) * 4)
ENDPROC
