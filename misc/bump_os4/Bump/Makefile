CC = vc +aosppc
CP = copy
RM = delete

# Change these as required
OPTIMIZE = -O4 -size
DEBUG =
CFLAGS = $(OPTIMIZE) $(DEBUG) -D__USE_INLINE__

# Flags passed to gcc during linking
LINK = $(OPTIMIZE) $(DEBUG)

# Name of the "thing" to build
TARGET  = Bump
VERSION = 3

# Additional linker libraries
LIBS =

# Source code files used in this project
# Add any additional files to this line

SRCS = Bump.c

# -------------------------------------------------------------
# Nothing should need changing below this line

OBJS = $(SRCS:.c=.o)

# Rules for building
$(TARGET): $(OBJS)
	$(CC) $(LINK) -nostdlib -o $(TARGET) $(OBJS) $(LIBS)

Bump.o: Bump.h Bump_rev.h

.PHONY: install
install: $(TARGET)
	$(CP) $(TARGET) C:

.PHONY: clean
clean:
	$(RM) $(TARGET) $(OBJS)

.PHONY: revision
revision:
	bumprev $(VERSION) $(TARGET)
