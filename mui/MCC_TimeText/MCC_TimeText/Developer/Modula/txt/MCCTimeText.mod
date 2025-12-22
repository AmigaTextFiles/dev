IMPLEMENTATION MODULE MCCTimeText;

(*
**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCTimeText.mod 12.0 (27.07.97)
**
*)

  FROM SYSTEM	IMPORT ADR, ADDRESS;
  FROM MuiL	IMPORT mNewObject;
  FROM UtilityD	IMPORT TagItemPtr;


  PROCEDURE TimeTextObject(tags : TagItemPtr) : ADDRESS;

  BEGIN
    RETURN mNewObject(ADR(mcTimeText),tags);
  END TimeTextObject;

END MCCTimeText.
