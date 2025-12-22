MODULE Frags ; (* This program will read from first 4K of memory *)

IMPORT
  E := Exec, Dos{37} ;

CONST
  sizes   = 20 ;
  minSize =  3 ;
  maxSize = sizes+minSize-1 ;

PROCEDURE main( ) ;

  VAR
    b      : INTEGER ;
    counts : ARRAY [0..sizes-1] OF INTEGER ;
    chunk  : E.MemChunkPtr ;
    mem	   : E.MemHeaderPtr ;

BEGIN
  FOR b := 0 TO sizes-1 DO counts[b] := 0 END ;

  E.Forbid() ;
  mem := E.MemHeaderPtr(E.SysBase^.MemList.lh_Head) ;
  WHILE mem^.mh_Node.ln_Succ # NIL DO
    chunk := mem^.mh_First ;
    WHILE chunk # NIL DO
      b := maxSize ;
      LOOP
	IF b < minSize THEN EXIT END ;
	IF b IN LONGSET(chunk^.mc_Bytes) THEN INC(counts[b-minSize]); EXIT END ;
	DEC(b)
      END ;
      chunk := chunk^.mc_Next ;
    END ;
    mem := E.MemHeaderPtr(mem^.mh_Node.ln_Succ) ;
  END ;
  E.Permit() ;

  Dos.Printf(" Free memory size distribution:\n") ;
  Dos.Printf("     Size  Count\n") ;
  FOR b := minSize TO maxSize DO
    Dos.Printf(" %8ld: %4ld\n", {b}, counts[b-minSize])
  END

END main ;

BEGIN main()
END Frags.
