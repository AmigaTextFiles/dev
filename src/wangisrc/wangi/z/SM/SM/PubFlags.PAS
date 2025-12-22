Procedure TogglePubFlags;

VAR
	old, flags : LONG;
	
begin
	flags := 0;
	if shang then flags := flags | SHANGHAI;
	if poppub then flags := flags | POPPUBSCREEN;
	old := SetPubScreenModes(flags);
end;