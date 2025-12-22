external;

{$I "include:exec/exec.i"}
{$I "include:dos/dos.i"}
{$I "include:dos/dosextens.i"}
{$I "include:intuition/intuition.i"}
{$I "include:Devices/ConUnit.i"}
{$I "include:Utils/StringLib.i"}

procedure CloseInfo(var info : InfoDataPtr);
external;

function OpenInfo : InfoDataPtr;
external;


function ReadKey : char;
var
   info  :  InfoDataPtr;
   win   :  WindowPtr;
   imsg  :  IntuiMessagePtr;
   msg   :  MessagePtr;
   key   :  char;
   idcmp, vanil   :  integer;
   dummy : Boolean;
begin
   key   := char(0);
   info  := OpenInfo;
   
   if info <> nil then begin
      win   := WindowPtr(ConUnitPtr((IoStdReqPtr(info^.id_InUse))^.io_Unit)^.cu_Window);
      idcmp := win^.IDCMPFlags;
      vanil := IDCMP_VANILLAKEY or IDCMP_RAWKEY;
      
      dummy := ModifyIDCMP(win, (idcmp or vanil));
      
      repeat
         msg   := WaitPort(win^.UserPort);
         imsg  := IntuiMessagePtr(GetMsg(win^.UserPort));
         
         if (imsg^.Class = IDCMP_VANILLAKEY) or (imsg^.Class = IDCMP_RAWKEY) then key := char(imsg^.Code);
         
         ReplyMsg(MessagePtr(imsg));
      until key <> char(0);
      
      repeat
         msg   := GetMsg(win^.UserPort);
         
         if msg <> nil then ReplyMsg(msg);
      until msg = nil;
      
      dummy := ModifyIDCMP(win, idcmp);
      
      CloseInfo(info);
   end;
   
   ReadKey := key;
end;
                                           
