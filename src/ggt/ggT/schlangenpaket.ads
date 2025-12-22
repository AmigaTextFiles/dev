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

with zeiger_verwaltung;

generic
   type element is private;

package schlangenpaket is
   type schlangen_infos is private;
   schlange_ist_leer : exception;

   procedure push (schlange : in out schlangen_infos; elem : in element);

   procedure pop (schlange : in out schlangen_infos; elem : out element);

   function länge (schlange : in schlangen_infos) return integer;

   function schlange_leer (schlange : in schlangen_infos) return boolean;

   private

      package listen_verwaltung is
         new zeiger_verwaltung (komponente => element);
      use listen_verwaltung;

      type schlangen_infos is
         record
            first,last : zeiger_typ := null;
            länge      : integer := 0;
         end record;

end schlangenpaket;
