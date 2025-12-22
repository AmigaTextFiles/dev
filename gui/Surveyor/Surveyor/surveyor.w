FROM
lbs:c.o
objs:surveyor.o
objs:planeacc.o
objs:chip.o
LIB
lbs:lc.lib
lbs:amiga.lib
TO
surveyor

SMALLCODE
NODEBUG
