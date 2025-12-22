MODULE MCCTimeText;

(*
**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCTimeText.mod 12.0 (27.07.97)
**
*)

  IMPORT
    mb := MuiBasics,
    u  := Utility,
    y  := SYSTEM;


  CONST
    cTimeText		* = "TimeText.mcc";

    aTimeTextTimeFormat	* = 081EE0098H;


  PROCEDURE TimeTextObject *{"TimeText.TimeTextObjectA"} (tags{9}..: u.Tag);


  PROCEDURE TimeTextObjectA *(tags{9}: u.TagListPtr);

  BEGIN
    mb.NewObjectA(y.ADR(cTimeText),tags);
  END TimeTextObjectA;

END MCCTimeText.
