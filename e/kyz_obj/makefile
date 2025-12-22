include ../make-defs

FILES =	bitfield.m catalog.m cdplayer.m datestring.m patch.m \
	rexxstate.m simplebitfield.m \
	test/catalogtest test/cdtest test/cdplaytest test/datetest \
	test/patchtest test/rexxtest \
	$(DOCS)

DOCS =	doc/bitfield.guide doc/catalog.guide doc/cdplayer.guide \
	doc/datestring.guide doc/patch.guide doc/rexxstate.guide \
	doc/simplebitfield.guide 


all: $(FILES)
docs: $(DOCS)
clean:; $(RM) $(FILES) *.m
	$(MAKE) -C test/catalog clean

test/catalogtest: catalog.m
	$(CP) catalog.m test/catalog
	$(MAKE) -C test/catalog

%.m: %.e; $(EC) $<

doc/%.guide: %.e
	$(ADOC) $< > doc/$(*F).doc
	doc2guide doc/$(*F)

test/%test: test/%test.e
	$(CP) #?$(*F)#?.m test/
	$(EC) $<
	$(RM) test/#?$(*F)#?.m

patch.m: patch.e
	$(ASM) $< TO patch_asm.o
	$(O2M) patch_asm
	$(FLUSH) patch_asm
	$(EC) $<
	$(RM) patch_asm.o
