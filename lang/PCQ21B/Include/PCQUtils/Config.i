
{$I "Include:PCQUtils/PCQList.i"}


const
   _Config_List_ : ListPtr = nil;
                                         

procedure ConfigWriteString(section, item, data : string);
external;

function SaveConfig(TheFile : String): Boolean;
external;

FUNCTION ConfigReadString(section : STRING;
                    item : STRING; default : STRING): STRING;
external;

FUNCTION ConfigReadInteger(section : STRING;
                     item : STRING; default : Integer):Integer;
external;

function ConfigReadBool(section, item : string; thedata : boolean): boolean;
external;

function OpenConfig(fname : string): boolean;
external;

procedure FlushConfig;
external;

procedure ConfigWriteBool(section, item: string; thedata : boolean);
external;

procedure ConfigWriteInteger(section,item : string; data : integer);
external;

procedure InitConfig;
external;



                             
