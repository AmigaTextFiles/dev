{ -----------------------------------------------------------------------
  -									-
  - Programm WB13							-
  -	     Sollte under Kick 2.0 die WB 1.3 Farben einstellen 	-
  -									-
  - Programmiert in PCQ- Pascal V1.2b (c) 1992 by T.Schmid              -
  - Dieses Programm ist Freeware, wurde aber ausdrücklich für PURYTI	-
  - erstellt								-
  -----------------------------------------------------------------------
}

Program WB13;

{$I "include:intuition/intuition.i"    }
{$I "include:intuition/intuitionbase.i"}

Const
    StdInName	: Address = Nil;
    StdOutName	: Address = Nil;

Var
    MyScreen	: Address;
    MyViewPort	: Address;
    MyIntuiBase : IntuitionBasePtr;
    GfxBase	: Address;

Procedure Usage(warum : String; code : Integer);
Begin
  If MyIntuiBase <> Nil Then CloseLibrary(LibraryPtr(MyIntuiBase));
  If GfxBase <> Nil Then CloseLibrary(GfxBase);
  If warum <> Nil Then WriteLn(warum);
  exit(code);
End;

Begin
    GfxBase:=OpenLibrary("graphics.library",0);
    If GfxBase = Nil Then Usage("Konnte graphics.library nicht öffnen",5);
    MyIntuiBase:=IntuitionBasePtr(OpenLibrary("intuition.library",0));
    If MyIntuiBase = Nil Then Usage("Konnte intuition.library nicht öffnen",10);
    Begin
      MyScreen:=MyIntuiBase^.FirstScreen;
{$A
	move.l	_MyScreen,d7   ; Diese Lösung ist von Diesel. Kennt jemand eine andere ?
	add.l	#44,d7	       ; Port:=MyScreen+44 = MyScreen^.ViewPort
	move.l	d7,_MyViewPort ; MyIntuiBase^.FirstScreen^.ViewPort Funktioniert nicht
}

      SetRGB4(MyViewPort,0,0,5,10);
      SetRGB4(MyViewPort,1,15,15,15);
      SetRGB4(MyViewPort,2,0,0,2);
      SetRGB4(MyViewPort,3,15,8,0);
      CloseLibrary(LibraryPtr(MyIntuiBase));
      CloseLibrary(GfxBase);
    End;
End.
