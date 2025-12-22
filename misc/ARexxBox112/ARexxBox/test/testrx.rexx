/* ARexx Skript zum Testen des ARexxBox-Tests :-) */

address 'arbtest'
options results

/* welche Befehle gibt's denn so? */

help stem a.

say 'Es gibt' a.commandlist.count 'Befehle im Testprogramm, und zwar:'

do i=0 to a.commandlist.count-1
	say a.commandlist.i
	end i

/* wie benutze ich HELP? */

help help var hilfe

say 'Die Hilfe zu HELP lautet:'
say hilfe

say 'PRESS RETURN!'
pull line

/* Listen testen */

a = 1234

say 'rufe nun multi_in_num auf (siehe Ausgabefenster)'
multi_in_num a 2*a 0 a/2 1

say 'Achtung, numerische Werte dürfen nur ganzzahlig sein! Beweis:'
multi_in_num 3.1415926

say 'PRESS RETURN!'
pull line

say 'rufe nun multi_in_str auf (siehe Ausgabefenster)'
multi_in_str a 'a' testtext "two words!" '"the quick brown fox jumps over the lazy dog"'

say 'Strings übergeben ist so schöner...'
a = '"Dies ist ein Test!"'
b = '"ARexxBox? Find'' ich gut!"'
multi_in_str a b

say 'PRESS RETURN!'
pull line

multi_out_num
say 'multi_out_num:' result

multi_out_str var v stem s.
count = s.liste.count

say 'multi_out_str als VAR:' v

say 'multi_out_str als STEM: s.liste.count =' count

do i=0 to count-1
	say 's.liste.' || i '=' s.liste.i
	end i

say 'ENDE des Tests!'

exit
