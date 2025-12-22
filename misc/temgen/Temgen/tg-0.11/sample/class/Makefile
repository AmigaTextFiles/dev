TG=../../tg

all: MainClass.cc MainClass.h

MainClass.h: classdef.tg class.tg
	$(TG) class.tg
	
MainClass.cc: MainClass.h

clean:
	rm -f *.o MainClass.*
