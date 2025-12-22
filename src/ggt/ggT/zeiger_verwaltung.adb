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

package body zeiger_verwaltung is
   listen_anfang : zeiger_typ := null;

   procedure ablegen (zeiger : in out zeiger_typ) is
   begin
      zeiger.nachfolger:= listen_anfang;
      listen_anfang:= zeiger;
      zeiger:= null;
      exception
         when constraint_error => null;
              -- wird ausgelöst, wenn zeiger null war,
              -- also ablegen mit einem unbelegten
              -- Zeiger aufgerufen wurde.
   end ablegen;

   procedure holen (zeiger : out zeiger_typ) is
   begin
      if listen_anfang = null
         then zeiger:= new komponente_rahmen;
         else zeiger:= listen_anfang;
              listen_anfang:= listen_anfang.nachfolger;
              zeiger.nachfolger:= null;
         end if;
   end holen;

end zeiger_verwaltung;
