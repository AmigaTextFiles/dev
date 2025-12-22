--
-- Paket: Einlesen von natürlichen Zahlen in beliebiger Repraesentierung
-- (GetAnyNumber)
--
-- Datei: getanynumber.ads
--
-- Autor: Gunnar Hilling
-- Datum: 22.11.2000
--

package GetAnyNumber is
	procedure GetANumber(num: Out Natural; base: In Natural);
	-- Lies eine natuerliche Zahl in der Basis 'base' ein
	-- Ungültige Zeichen in der Eingabe werden ignoriert.
	-- Kein (gültiges) Zeichen in der Eingabe (neue Zeile) liefert den Wert 0
end GetAnyNumber;
