IMPLEMENTATION MODULE MCCTimeString;

(*
**
** Copyright © 1996 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCTimeString.mod 12.2 (11.12.96)
**
*)

  FROM SYSTEM	IMPORT ADR, ADDRESS;
  FROM MuiL	IMPORT mNewObject;
  FROM UtilityD	IMPORT TagItemPtr;


  PROCEDURE TimeStringObject(tags : TagItemPtr) : ADDRESS;

  BEGIN
    RETURN mNewObject(ADR(mcTimeString),tags);
  END TimeStringObject;

END MCCTimeString.
