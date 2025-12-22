CC      = vc
VASM    = vasmm68k_mot
VLINK   = vlink
LDFLAGS = -stdlib
CONFIG  = +aos68k
ODIR    = build-vbcc

CFLAGS_LIBRARY  = -O2 -+ -c99 -speed -cpp-comments -sc -DVBCC -c
LDFLAGS_LIBRARY = -nostdlib -lamiga
LDLIBS =

SRC_TEST = src/test.c
SRC_C    = $(filter-out $(SRC_TEST),$(wildcard src/*.c))
SRC_S    = $(wildcard src/*.s)

LIBRARY = libs/c2p.library
#LIBRARY = uae/dh0/libs/c2p.library
_OBJ = $(SRC_C:.c=.o) $(SRC_S:.s=.o)
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

# Prepare variables for target 'clean'
ifeq ($(OS),Windows_NT)
	RM:=del
	PATHSEP:=\\
	CONFIG:=${CONFIG}_win
else
	RM:=rm -f 
	PATHSEP:=/
endif

all:
	$(MAKE) clean
	$(MAKE) lib
	$(MAKE) examples

lib: $(LIBRARY)

$(LIBRARY) : $(OBJ)
	$(CC) $(CONFIG) $(LDFLAGS_LIBRARY) -o $@ $(OBJ) $(LDLIBS)

$(ODIR)/%.o : %.c
	$(CC) $(CONFIG) $(CFLAGS_LIBRARY) -c $^ -o $@

$(ODIR)/%.o : %.s
	$(VASM) -quiet -m68030 -Fhunk -o $@ $<


clean:
	-$(RM) $(ODIR)$(PATHSEP)*.o
	-$(RM) $(subst /,$(PATHSEP),$(LIBRARY))



############
# EXAMPLES #
############

examples:	example_basic example_basic_delta example_chunky example_custom-bitmap example_offset example_scrambled

ODIR_EXAMPLES = $(ODIR)/examples
EDIR_EXAMPLES = sdk/examples
#EDIR_EXAMPLES = uae/dh0



EXE_BASIC = $(EDIR_EXAMPLES)/basic
OBJ_BASIC = $(ODIR_EXAMPLES)/basic.o sdk/c2p.lib
SRC_BASIC = sdk/examples/basic.c

example_basic: $(ODIR_EXAMPLES)/basic.o
	$(VLINK) -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(VBCC)/targets/m68k-amigaos/lib/startup.o $(OBJ_BASIC) -L$(VBCC)/targets/m68k-amigaos/lib -lvc -lamiga -mrel -o $(EXE_BASIC)

$(ODIR_EXAMPLES)/basic.o: $(SRC_BASIC)
	$(CC) $(CONFIG) -c -c99 -O3 -speed -cpp-comments -sd -sc -o $@ $<



EXE_BASIC_DELTA = $(EDIR_EXAMPLES)/basic-delta
OBJ_BASIC_DELTA = $(ODIR_EXAMPLES)/basic-delta.o sdk/c2p.lib
SRC_BASIC_DELTA = sdk/examples/basic-delta.c

example_basic_delta: $(ODIR_EXAMPLES)/basic-delta.o
	$(VLINK) -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(VBCC)/targets/m68k-amigaos/lib/startup.o $(OBJ_BASIC_DELTA) -L$(VBCC)/targets/m68k-amigaos/lib -lvc -lamiga -mrel -o $(EXE_BASIC_DELTA)

$(ODIR_EXAMPLES)/basic-delta.o: $(SRC_BASIC_DELTA)
	$(CC) $(CONFIG) -c -c99 -O3 -speed -cpp-comments -sd -sc -o $@ $<



EXE_CHUNKY = $(EDIR_EXAMPLES)/chunky
OBJ_CHUNKY = $(ODIR_EXAMPLES)/chunky.o sdk/c2p.lib
SRC_CHUNKY = sdk/examples/chunky.c

example_chunky: $(ODIR_EXAMPLES)/chunky.o
	$(VLINK) -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(VBCC)/targets/m68k-amigaos/lib/startup.o $(OBJ_CHUNKY) -L$(VBCC)/targets/m68k-amigaos/lib -lvc -lamiga -mrel -o $(EXE_CHUNKY)

$(ODIR_EXAMPLES)/chunky.o: $(SRC_CHUNKY)
	$(CC) $(CONFIG) -c -c99 -O3 -speed -cpp-comments -sd -sc -o $@ $<



EXE_CUSTOM_BITMAP = $(EDIR_EXAMPLES)/custom-bitmap
OBJ_CUSTOM_BITMAP = $(ODIR_EXAMPLES)/custom-bitmap.o sdk/c2p.lib
SRC_CUSTOM_BITMAP = sdk/examples/custom-bitmap.c

example_custom-bitmap: $(ODIR_EXAMPLES)/custom-bitmap.o
	$(VLINK) -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(VBCC)/targets/m68k-amigaos/lib/startup.o $(OBJ_CUSTOM_BITMAP) -L$(VBCC)/targets/m68k-amigaos/lib -lvc -lamiga -mrel -o $(EXE_CUSTOM_BITMAP)

$(ODIR_EXAMPLES)/custom-bitmap.o: $(SRC_CUSTOM_BITMAP)
	$(CC) $(CONFIG) -c -c99 -O3 -speed -cpp-comments -sd -sc -o $@ $<



EXE_OFFSET = $(EDIR_EXAMPLES)/offset
OBJ_OFFSET = $(ODIR_EXAMPLES)/offset.o sdk/c2p.lib
SRC_OFFSET = sdk/examples/offset.c

example_offset: $(ODIR_EXAMPLES)/offset.o
	$(VLINK) -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(VBCC)/targets/m68k-amigaos/lib/startup.o $(OBJ_OFFSET) -L$(VBCC)/targets/m68k-amigaos/lib -lvc -lamiga -mrel -o $(EXE_OFFSET)

$(ODIR_EXAMPLES)/offset.o: $(SRC_OFFSET)
	$(CC) $(CONFIG) -c -c99 -O3 -speed -cpp-comments -sd -sc -o $@ $<



EXE_SCRAMBLED = $(EDIR_EXAMPLES)/scrambled
OBJ_SCRAMBLED = $(ODIR_EXAMPLES)/scrambled.o sdk/c2p.lib
SRC_SCRAMBLED = sdk/examples/scrambled.c

example_scrambled: $(ODIR_EXAMPLES)/scrambled.o
	$(VLINK) -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(VBCC)/targets/m68k-amigaos/lib/startup.o $(OBJ_SCRAMBLED) -L$(VBCC)/targets/m68k-amigaos/lib -lvc -lamiga -mrel -o $(EXE_SCRAMBLED)

$(ODIR_EXAMPLES)/scrambled.o: $(SRC_SCRAMBLED)
	$(CC) $(CONFIG) -c -c99 -O3 -speed -cpp-comments -sd -sc -o $@ $<

