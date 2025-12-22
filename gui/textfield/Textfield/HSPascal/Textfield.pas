{    TextField (V3.1) interface for HSPascal     }
{                                                }
{ Textfield is (C) Copyright 1995 by Mark Thomas }
{                                                }
{  HSPascal interface v2.0 by Mark Thomas        }
{      with help from Foivos Kourendas           }

{ Please note that some parts of V3 defines      }
{ are commented out since I don't know the       }
{ HSPascal type for C's char*.                   }

Unit TextField;

Interface
Uses Exec,Intuition;

Const

	TEXTFIELDNAME = 'gadgets/textfield.gadget';
	TEXTFIELDVERSION = 3;

	{  TAGS  | NOTE : TAG_User:=$80000000}

	TextField_TagBase = $84000000;

	{ V1 atrributes }
	TextField_Text          = $84000001;
	TextField_InsertText    = $84000002;
	TextField_TextFont      = $84000003;
	TextField_Delimiters    = $84000004;
	TextField_Top           = $84000005;
	TextField_BlockCursor   = $84000006;
	TextField_Size          = $84000007;
	TextField_Visible       = $84000008;
	TextField_Lines         = $84000009;
	TextField_NoGhost       = $8400000A;
	TextField_MaxSize       = $8400000B;
	TextField_Border        = $8400000C;
	TextField_TextAttr      = $8400000D;
	TextField_FontStyle     = $8400000E;
	TextField_Up            = $8400000F;
	TextField_Down          = $84000010;
	TextField_Alignment     = $84000011;
	TextField_VCenter       = $84000012;
	TextField_RuledPaper    = $84000013;
	TextField_PaperPen      = $84000014;
	TextField_InkPen        = $84000015;
	TextField_LinePen       = $84000016;
	TextField_UserAlign     = $84000017;
	TextField_Spacing       = $84000018;
	TextField_ClipStream    = $84000019;
	TextField_ClipStream2   = $8400001A;
	TextField_UndoStream    = $8400001A;
	TextField_BlinkRate     = $8400001B;
	TextField_Inverted      = $8400001C;
	TextField_Partial       = $8400001D;
	TextField_CursorPos     = $8400001E;

	{ V2 atrributes }

	TextField_ReadOnly      = $8400001F;
	TextField_Modified      = $84000020;
	TextField_AcceptChars   = $84000021;
	TextField_RejectChars   = $84000022;
	TextField_PassCommand   = $84000023;
	TextField_LineLength    = $84000024;
	TextField_MaxSizeBeep   = $84000025;
	TextField_DeleteText    = $84000026;
	TextField_SelectSize    = $84000027;
	TextField_Copy          = $84000028;
	TextField_CopyAll       = $84000029;
	TextField_Cut           = $8400002A;
	TextField_Paste         = $8400002B;
	TextField_Erase         = $8400002C;
	TextField_Undo          = $8400002D;

	{ V3 atrributes }

	TextField_TabSpaces     = $8400002E;
	TextField_NonPrintChars = $8400002F;

	{  TextField_Border  }

	TextField_BORDER_NONE        = 0;
	TextField_BORDER_BEVEL       = 1;
	TextField_BORDER_DOUBLEBEVEL = 2;


	{  TextField_Alignment  }

	TextField_ALIGN_LEFT   = 0;
	TextField_ALIGN_CENTER = 1;
	TextField_ALIGN_RIGHT  = 2;

Function GetClass: pIClass;
Function TextField_GetClass: pIClass;

{ I don't have HSPascal, so I can't be    }
{ sure about this:                        }

{ Function TextField_GetCopyright: pChar; }

Var
	TextFieldBase: pLibrary;
	TextFieldClass: pIClass;

Implementation

Function GetClass: pIClass;
XASSEMBLER;
ASM	move.l	a6,-(sp)
	move.l	TextFieldBase,a6
	jsr	-$1E(a6)
	move.l	d0,$8(sp)
	move.l	(sp)+,a6
END;

{ I don't have HSPascal, so I can't be    }
{ sure about this:                        }

{
Function GetCopyright: pChar;
XASSEMBLER;
ASM	move.l	a6,-(sp)
	move.l	TextFieldBase,a6
	jsr	-$24(a6)
	move.l	d0,$8(sp)
	move.l	(sp)+,a6
END;
}

Function TextField_GetClass: pIClass;
BEGIN
	TextField_GetClass := GetClass;
END;

{ I don't have HSPascal, so I can't be    }
{ sure about this:                        }

{
Function TextField_GetCopyright: pChar;
BEGIN
	TextField_GetCopyright := GetCopyright;
END;
}

End.
