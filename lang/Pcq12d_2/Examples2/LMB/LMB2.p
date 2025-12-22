Program LMBdemo;



Function LeftMouseButton: Boolean;
Type
	bt = ^Byte;
Var
	bfe : bt;
Begin
	bfe := Address($bfe001);

	If (bfe^ MOD 128) > 64			{ bit 6 gesetzt ? }
	then  LeftMouseButton := False		{ ja -> nicht gedrückt }
	else  LeftMouseButton := True;		{ nein -> lmb gedrückt }
end;


Begin

  Repeat

    write("\n\n  LMB-Demo#2 by Diesel 4 use with PCQ\n\n   press left mousebutton !!!\n\n");

  until LeftMousebutton;

end.
