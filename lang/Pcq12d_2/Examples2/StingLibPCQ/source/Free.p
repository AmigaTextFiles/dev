External;

{$I "include:utils/stringlib.i"}
{$I "include:exec/memory.i"}

type
	Str_List = record
		pos  : integer;
		next : ^Str_List;
	end;

	Str_ListPtr = ^Str_List;


procedure Str_FreeStr_List(p : Str_ListPtr);

begin
	if p^.next = nil then
		freemem(p,8)
	else
	begin
		Str_FreeStr_List(p^.next);
		freemem(p,8);
	end;
end;
