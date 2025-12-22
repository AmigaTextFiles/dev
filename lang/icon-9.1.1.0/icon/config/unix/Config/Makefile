CC=gcc
CFLAGS= -DVarTran -Wall -O2 
LDFLAGS=
SHELL=/bin/sh
MAKE=make

all:
		@echo "what do you want to make"

Setup:
		make -f ../Config/Makefile Clean
		make -f ../Config/Makefile Localcode
		make -f ../Config/Makefile Makefiles
		make -f ../Config/Makefile VT

Setup-X-Icon: Setup
		echo "#define Graphics 1" >>../../../src/h/define.h
		-if [ -f xiconc.def ]; \
		    then cat xiconc.def >> ../../../src/h/define.h; fi
		echo "XPMLIB=-L../../bin -lXpm" > ../../../src/runtime/Makefile
		-if [ -f xiconx.mak ]; \
		    then cat xiconx.mak >> ../../../src/runtime/Makefile; \
		    else echo "XLIB= -lX11" \
			>> ../../../src/runtime/Makefile; fi
		echo "XPM = xpm" >> ../../../src/runtime/Makefile
		cat runtime.hdr ../Config/runtime.make \
		   >> ../../../src/runtime/Makefile
		cat xpm.hdr ../Config/xpm.make \
		   > ../../../src/xpm/Makefile
		echo "XPM = xpm" > ../../../src/iconc/Makefile
		cat iconc.hdr ../Config/iconc.make \
		   >> ../../../src/iconc/Makefile

Clean:
		rm -f ../../../src/common/rswitch.[csS]

Makefiles:
		cat rtt.hdr ../Config/rtt.make \
		   > ../../../src/rtt/Makefile
		cat common.hdr ../Config/common.make \
		   > ../../../src/common/Makefile
		cat iconc.hdr ../Config/iconc.make \
		   > ../../../src/iconc/Makefile
		cat preproc.hdr ../Config/preproc.make \
		   > ../../../src/preproc/Makefile
		cat icont.hdr ../Config/icont.make \
		   > ../../../src/icont/Makefile
		cat runtime.hdr ../Config/runtime.make \
		   > ../../../src/runtime/Makefile
		cat vtran.hdr ../Config/vt2.make > ../../../src/vtran/Vtmake2
		cp ../Config/vt1.make ../../../src/vtran/Vtmake1

Localcode:
		cp define.h ../../../src/h
		cp rswitch.[csS] ../../../src/common
		-if grep -s NoRanlib define.h; \
		   then touch ../../../NoRanlib; \
		   else rm -rf ../../../NoRanlib; fi

VT:
		rm -f icon_vt.c
		ln ../Config/icon_vt.c icon_vt.c
		$(CC) -E icon_vt.c | egrep -v '(^#|^$$)' > ../../../bin/icon_vt
#		ed - ../../../bin/icon_vt <../Config/dequote.ed
		-chmod 775 ../../../bin/icon_vt
		rm -f icon_vt.c
