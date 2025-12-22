-- source : sets.adb
-- header : sets.ads
-- Zweck  : generischer, abstrakter Datentyp (ADT) für Mengen.
--          Verwendet generischen Listentyp von Gunnar Hilling.
-- Autor  : Norman Walter, Universität Stuttgart
-- Version: 1.2 (6.Januar 2001) mit Vergleichsoperatoren

with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;


package body Sets is

-- Blatt 12, Aufgabe 1:
-- Implementierung der Vergleichsoperatoren

function "<"(s1,s2:in set) return boolean is
begin
 if isempty(s2) then
   return false; -- kann nicht kleiner als leere Menge sein
 elsif isempty(s1) then
   return true; -- s2 ist nicht leer
 elsif head(s1)=head(s2) then
   return tail(s1)<tail(s2); -- Restevergleich
 else
   return head(s1)<head(s2); -- Teste aktuelle Elemente
 end if;
end "<";

function ">"(s1,s2:in set) return boolean is
begin
 if isempty(s2) then
   return true; -- kann nicht kleiner als leere Menge sein
 elsif isempty(s1) then
   return false; -- leere Menge kann nicht größer als etwas sein
 elsif head (s1)=head(s2) then
   return tail(s1)>tail(s2); -- Restevergleich
 else
   return head(s1)>head(s2); -- Teste aktuelle Elemente
 end if;
end ">";

function "="(s1,s2:in set) return boolean is
begin
 return head(s1)=head(s2);
end "=";

function "<="(s1,s2:in set) return boolean is
begin
 if "<"(s1,s2) or "="(s1,s2) then
   return true;
 else
   return false;
 end if;
end "<=";

function ">="(s1,s2:in set) return boolean is
begin
 if ">"(s1,s2) or "="(s1,s2) then
   return true;
 else
   return false;
 end if;
end ">=";

-- von Blatt 11
-- Aufgabe 1:

procedure Put(S: in Set) is
-- Gibt Menge aus.
begin
    if not IsEmpty(S) then
        ElPut(Head(S));
        Put(Tail(S));
    end if;
end Put;

function NewSet return Set is
-- Erzeugt leere Menge
begin
    return NewList;
end Newset;

function Copy(S: in Set) return Set is
-- Liefert eine Kopie der Menge s.
begin
    if IsEmpty(S) then
        return NewSet;
    else
        return Cons(Head(S), Copy(Tail(S)));
    end if;
end Copy;

function Incl(S: in Set; E: in Element) return Set is
-- Liefert Kopie von s mit zusätzlichem Element e.
begin
    if IsEmpty(S) then
        return Cons(E, NewSet);
    else
        if Contains(S, E) then
            return Copy(S);
        elsif E < Head(S) then
            return Cons(E, S);
        else
            return Cons(Head(S), Incl(Tail(S), E));
        end if;
    end if;
end Incl;

function Excl(S: in Set; E: in Element) return Set is
-- Liefert Kopie von s ohne das Element e.
begin
    if IsEmpty(S) then
        return NewSet;
   else
       if not Contains(S, E) then
           return Copy(S);
       elsif Head(S) = E then
           return Copy(Tail(S));
       else
           return Cons(Head(S), Excl(Tail(S), E));
       end if;
    end if;
end Excl;

function Contains(S: in Set; E: in Element) return Boolean is
-- Liefert true, falls e in s enthalten ist, sonst false
begin
    if IsEmpty(S) then
        return False;
    else
        if Head(S) = E then
            return True;
        else
            return Contains(Tail(S), E);
        end if;
    end if;
end Contains;

-- Aufgabe 2:

function Difference(S1, S2: in Set) return Set is
-- Liefert Mengendifferenz
begin
    if IsEmpty(S1) then
        return NewSet;
    elsif IsEmpty(S2) then
        return copy(S1);
    else
        return Excl(Difference(S1, Tail(S2)), Head(S2));
    end if;
end Difference;

function Intersection(S1, S2: in Set) return Set is
-- Liefert Schnittmenge
begin
    if IsEmpty(S1) or IsEmpty(S2) then
        return NewSet;
    else
        if Head(S1) = Head(S2) then
            return Incl(Intersection(Tail(S1), Tail(S2)), Head(S1));
        elsif Head(S2) < Head(S1) then
            return Intersection(S1, Tail(S2));
        else
            return Intersection(Tail(S1), S2);
        end if;
    end if;
end Intersection;

function Union(S1, S2: in Set) return Set is
-- Liefert Vereinigungsmenge
begin
    if IsEmpty(S1) and IsEmpty(S2) then
        return Newset;
    elsif IsEmpty(S1) then
        return S2;
    elsif IsEmpty(S2) then
        return S1;
    else
        return Incl(Union(Tail(S1), S2), Head(S1));
    end if;
end Union;


end Sets;
