OPT	PPC,NOEXE,NOSTD

PROC Out(fh:PTR,char:L)(L) IS Write(fh,[char,0]:CHAR,1)
