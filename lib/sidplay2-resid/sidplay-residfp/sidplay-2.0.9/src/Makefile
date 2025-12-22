CROSS := ppc-amigaos
CXX := $(CROSS)-g++
RM := rm -f

CXXFLAGS := -O2 -g -Wall -Werror -I.
LDFLAGS := -use-dynld
LIBS := -lsidplay2 -lsidutils -lresid-builder

OBJS := main.o args.o player.o menu.o IniConfig.o keyboard.o \
	audio/null/null.o audio/ahi/audiodrv.o audio/wav/WavFile.o

sidplay2: $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

.PHONY: clean
clean:
	$(RM) sidplay2 *.o audio/*/*.o
