/*
  LibHeader.c          Universal header file for libraries     V1.0
  Copyright(C) 1994    Jochen Wiedmann

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

  $RCSfile: $
  $Revision: $
  $Date: $

  Computer: Amiga 1200
  Compiler: Dice 3.01

  Author:     Jochen Wiedmann
              Am Eisteich 9
	      72555 Metzingen
	      Germany
	      Phone: 07123 / 14881
	      Internet: wiedmann@zdv.uni-tuebingen.de

  This code implements the usual startup code of the library. I
  recommend reading Appendix C (Sample Library Source Code) of the
  RKM: Libraries, Third Edition for a complete understanding of the
  following. Another good choice would be the shared library example
  of the Dice distribution.

  Your library should be implmented in another file. You must define the
  following preprocessor symbols with compiler options, when this file
  is compiled:
    LIBNAME:     Name of this library, "chess.library" for example
    LIBVERSION:  Library version, "40" for example
    LIBREVISION: Library revision, "1" for example

  The following preprocessor may be defined, but don't need to:
    LIBINITFUNC:  Function to be called when the library is opened the
                  first time to do library specific things. Will have the
		  library base pointer in register a6. (Default is no
		  library specific startup code.) This will typically open
		  other libraries or allocate some memory.
    LIBOPENFUNC:  Function to be called every time the library is opened.
                  Does not make much sense in most cases. (Default is no
		  library specific stuff.)
    LIBCLOSEFUNC: Function to be called every time when CloseLibrary() is
                  executed. This is the opponent to LIBCLOSEFUNC and does
		  not make much sense in most cases either. (Default is no
		  library specific stuff.)
    LIBTERMFUNC:  Function to be called before the library is removed out
                  of the RAM. This is the opponent to LIBINITFUNC and will
		  typically close other Libraries. (Default is no library
		  specific stuff.)
    LIBBASESIZE:  Size of the library base, "sizeof(struct Library)" for
                  example. (This is the default, if LIBBASESIZE isn't
		  defined.
    LIBFUNCTABLE: Name of the function table. (Default LibFuncTable)



  WARNINGS - WARNINGS - WARNINGS - WARNINGS - WARNINGS - WARNINGS - WARNINGS
    - This code depends heavily on some assumptions which are fulfilled
      by Dice:
        * All data declared as "const" will go to the code segment
        * The compiler doesn't rearrange the order of the data and code
          items.
    - You may use uninialized data items in your library code. However,
      the startup code will *not* clear the BSS segment. This means
      that you must not depend on an uninitialized variable being zero!
    - You may use the data and bss segment as usual. But remember that
      this data will be global to the library and hence shared by all
      users of the library. And don't forget to recreate the a4 register,
      if you use such data items! (Usually by adding __saveds or
      something similar to your functions.)

  EXAMPLE: To create the header of "chess.library", version 40.1 with library
  specific routines InitChessLib and CloseChessLib, and a "struct
  ChessLibBase" as library base you would do the following:

    dcc -DLIBNAME=chess.library -DLIBVERSION=40 -DLIBREVISION=1
        -DLIBINITFUNC=InitChessLib -DLIBTERMFUNC=CloseChessLib
	"-DLIBBASESIZE=sizeof(struct ChessLibBase)" -c ChessLib.c
*/





/****************************************************************************
  Include files
****************************************************************************/
#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif
#ifndef EXEC_RESIDENT_H
#include <exec/resident.h>
#endif
#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif
#ifndef EXEC_INITIALIZERS_H
#include <exec/initializers.h>
#endif
#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif
#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif
#ifndef PRAGMAS_EXEC_PRAGMAS_H
#include <pragmas/exec_pragmas.h>
#endif





/*****************************************************************************
  Compiler specific stuff (Handling register arguments)
*****************************************************************************/
#if defined(_DCC)
#define REG(x) __ ## x
#define SAVEDS __geta4
#define ASM
#define REGARGS __regargs
#else
#if defined(__SASC)
#define REG(x) register __ ## x
#define SAVEDS __saveds
#define ASM __asm
#define REGARGS __regargs
#else
#error "Don't know how to handle register arguments for your compiler."
#endif
#endif



/*
  This routine is an entry point if anyone might wish to run the library
  as an executable.
*/
STATIC LONG DummyStart(VOID){return(-1);}






/****************************************************************************
  Library name, ID and version string
****************************************************************************/
#define S(x) #x
const STATIC UBYTE LibName [] = S(LIBNAME);
const STATIC UBYTE IdString [] = S(LIBNAME) " " S(LIBVERSION) "." \
       S(LIBREVISION) " (" __DATE__ ")\r\n";
const STATIC UBYTE VerString [] = "\0$VER:" S(LIBNAME) " " S(LIBVERSION) "." \
       S(LIBREVISION) " (29.06.94)";






/*****************************************************************************
  The following table is used to initialize the library base. See
  exec.library/InitStruct() and "exec/initializers.i" for details.
*****************************************************************************/
const STATIC UWORD DataTable[] =  { 0xa000 + (int) OFFSET(Node, ln_Type),
				      NT_LIBRARY << 8,
				    0x8000 + (int) OFFSET(Node, ln_Name)
				  };
const STATIC ULONG DataTable1[] = { (ULONG) LibName };
const STATIC UWORD DataTable2[] = { 0xa000 + (int) OFFSET(Library, lib_Flags),
				      (LIBF_SUMUSED|LIBF_CHANGED) << 8,
				    0x9000 + (int) OFFSET(Library, lib_Version),
				      LIBVERSION,
				    0x9000 + (int) OFFSET(Library, lib_Revision),
				      LIBREVISION,
				    0x8000 + (int) OFFSET(Library, lib_IdString)
				  };
const STATIC ULONG DataTable3[] = { (ULONG) IdString,
				    0
				  };






/****************************************************************************
  The following table is expected to be at the beginning of any library.
****************************************************************************/
extern APTR InitTable [];
const STATIC struct Resident RomTag =
{
  RTC_MATCHWORD, /* ILLEGAL instruction, magic cookie to identify Resident
		    structure */
  &RomTag,       /* Additional legality check */
  &RomTag,       /* Where to continue looking for Resident structures */
  RTF_AUTOINIT,  /* Easy initialization */
  LIBVERSION,    /* Library version */
  NT_LIBRARY,    /* type of module */
  0,             /* Priority, don't use */
  LibName,       /* library name */
  IdString,      /* Id string */
  InitTable      /* See below */
};






/*****************************************************************************
  The following function will be called at startup.

  Inputs: LibPtr - pointer to the library base, initialized due to the
                   specifications in DataTable
	  SegList - BPTR to the segment list
	  _SysBase - the usual ExecBase pointer

  Result: LibPtr, if all was okay and the library may be linked into the
          system library list. NULL otherwise
*****************************************************************************/
STATIC BPTR MySegList;
struct ExecBase *SysBase;
SAVEDS ASM struct Library *_LibInit(REG(d0) struct Library *LibPtr,
				    REG(a0) BPTR SegList,
				    REG(a6) struct ExecBase *_SysBase)

{ 
  SysBase = _SysBase;
#ifdef LIBINITFUNC
  extern ULONG LIBINITFUNC(REG(a6) struct Library *);
#endif
  MySegList = SegList;
#ifdef LIBINITFUNC
  if (LIBINITFUNC(LibPtr))
    {
      return((BPTR) NULL);
    }
#endif

  return(LibPtr);
}






/****************************************************************************
  The romtag specified that we were RTF_AUTOINIT. This means that rt_Init
  points to the table below. (Without RTF_AUTOINIT it would point to a
  routine to run.)
****************************************************************************/
#ifndef LIBBASESIZE
#define LIBBASESIZE sizeof(struct Library)
#endif

#ifndef LIBFUNCTABLE
#define LIBFUNCTABLE LibFuncTable
#endif







/****************************************************************************
  The following functions are called from exec.library/OpenLibrary(),
  exec.library/CloseLibrary() and exec.library/ExpungeLibrary(),
  respectively.

  Exec puts the library base pointer in a6 and turns off task switching
  while they are executed, so we should not wait too long inside.
****************************************************************************/

/*
  This function is called from exec.library/OpenLibrary().

  Inputs: LibPtr - pointer to the library base
          Version - the suggested version number

  Result: LibPtr, if successful, NULL otherwise
*/
ASM struct Library *_LibOpen(REG(a6) struct Library *LibPtr,
			     REG(d0) ULONG Version)
{
#ifdef LIBOPENFUNC
  extern ULONG LIBOPENFUNC(REG(a6) struct Library *);
#endif

  ++LibPtr->lib_OpenCnt;
  LibPtr->lib_Flags &= ~LIBF_DELEXP; /* Prevent delayed expunge */

  /* Library specific initialization */
#ifdef LIBOPENFUNC
  extern ULONG LIBOPENFUNC(LibPtr);
#endif

  return(LibPtr);
}




/*
  This function is called from exec.library/RemoveLibrary().

  Inputs: LibPtr - pointer to the library base.

  Result: Segment list of the library (see arguments of _LibInit()),
          if the library isn't opened currently, NULL otherwise.
*/
SAVEDS ASM BPTR _LibExpunge(REG(a6) struct Library *LibPtr)

{
#ifdef LIBTERMFUNC
  extern VOID LIBTERMFUNC(REG(a6) struct Library *);
#endif
  if (LibPtr->lib_OpenCnt)
    { LibPtr->lib_Flags |= LIBF_DELEXP;
      return((BPTR) NULL);
    }

  /* Library specific cleanup. */
#ifdef LIBTERMFUNC
  LIBTERMFUNC(LibPtr);
#endif

  /* Remove the library from the library list. */
  Remove((struct Node *) LibPtr);

  return(MySegList);
}





/*
  This function is called from exec/CloseLibrary().

  Inputs: LibPtr - pointer to the library base as returned from
                   OpenLibrary().

  Result: Segment list of the library (see arguments of _LibInit), if there
          was a delayed expunge and the library is no longer open, NULL
	  otherwise.
*/
ASM BPTR _LibClose(REG(a6) struct Library *LibPtr)

{
#ifdef LIBCLOSEFUNC
  extern VOID LIBCLOSEFUNC(REG(a6) struct Library *);

  LIBCLOSEFUNC(LibPtr);
#endif

  if (!(--LibPtr->lib_OpenCnt)  &&  (LibPtr->lib_Flags & LIBF_DELEXP))
    { return(_LibExpunge(LibPtr));
    }
  return((BPTR) NULL);
}





/*
  Dummy function to return 0.
*/
ULONG _LibNull(VOID)

{
  return(0);
}





#include "LibFuncTable.c"

const APTR InitTable[4] =
{
  (APTR)LIBBASESIZE,  /* size of library base */
  (APTR)LIBFUNCTABLE, /* library function table */
  (APTR)DataTable,    /* library base initialization table */
  (APTR)_LibInit,      /* function to call on startup */
};
