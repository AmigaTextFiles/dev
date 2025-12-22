
STL = LIB:lc.lib LIB:amiga.lib
BLO = SC SD ND NOICONS
TNM = DEFINE __main=__tinymain

SRI: SRI.c
	LC:lc -cfsu -v -O SRI.c
	LC:blink FROM LIB:cback.o SRI.o $(TNM) LIB $(STL) $(BLO) TO SRI

SRI_German: SRI.c
	LC:lc -dGERMAN=1 -cfsu -v -O -oSRI_German.o SRI.c
	LC:blink FROM LIB:cback.o SRI_German.o $(TNM) LIB $(STL) $(BLO) TO SRI_German
