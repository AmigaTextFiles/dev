(* Interface to the the lh.library by Christoph Teuber, Rheinstr. 65, 5600
Wuppertal 1, Germany. *)

MODULE LhLib;

IMPORT e : Exec,
       io,
       s : SYSTEM;

TYPE LhBuffer * = STRUCT
      lhSrc * : e.ADDRESS;
      lhSrcSize * : LONGINT;
      lhDst * : e.ADDRESS;
      lhDstSize * : LONGINT;
      lhAux * : e.ADDRESS;
      lhAuxSize * : e.ADDRESS;
      lhReserved * : LONGINT;
   END;

     LhBufferPtr * = POINTER TO LhBuffer;

VAR LhBase * : e.LibraryPtr;

PROCEDURE CreateBuffer * {LhBase, -30} (OnlyDecode {0}:BOOLEAN):LhBufferPtr;
PROCEDURE DeleteBuffer * {LhBase, -36} (Buffer {8}:LhBufferPtr);
PROCEDURE LhEncode * {LhBase, -42} (Buffer {8}:LhBufferPtr): LONGINT;
PROCEDURE LhDecode * {LhBase, -48} (Buffer {8}:LhBufferPtr): LONGINT;

BEGIN  (* LhLib *)
 LhBase := e.OpenLibrary ("lh.library", 0);
 IF LhBase = NIL THEN
  io.WriteString ("Ich bin ja nicht anspruchsvoll aber die lh.library brauch ich doch.\n");
  HALT(0);
 END;

CLOSE
 IF LhBase#NIL THEN e.CloseLibrary(LhBase) END;

END LhLib.
