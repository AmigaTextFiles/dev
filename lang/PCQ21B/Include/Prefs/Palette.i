  {      File format for palette preferences    }


{$I "Include:Libraries/IffParse.i"}


const
    ID_PALT = 1346456660;

Type
 PalettePrefs = Record
    pap_Reserved     : Array[0..3] of Integer;    { System reserved                }
    pap_4ColorPens   : Array[1..32] of WORD;
    pap_8ColorPens   : Array[1..32] of WORD;
    pap_Colors       : Array[1..32] of ColorSpec;     { Used as full 16-bit RGB values }
 end;
 PalettePrefsPtr = ^PalettePrefs;


{***************************************************************************}


