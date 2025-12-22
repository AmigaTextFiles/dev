;
; ** $VER: locale.h 38.4 (5.12.91)
; ** Includes Release 40.15
; **
; ** File format for locale preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


#ID_LCLE = $4C434C45
#ID_CTRY = $43545259

Structure CountryPrefs

    cp_Reserved.l[4]
    cp_CountryCode.l
    cp_TelephoneCode.l
    cp_MeasuringSystem.b

    cp_DateTimeFormat.b[80]
    cp_DateFormat.b[40]
    cp_TimeFormat.b[40]

    cp_ShortDateTimeFormat.b[80];
    cp_ShortDateFormat.b[40];
    cp_ShortTimeFormat.b[40];

    ;  for numeric values
    cp_DecimalPoint.b[10]
    cp_GroupSeparator.b[10]
    cp_FracGroupSeparator.b[10]
    cp_Grouping.b[10]
    cp_FracGrouping.b[10]

    ;  for monetary values
    cp_MonDecimalPoint.b[10]
    cp_MonGroupSeparator.b[10]
    cp_MonFracGroupSeparator.b[10]
    cp_MonGrouping.b[10]
    cp_MonFracGrouping.b[10]
    cp_MonFracDigits.b
    cp_MonIntFracDigits.b

    ;  for currency symbols
    cp_MonCS.b[10]
    cp_MonSmallCS.b[10]
    cp_MonIntCS.b[10]

    ;  for positive monetary values
    cp_MonPositiveSign.b[10]
    cp_MonPositiveSpaceSep.b
    cp_MonPositiveSignPos.b
    cp_MonPositiveCSPos.b

    ;  for negative monetary values
    cp_MonNegativeSign.b[10]
    cp_MonNegativeSpaceSep.b
    cp_MonNegativeSignPos.b
    cp_MonNegativeCSPos.b

    cp_CalendarType.b
EndStructure


Structure LocalePrefs

    lp_Reserved.l[4]
    lp_CountryName.b[32]
    lp_PreferredLanguages.b[300]  ; was [10][30]
    lp_GMTOffset.l
    lp_Flags.l
    lp_CountryData.CountryPrefs
EndStructure


; ***************************************************************************


