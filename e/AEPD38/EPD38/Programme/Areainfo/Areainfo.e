MODULE 'graphics/rastport'
MODULE 'exec/memory'

CONST VECTORS=10000

PROC main()

 DEF areabuffer,area:PTR TO areainfo


 IF(gfxbase := OpenLibrary('graphics.library',0))

  IF(areabuffer := AllocMem(VECTORS*5,MEMF_ANY OR MEMF_CLEAR))

	InitArea(area,areabuffer,VECTORS);

	Vprintf('Adresse Speicherblock : %08lx\n',[areabuffer]);
	Vprintf('Adresse VectorTable   : %08lx\n',[area.vctrtbl]);
	Vprintf('Adresse FlagTable     : %08lx\n',[area.flagtbl]);

	FreeMem(areabuffer,VECTORS * 5);
  ENDIF

  CloseLibrary(gfxbase);
  ENDIF
ENDPROC
