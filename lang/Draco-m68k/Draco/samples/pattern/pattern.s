copy pattern.g drinc:

fdcompile -lLd pattern_lib.fd ;generates pattern.o (aka pattern.lib) and pattern_head.o
delete pattern.lib
rename pattern.o pattern.lib
copy pattern.lib drlib:

draco compile.d match.d
BLink from pattern_head.o+compile.r+match.r library drlib:draco.lib to pattern.library
copy pattern.library libs:

delete #?.r
