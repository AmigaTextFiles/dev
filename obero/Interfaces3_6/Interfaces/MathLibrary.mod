(*
(*
**  Amiga Oberon Interface Module:
**  $VER: MathLibrary.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE MathLibrary;   (* $Implementation- *)

IMPORT e * := Exec;

TYPE

  MathIEEEBasePtr * = UNTRACED POINTER TO MathIEEEBase;
  MathIEEEBase * = STRUCT (libNode * : e.Library)
    reserved * : ARRAY 18 OF CHAR;
    taskOpenLib * : PROCEDURE(): LONGINT;
    taskCloseLib * : PROCEDURE(): LONGINT;
    (*      This structure may be extended in the future *)
  END;

(*
* Math resources may need to know when a program opens or closes this
* library. The functions TaskOpenLib and TaskCloseLib are called when
* a task opens or closes this library. They are initialized to point to
* local initialization pertaining to 68881 stuff if 68881 resources
* are found. To override the default the vendor must provide appropriate
* hooks in the MathIEEEResource. If specified, these will be called
* when the library initializes.
*)

END MathLibrary.


