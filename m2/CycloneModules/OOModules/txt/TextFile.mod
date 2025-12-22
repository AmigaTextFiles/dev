IMPLEMENTATION MODULE TextFile;

FROM SYSTEM IMPORT ADDRESS;
IMPORT fs:FileSystem,String,H:Heap;


CONSTRUCTOR TText.Init;
BEGIN
 root:=NIL; 
 last:=NIL;
 lines:=0; maxlen:=0;
END TText.Init;

PROCEDURE TText.AddLine(txt:ARRAY OF CHAR);
VAR l:LONGINT;
    new:TextRecPtr;
BEGIN
 l:=String.Length(txt);
 IF l>maxlen THEN maxlen:=l; END;
 H.Allocate(new,SIZE(TextRec)-MaxTextLen+l+2);
 WITH new^ DO
  len:=l;
  String.Copy(text,txt);
  next:=NIL;
  prev:=last;
 END;
 IF new^.prev=NIL THEN root:=new; ELSE new^.prev^.next:=new; END;
 last:=new;
 INC(lines); 
END TText.AddLine;

PROCEDURE TText.InsertLine(p:TextRecPtr;txt:ARRAY OF CHAR);
VAR l:LONGINT;
    new:TextRecPtr;
BEGIN
 l:=String.Length(txt);
 IF l>maxlen THEN maxlen:=l; END;
 H.Allocate(new,SIZE(TextRec)-MaxTextLen+l+2);
 WITH new^ DO
  len:=l;
  String.Copy(text,txt);
  next:=NIL;
  prev:=NIL;
  IF p#NIL THEN
    prev:=p^.prev;
    next:=p;
    p^.prev:=new;
    IF prev=NIL THEN root:=new; ELSE prev^.next:=new; END;
  END;
 END;
 INC(lines); 
END TText.InsertLine;

PROCEDURE TText.DeleteLine(p:TextRecPtr);
VAR tmp:TextRecPtr;
BEGIN
 IF p#NIL THEN
  IF p^.next#NIL THEN p^.next^.prev:=p^.prev; ELSE last:=p^.prev; END; 
  IF p^.prev#NIL THEN p^.prev^.next:=p^.next; ELSE root:=p^.next; END; 
  DEC(lines);
  H.Deallocate(p);
 END;
END TText.DeleteLine;

PROCEDURE TText.ReadText(name:ARRAY OF CHAR):BOOLEAN;
VAR f:fs.File;
    eof:BOOLEAN;
    t:ARRAY[0..MaxTextLen] OF CHAR;
    i:LONGINT;
    ch:CHAR;
BEGIN
 fs.Lookup(f,name,FALSE);
 IF f.res#fs.done THEN RETURN FALSE END;
 i:=0;
 fs.ReadChar(f,ch);
 WHILE (f.res=fs.done) & ~f.eof DO
   IF ch='\n' THEN t[i]:=0C; AddLine(t); i:=0; ELSE t[i]:=ch; INC(i) END;
   fs.ReadChar(f,ch);
 END;
 eof:=f.eof;
 fs.Close(f);
 RETURN eof; 
END TText.ReadText;


PROCEDURE TText.GetLine(l:LONGINT):ADDRESS;
VAR temp:TextRecPtr;
    i:LONGINT;
BEGIN
 temp:=root;
 WHILE (temp#NIL) & (i<l) DO
  temp:=temp^.next;
  INC(i);
 END;
 RETURN temp;
END TText.GetLine;

PROCEDURE TText.Free;
VAR
 old:TextRecPtr;
BEGIN
 WHILE root#NIL DO
   old:=root;
   root:=root^.next;
   H.Deallocate(old);
 END;
 lines:=0; maxlen:=0; root:=NIL;
END TText.Free;

BEGIN
END TextFile.
