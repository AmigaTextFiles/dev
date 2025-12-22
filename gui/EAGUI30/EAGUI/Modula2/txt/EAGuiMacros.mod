(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
   
 | $VER: EAGuiMacros.imp 3.00 (23.11.94) by Stefan Schulz [sts]
 
 | Desc: Interface to EAGUI.library
 
 | Dist: This Module is © Copyright 1994 by Stefan Schulz
 
 | Rqrs: Amiga OS 2.0 or higher
 |       EAGUI.library V3
 |       EAGUI - Environment Adaptive Graphic User Interface
 |       Copyright © 1993, 1994 by Marcel Offermans and Frank Groen
 
 | Lang: M2Amiga
 | Trns: M2Amiga Modula 2 Software Development System
 |       © Copyright by A+L AG, CH-2540 Grenchen
 
 | Hist: Version \date\
 |
 |       3.00   \23.11.94\
 |              interface adapted to EAGUI.library V3
 |              names changed to M2-Standard
 |
 |       1.00   \01.05.94\
 |              initial Version
 
 * ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *)

IMPLEMENTATION MODULE EAGuiMacros;

(*$ DEFINE Locale:= FALSE

    StackParms:= FALSE
    NilChk    := FALSE
    EntryClear:= FALSE
    LargeVars := FALSE
*)

(* IMPORTS ********************************************************************** *)

IMPORT  d       : EAGuiD,
        l       : EAGuiL;

IMPORT  ed      : ExecD,
        gt      : GadToolsD,
        gd      : GraphicsD,
        S       : SYSTEM,
        ud      : UtilityD;

(* ****************************************************************************** *)

VAR     buffer  : ARRAY [1..50] OF LONGINT;     (* for taglists *)


PROCEDURE HGroup          (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeHGroup,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END HGroup;


PROCEDURE VGroup          (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeVGroup,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END VGroup;


(*$ IF  Locale  *)
PROCEDURE GTString        (     text        : d.StrPtr;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ELSE        *)(*$ CopyDyn:= FALSE *)
PROCEDURE GTString        (     text        : ARRAY OF CHAR;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ENDIF       *)
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.stringKind,
                       (*$ IF  Locale  *)
                         d.gtText, text,
                       (*$ ELSE        *)
                         d.gtText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.gtFlags,  gt.placetextLeft,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTString;


(*$ IF  Locale  *)
PROCEDURE GTText          (     text        : d.StrPtr;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ELSE        *)(*$ CopyDyn:= FALSE *)
PROCEDURE GTText          (     text        : ARRAY OF CHAR;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ENDIF       *)
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.textKind,
                       (*$ IF  Locale  *)
                         d.gtText, text,
                       (*$ ELSE        *)
                         d.gtText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.gtFlags,  gt.placetextLeft,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTText;


(*$ IF  Locale  *)
PROCEDURE GTButton        (     text        : d.StrPtr;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ELSE        *)(*$ CopyDyn:= FALSE *)
PROCEDURE GTButton        (     text        : ARRAY OF CHAR;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ENDIF       *)
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.buttonKind,
                       (*$ IF  Locale  *)
                         d.gtText, text,
                       (*$ ELSE        *)
                         d.gtText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.gtFlags,  gt.placetextLeft,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTButton;


PROCEDURE GTScroller      (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.scrollerKind,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTScroller;


PROCEDURE GTSlider        (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.sliderKind,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTSlider;


(*$ IF  Locale  *)
PROCEDURE GTCheckBox      (     text        : d.StrPtr;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ELSE        *)(*$ CopyDyn:= FALSE *)
PROCEDURE GTCheckBox      (     text        : ARRAY OF CHAR;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ENDIF       *)
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.checkboxKind,
                       (*$ IF  Locale  *)
                         d.gtText, text,
                       (*$ ELSE        *)
                         d.gtText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.gtFlags,  gt.placetextLeft,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTCheckBox;


(*$ IF  Locale  *)
PROCEDURE GTInteger       (     text        : d.StrPtr;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ELSE        *)(*$ CopyDyn:= FALSE *)
PROCEDURE GTInteger       (     text        : ARRAY OF CHAR;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ENDIF       *)
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.integerKind,
                       (*$ IF  Locale  *)
                         d.gtText, text,
                       (*$ ELSE        *)
                         d.gtText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.gtFlags,  gt.placetextLeft,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTInteger;


(*$ IF  Locale  *)
PROCEDURE GTNumber        (     text        : d.StrPtr;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ELSE        *)(*$ CopyDyn:= FALSE *)
PROCEDURE GTNumber        (     text        : ARRAY OF CHAR;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ENDIF       *)
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.numberKind,
                       (*$ IF  Locale  *)
                         d.gtText, text,
                       (*$ ELSE        *)
                         d.gtText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.gtFlags,  gt.placetextLeft,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTNumber;


(*$ IF  Locale  *)
PROCEDURE GTListView      (     text        : d.StrPtr;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ELSE        *)(*$ CopyDyn:= FALSE *)
PROCEDURE GTListView      (     text        : ARRAY OF CHAR;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
(*$ ENDIF       *)
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.listviewKind,
                       (*$ IF  Locale  *)
                         d.gtText, text,
                       (*$ ELSE        *)
                         d.gtText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.gtFlags,  gt.placetextAbove,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTListView;


PROCEDURE GTMX            (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.mxKind,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTMX;


PROCEDURE GTCycle         (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.cycleKind,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTCycle;


PROCEDURE GTPalette       (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.gtType,   gt.paletteKind,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END GTPalette;


PROCEDURE EmptyBox        (     weight      : LONGINT;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.NewObjectA
                (d.typeGTGadget,
                 S.TAG(buffer,
                       d.standardMethod, d.smMinSize+d.smBorder,
                       d.weight,   weight,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END EmptyBox;


END EAGuiMacros.imp
