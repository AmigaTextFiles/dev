--
-- Paket: Einlesen von natürlichen Zahlen in beliebiger Repraesentierung
-- (HexChar)
--
-- Datei: hexchar.ads
--
-- Autor: Gunnar Hilling
-- Datum: 22.11.2000
--

package HexChar is
	function IsValidVal(n: Natural; base: Natural) return Boolean;
	-- liefert TRUE, falls 'n' ein gültige Ziffernwert in der Basis 'base' ist,
	-- sonst FALSE
	function HexDigit(n: Natural) return Character;
	-- Hexziffer '0' .. '9', 'A' .. 'F' zu n
	-- Pre: n < 16
	function IsValidChar(c: Character; base: Natural) return Boolean;
	-- liefert TRUE, falls 'c' eine gültige Ziffer (als Character)
	-- in der Basis 'base' ist, sonst FALSE
	function HexValue(c: Character) return Natural;
	-- Umkehrfunktion zu HexDigit
	-- Pre c in '0' .. '9', 'A' .. 'F'
end HexChar;
