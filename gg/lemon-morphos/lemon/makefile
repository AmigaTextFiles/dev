STRIP		= strip
CC			= gcc
CDEFS 	=
CFLAGS	= $(CDEFS) -O3 -finline-functions -funroll-loops -fstrict-aliasing -mcpu=750 -mmultiple -mstring -Wall
TARGET	= lemon

OBJS  = lemon.o

ECHO = echo
ECHE = echo -e
BOLD = \033[1m
NRML = \033[22m

COMPILING = @$(ECHE) "compiling $(BOLD)$@$(NRML)..."
LINKING = @$(ECHE) "linking $(BOLD)$@$(NRML)..."
STRIPPING = @$(ECHE) "stripping $(BOLD)$@$(NRML)..."
ARCHIVING = @$(ECHE) "archiving $(BOLD)$@$(NRML)..."

%.o: %.c
	$(COMPILING)
	@$(CC) $(CFLAGS) -o $@ -c $*.c

all: $(TARGET)

lemon.o: lemon.c

$(TARGET): $(OBJS)
	$(LINKING)
	@$(CC) $(OBJS) -o $@.db
	$(STRIPPING)
	@$(STRIP) --remove-section=.comment $@.db -o $@
	@chmod +x $(TARGET)

clean: 
	@rm -f *.o *.s $(TARGET) *.a
