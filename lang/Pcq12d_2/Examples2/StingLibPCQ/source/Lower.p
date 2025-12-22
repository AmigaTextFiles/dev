external;

{$I "include:utils/stringlib.i"}

function Str_Lower(s:string) : string;

var i : integer;
	 s1 : string;

begin
	s1 := strdup(s);
	for i:=0 to (strlen(s1)-1) do
		s1[i] := tolower(s1[i]);
	Str_Lower:=s1;
end;

