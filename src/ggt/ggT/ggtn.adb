-- ggtn
-- Autor: Norman Walter, Universität Stuttgart
-- Datum: 3.2.2002
-- Berechnet den größten gemeinsamen Teiler (ggT)
-- von n größer oder gleich 2 Zahlen.

with text_io,ada.integer_text_io;
use  text_io,ada.integer_text_io;

with schlangenpaket;

with teiler;
use  teiler;

procedure ggtn is

package int_schlange is new schlangenpaket(integer);
use int_schlange;

stack: schlangen_infos;
x: integer;

function ggt_n (FIFO: schlangen_infos) return integer is
-- Berechnet den größten gemeinsamen Teiler von n >= 2 Zahlen.
-- Die Zahlen werden zuvor im FIFO-Speicher abgelegt.
-- Funktion ggt wird überladen.

a,b: integer;
stapel: schlangen_infos;

 begin

  stapel:=FIFO;

  loop

    -- Zahl a vom Stapel abnehmen.
    pop(stapel,a);

    -- Prüfen, ob es das letzte Element war.
    -- Wenn ja, springe aus der Schleife.
    -- Der ggT von allen Zahlen steht dann in der Variable a.

    exit when schlange_leer(stapel);

    -- Zahl b vom Stapel abnehmen.
    pop(stapel,b);

    -- Größten gemeinsamen Teiler von a und b auf den Stapel legen.
    -- Achtung: Dies ist keine Rekursion. Es wird vielmehr die
    -- Funktion ggt(a,b) für zwei Elemente zur Berechnung herangezogen.

    push(stapel,ggt(a,b));

  end loop;

  -- Gebe den ggT von allen zahlen zurück.

  return a;

end ggt_n;


begin

 put("Berechnet den größten gemeinsamen Teiler von n > 1 Zahlen.");
 new_line;
 put("Eingabe von 0 beendet die Eingabe");
 new_line;

 loop

   put("Zahl=");
   get(x);

   -- Gibt der Benutzer 0 ein, wird die Eingabeschleife beendet.
   -- Alle Zahlen, von denen der ggT gebildet werden soll,
   -- liegen dann auf dem Stack.

   exit when x=0;

   -- Zahl auf den Stack legen

   push(stack,x);

 end loop;

   put("Größter gemeinsamer Teiler: ");
   put(ggt_n(stack),0);

end ggtn;
