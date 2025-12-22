   {   File format for text printer preferences }

{$I "Include:Libraries/IffParse.i"}

const
 ID_PTXT = 1347704916;
 ID_PUNT = 1347767892;


 DRIVERNAMESIZE = 30;               { Filename size     }
 DEVICENAMESIZE = 32;               { .device name size }

Type
 PrinterTxtPrefs = Record
    pt_Reserved     : Array[0..3] of Integer;               { System reserved            }
    pt_Driver       : Array[0..DRIVERNAMESIZE-1] of Char;   { printer driver filename    }
    pt_Port         : Byte;                                 { printer port connection    }

    pt_PaperType,
    pt_PaperSize,
    pt_PaperLength,               { Paper length in # of lines }

    pt_Pitch,
    pt_Spacing,
    pt_LeftMargin,                { Left margin                }
    pt_RightMargin,               { Right margin       }
    pt_Quality      : WORD;
 end;
 PrinterTxtPrefsPtr = ^PrinterTxtPrefs;

const
{ constants for PrinterTxtPrefs.pt_Port }
 PP_PARALLEL = 0;
 PP_SERIAL   = 1;

{ constants for PrinterTxtPrefs.pt_PaperType }
 PT_FANFOLD  = 0;
 PT_SINGLE   = 1;

{ constants for PrinterTxtPrefs.pt_PaperSize }
 PS_US_LETTER   = 0 ;
 PS_US_LEGAL    = 1 ;
 PS_N_TRACTOR   = 2 ;
 PS_W_TRACTOR   = 3 ;
 PS_CUSTOM      = 4 ;
 PS_EURO_A0     = 5 ;              { European size A0: 841 x 1189 }
 PS_EURO_A1     = 6 ;              { European size A1: 594 x 841  }
 PS_EURO_A2     = 7 ;              { European size A2: 420 x 594  }
 PS_EURO_A3     = 8 ;              { European size A3: 297 x 420  }
 PS_EURO_A4     = 9 ;              { European size A4: 210 x 297  }
 PS_EURO_A5     = 10;              { European size A5: 148 x 210  }
 PS_EURO_A6     = 11;              { European size A6: 105 x 148  }
 PS_EURO_A7     = 12;              { European size A7: 74 x 105   }
 PS_EURO_A8     = 13;              { European size A8: 52 x 74    }

{ constants for PrinterTxtPrefs.pt_PrintPitch }
 PP_PICA  = 0;
 PP_ELITE = 1;
 PP_FINE  = 2;

{ constants for PrinterTxtPrefs.pt_PrintSpacing }
 PS_SIX_LPI   = 0;
 PS_EIGHT_LPI = 1;

{ constants for PrinterTxtPrefs.pt_PrintQuality }
 PQ_DRAFT  = 0;
 PQ_LETTER = 1;

Type
 PrinterUnitPrefs = Record
    pu_Reserved         : Array[0..3] of Integer;              { System reserved              }
    pu_UnitNum,                                                { Unit number for OpenDevice() }
    pu_OpenDeviceFlags  : Integer;                             { Flags for OpenDevice()       }
    pu_DeviceName       : Array[0..DEVICENAMESIZE-1] of Char;  { Name for OpenDevice()        }
 end;
 PrinterUnitPrefsPtr = ^PrinterUnitPrefs;


