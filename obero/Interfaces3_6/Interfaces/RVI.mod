(*(***********************************************************************

:Program.    RVI.mod
:Contents.   Oberon Interface for the REXX Variables Interface
:Support.    RVI (rexxvars.o) (C) by William S. Hawes
:Author.     Martin Horneffer
:Copyright.  Freely Distributable
:Language.   Oberon
:Translator. Amiga Oberon Compiler V2.25d
:History.     1.0  10 Feb 1992, Martin Horneffer
:History.     1.1  01 Oct 1992, hartmut Goebel: use $JOIN
:History.    40.15 28 Dec 1993, hartmut Goebel: adapted to Interfaces 40.15
:Address.    Warmweiherstraﬂe 18, W-5100 Aachen
:Phone.      0(049)241-535233
:Remark.     names of ARexx variable MUST be uppercase!
:Remark.     STEMs are nothing but variables with names that
:Remark.     contain a dot (".").
:Version.    $VER: RVI.mod 40.15 (28.12.93) Oberon 3.0

***********************************************************************)*)

MODULE RVI;

(* REXX Variables Interface *)

IMPORT
  e  * := Exec,
  rx * := Rexx,
  SYSTEM;

(* $JOIN rexxvars.o *)

(*
 * CheckRexxMsg()
 * Usage: boolean = CheckRexxMsg(message);
 *
 * This function verifies that the message pointer is a valid RexxMsg and
 * that it came from an ARexx macro program.  The validation test is more
 * stringent  than that performed by the ARexx library function IsRexx().
 * The latter verifies that the message is tagged as a RexxMsg structure,
 * but  not  that  it necessarily came from an ARexx macro program.  Each
 * macro  program  installs a pointer to its global data structure in the
 * command  message,  and this pointer is necessary to gain access to the
 * symbol table.
 *
 * The return from the function will be non-zero (TRUE) if the message is
 * valid, and 0 (FALSE) otherwise.
 *)
PROCEDURE CheckRexxMsg * {"CheckRexxMsg"}(message{8}: rx.RexxMsgPtr): BOOLEAN;

(*
 * GetRexxVar()
 * Usage: error = GetRexxVar(message,variable,&value);
 *
 * This function retrieves the current value for the specified variable name.
 * It first validates the message using CheckRexxMsg() and then, if the
 * message pointer is valid, retrieves the value string and passes it in the
 * supplied return pointer.  The return pointer is actually an argstring (an
 * offset pointer to a RexxArg structure), but can be treated as a pointer
 * to a null-terminated string.  The value must not be disturbed by the host.
 *
 * The function return will be zero if the value was successfully retrieved
 * and non-zero otherwise.  An error code of 10 indicates an invalid message.
 *)
PROCEDURE GetRexxVarA1 * {"GetRexxVar"}(message{8} : rx.RexxMsgPtr;
                                        variable{9}: ARRAY OF CHAR): LONGINT;
(* value returned in A1 *)

PROCEDURE GetRexxVar * (message  : rx.RexxMsgPtr;
                        variable : ARRAY OF CHAR;
                        VAR value: e.LSTRPTR): LONGINT;
  (* $CopyArrays- *)
  VAR error: LONGINT;
  BEGIN
    error := GetRexxVarA1(message,variable);
    value := SYSTEM.REG(9);
    RETURN error;
  END GetRexxVar;

(*
 * SetRexxVar()
 * Usage: error = SetRexxVar(message,variable,value,length);
 *
 * This  function  installs  a  value  in  the  specified  variable.   It
 * validates  the  message pointer using CheckRexxMsg() and then installs
 * the  value,  creating  a symbol table entry if required.  The value is
 * supplied  as a pointer to a data area along with the total length; the
 * data may contain arbitrary values and need not be null-terminated.
 *
 * The  function  return  will  be  zero  if  the call was successful and
 * non-zero  otherwise.   The possible error codes are given in the table
 * below.
 *
 *    Error Code  Reason for Failure
 *        3       Insufficient storage
 *        9       String too long
 *       10       Invalid message
 *)
PROCEDURE SetRexxVar * {"SetRexxVar"}(message{8} : rx.RexxMsgPtr;
                                      variable{9}: ARRAY OF CHAR;
                                      value{0}   : ARRAY OF CHAR;
                                      length{1}  : LONGINT): LONGINT;
END RVI.
