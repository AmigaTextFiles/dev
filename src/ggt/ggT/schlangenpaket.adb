-- Schlangenpaket
-- Autor: Norman Walter
-- Datum: 2.2.2002

-- Das Paketschema schlangenpaket stellt dem Benutzer ein
-- Warteschlangenkonzept für einen beliebigen Datentyp zur
-- Verfügung. Aus einer Schlange werden die Elemente in der
-- Reihenfolge ihrer Ankunft wieder ausgegeben (FIFO).
-- länge gibt die Anzahl der Elemente in einer Schlange an.
-- Der Versuch, einer leeren Schlang ein Element zu entnehmen,
-- löst die Ausnahme schlange_ist_leer aus. Intern wird eine
-- Schlange durch den geschützten Typ schlangen_infos
-- repräsentiert. Es wird das Paket zeiger_verwaltung benutzt.


package body schlangenpaket is

use listen_verwaltung;

   procedure push (schlange : in out schlangen_infos; elem : in element) is

   begin

      if schlange.last = null
         then holen (schlange.last);
              schlange.last.all:= (elem,null);
              schlange.first:= schlange.last;
         else holen (schlange.last.nachfolger);
              schlange.last.nachfolger.all:= (elem,null);
              schlange.last:= schlange.last.nachfolger;
         end if;

         schlange.länge:= schlange.länge + 1;

   end push;

   procedure pop (schlange : in out schlangen_infos; elem : out element) is

   begin

      if schlange.länge = 0 then raise schlange_ist_leer;
      end if;

      elem:= schlange.first.daten;

      aushängen:

         declare

            hilfszeiger : zeiger_typ;

            begin

               hilfszeiger:= schlange.first;
               schlange.first:= schlange.first.nachfolger;

               ablegen (hilfszeiger);

      end aushängen;

      schlange.länge:= schlange.länge-1;

      if schlange_leer(schlange) then schlange.last:= null;
      end if;

   end pop;

   function länge (schlange : in schlangen_infos) return integer is

   begin
      return schlange.länge;

   end länge;

   function schlange_leer (schlange : in schlangen_infos) return boolean is
   -- Liefert true zurück, falls schlange leer ist, sonst false
   begin
      return schlange.länge = 0;

   end schlange_leer;

end schlangenpaket;
