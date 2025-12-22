IMPLEMENTATION MODULE MCCDate;

(*
**
** Copyright © 1996 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCDate.mod 12.2 (11.12.96)
**
*)

  FROM SYSTEM	IMPORT ADR,ADDRESS;
  FROM MuiL	IMPORT mNewObject;
  FROM UtilityD	IMPORT TagItemPtr;

(*
  PROCEDURE DateObject(tags : TagItemPtr) : ADDRESS;

  BEGIN
    RETURN mNewObject(ADR(mcDate),tags);
  END DateObject;
*)
END MCCDate.
