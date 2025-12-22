External;

{$I "include:utils/stringlib.i"}
{$I "include:exec/memory.i"}

type
	Str_List = record
		pos  : integer;
		next : ^Str_List;
	end;

	Str_ListPtr = ^Str_List;

function Str_C_Pos(s : string;c : char) : Str_listPtr;

var
	debut,cour,nouv : Str_ListPtr;
	i : integer;

begin
	debut := nil;
	for i := 0 to (strlen(s)-1) do
		if s[i] = c then
		begin
			nouv := allocmem(8,MEMF_PUBLIC);
			nouv^.pos := i+1;
			nouv^.next := nil;
			if debut = nil then
				debut := nouv
			else
				cour^.next := nouv;
			cour := nouv;
		end;
	Str_C_Pos := debut;
end;
