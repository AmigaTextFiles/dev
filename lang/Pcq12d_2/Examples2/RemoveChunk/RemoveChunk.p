Program RemoveChunk;

{ Utility, um ueberfluessige Chunks (z.B. GRAB, CRNG, AUTH)
  aus IFF-Datei zu entfernen.

  Autor: Andreas Tetzl

  Public Domain
}

{$I "Include:Exec/Memory.i"}
{$I "Include:DOS/DOS.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Utils/Parameters.i"}

const Version = "$VER: RemoveChunk 1.0 (18.2.96) Andreas Tetzl";

VAR source, dest : FileHandle;
    buffer : String;
    chunkbuf : Address;
    sourcename, destname, chunk : String;
    i, s : Integer;
    chunkfound : Boolean;

FUNCTION MAKE_ID(Str : String) : Integer;
BEGIN
 MAKE_ID:=(Ord(Str[0]) shl 24) OR (Ord(Str[1]) shl 16) OR (Ord(Str[2]) shl 8) OR (Ord(Str[3]));
END;


BEGIN
 chunkfound:=FALSE;
 sourcename:=AllocString(500);
 destname:=AllocString(500);
 chunk:=AllocString(20);
 buffer:=AllocString(20);

 GetParam(1, sourcename);
 GetParam(2, destname);
 GetParam(3, chunk);

 if StrEq(sourcename,"") or StrEq(destname,"") or StrEq(chunk,"") then
  BEGIN
   Writeln("Usage: RemoveChunk Source Destination IFFChunkName");
   Exit(0);
  END;

 source:=DOSOpen(sourcename,MODE_OLDFILE);
 if source=NIL then
  BEGIN
   writeln("can't open source file");
   Exit(10);
  END;

 i:=DOSRead(source,buffer,4);
 if MAKE_ID(buffer)<>MAKE_ID("FORM") then
  BEGIN
   DOSClose(source);
   writeln("no iff file");
   Exit(10);
  END;

 dest:=DOSOpen(destname,MODE_NEWFILE);
 if dest=NIL then
  BEGIN
   DOSClose(source);
   writeln("can't open destination file");
   Exit(10);
  END;

 i:=DOSWrite(dest,buffer,4);
 i:=DOSRead(source,buffer,8);  { read filesize, filetype }
 i:=DOSWrite(dest,buffer,8);

 Repeat
  i:=DOSRead(source,buffer,4);     { read chunk name }
  i:=DOSRead(source,adr(s),4);     { read chunk size }

  if i=0 then   { end of file }
   BEGIN
    DOSClose(source);
    DOSClose(dest);
    if chunkfound then
     Writeln("chunk ",chunk," removed")
    else
     Writeln("chunk ",chunk," not found");
    Exit(0);
   END;

  chunkbuf:=AllocVec(s,MEMF_ANY);
  if chunkbuf=NIL then
   BEGIN
    DOSClose(source);
    DOSClose(dest);
    Writeln("not enough memory");
    Exit(20);
   END;

  i:=DOSRead(source,chunkbuf,s);     { read chunk data }

  if MAKE_ID(buffer)<>MAKE_ID(chunk) then
   BEGIN
    i:=DOSWrite(dest,buffer,4);     { write chunk name }
    i:=DOSWrite(dest,adr(s),4);     { write chunk size }
    i:=DOSWrite(dest,chunkbuf,s);   { write chunk data }
   END
  ELSE chunkfound:=TRUE;

  FreeVec(ChunkBuf);
 Until FALSE;
END.

