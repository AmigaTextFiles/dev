include ../make-defs

FILES =	args.m fixed.m keypress.m loadfile.m \
	makedir.m rawkeys.m stealchip.m string.m \
\
	eglobs.i clr.m debug.m ddebug.m defarg.m div64.m hex.m \
	mkport.m ledfilter.m paths.m segtracker.m steallong.m \
\
	test/debugtest test/hextest test/keytest test/ledtest \
	test/pathtest test/segtrackertest test/stealtest

all: $(FILES)
clean:;	$(RM) $(FILES) *.o *.m test/*.m

test/%test: test/%test.e
	$(CP) #?$(*F)#?.m test/
	$(EC) $<
	$(RM) test/#?$(*F)#?.m

%.m: %.e
	$(EC) $<

%.m: %.asm eglobs.i
	$(ASM) NOEXE $< 
	$(O2M) $(*F)
	$(FLUSH) $(*F)
	$(RM) $(*F).o

eglobs.i:
	$(EC) eglobs
	eglobs >eglobs.i
	$(RM) eglobs
