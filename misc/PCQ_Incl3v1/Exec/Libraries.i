
{ 
		exec/libraries.i
}

{$I "Include:exec/nodes.i" }

CONST

{ ------ Special Constants --------------------------------------- }
  LIB_VECTSIZE	=  6;	{  Each library entry takes 6 bytes  }
  LIB_RESERVED	=  4;	{  Exec reserves the first 4 vectors  }
  LIB_BASE	= (-LIB_VECTSIZE);
  LIB_USERDEF	= (LIB_BASE-(LIB_RESERVED*LIB_VECTSIZE));
  LIB_NONSTD	= (LIB_USERDEF);

{ ------ Standard Functions -------------------------------------- }
  LIB_OPEN	=  -6;
  LIB_CLOSE	= -12;
  LIB_EXPUNGE	= -18;
  LIB_EXTFUNC	= -24;	{  for future expansion  }

TYPE

{ ------ Library Base Structure ---------------------------------- }
{  Also used for Devices and some Resources  }

Library = record
    lib_Node  : Node;
    lib_Flags,
    lib_pad   : Byte;
    lib_NegSize,	    {  number of bytes before library  }
    lib_PosSize,	    {  number of bytes after library  }
    lib_Version,	    {  major  }
    lib_Revision : Short;   {  minor  }
    lib_IdString : String;  {  ASCII identification  }
    lib_Sum      : Integer; {  the checksum itself  }
    lib_OpenCnt  : Short;   {  number of current opens  }
end;			    {  * Warning: size is not a longword multiple ! * }
LibraryPtr = ^Library;

CONST

{  lib_Flags bit definitions (all others are system reserved)  }

  LIBF_SUMMING = %00000001;	{  we are currently checksumming  }
  LIBF_CHANGED = %00000010;	{  we have just changed the lib  }
  LIBF_SUMUSED = %00000100;	{  set if we should bother to sum  }
  LIBF_DELEXP  = %00001000;	{  delayed expunge  }



Procedure AddLibrary(lib : LibraryPtr);
    External;

Procedure CloseLibrary(lib : LibraryPtr);
    External;

Function MakeFunctions(target, functionarray, dispbase : Address) : Integer;
    External;

Function MakeLibrary(vec, struct, init : Address;
			dSize : Integer;
			segList : Address) : LibraryPtr;
    External;

Function OpenLibrary(libName : String; version : Integer) : LibraryPtr;
    External;

Procedure RemLibrary(library : LibraryPtr);
    External;

Function SetFunction(library : LibraryPtr;
			funcOff : Integer;
			funcEntry : Address) : Address;
    External;

Procedure SumLibrary(library : LibraryPtr);
    External;

