IMPLEMENTATION MODULE MCCMonthNavigator;

(*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCMonthNavigator.mod 16.5 (21.08.97)
**
** M2 interface model by Olaf Peters <olf@informatik.uni-bremen.de>
**
*)

  FROM SYSTEM	IMPORT ADR,ADDRESS;
  FROM MuiL	IMPORT mNewObject;
  FROM UtilityD	IMPORT TagItemPtr;


  PROCEDURE MonthNavigatorObject(tags : TagItemPtr) : ADDRESS;

  BEGIN
    RETURN mNewObject(ADR(mcMonthNavigator),tags);
  END MonthNavigatorObject;

END MCCMonthNavigator.
