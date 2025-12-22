IMPLEMENTATION MODULE MCCDateString;

(*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCDateString.mod 12.3 (19.08.97)
**
*)

  FROM SYSTEM	IMPORT ADR,ADDRESS;
  FROM MuiL	IMPORT mNewObject;
  FROM UtilityD	IMPORT TagItemPtr;


  PROCEDURE DateStringObject(tags : TagItemPtr) : ADDRESS;

  BEGIN
    RETURN mNewObject(ADR(mcDateString),tags);
  END DateStringObject;

END MCCDateString.
