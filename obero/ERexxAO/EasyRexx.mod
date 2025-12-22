MODULE EasyRexx;
(*
(*
 *      Interface module for easyrexx.library 1.78 (©1994 Ketil Hunn)
 *      Stefan Le Breton
 *      slbrbbbh@w250zrz.zrz.TU-Berlin.de
 *      $VER: EasyRexx.mod 1.0 (21.03.95)
 *)
 *)

IMPORT
  d * := Dos,
  e * := Exec,
  rx * := Rexx,
  rvi * := RVI,
  u * := Utility;

CONST
  easyrexxName * =    "easyrexx.library";
  easyrexxVersion * = 1;


(***** STRUCTS ***********************************************************************)
TYPE
  ARexxCommandTable * = STRUCT
    id            * :LONGINT;
    command       *,
    template      * :e.LSTRPTR;
    userdata      * :e.APTR;
  END;
  ARexxCommandTablePtr * = UNTRACED POINTER TO ARRAY MAX(INTEGER) OF ARexxCommandTable;

  ARexxContextPtr * = UNTRACED POINTER TO ARexxContext;
  ARexxContext * = STRUCT
    (* PRIVATE *)
    port            - :e.MsgPortPtr;
    table           - :ARexxCommandTablePtr;
    argcopy         -,
    portname        - :e.LSTRPTR;
    maxargs         - :SHORTINT;
    rdargs          - :d.RDArgsPtr;
    msg             - :rx.RexxMsgPtr;
    flags           - :LONGSET;
    (* PUBLIC *)
    id              * :LONGINT;
    argv            * :d.ArgsStruct;
  END;

(***** TAGS **************************************************************************)
CONST
  aDummy        * = u.user;
  portName      * = aDummy+1;     (* Name of AREXX port *)
  commandTable  * = aDummy+2;     (* Table of supported AREXX commands *)
  returnCode    * = aDummy+3;     (* Primary result (return code) *)
  result1       * = returnCode;   (* Alias for ER_ReturnCode *)
  result2       * = aDummy+4;     (* Secondary result *)
  port          * = aDummy+5;     (* Use already created port *)

(**** MACROS *************************************************************************)
(*
 * Look at Test.mod, to see how you can handle these ARG macros in Oberon
 * in a secure way. I could provide PROCEDUREs in Oberon, but they're not very much
 *  Oberon-like...
 *)

(*
#define ER_SIGNAL(c)            (1L<<c->port->mp_SigBit)
//#define ARG(c,i)                              (c->argv[i]==NULL ? FALSE:TRUE)
#define ARG(c,i)                                (c->argv[i])
#define ARGNUMBER(c,i)  /*((LONG */c->argv[i]))
#define ARGSTRING(c,i)  ((UBYTE */c->argv[i])
#define ARGBOOL(c,i)            (c->argv[i]==NULL ? FALSE:TRUE)
#define TABLE_END                               NULL,NULL,NULL,NULL
*)

(* Just for compability, but should not be neccessary *)
PROCEDURE Signal * (c: ARexxContextPtr): LONGSET; BEGIN RETURN LONGSET{c.port.sigBit}; END Signal;

(* Normally you will use this: *)
PROCEDURE SignalBit * (c: ARexxContextPtr): SHORTINT; BEGIN RETURN c.port.sigBit; END SignalBit;

(**** FUNCTIONS **********************************************************************)
VAR
  base * :e.LibraryPtr;

(* ##private *)
(*
 * not documented
 *)

(* ##public *)
PROCEDURE FreeARexxContext*{base,-78}(context{8}              : ARexxContextPtr);
PROCEDURE AllocARexxContextA*{base,-84}(taglist{8}            : ARRAY OF u.TagItem): ARexxContextPtr;
PROCEDURE AllocARexxContext*{base,-84}(tag1{8}..              : u.Tag): ARexxContextPtr;
PROCEDURE GetARexxMsg*{base,-90}(context{8}                   : ARexxContextPtr): BOOLEAN;
PROCEDURE SendArexxCommandA*{base,-96}(command{9}             : e.LSTRPTR;
                                       taglist{8}             : ARRAY OF u.TagItem): LONGINT;
PROCEDURE SendArexxCommand*{base,-96}(command{9}              : e.LSTRPTR;
                                       tag1{8}..              : u.Tag): LONGINT;
PROCEDURE ReplyARexxMsgA*{base,-102}(context{9}               : ARexxContextPtr;
                                     taglist{8}               : ARRAY OF u.TagItem);
PROCEDURE ReplyARexxMsg*{base,-102}(context{9}                : ARexxContextPtr;
                                     tag1{8}..                : u.Tag);


BEGIN
  base := e.OpenLibrary(easyrexxName, easyrexxVersion);
  IF base = NIL THEN HALT(20) END;
CLOSE
  IF base # NIL THEN e.CloseLibrary(base) END;
END EasyRexx.
