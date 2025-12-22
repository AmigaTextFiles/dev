
-> lexStream is a lexical analyser for interpreters/compilers.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/any','fw/token'

-> lexical tokens and reserved words.
DEF lexTokens:PTR TO token

OBJECT lexStream OF any
  last:INT               -> last lexical token
  value:LONG             -> numeral value
  ident:PTR TO CHAR      -> current identifier
  line:INT               -> current line
  pos:PTR TO CHAR        -> current position in text
  text:PTR TO CHAR       -> source text
  storedLine:INT         -> stored line
  storedPos:INT          -> stored position
  storedLast:INT         -> stored lexical token
ENDOBJECT

-> Spell all lexical tokens for the analyser.
PROC spellTokenSet(tokenList:PTR TO LONG) OF lexStream
  DEF tok:PTR TO token
  DEF start
  start:=tokenList[]++
  lexTokens:=NEW tok.newToken(tokenList[]++,start++)
  WHILE tokenList[]
    lexTokens.add(NEW tok.newToken(tokenList[]++,start++))
  ENDWHILE
ENDPROC

-> Set source file to be scanned.
-> Lexical tokens should not be longer than 40 characters.
PROC attachStream(fileName:PTR TO CHAR) OF lexStream HANDLE
  DEF handle=NIL,length
  IF self.text THEN self.detachStream()
  length:=FileLength(fileName)
  IF (handle:=Open(fileName,OLDFILE))=NIL THEN Raise("OPEN")
  self.text:=NewR(length+2)
  IF Read(handle,self.text,length)<length THEN Raise("IN")
  self.text[length]:="\0"
  self.pos:=self.text
  self.line:=1
  self.ident:=String(40)
  self.read()
EXCEPT DO
  IF handle THEN Close(handle)
  ReThrow()
ENDPROC

-> Detach source file scanned.
-> MUST be preceded by an 'attachStream()' call.
PROC detachStream() OF lexStream
  Dispose(self.text)
  self.text:=NIL
ENDPROC

-> Read next lexical token from the text.
-> Update line, pos, last, value, ident.
PROC read() OF lexStream IS EMPTY

-> Store text position.
PROC store() OF lexStream
  self.storedLine:=self.line
  self.storedPos:=self.pos-self.text
  self.storedLast:=self.last
ENDPROC

-> Restore text position.
PROC restore() OF lexStream
  self.line:=self.storedLine
  self.pos :=self.text+self.storedPos
  self.last:=self.storedLast
ENDPROC

