OPT MODULE

OPT EXPORT

PROC readfile(name, memflags=NIL)
   DEF rl, len, mem, fh
   len:=FileLength(name)
   IF len < 1 THEN Throw("OPEN", name)
   mem:=NewM(len, memflags)
   fh:=Open(name, OLDFILE)
   IF fh = NIL THEN Raise("OPEN")
   rl:=Read(fh, mem, len)
   Close(fh)
   IF rl<>len THEN Raise("IN")
ENDPROC mem, len


PROC writefile(name, mem, len)
   DEF fh, wl
   fh:=Open(name, NEWFILE)
   IF fh = NIL THEN Throw("OUT", name)
   wl:=Write(fh, mem, len)
   Close(fh)
   IF wl<>len THEN Raise("OUT")
ENDPROC

PROC freefile(mem) IS Dispose(mem)




