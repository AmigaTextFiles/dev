#
# 'qdev'
# by Burnt Chip Dominators
#
# Please note! Object 'i-mem_dbsupport.o' is in fact 'i-mem_dbsupport.o_db'
# by default, so  output  is  possible independently of global or selective
# setting. You should really leave it as it is.
#

OBJECTS_A =                       \
          a-crt_xxxargv.o         \
          a-crt_xxxinstance.o     \
          a-crt_xxxmethod.o       \
          a-ctl_haltidcmp.o       \
          a-nfo_fssmvalid.o       \
          a-nfo_m68kcputype.o

OBJECTS_P =                       \
          p-mem_lzwcompress.o     \
          p-mem_lzwdecompress.o   \
          p-mem_lzwfree.o         \
          p-txt_debugprintf.o

OBJECTS_I =                       \
          i-mem_csumchs32.o       \
          i-mem_csumeor32.o       \
          i-mem_csumint32.o       \
          i-mem_fnv128hash.o      \
          i-mem_fnv64hash.o       \
          i-mem_pjw64hash.o       \
          i-nfo_qversion.o        \
          i-txt_fnv128hash.o      \
          i-txt_fnv128ihash.o     \
          i-txt_fnv64hash.o       \
          i-txt_fnv64ihash.o      \
          i-txt_pjw64hash.o       \
          i-txt_pjw64ihash.o      \
          i-txt_quickhash.o       \
          i-txt_quickihash.o

OBJECTS_X =

#
# Warning!  Order  of these objects  is not random.  They are word arranged
# which means that first object will be extracted as a first word!
#
OBJECTS_QO =


OBJECTS = $(OBJECTS_A) $(OBJECTS_P) $(OBJECTS_I)
OBJECTSB = $(addsuffix b,$(OBJECTS))
OBJECTSB32 = $(addsuffix b32,$(OBJECTS))
OBJECTSDB = $(addsuffix _db,$(OBJECTS))

LIBRARY = libqdev.a
LIBRARYB = libb/$(LIBRARY)
LIBRARYB32 = libb32/libm020/$(LIBRARY)
LIBRARYDB = libqdev_debug.a

ifeq ($(BINARYMODE),R)
BMOBJECTS = $(OBJECTSB)
BMLIBRARY = $(LIBRARYB)
else
ifeq ($(BINARYMODE),R32)
BMOBJECTS = $(OBJECTSB32)
BMLIBRARY = $(LIBRARYB32)
else
BMOBJECTS = $(OBJECTS)
BMLIBRARY = $(LIBRARY)
endif
endif

GCC = gcc
APF = APF -sl
CC = $(GCC)
G_CC = $(CC)
L_CC = $(CC)
MKMB =
MKMP =
EXAB =
EXAP =


INCPATH = ../include/qdev
SUPPCODE = ../supp

#AP_MITP_OPT = -tb -ts -tl

DEBUGSTD = -D___QDEV_DEBUGINFO -fno-inline-functions
DEBUGIO = $(DEBUGSTD) -finstrument-functions


all: platform

$(LIBPRFX)*.o*:                   $(INCPRFX)$(INCPATH)/qdev.h
$(LIBPRFX)qcrt0.o:                $(INCPRFX)$(INCPATH)/qcrt0.h
$(LIBPRFX)a-crt_xxxargv.o*:       $(INCPRFX)$(INCPATH)/qcrt0.h
$(LIBPRFX)a-crt_xxxinstance.o*:   $(INCPRFX)$(INCPATH)/qcrt0.h
$(LIBPRFX)a-crt_xxxmethod.o*:     $(INCPRFX)$(INCPATH)/qcrt0.h
$(LIBPRFX)p-mem_lzwcompress.o*:   $(INCPRFX)$(INCPATH)/p-mem_lzwxxx.h
$(LIBPRFX)p-mem_lzwdecompress.o*: $(INCPRFX)$(INCPATH)/p-mem_lzwxxx.h
$(LIBPRFX)p-mem_lzwfree.o*:       $(INCPRFX)$(INCPATH)/p-mem_lzwxxx.h
$(LIBPRFX)i-mem_pjw64hash.o*:     $(INCPRFX)$(INCPATH)/i-txt_pjw64hash.h
$(LIBPRFX)i-nfo_qversion.o*:      $(INCPRFX)$(INCPATH)/qversion.h
$(LIBPRFX)i-txt_fnv128hash.o*:    $(INCPRFX)$(INCPATH)/i-txt_fnv128hash.h
$(LIBPRFX)i-txt_fnv64hash.o*:     $(INCPRFX)$(INCPATH)/i-txt_fnv64hash.h
$(LIBPRFX)i-txt_pjw64hash.o*:     $(INCPRFX)$(INCPATH)/i-txt_pjw64hash.h
$(LIBPRFX)i-txt_quickhash.o*:     $(INCPRFX)$(INCPATH)/i-txt_quickhash.h



$(LIBPRFX)i-mem_fnv128hash.o*:    $(LIBPRFX)i-txt_fnv128hash.c                \
                                  $(INCPRFX)$(INCPATH)/i-txt_fnv128hash.h
$(LIBPRFX)i-mem_fnv64hash.o*:     $(LIBPRFX)i-txt_fnv64hash.c                 \
                                  $(INCPRFX)$(INCPATH)/i-txt_fnv64hash.h
$(LIBPRFX)i-txt_fnv128ihash.o*:   $(LIBPRFX)i-txt_fnv128hash.c                \
                                  $(INCPRFX)$(INCPATH)/i-txt_fnv128hash.h
$(LIBPRFX)i-txt_fnv64ihash.o*:    $(LIBPRFX)i-txt_fnv64hash.c                 \
                                  $(INCPRFX)$(INCPATH)/i-txt_fnv64hash.h
$(LIBPRFX)i-txt_pjw64ihash.o*:    $(LIBPRFX)i-txt_pjw64hash.c                 \
                                  $(INCPRFX)$(INCPATH)/i-txt_pjw64hash.h
$(LIBPRFX)i-txt_quickihash.o*:    $(LIBPRFX)i-txt_quickhash.c                 \
                                  $(INCPRFX)$(INCPATH)/i-txt_quickhash.h
