-- sets.ads
-- Header fuer Blatt 11, generischer Mengentyp
-- Erweiterte Version 1.1
-- Autor: Norman Walter
-- Datum: 6.02.2001

with lists;

generic
   type Element is private;
      --Vergleichsfunktion für den Elementtyp, wird zum Ordnen benötigt.
   with function "<"(u,v: Element) return boolean;
   with function ">"(u,v: Element) return boolean;
   with function "="(u,v: Element) return boolean;
   with function ">="(u,v: Element) return boolean;
   with function "<="(u,v: Element) return boolean;
      --Ausgabeprozedur für den Elementtype, für "Put".
   with procedure ElPut(u: Element);

package sets is
   type set is private;
   
      -- Menge ausgeben
   procedure Put(s: In set);

-- Aufgabe 1 (siehe Aufgabenstellung): 
   function newset return set;
   function copy(s: In set) return set;
   function incl(s: In set; e: In Element) return set;
   function excl(s: In set; e: In Element) return set;
   function contains(s: In set; e: In Element) return boolean;

-- Aufgabe 2 (siehe Aufgabenstellung):
   function difference(s1, s2: In set) return set;
   function intersection(s1, s2: In set) return set;
   function union(s1, s2: In set) return set;

private
      -- Liste wird benötigt, muß daher hier instantiiert werden.
   package elem_list is new lists(Element); use elem_list;
      -- Eine Menge ist eine Liste (mit besonderen Eigenschaften).
   type set is new liste;

end sets;
