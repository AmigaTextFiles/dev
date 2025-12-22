-> findboards.e

->>> Header (globals)
OPT PREPROCESS

MODULE 'expansion',
       'libraries/configregs',
       'libraries/configvars'

ENUM ERR_NONE, ERR_LIB

RAISE ERR_LIB IF OpenLibrary()=NIL

-> E-Note: used to convert an INT to unsigned
#define UNSIGNED(x) ((x) AND $FFFF)
-> E-Note: used to convert a LONG to unsigned CHAR
#define UNSIGNEDCHAR(x) ((x) AND $FF)
->>>

->>> PROC main()
PROC main() HANDLE
  DEF myCD:PTR TO configdev, m, i, p, f, t
  expansionbase:=OpenLibrary('expansion.library', 0)
  
  -> FindConfigDev(oldConfigDev,manufacturer,product)
  -> oldConfigDev = NIL for the top of the list
  -> manufacturer = -1 for any manufacturer
  -> product      = -1 for any product
  myCD:=NIL
  WHILE myCD:=FindConfigDev(myCD, -1, -1)  -> Search for all ConfigDevs
    WriteF('\n---ConfigDev structure found at location $\h---\n', myCD)

    -> These values were read directly from the board at expansion time
    WriteF('Board ID (ExpansionRom) information:\n')

    t:=myCD.rom.type
    m:=UNSIGNED(myCD.rom.manufacturer)
    p:=myCD.rom.product
    f:=myCD.rom.flags
    i:=UNSIGNED(myCD.rom.initdiagvec)

    WriteF('er_Manufacturer         =\d=$\z\h[4]=(~$\h[4])\n',
           m, m, UNSIGNED(Not(m)))
    WriteF('er_Product              =\d=$\z\h[2]=(~$\h[2])\n',
           p, p, UNSIGNEDCHAR(Not(p)))

    WriteF('er_Type                 =$\z\h[2]', myCD.rom.type)
    IF myCD.rom.type AND ERTF_MEMLIST
      WriteF('  (Adds memory to free list)\n')
    ELSE
      WriteF('\n')
    ENDIF

    WriteF('er_Flags                =$\z\h[2]=(~$\h[2])\n',
           f, UNSIGNEDCHAR(Not(f)))
    WriteF('er_InitDiagVec          =$\z\h[4]=(~$\h[4])\n',
           i, UNSIGNED(Not(i)))

    -> These values are generated when the AUTOCONFIG(tm) software relocates
    -> the board
    WriteF('Configuration (ConfigDev) information:\n')
    WriteF('cd_BoardAddr            =$\h\n', myCD.boardaddr)
    WriteF('cd_BoardSize            =$\h (\dK)\n',
               myCD.boardsize, myCD.boardsize/1024)

    WriteF('cd_Flags                =$\h', myCD.flags)
    IF myCD.flags AND CDF_CONFIGME
      WriteF('\n')
    ELSE
      WriteF('  (driver clears CONFIGME bit)\n')
    ENDIF
  ENDWHILE
EXCEPT DO
  IF expansionbase THEN CloseLibrary(expansionbase)
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: could not open expansion library\n')
  ENDSELECT
ENDPROC
->>>

