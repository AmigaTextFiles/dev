(* ------------------------------------------------------------------------
  :Program.       NoFragLib
  :Contents.      Interface to Jan van den Baard's Library
  :Author.        Kai Bolay [kai]
  :Address.       Snail-Mail:              E-Mail:
  :Address.       Hoffmannstraﬂe 168       UUCP: kai@amokle.stgt.sub.org
  :Address.       D-7250 Leonberg 1        FIDO: 2:2407/106.3
  :History.       v1.0 [kai] 15-Feb-91 (translated from C)
  :History.       v1.0 [kai] 13-Feb-93 (recompiled + bug-fixes)
  :Copyright.     FD
  :Language.      Oberon
  :Translator.    AMIGA OBERON v3.01d
------------------------------------------------------------------------ *)

MODULE NoFragLib;

IMPORT
  Exec, Intuition, SYSTEM;

CONST
  NoFragVersion* = 2;
  NoFragRevision* = 2;
  NoFragName* = "nofrag.library";

TYPE
  NoFragBasePtr* = UNTRACED POINTER TO NoFragBase;
  NoFragBase* = STRUCT (libNode: Exec.Library) END;

(*
 * ALL structures following are PRIVATE! DO NOT USE THEM!
 *)
  MemoryBlockPtr* = UNTRACED POINTER TO MemoryBlock;

  MemoryBlock* = STRUCT
    next*, previous*: MemoryBlockPtr;
    requirements*: LONGSET;
    bytesUsed*: LONGINT;
  END;

  MemoryItemPtr* = UNTRACED POINTER TO MemoryItem;

  MemoryItem* = STRUCT
    next*, previous*: MemoryItemPtr;
    block*: MemoryBlockPtr;
    size*: LONGINT;
  END;

  BlockListPtr* = UNTRACED POINTER TO BlockList;

  BlockList = STRUCT
    first*, end*, last*: MemoryBlockPtr;
  END;

  ItemListPtr* = UNTRACED POINTER TO ItemList;

  ItemList* = STRUCT
    first*, end*, last*: MemoryItemPtr;
  END;

(*
 * This structure may only be used to pass on to the library routines!
 * It may ONLY be obtained by a call to "GetMemoryChain()"
 *)

  MemoryChainPtr* = UNTRACED POINTER TO MemoryChain;

  MemoryChain* = STRUCT
    block*: BlockList;
    items*: ItemList;
    blockSize*: LONGINT;
  END;

CONST
  MinAlloc* = SYSTEM.SIZE (MemoryItem);

VAR
  base*: NoFragBasePtr;

PROCEDURE GetMemoryChain* {base, -30} (blocksize{0}: LONGINT): MemoryChainPtr;
PROCEDURE AllocItem* {base, -36} (chain{8}: MemoryChainPtr; size{0}: LONGINT;
                                  requirements{1}: LONGSET): Exec.ADDRESS;
PROCEDURE FreeItem* {base, -42} (chain{8}: MemoryChainPtr;
                                 memptr{9}: Exec.ADDRESS; size{0}: LONGINT);
PROCEDURE FreeMemoryChain* {base, -48} (chain{8}: MemoryChainPtr;
                                        all{0}: BOOLEAN);
PROCEDURE AllocVecItem* {base, -54} (chain{8}: MemoryChainPtr; size{0}: LONGINT;
                                     requirements{1}: LONGSET): Exec.ADDRESS;
PROCEDURE FreeVecItem* {base, -60} (chain{8}: MemoryChainPtr;
                                    memptr{9}: Exec.ADDRESS);

BEGIN

  base := Exec.OpenLibrary (NoFragName, NoFragVersion);
  IF base = NIL THEN
    IF Intuition.DisplayAlert (Intuition.recoveryAlert,
         "\x00\x64\x14missing nofrag.library v2\o\o", 50) THEN END;
    HALT (20)
  END; (* IF *)
CLOSE
  IF base # NIL THEN
    Exec.CloseLibrary (base);
    base := NIL;
  END; (* IF *)
END NoFragLib.
