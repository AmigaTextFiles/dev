VPATH = /Entwicklung/Entwicklung/progtools/subversion-1.1.4/apr-util/uri

INCLUDES = -I/Entwicklung/Entwicklung/progtools/subversion-1.1.4/apr-util/include -I/Entwicklung/Entwicklung/progtools/subversion-1.1.4/apr-util/include/private  -I/Entwicklung/Entwicklung/progtools/subversion-1.1.4/apr/include  -I/Entwicklung/Entwicklung/progtools/subversion-1.1.4/apr-util/xml/expat/lib -I.

TARGETS = uri_delims.h apr_uri.lo
CLEAN_TARGETS = gen_uri_delims uri_delims.h

# bring in rules.mk for standard functionality
include /Entwicklung/Entwicklung/progtools/subversion-1.1.4/apr-util/build/rules.mk

gen_uri_delims_OBJECTS = gen_uri_delims.lo
gen_uri_delims: $(gen_uri_delims_OBJECTS)
	$(LINK) $(EXTRA_LDFLAGS) $(gen_uri_delims_OBJECTS) $(EXTRA_LIBS)

apr_uri.lo: uri_delims.h apr_uri.c

uri_delims.h: gen_uri_delims
	./gen_uri_delims > uri_delims.h
