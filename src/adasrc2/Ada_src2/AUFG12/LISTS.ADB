-- lists.adb
-- Implementierung fuer Blatt 11, generischer Listentyp
-- Autor: Gunnar Hilling
-- Datum: 17.01.2001
--
-- wie in der Vorlesung vorgestellt

package body lists is


function newlist return liste is
begin
	return NULL;
end newlist;

function cons(x: T; l: liste) return liste is
begin
	return new knoten'(wert => x, nach => l);
end cons;

function isempty(l: liste) return boolean is
begin
	return l = null;
end isempty;

function head(l: liste) return T is
begin
	return l.wert;
end head;

function tail(l: liste) return liste is
begin
	return l.nach;
end tail;

end lists;
