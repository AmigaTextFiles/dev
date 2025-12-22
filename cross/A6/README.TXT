A6 0.4.3 -- known problems

The makefiles are terrible; on Unix, you'll have to
do "make a6;make compare" and do the steps to test it
yourself.  For some reason, it wants to compile
"all.c" and I haven't sussed out why - if you can
mangle the results into a working makefile, please send
it to me.

Under DOS, the situation is worse.  That one generates
a circular reference, and I can't suss that one out
either.

On the Amiga...  it just works.

Man, I hate make.

SC


LATE BREAKING NEWS:  I just found out .add and .eor
don't work.  Damn and curse, I don't have time to
fix it;  I've patched good.prg so compare won't
complain.  I promise I'll fix this next time (and
that the next version won't take so damn long!)