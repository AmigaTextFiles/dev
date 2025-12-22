-- lists.ads
-- Header fuer Blatt 11, generischer Listentyp
-- Autor: Gunnar Hilling
-- Datum: 17.01.2001
--
-- wie in der Vorlesung vorgestellt

generic
	type T is private;

package lists is
	type liste is private;

	function newlist return liste;
	function cons(x: T; l: liste) return liste;
	function isempty(l: liste) return boolean;
	function head(l: liste) return T;
	function tail(l: liste) return liste;

private
	type knoten;
	type liste is access knoten;
	type knoten is record
			wert: T;
			nach: liste;
		end record;

end lists;
