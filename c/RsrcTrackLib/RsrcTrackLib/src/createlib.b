
;
;  Creates automatically the pragmas out of the ressourcetracking.fd file.
;  A library for the vbcc compiler is created and copied into the right place.
;  Needs vbcc, PhxAss and the fdtopragma utility from dice.
;

Stack 8192

cd div/
c:delete #?.(s|o)

vbccm68k:bin/fd2lib -sc -sd -of "PhxAss %s SD SC OPT NRQLPSMDI" /fd/ressourcetracking.fd >genlib.b
c:execute genlib.b

vbccm68k:bin/alib R ressourcetracking `c:list LFORMAT "%m" #?.o`

c:copy ressourcetracking.lib vlibm68k:

cd /

dcc:abin/fdtopragma fd/ressourcetracking.fd -o include/pragmas/ressourcetracking_pragmas.h

