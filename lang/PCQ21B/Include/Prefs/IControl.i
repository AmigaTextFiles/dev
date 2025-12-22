 {  File format for intuition control preferences }

{$I "Include:Libraries/IffParse.i"}


{***************************************************************************}

const
 ID_ICTL = 1229149260;

Type
 IControlPrefs = Record
    ic_Reserved     : Array[0..3] Of Integer;       { System reserved              }
    ic_TimeOut      : WORD;                         { Verify timeout               }
    ic_MetaDrag     : WORD;                         { Meta drag mouse event        }
    ic_Flags        : Integer;                      { IControl flags (see below)   }
    ic_WBtoFront,                                   { CKey: WB to front            }
    ic_FrontToBack,                                 { CKey: front screen to back   }
    ic_ReqTrue,                                     { CKey: Requester TRUE         }
    ic_ReqFalse     : Byte;                         { CKey: Requester FALSE        }
 end;
 IControlPrefsPtr = ^IControlPrefs;

const
{ flags for IControlPrefs.ic_Flags }
 ICB_COERCE_COLORS = 0;
 ICB_COERCE_LACE   = 1;
 ICB_STRGAD_FILTER = 2;
 ICB_MENUSNAP      = 3;
 ICB_MODEPROMOTE   = 4;

 ICF_COERCE_COLORS = 1;
 ICF_COERCE_LACE   = 2;
 ICF_STRGAD_FILTER = 4;
 ICF_MENUSNAP      = 8;
 ICF_MODEPROMOTE   = 16;


{***************************************************************************}


