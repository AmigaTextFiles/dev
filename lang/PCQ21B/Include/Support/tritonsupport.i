

{
   Some handy supportfunctions for triton.library.
   This header will get bigger with more functions.
}

var
   Triton_App : TR_AppPtr;

procedure TR_SetValue(p : TR_ProjectPtr; id : integer; value : integer);
external;

function TR_GetValue(p : TR_ProjectPtr; id : integer): integer;
external;

procedure TR_SetText(p : TR_ProjectPtr; id : integer; txt : string);
external;

procedure TR_SetString(p : TR_ProjectPtr; id : Integer; txt : String);
external;

function TR_GetString(p : TR_ProjectPtr; id : integer): string;
external;

procedure TR_Enable(p : TR_ProjectPtr; id : integer);
external;

procedure TR_Disable(p : TR_ProjectPtr; id : integer);
external;

function TR_GetCheckBox(p : TR_ProjectPtr; id : integer): boolean;
external;

procedure TR_SetCheckBox(p : TR_ProjectPtr; id : integer; onoff : boolean);
external;

procedure TR_UpdateListView(p : TR_ProjectPtr; gadid : Integer; thelist: ListPtr);
external;

procedure TR_SetWindowTitle(p : TR_ProjectPtr; thetitle : string);
external;


{$C+}
function TR_OpenTriton(version : ULONG; ...): boolean;
external;
{$C-}

procedure TR_CloseTriton;
external;



            
