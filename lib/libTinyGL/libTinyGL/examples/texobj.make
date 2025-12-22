# Name of the executable created
Target := texobj68k
# List of source files, separated by spaces
Sources := texobj.c

# Path to include directories.
tglhome := ..
sdlhome := ../../sdl
# Path for the executable.
BinPath = .

# general compiler settings (might need to be set when compiling the lib, too)
# preprocessor flags, e.g. defines and include paths
USERCPPFLAGS = 
 # compiler flags such as optimization flags
USERCXXFLAGS = -s -m68020-40 -msoft-float -O2 -DNO_INLINE_VARARGS -DNO_INLINE_STDARG -DGL_GLEXT_LEGACY
#USERCXXFLAGS = -g -Wall
# linker flags such as additional libraries and link paths
USERLDFLAGS = -fno-rtti -fno-exceptions -noixemul

CPPFLAGS = -I$(sdlhome)/include_68k_rtg -I$(tglhome)/src $(USERCPPFLAGS)
CXXFLAGS = $(USERCXXFLAGS)
LDFLAGS = $(USERLDFLAGS)

#default target is OS3.1
all: all_os3

# target specific settings
all_os3: LDFLAGS += -L$(sdlhome)/lib_68k_rtg -lSDL -L$(tglhome)/lib -lTinyGL -ldebug -lm
all_os3 clean_os3: SYSTEM=os3
# name of the binary - only valid for targets which set SYSTEM
DESTPATH = $(BinPath)/$(Target)$(SUF)

all_os3:
	$(warning Building...)
	m68k-amigaos-gcc $(CPPFLAGS) $(CXXFLAGS) $(Sources) -o $(DESTPATH) $(LDFLAGS)

clean: clean_os3
	$(warning Cleaning...)

clean_os3:
	@$(RM) $(DESTPATH)

.PHONY: all clean clean_os3

