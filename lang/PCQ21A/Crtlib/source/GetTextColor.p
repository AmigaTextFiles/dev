external;

{$I "include:Dos/Dos.i"}
{$I "Include:Devices/ConUnit.i"}
{$I "Crt.i"}

procedure CloseInfo(var info : InfoDataPtr);
external;

function OpenInfo : InfoDataPtr;
external;

function GetTextColor : byte;
var
   info  :  InfoDataPtr;
   pen   :  byte;
begin
   pen   := 1;
   info  := OpenInfo;
   
   if info <> nil then begin
      pen   := ConUnitPtr((IoStdReqPtr(info^.id_InUse))^.io_Unit)^.cu_FgPen;
      
      CloseInfo(info);
   end;
   
   GetTextColor   := pen;
end;
                                        
