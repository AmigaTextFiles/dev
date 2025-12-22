#------------------------------------------------------------------------------

CC			= gcc
CHMOD		= chmod
STRIP		= strip
CFLAGS	= -s -O2 -Wall -mcpu=powerpc -fomit-frame-pointer -noixemul
LFLAGS	= -lnathread -labox -noixemul
SFLAGS	= --strip-all --strip-unneeded --remove-section .comment

#------------------------------------------------------------------------------

TEST1		= test1
TEST1O	= test1.o
TEST2		= test2
TEST2O	= test2.o

#------------------------------------------------------------------------------

all: $(TEST1) $(TEST2)

$(TEST1): $(TEST1O)
	$(CC) $(TEST1O) -o $@.debug $(LFLAGS)
	$(STRIP) $(SFLAGS) $@.debug -o $@
	$(CHMOD) +x $@

$(TEST2): $(TEST2O)
	$(CC) $(TEST2O) -o $@.debug $(LFLAGS)
	$(STRIP) $(SFLAGS) $@.debug -o $@
	$(CHMOD) +x $@

.c.o:
	$(CC) $(CDEFS) $(CFLAGS) -c $< -o $@

#------------------------------------------------------------------------------

clean:
	rm -f *.o *.debug $(TEST1) $(TEST2)

#------------------------------------------------------------------------------

