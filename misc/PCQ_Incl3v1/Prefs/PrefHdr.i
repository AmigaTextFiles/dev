  {    File format for preferences header }


{$I "Include:Libraries/IffParse.i"}

const
 ID_PREF = 1347568966;
 ID_PRHD = 1347569732;

Type
 PrefHeader = Record
    ph_Version,             { version of following data }
    ph_Type     : Byte;     { type of following data    }
    ph_Flags    : Integer;  { always set to 0 for now   }
 end;
 PrefHeaderPtr = ^PrefHeader;

