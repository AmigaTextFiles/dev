-> Get_Disk_Unit_ID.e - Example of getting the UnitID of a disk

OPT PREPROCESS

-> E-Note: E does not (as of v3.1a) support Resources in the conventional way
MODULE 'other/disk',
       'resources/disk'

PROC main()
  DEF ids, type
  IF NIL=(diskbase:=OpenResource(DISKNAME))
    WriteF('Cannot open \s\n', DISKNAME)  -> E-Note: big typo in C version
  ELSE
    WriteF('Defined drive types are:\n')
    WriteF('  AMIGA  $00000000\n')
    WriteF('  5.25"  $55555555\n')
    WriteF('  AMIGA  $00000000 (high density)\n')  -> Commodore-only product
    WriteF('  None   $FFFFFFFF\n\n')

    -> What are the UnitIDs?
    FOR ids:=0 TO 3
      type:=getUnitID(ids)
      WriteF('The UnitID for unit \d is $\z\h[8]\n', ids, type)
    ENDFOR
  ENDIF
ENDPROC
