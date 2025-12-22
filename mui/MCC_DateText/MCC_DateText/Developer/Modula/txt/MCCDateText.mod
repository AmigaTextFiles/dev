IMPLEMENTATION MODULE MCCDateText;

(*
**
** Copyright © 1996 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCDateText.mod 12.0 (19.08.97)
**
*)

  FROM SYSTEM	IMPORT ADR,ADDRESS;
  FROM MuiL	IMPORT mNewObject;
  FROM UtilityD	IMPORT TagItemPtr;


  PROCEDURE DateTextObject(tags : TagItemPtr) : ADDRESS;

  BEGIN
    RETURN mNewObject(ADR(mcDateText),tags);
  END DateTextObject;

END MCCDateText.
