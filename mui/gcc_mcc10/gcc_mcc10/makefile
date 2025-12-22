# Some mcc/mcp examples
#
# GNU:lib/libnix/libnix.a  is needed only for some functions (math, long * and /)
# stdio functions are forbiden anyway   :-(
#

.PHONY: all


all: Simple.mcp Simple.mcc mcctest test
#	c:avail flush



Simple.mcp: Simple_mcp_lib.o Simple_mcp.o
#	gcc -nostdlib -O -s $^ GNU:lib/libnix/libnix.a -lamiga -o $@
	gcc -nostdlib -O -s $^ GNU:lib/libnix/libnix.a -lamiga -o $@

Simple_mcp_lib.o: Simple_mcp_lib.c
	gcc -nostdlib -O $^ -c

Simple_mcp.o: Simple_mcp.c
	gcc -nostdlib -O $^ -c



Simple.mcc: Simple_mcc_lib.o Simple_mcc.o
#	gcc -nostdlib -O -s $^ GNU:lib/libnix/libnix.a -lamiga -o $@
	gcc -nostdlib -O -s $^ -lamiga -o $@

Simple_mcc_lib.o: Simple_mcc_lib.c
	gcc -nostdlib -O $^ -c

Simple_mcc.o: Simple_mcc.c
	gcc -nostdlib -O $^ -c



mcctest:  mcctest.c
	gcc -noixemul -O $^ -o $@



test:  test.c
	gcc -noixemul -O $^ -o $@



install: Simple.mcp Simple.mcc
	cp Simple.mcp MUI:libs/MUI/Simple.mcp
	cp Simple.mcc MUI:libs/MUI/Simple.mcc
#	c:avail flush

clean:
	rm -f MUI:libs/MUI/Simple.mcp
	rm -f MUI:libs/MUI/Simple.mcc
#	c:avail flush

cleanall:
	rm -f *.o
	rm -f mcctest
	rm -f test
	rm -f Simple.mcp
	rm -f MUI:libs/MUI/Simple.mcp
	rm -f Simple.mcc
	rm -f MUI:libs/MUI/Simple.mcc
#	c:avail flush

flush:
	c:avail flush
