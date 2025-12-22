external;

{$I "Include:Exec/Memory.i"}
{$I "Include:Dos/Dos.i"}

procedure CloseInfo(var info : InfoDataPtr);
begin
   if info <> nil then begin
      FreeVec(info);
      info := nil;
   end;
end;
                               
