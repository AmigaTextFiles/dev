
xp%=INSTR(COMMAND$,".")

long1&=VAL(LEFT$(COMMAND$, xp%-1))

long2&=VAL(MID$(COMMAND$,xp%+1))

dub#=CVD(MKL$(long1&)+MKL$(long2&))

dub$=LTRIM$(STR$(dub#))

PRINT dub$


