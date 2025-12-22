CC=g++
OBJECTS= sapCpu.o sapPokey.o pokey0.o pokey1.o sapEngine.o
OPTS=-O2 
AR=ar

all:
	@echo -e "Linux port of SAP Library ver.1.51 by Adam Bienias"
	@echo -e "\ncompilation:"
	@echo -e "\ttype 'make static' to build static library"
	@echo -e "\tor   'make dynamic' to build dynamic library"
	@echo -e "\ninstallation:"
	@echo -e "\ttype 'make install'"
	@echo -e "\nuninstallation:"
	@echo -e "\ttype 'make uninstall'\n"

static: libsap.a

dynamic: libsap.so

$(OBJECTS): %.o: %.cpp
	$(CC) $(OPTS) -o $@ -c $<

libsap.a: $(OBJECTS)
	$(AR) rc $@ $(OBJECTS)

libsap.so: $(OBJECTS)
	$(CC) $(OBJECTS) -shared -o $@

clean:
	rm -f $(OBJECTS) libsap.so libsap.a

install:
	install -Dm644 libsap.h /usr/local/include/libsap.h
	if [ -f libsap.a ]; then install -Dm755 libsap.a /usr/local/lib/libsap.a; fi
	if [ -f libsap.so ]; then install -Dm755 libsap.so /usr/local/lib/libsap.so; fi

uninstall:
	rm -f /usr/local/include/libsap.h /usr/local/lib/libsap.a /usr/local/lib/libsap.so
