program AutoReqDemo;

{ ****************************************************************************

	(P) 12/1992 by Diesel - dieses Programm und der zugehörige
	Quellcode sind Public Domain - macht damit, was Ihr wollt.
	Is' auch nur ein kleines Beispielprogramm ...

  **************************************************************************** }


{$I "include:intuition/intuition.i" }
{$I "include:libraries/dos.i" }

Const	{ Texte deklarieren, die im Req. erscheinen sollen - Wichtig :
	  es handelt sich um IntuiText-Records !!!  }

	TopText : IntuiText = (2,3,jam1,1,1,NIL,"Gefällt Dir der Requester ?   :-)",NIL);
	PosText : IntuiText = (AutoFrontPen,AutoBackPen,AutoDrawMode,AutoLeftEdge,AutoTopEdge,NIL,"Na logo",NIL);
	NegText : IntuiText = (AutoFrontPen,AutoBackPen,AutoDrawMode,AutoLeftEdge,AutoTopEdge,NIL,"Also, ich weiß nicht so recht ...",NIL);


Var
	ok : Boolean;

Begin

	ok:=AutoRequest(NIL,	{ sonst eigener WindowPtr }
			Adr(TopText),
			Adr(PosText),
			Adr(NegText),
			0,	{ IDCMP-Flags für pos. Fall }
			0,	{ IDCMP-Flags für neg. Fall }
			227,	{ wieso grade 227 ? Nur so .. }
			35);

	{ Ihr könnt bei den IDCMP-Flags auch was anderes angeben.
	  Diese Flags würden Eurem Programm dann gesendet. Praktisch
	  z.B. bei CloseWindow . }


	If ok=TRUE then write("...hat Geschmack,der Mensch !\n")
		   else write("Meine Güte, verwöhnt, was ?!?!!\n");


	Delay(50);

End.
