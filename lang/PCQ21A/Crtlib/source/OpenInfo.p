external;

{$I "Include:Devices/Timer.i"}
{$I "Include:Exec/Tasks.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Dos/Dos.i"}
{$I "Include:Dos/DosExtens.i"}

function OpenInfo : InfoDataPtr;
var
   port     :  MsgPortPtr;
   info     :  InfoDataPtr;
   bptr, d4, d5, d6, d7 :  integer;
begin
   info  := InfoDataPtr(AllocVec(SizeOf(InfoData), MEMF_PUBLIC));
   
   if info <> nil then begin
      port  := GetConsoleTask;
      bptr  := integer(info) shr 2;
      
      if port <> nil then begin
         if DoPkt(port, ACTION_DISK_INFO, bptr, d4, d5, d6, d7) <> DOSFALSE then info := InfoDataPtr(bptr shl 2)
         else port := nil;
      end;
      
      if port = nil then begin   
         FreeVec(info);
         info := nil;
      end;
   end;

   OpenInfo := info;
end;
                               
