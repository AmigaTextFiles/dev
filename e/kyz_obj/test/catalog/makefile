include ../../../make-defs
#
#EC = ec OPTI QUIET
#CAT = FlexCat NOBEEP

FILES=helloworld_test catalogs/français/helloworld.catalog

all: $(FILES)
clean:;	$(RM) $(FILES) *.m helloworld.e

#-------------------------

# generate actual code for the helloworld catalog
helloworld.e: helloworld.cd E.sd
	$(CAT) $< $@=E.sd

# compile the generated catalog code
helloworld.m: helloworld.e catalog.m
	$(EC) $<

# make the main test program itself
helloworld_test: helloworld_test.e helloworld.m
	$(EC) $<

# generate real catalog from the .ct (and .cd) file
%.catalog: %.ct
	$(CAT) $(*F).cd $< catalog $@
