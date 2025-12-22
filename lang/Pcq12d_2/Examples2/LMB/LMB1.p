Program LMBdemo;

Function LeftMouseButton: Boolean;
Begin
{$A
;---
	moveq	#0,d0
	btst	#6,$bfe001
	bne.s	notpressed
pressed:
	moveq	#-1,d0

notpressed:
;---
}
end;


Begin

  Repeat

    write("\n\n  LMB-Demo by Diesel 4 use with PCQ\n\n   press left mousebutton !!!\n\n");

  until LeftMousebutton;

end.
