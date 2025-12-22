include ../../make-defs

FILES=catalog.m helloworld_test catalogs/français/helloworld.catalog catalog.guide

all: $(FILES)
clean:;	$(RM) $(FILES) *.m helloworld.e

helloworld_test: helloworld_test.e helloworld.m; $(EC) $<
helloworld.m: helloworld.e catalog.m; $(EC) $<

%.m: %.e; $(EC) $<
%.e: %.cd E.sd; $(CAT) $< $@=E.sd
%.catalog: %.ct; $(CAT) $(*F).cd $< catalog $@

%.guide: %.e; mkdoc $(*F) $@ $<
