{ -----------------------------------------------------------------------
  -									-
  - Programm WBColors							-
  -	     Sollte under Kick 2.0 die WB 1.3 Farben einstellen 	-
  -	     und under Kick 1.3 die WB 2.0 Farben			-
  -									-
  - Programmiert in PCQ- Pascal V1.2b (c) 1992 by T.Schmid              -
  - Dieses Programm ist Freeware, wurde aber ausdrücklich für PURYTI	-
  - erstellt								-
  -----------------------------------------------------------------------
}

Program WBColors;

{$I "include:exec/exec.i"              }
{$I "include:exec/execbase.i"          }
{$I "include:intuition/intuition.i"    }
{$I "include:intuition/intuitionbase.i"}

Const
    StdInName	  : Address = Nil;
    StdOutName	  : Address = Nil;
    Exec	  : Integer = $0004;

Var
    MyScreen	  : Address;
    MyViewPort	  : Address;
    MyIntuiBase   : IntuitionBasePtr;
    GfxBase	  : Address;
    MyExecBase	  : ExecBasePtr;

Type
    MyAdrPtr = ^Address;

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
    MyScreen:=MyIntuiBase^.FirstScreen;
{$A
	move.l	_MyScreen,d7	; Diese Lösung ist von Diesel. Kennt jemand eine andere ?
	add.l	#44,d7	       ; Port:=MS+44 = MS^.viewPort
	move.l	d7,_MyViewPort ; IB^.FirstScreen^.ViewPort Funktioniert nicht
}

    MyExecBase:=Address(MyAdrPtr(Exec)^);
    If MyExecBase^.LibNode.lib_Version < 37 Then
    Begin
       SetRGB4(MyViewPort,0,0,5,10);
       SetRGB4(MyViewPort,1,15,15,15);
       SetRGB4(MyViewPort,2,0,0,2);
       SetRGB4(MyViewPort,3,15,8,0);
    End Else Begin
       SetRGB4(MyViewPort,0,10,10,10);
       SetRGB4(MyViewPort,1,0,0,0);
       SetRGB4(MyViewPort,2,15,15,15);
       SetRGB4(MyViewPort,3,6,7,9);
    End;
    CloseLibrary(LibraryPtr(MyIntuiBase));
    CloseLibrary(GfxBase);
End.
