IMPLEMENTATION MODULE MCCTime;

(*
**
** Copyright © 1996 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCTime.mod 12.2 (11.12.96)
**
*)

  FROM SYSTEM	IMPORT ADR,ADDRESS;
  FROM MuiL	IMPORT mNewObject;
  FROM UtilityD	IMPORT TagItemPtr;

(*
  PROCEDURE TimeObject(tags : TagItemPtr) : ADDRESS;

  BEGIN
    RETURN mNewObject(ADR(mcTime),tags);
  END TimeObject;
*)
END MCCTime.
