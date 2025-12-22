external;

{$I "include:utils/stringlib.i"}

function Str_Upper(s:string) : string;

var i : integer;
	 s1 : string;

begin
	s1 := strdup(s);
	for i:=0 to (strlen(s1)-1) do
		s1[i] := toupper(s1[i]);
	Str_Upper:=s1;
end;

