CC = ppc-morphos-gcc
STRIP = ppc-morphos-strip

SRCS = mini-printf.c tools.c pcd.c pcd_mcc.c 
	  
# 


OBJS = $(SRCS:.c=.o)

CFLAGS = -Wall -IWork:Development/Workspace/PCD_Test/pcd_mcc

LIB =  pcd.mcc 

all: $(LIB)


	
%.o: %.c *.h
	@echo Compiling $@...
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(LIB): $(OBJS)
	@echo Making $@...
	@$(CC) $(OBJS) -D__GNUC__ -D__MORPHOS__ -nostdlib -s -O2 -lm -labox -laboxstubs -ldebug -LWork:Development/Workspace/PCD_Test/pcd_mcc -lpcd -o $(LIB)  

clean:
	@echo Cleaning up...
	@-$(RM) -f $(OBJS) $(LIB)