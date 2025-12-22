(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
 | 
 | $VER: EAGuiMacros.imp 1.00 (01.05.95) by Stefan Schulz
 | 
 | Module          : EAGuiMacros
 | Last Modified   : Wednesday, 01.05.94
 | Author          : Stefan Schulz
 | Actual Revision : 1.00
 | 
 | 
 | Description
 | -----------
 |   - Interface to EAGUI.library
 |     EAGUI - Environment Adaptive Graphic User Interface
 |     Copyright © 1993, 1994 by Marcel Offermans and Frank Groen
 | 
 | Requirements
 | ------------
 |   - EAGUI.library V2
 | 
 | Language
 | --------
 |   - M2Amiga Modula 2 Software Development System
 |     © Copyright by A+L AG, CH-2540 Grenchen
 | 
 | Revision 1.00  \01.05.94\
 |  - initial revision
 |
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
 RETURN l.EaNewObjectA
                (d.eaTypeHGroup,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       ud.tagMore, tags,
                 ud.tagEnd));
 END HGroup;


PROCEDURE VGroup          (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.EaNewObjectA
                (d.eaTypeVGroup,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
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
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.stringKind,
                       (*$ IF  Locale  *)
                         d.eaGTText, text,
                       (*$ ELSE        *)
                         d.eaGTText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.eaGTFlags,  gt.placetextLeft,
                       ud.tagMore,   tags,
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
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.textKind,
                       (*$ IF  Locale  *)
                         d.eaGTText, text,
                       (*$ ELSE        *)
                         d.eaGTText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.eaGTFlags,  gt.placetextLeft,
                       ud.tagMore,   tags,
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
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.buttonKind,
                       (*$ IF  Locale  *)
                         d.eaGTText, text,
                       (*$ ELSE        *)
                         d.eaGTText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.eaGTFlags,  gt.placetextLeft,
                       ud.tagMore,   tags,
                 ud.tagEnd));
 END GTButton;


PROCEDURE GTScroller      (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.scrollerKind,
                       ud.tagMore,   tags,
                 ud.tagEnd));
 END GTScroller;


PROCEDURE GTSlider        (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.sliderKind,
                       ud.tagMore,   tags,
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
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.checkboxKind,
                       (*$ IF  Locale  *)
                         d.eaGTText, text,
                       (*$ ELSE        *)
                         d.eaGTText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.eaGTFlags,  gt.placetextLeft,
                       ud.tagMore,   tags,
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
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.integerKind,
                       (*$ IF  Locale  *)
                         d.eaGTText, text,
                       (*$ ELSE        *)
                         d.eaGTText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.eaGTFlags,  gt.placetextLeft,
                       ud.tagMore,   tags,
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
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.numberKind,
                       (*$ IF  Locale  *)
                         d.eaGTText, text,
                       (*$ ELSE        *)
                         d.eaGTText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.eaGTFlags,  gt.placetextLeft,
                       ud.tagMore,   tags,
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
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.listviewKind,
                       (*$ IF  Locale  *)
                         d.eaGTText, text,
                       (*$ ELSE        *)
                         d.eaGTText, S.ADR(text),
                       (*$ ENDIF       *)
                       d.eaGTFlags,  gt.placetextAbove,
                       ud.tagMore,   tags,
                 ud.tagEnd));
 END GTListView;


PROCEDURE GTMX            (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.mxKind,
                       ud.tagMore,   tags,
                 ud.tagEnd));
 END GTMX;


PROCEDURE GTCycle         (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.cycleKind,
                       ud.tagMore,   tags,
                 ud.tagEnd));
 END GTCycle;


PROCEDURE GTPalette       (     tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaGTType,   gt.paletteKind,
                       ud.tagMore,   tags,
                 ud.tagEnd));
 END GTPalette;


PROCEDURE EmptyBox        (     weight      : LONGINT;
                                tags        : ud.TagItemPtr     ) : d.OPTR;
 BEGIN
 RETURN l.EaNewObjectA
                (d.eaTypeGTGadget,
                 S.TAG(buffer,
                       d.eaStandardMethod, d.eaSMMinSize+d.eaSMBorder,
                       d.eaWeight,   weight,
                       ud.tagMore,   tags,
                 ud.tagEnd));
 END EmptyBox;


END EAGuiMacros.imp
