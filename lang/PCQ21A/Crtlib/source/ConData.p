external;

{$I "include:Dos/Dos.i"}
{$I "Include:Devices/ConUnit.i"}
{$I "Crt.i"}

procedure CloseInfo(var info : InfoDataPtr);
external;

function OpenInfo : InfoDataPtr;
external;

function ConData(modus : byte) : integer;
var
   info  :  InfoDataPtr;
   unit  :  ConUnitPtr;
   pos   :  integer;
begin
   pos   := 1;
   info  := OpenInfo;
   
   if info <> nil then begin
      unit  := ConUnitPtr((IoStdReqPtr(info^.id_InUse))^.io_Unit);

      case modus of
         CD_CURRX :  pos   := unit^.cu_XCP;
         CD_CURRY :  pos   := unit^.cu_YCP;
         CD_MAXX  :  pos   := unit^.cu_XMax;
         CD_MAXY  :  pos   := unit^.cu_YMax;
      end;
      
      CloseInfo(info);
   end;
   
   ConData := pos + 1;
end;
                              
