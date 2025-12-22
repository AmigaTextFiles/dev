(*
ARQ.MOD ©1998-99 Morten Bjergstrøm
EMail: mbjergstroem@hotmail.com
*)

<*STANDARD-*>
MODULE ARQ;

IMPORT
  e:=Exec,
  i:=Intuition;


CONST
  MAGIC*=06D6A6C21H;
  ID_INFO*=0;
  ID_DISK*=1;
  ID_DELETE*=2;
  ID_GURU*=3;
  ID_RWERROR*=4;
  ID_WPROTECT*=5;
  ID_PRINTER*=6;
  ID_QUESTION*=7;
  ID_EXCLAM*=8;

  ID_IMAGE*=-1;
  ID_ANIM*=-2;

TYPE

  ExtEasyStruct*=RECORD
    Image*:i.ImagePtr;
    Sound*:e.LSTRPTR;
    AnimID*:e.WORD;
    Flags*:e.UWORD;
    Magic*:e.ULONG;
    Reserved*:ARRAY 3 OF e.ULONG;
    Easy*:i.EasyStruct;
  END;

END ARQ.
