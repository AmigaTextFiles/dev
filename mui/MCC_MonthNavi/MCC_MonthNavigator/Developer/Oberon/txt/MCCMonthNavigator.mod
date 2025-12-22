MODULE MCCMonthNavigator;

(*
**
** Copyright © 1996-1997,1999 Dipl.-Inform. Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: MCCMonthNavigator.mod 16.7 (06.06.99)
**
** Oberon interface model by Thore Boeckelmann <tboeckel@guardian.infox.com>
**
*)

  IMPORT
    mb := MuiBasics,
    u  := Utility,
    y  := SYSTEM;


  CONST
    cMonthNavigator			*= "MonthNavigator.mcc";

    aMonthNavigatorShowWeekdayNames	*= 081EE0005H;
    aMonthNavigatorShowWeekNumbers	*= 081EE0006H;
    aMonthNavigatorInput		*= 081EE0009H;
    aMonthNavigatorUseFrames		*= 081EE000AH;
    aMonthNavigatorShowInvisibles	*= 081EE000BH;
    aMonthNavigatorWeekdayNamesSpacing	*= 081EE000CH;
    aMonthNavigatorWeekNumbersSpacing	*= 081EE000DH;
    aMonthNavigatorLineWeekdayNames	*= 081EE000EH;
    aMonthNavigatorLineWeekNumbers	*= 081EE000FH;
    aMonthNavigatorDraggable		*= 081EE0012H;
    aMonthNavigatorMarkHook		*= 081EE0013H;
    aMonthNavigatorDropable		*= 081EE0014H;
    aMonthNavigatorDragQueryHook	*= 081EE0015H;
    aMonthNavigatorDragDropHook		*= 081EE0016H;
    aMonthNavigatorShowLastMonthDays	*= 081EE0017H;
    aMonthNavigatorShowNextMonthDays	*= 081EE0018H;
    aMonthNavigatorMonthAdjust		*= 081EE0019H;
    aMonthNavigatorFixedTo6Rows		*= 081EE0033H;
    aMonthNavigatorLayout		*= 081EE0034H;


    mMonthNavigatorUpdate		*= 081EE0010H;
    mMonthNavigatorMark			*= 081EE0030H;
    mMonthNavigatorDragQuery		*= 081EE0031H;
    mMonthNavigatorDragDrop		*= 081EE0032H;

    vMonthNavigatorInputModeNone	*= 0;
    vMonthNavigatorInputModeRelVerify	*= 1;
    vMonthNavigatorInputModeImmediate	*= 2;

    vMonthNavigatorLayoutAmerican	*= 0;
    vMonthNavigatorLayoutEuropean	*= 1;

    vMonthNavigatorShowMDays_No		*= 0;
    vMonthNavigatorShowMDays_OnlyFillUp	*= 1;
    vMonthNavigatorShowMDays_Yes	*= 2;

    vMonthNavigatorMarkHookHiToday	*= 1;

    vMonthNavigatorMarkDayVersion	*= 1;

    cfgMonthNavigatorTodayUnderline	*= 081ee002CH;
    cfgMonthNavigatorTodayBold		*= 081ee002DH;
    cfgMonthNavigatorTodayItalic	*= 081ee002EH;
    cfgMonthNavigatorTodayAlignment	*= 081ee002FH;
    cfgMonthNavigatorTodayBackground	*= 081ee001DH;
    cfgMonthNavigatorTodayPen		*= 081ee001EH;
    cfgMonthNavigatorTodayShortHelp	*= 081ee001FH;


  TYPE
    pMonthNavigatorUpdate *=
      STRUCT
        MethodID	*: LONGINT;
      END;

    pMonthNavigatorMark *=
      STRUCT
        MethodID	*: LONGINT;
        Year		*: LONGINT;
        Month		*: LONGINT;
        Day		*: LONGINT;
        dayobj		*: I.ObjectPtr;
      END;

    pMonthNavigatorDragQuery *=
      STRUCT
        MethodID	*: LONGINT;
        Year		*: LONGINT;
        Month		*: LONGINT;
        Day		*: LONGINT;
        dayobj		*: I.ObjectPtr;
        obj		*: I.ObjectPtr;
      END;

    pMonthNavigatorDragDrop *=
      STRUCT
        MethodID	*: LONGINT;
        Year		*: LONGINT;
        Month		*: LONGINT;
        Day		*: LONGINT;
        dayobj		*: I.ObjectPtr;
        obj		*: I.ObjectPtr;
      END;

    sMonthNavigatorMarkDay *=
      STRUCT
        Version		*: LONGINT;
        Year		*: LONGINT;
        Month		*: SHORTINT;
        Day		*: SHORTINT;

        PreParse	*: POINTER TO CHAR;
        Background	*: LONGINT;
        ShortHelp	*: POINTER TO CHAR;
        Disabled	*: BOOLEAN;
      END;


  PROCEDURE MonthNavigatorObject *{"MonthNavigator.MonthNavigatorObjectA"} (tags{9}..: u.Tag);


  PROCEDURE MonthNavigatorObjectA *(tags{9}: u.TagListPtr);

  BEGIN
    mb.NewObjectA(y.ADR(cMonthNavigator),tags);
  END MonthNavigatorObjectA;

END MCCMonthNavigator.
