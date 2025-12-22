-- Zeigerverwaltung
-- Autor: Norman Walter
-- Datum: 2.2.2002

-- Das Paketschema zeiger_verwaltung stellt dem Benutzer die
-- Möglichkeit der "garbage collection" zur Verfügung.
-- Es wird der zeiger_typ definiert, mit dem die Komponenten
-- einfach verkettet werden. Das Paket enthält die Prozeduren
-- ablegen und holen, um ein überflüssig gewordenes
-- Listenelement an die Liste anzuhängen bzw. ein Listenelement
-- aus der Liste zu entnehmen. Erst wenn die Liste leer ist,
-- wird in holen ein neues Listenelement erzeugt.

generic
   type komponente is private;

package zeiger_verwaltung is
   type komponente_rahmen;
   type zeiger_typ is access komponente_rahmen;
   type komponente_rahmen is
      record
         daten : komponente;
         nachfolger : zeiger_typ;
      end record;
   procedure ablegen (zeiger : in out zeiger_typ);
   procedure holen (zeiger : out zeiger_typ);
end zeiger_verwaltung;
