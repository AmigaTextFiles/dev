{ Program OVTest : Loads in a picture ( Test.8iff ) and fades
  it in using opal.library routines (Opal.unit). by K.Petlig }

Program OVTest;

uses Exec, Opal, Crt;

var
  OScrn : pOpalScreen;
  RC : LongInt;
  FName : CString;
  IVar : Integer;

begin
  OScrn:= NIL;
  PasToC('Test.8iff', FName);   { Name of the background }
  OpalBase:= OpenLibrary('opal.library', 0);
  if OpalBase <> NIL then begin
    RC:= LoadImage24(OScrn,@FName,0);
    if RC > OL_ERR_MAXERR then begin
      OScrn:= pOpalScreen(RC);  { Result code must be Pointer }
      UpdatePalette24;
      FadeOut24(2);
      Delay(100);
      Refresh24;
      FadeIn24(100);
      for IVar:= 1 to 200 do
        Scroll24(1, 0);
      for IVar:= 1 to 89 do Begin
        Scroll24(-1, 2);
        Scroll24(-0, 2);
        end;
      Delay(500);
      CloseScreen24;
      CloseLibrary(OpalBase);
      end;
    end;
  end.
