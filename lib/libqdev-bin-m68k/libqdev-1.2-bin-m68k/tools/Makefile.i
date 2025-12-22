#
# 'qdev'
# by Burnt Chip Dominators
#

#
# Following  variable selects binary  mode. Following  modes are available:
# S - Standard, R - Resident, R32 - Resident32.
#
ifeq ($(BINARYMODE),)
BINARYMODE = R
endif

GENANIMP = ../../tools/genanim-0.3
GENANIMF = $(GENANIMP)/genanim

MKHEADERP = ../../tools/mkheader-0.1
MKHEADERF = $(MKHEADERP)/mkheader

LZWPACKP = ../../tools/lzwpack-0.1
LZWPACKF = $(LZWPACKP)/lzwpack

GENSYMTABP = ../tools/gensymtab-0.1
GENSYMTABF = $(GENSYMTABP)/gensymtab

VERBOSE = -Wl,-v
OPTLEV = -O2 -fomit-frame-pointer
ASOPTLEV = opt 1
ASSUFFIX = hunk
MAINLIBP = ../../lib

LIBSTUBS = -lstubs
LIBNIX = -lnix
LIBAMIGA = -lamiga
LIBGCC = -lgcc
LIBAPF = -lAPur

NOSTARTFILES = -nostartfiles -Dnostartfiles
RESIDENT = -resident -Dresident
RESIDENT32 = -resident32 -Dresident

AS = /c/PhxAss
H2A = hunk2aout

QCRT0 = qcrt0.o

STDASCPU = m 68020
STDASFLAGS = quiet noexe
STDCPU = -m68020-60 -msoft-float
STDCFLAGS = 
STDLDFLAGS = $(NOSTARTFILES) -nostdlib /lib/libnix/ncrt0.o
STDLPATH = -L/lib -L/lib/libnix

RESASCPU = m 68020
RESASFLAGS = quiet noexe sd 4 #sc
RESCPU = -m68020-60 -msoft-float #-msmall-code
RESCFLAGS = $(RESIDENT)
RESLDFLAGS = $(NOSTARTFILES) -nostdlib /lib/libnix/nrcrt0.o
RESLPATH = -L/lib/libb -L/lib/libb/libnix

RES32ASCPU = m 68020
RES32ASFLAGS = quiet noexe sd 4
RES32CPU = -m68020-60 -msoft-float
RES32CFLAGS = $(RESIDENT32)
RES32LDFLAGS = $(NOSTARTFILES) -nostdlib /lib/libnix/nrcrt0.o
RES32LPATH = -L/lib/libb32/libm020 -L/lib/libb/libm020/libnix

ifeq ($(BINARYMODE),R)
BMASCPU = $(RESASCPU)
BMASFLAGS = $(RESASFLAGS)
BMCPU = $(RESCPU)
BMCFLAGS = $(RESCFLAGS)
BMLDFLAGS = $(RESLDFLAGS)
BMLPATH = $(RESLPATH)
else
ifeq ($(BINARYMODE),R32)
BMASCPU = $(RES32ASCPU)
BMASFLAGS = $(RES32ASFLAGS)
BMCPU = $(RES32CPU)
BMCFLAGS = $(RES32CFLAGS)
BMLDFLAGS = $(RES32LDFLAGS)
BMLPATH = $(RES32LPATH)
else
BMASCPU = $(STDASCPU)
BMASFLAGS = $(STDASFLAGS)
BMCPU = $(STDCPU)
BMCFLAGS = $(STDCFLAGS)
BMLDFLAGS = $(STDLDFLAGS)
BMLPATH = $(STDLPATH)
endif
endif
