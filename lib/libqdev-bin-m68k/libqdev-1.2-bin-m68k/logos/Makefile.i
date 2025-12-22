#
# Logo creation machinery.
#

CFLAGS = $(OPTLEV) $(STDCPU) -Wall -I../$(INCPATH)
LDFLAGS = -s $(NOSTARTFILES)


$(LOGO).logo: $(GENANIMF) $(MKHEADERF) $(LZWPACKF)
	-rm -f $(LOGO).h
	/c/list >$(LOGO).batch \#?.h lformat %n files
	/c/sort $(LOGO).batch $(LOGO).batch
	$(GENANIMF) $(LOGO).batch $(LOGO).c fd $(FDELAY) \
cd $(CDELAY)
	$(CC) $(CFLAGS) $(LDFLAGS) $(LOGO).c -o $@
	$(LZWPACKF) $@ $(LOGO).lzw
	$(MKHEADERF) $(LOGO).lzw $(LOGO).h
	$(CC) $(CFLAGS) $(LDFLAGS) -D___GENANIM_PACKED \
$(LOGO).c -o $(LOGO).loco

$(GENANIMF): $(GENANIMF).c
	(cd $(GENANIMP) ; make)

$(MKHEADERF): $(MKHEADERF).c
	(cd $(MKHEADERP) ; make)

$(LZWPACKF): $(LZWPACKF).c
	(cd $(LZWPACKP) ; make)

clean:
	-rm -f $(LOGO).batch $(LOGO).c $(LOGO).h $(LOGO).lzw

cleanall:
	-rm -f $(LOGO).batch $(LOGO).c $(LOGO).h $(LOGO).lzw \
$(LOGO).loco $(LOGO).logo
