%.o: %.c
	$(CC) $(CFLAGS) -I .. -c $^ 2>&1|tee $*.err
	-if test ! -s $*.err; then rm $*.err; fi

$(TARGET)_functable.c: $(TARGET).fd
	gawk '/@offset/ { while(offset<$$2-1) { print "0," >"tabl";offset++ } } \
	      ! /@/ { if(index($$1,",")) fun=substr($$1,1,index($$1,",")-1); \
	              else fun=$$1; print "&__" fun "," >"tabl"; \
	              print "void __" fun "();" >"prot";offset++ }' $(TARGET).fd
	( cat prot; \
	  echo "void (*const $(TARGET)_funcTable[])()={"; \
	  cat tabl; \
	  echo "(void (*)())-1 };"; ) >$@
	-rm tabl prot

$(TARGET)_fc.h:
	gawk '/FC/ { print $$0 }' *.c >$@

$(TARGET)_fd.h:
	gawk '/FD/ { print $$0 }' *.c >$@

$(TARGET).fc: $(TARGET)_fc.h ../macro/fch2fc.h
	gcc -E -P -include ../macro/fch2fc.h $(TARGET)_fc.h | \
	tr -d ' \t\n' | tr '.;' ' \n' >$@

$(TARGET).fd: $(TARGET)_fd.h ../macro/fdh2fd.h
	gcc -E -P -include ../macro/fdh2fd.h $(TARGET)_fd.h | \
	sort -n | \
	( echo "@basevar.SysBase;"; \
	  gawk '{ if($$1!=""){ if(offset!=$$1) print "@offset." $$1 ";"; \
	        offset=$$1+1; for(i=2;i<=NF;i++) print $$i } }' ) | \
	tr -d ' \t\n' | tr '.;' ' \n' >$@

_$(TARGET).h: $(TARGET)_fd.h
	( echo "#define LIBBASE $(LIBBASE)"; \
	  echo "#define LIBTYPE $(LIBTYPE) *"; ) >_base.h
	( echo "%ifndef __$(TARGET)_h_^"; \
	  echo "%define __$(TARGET)_h_^"; \
	  ( for lib in $(PREINCLUDE); do echo "%include <$$lib.h>^"; done ); \
	  echo "$(LIBTYPE);^"; \
	  gcc -E -P -include ../macro/fdh2_h.h -include _base.h $(TARGET)_fd.h; \
	  echo "%endif"; ) | \
	tr -d '\n' | tr '^%' '\n#' >$@
	-rm _base.h

lib$(TARGET).a: $(TARGET).fd
	mkdir tmp
	cd tmp;../../genglue/genglue -s ../$(TARGET).fd
	cd tmp;../../genglue/genglue -s -l -p _ ../$(TARGET).fd
	cd tmp;gcc -c *.s
	cd tmp;ar -q ../lib$(TARGET).a *.o
	rm -r tmp

lib_$(TARGET).a: $(TARGET).fd $(TARGET).fc
	mkdir tmp
	cd tmp;../../genglue/genglue -s -r -l -p __ -q ___ ../$(TARGET).fd
	cd tmp;../../genglue/genglue -s -l ../$(TARGET).fc
	cd tmp;../../genglue/genglue -s -r -l -p __ -q ___ ../$(TARGET).fc
	cd tmp;gcc -c *.s
	cd tmp;ar -q ../lib_$(TARGET).a *.o
	rm -r tmp
