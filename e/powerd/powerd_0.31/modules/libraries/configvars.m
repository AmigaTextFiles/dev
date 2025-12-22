MODULE 'exec/nodes','libraries/configregs'

OBJECT ConfigDev
  Node:LN,
  Flags:UBYTE,
  Pad:UBYTE,
  Rom:ExpansionROM,
  BoardAddr:APTR,
  BoardSize:ULONG,
  SlotAddr:UWORD,
  SlotSize:UWORD,
  Driver:APTR,
  NextCD:PTR TO ConfigDev,
  Unused[4]:ULONG

FLAG CD_SHUTUP,
    CD_CONFIGME,
    CD_BADMEMORY,
    CD_PROCESSED

OBJECT CurrentBinding
  ConfigDev:PTR TO ConfigDev,
  FileName:PTR TO UBYTE,
  ProductString:PTR TO UBYTE,
  ToolTypes:PTR TO PTR TO UBYTE
