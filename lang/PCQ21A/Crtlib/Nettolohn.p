program netto;

{$I "include:Other/crt.i"}

const
   kv =  0.12;    { Krankenversicherungssatz }
   av =  0.065;   { Arbeitslosenversicherungssatz }
   pv =  0.017;   { Pflegeversicherungssatz }
   rv =  0.202;   { Rentenversicherungssatz }
   
   ls =  0.2;     { Fiktiver Lohnsteuersatz }
   sz =  0.075;   { Solidaritätszuschlagssatz }
   
   t1 =  3;    { Tabulator 1 }
   t2 =  30;   { Tabulator 2 }
   
var
   kirche_ja   :  boolean;
   stunden     :  integer;
   stundenlohn, lohnsteuer, brutto, sozi, ks : real;
   key         :  char;
   
function WritePrompt(spalte : integer; str : string) : integer;
begin
   GotoXY(t1, spalte);  Write(str);
   GotoX(t2-3);         Write(" > ");
   
   WritePrompt := WhereX;
end;
   
procedure WriteLnBetrag(str : string; betrag : real; prozent : real);
begin
   GotoX(t1);     Write(str);
   GotoX(t2-3);   Write(" : ");
   
   if prozent >= 0 then WriteLn((betrag*prozent):10:2, " DM [", (prozent*100):2:2, "%]")
   else WriteLn(betrag:10:2, " DM");
end;

function JaNein(spalte : integer; str : string) : boolean;
var
   antwort  :  char;
   zeile    :  integer;
begin
   zeile    := WhereY;
   spalte   := WritePrompt(spalte, str);
   
   Write("j oder n");
   GotoX(spalte);
   
   repeat
      antwort := ReadKey;
   until (antwort = char($0D)) or (antwort = 'j') or (antwort = 'n');
   
   if antwort = char($0D) then antwort := 'j';
   
   GotoX(spalte); WriteLn(antwort, "       ");
   
   JaNein := (antwort = 'j');
end;

begin
   ClrScr;
   ConBackground(1);
   
   repeat
      TextColor(0);
      GotoXY(t1+2, 2);  Write("Berechnung des monatlichen Nettolohnes");
      GotoXY(t1+2, 3);  Write("¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯");
      TextColor(4);
      CursorOn;
      GotoX(WritePrompt(4, "  Anzahl Arbeitsstunden"));  ReadLn(stunden);
      GotoX(WritePrompt(5, "  Stundenlohn"));            ReadLn(stundenlohn);

      TextColor(2);
      kirche_ja   := JaNein(6, "  Kirchenmitglied");
      brutto      := stundenlohn * stunden;

      TextColor(4);
      WriteLnBetrag("  Bruttolohn", brutto, -1);

      lohnsteuer  := brutto * ls;

      TextColor(3);
      WriteLnBetrag("- Lohnsteuer", brutto, ls);
      WriteLnBetrag("- Solizuschlag", lohnsteuer, sz);

      if (kirche_ja = true) then begin
         ks := 0.09;
         WriteLnBetrag("- Kirchensteuer", lohnsteuer, ks);
      end else ks := 0;

      WriteLnBetrag("- Rentenversicherung", brutto, rv/2);
      WriteLnBetrag("- Krankenversicherung", brutto, kv/2);
      WriteLnBetrag("- Arbeitslosenvers.", brutto, av/2);
      WriteLnBetrag("- Pflegeversicherung", brutto, pv/2);
      
      TextColor(4);
      WriteLnBetrag("= Nettolohn", (brutto - lohnsteuer*(1+sz+ks) - brutto*((rv+kv+av+pv)/2)), -1);
      
      CursorOff;
      
      key := ReadKey;
      
      ClrScr;
   until key = 'q';
   
   ConReset;
end.
