Program PenShare;

{ Dieses Programm demonstriert die ObtainPen Funktion der graphics.lib V39+

  Ab OS3.0 gibt es sogenanntes Pen Sharing. Das bedeutet, daß sich
  verschiedene Programme die Farben der Workbench teilen. Zum Beispiel
  können Sie mit Multiview 2 Bilder mit 256 auf der Workbench anzeigen,
  wobei beide noch relativ gut aussehen.

  Mit der Funktion ObtainPen können Sie sich ein Farbregister mit einem
  ganz bestimmten Farbwert reservieren lassen.

  Es gibt noch eine zweite Funktion namens ObtainBestPen (Multiview
  benutzt diese Fkt.). Mit ihr werden die Farbwerte nicht 100%ig exakt
  behandelt. So wird z.B. zwei leicht unterschiedlichen Rottönen dasselbe
  Farbregister zugeordnet.


  Autor: Andreas Tetzl
  Datum: 22.12.1994
}

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/Text.i"}
{$I "Include:Graphics/View.i"}
{$I "Include:Utility/Utility.i"}
{$I "Include:Utils/TagUtils.i"}
{$I "Include:Exec/Ports.i"}

VAR RP : RastPortPtr;
    Win : WindowPtr;
    Colors : Array[0..2] of Integer;
    Msg : MessagePtr;
    VP : ViewPortPtr;
    i : Integer;
    TagList : Address;

PROCEDURE CleanExit(Why : String; RC : Integer);
Begin
 For i:=0 to 2 do
  If Colors[i]<>-1 then ReleasePen(VP^.ColorMap,Colors[i]);

 If Win<>NIL then CloseWindow(Win);
 If GfxBase<>NIL then CloseLibrary(GfxBase);
 If UtilityBase<>NIL then CloseLibrary(UtilityBase);
 If Why<>NIL then Writeln(Why);
 Exit(RC);
end;

Begin
 For i:=0 to 2 do Colors[i]:=-1; { Farbwerte vorbelegen (wegen CleanExit()) }

 UtilityBase:=OpenLibrary("utility.library",39);
 If UtilityBase=NIL then CleanExit("Benötige mindestens OS 3.0 !",10);

 GfxBase:=OpenLibrary("graphics.library",39);
 If GfxBase=NIL then CleanExit("Kann graphics.library nicht öffnen",10);

 TagList:=CreateTagList(WA_Width,150,
                        WA_Height,100,
                        WA_Title,"PenShare",
                        WA_Flags,WFLG_CLOSEGADGET+WFLG_DRAGBAR,
                        WA_IDCMP,IDCMP_CLOSEWINDOW,
                        TAG_END);

 Win:=OpenWindowTagList(nil,TagList);
 FreeTagItems(TagList);
 If Win=NIL then CleanExit("Kann Fenster nicht öffnen",10);
 VP:=ViewPortAddress(Win);
 RP:=Win^.RPort;

 { Für n geben Sie die gewünschte Farbregisternummer }
 { an (-1, wenn es Ihnen egal ist).                  }
 { Die folgenden drei RGB-Werte müssen die ganzen    }
 { 32 Bit ausnutzen. Wenn Sie z.B. für Rot den Wert  }
 { $F0 setzen wollen, müssen Sie in r den Wert       }
 { $F0F0F0F0 einsetzen !                             }
 { Wenn Sie die Farbe später verändern               }
 { (z.B. ColorCycling), müssen Sie im Flags          }
 { Parameter PENF_EXCLUSIVE setzen !                 }
 { (siehe Include:graphics/View.i                    }

 Colors[0]:=ObtainPen(VP^.ColorMap,-1,$FFFFFFFF,0,0,0); { Rot  }
 Colors[1]:=ObtainPen(VP^.ColorMap,-1,0,$FFFFFFFF,0,0); { Grün }
 Colors[2]:=ObtainPen(VP^.ColorMap,-1,0,0,$FFFFFFFF,0); { Blau }
 If (Colors[0]=-1) or (Colors[1]=-1) or (Colors[1]=-1) then 
  CleanExit("Bitte stellen Sie mehr Farben für die Workbench ein.",10);

 SetAPen(RP,Colors[0]);
 Move(RP,40,40);
 GText(RP,"Rot",3);
 
 SetAPen(RP,Colors[1]);
 Move(RP,40,60);
 GText(RP,"Grün",4);

 SetAPen(RP,Colors[2]);
 Move(RP,40,80);
 GText(RP,"Blau",4);

 Msg:=WaitPort(Win^.UserPort);
 Msg:=GetMsg(Win^.UserPort);
 ReplyMsg(Msg);

 CleanExit(NIL,0);
end.

