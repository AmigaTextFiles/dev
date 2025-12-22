unit funcdefs;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;

procedure addthings;

implementation

const
  
  numof = 55;
  
  names : array[1..numof] of string[18] =
  (
  'OpenWindowTagList',
  'CloseWindow',
  'PrintIText',
  'LockPubScreen',
  'UnlockPubScreen',
  
  'SetMenuStrip',
  'ClearMenuStrip',
  'GetVisualInfoA',
  'FreeVisualInfo',
  'CreateContext',
  
  'CreateGadgetA',
  'GT_RefreshWindow',
  'FreeGadgets',
  'CreateMenusA',
  'LayoutMenusA',
  
  'FreeMenus',
  'OpenDiskFont',
  'CloseFont',
  'DrawBevelBoxA',
  'CopyMem',
  
  'OpenLibrary',
  'CloseLibrary',
  'FreeVec',
  'AllocVec',
  'ActivateWindow',
  
  'WindowToFront',
  'WaitPort',
  'GT_GetIMsg',
  'GT_ReplyIMsg',
  
  'GetCatalogStr',
  'CloseCatalog',
  'OpenCatalogA',
  'DrawImage',
  'AddAppWindowA',
  
  'RemoveAppWindow',
  'ModifyIDCMP',
  'Forbid',
  'Permit',
  'Remove',
  
  'ReplyMsg',
  'OpenScreenTagList',
  'InitBitMap',
  'AllocRaster',
  'FreeRaster',
  'BltClear',
  
  'FindDisplayInfo',
  'GetDisplayInfoData',
  'GetScreenDrawInfo',
  'FreeScreenDrawInfo',
  'DrawImageState',
  
  'NewObjectA',
  'SetAttrsA',
  'SetGadgetAttrsA',
  'DisposeObject',
  'RefreshGList'
  
  );
  
  offsets : array[1..numof] of integer =
  (
  -606,
  -72,
  -216,
  -510,
  -516,
  
  -264,
  -54,
  -126,
  -132,
  -114,
  
  -30,
  -84,
  -36,
  -48,
  -66,
  
  -54,
  -30,
  -78,
  -120,
  -624,
  
  -552,
  -414,
  -690,
  -684,
  -450,
  
  -312,
  -384,
  -72,
  -78,
  
  -72,
  -36,
  -150,
  -114,
  -48,
  
  -54,
  -150,
  -132,
  -138,
  -252,
  
  -378,
  -612,
  -390,
  -492,
  -498,
  -300,
  
  -726,
  -756,
  -690,
  -696,
  -618,
  
  -636,
  -648,
  -660,
  -642,
  -432
  );

procedure addthings;
var
  loop : word;
begin
  for loop:= 1 to numof do 
    addlinefront(@constlist,names[loop]+copy('                         ',1,25-length(names[loop]))
               +'EQU    '+fmtint(offsets[loop]),'');
end;

end.