# Makefile for VRMLSupport
# V 1.0
# 30 july 98

CC = gcc
OPT = -IDH1:Sources/BodySoft/Useful -IDH1:Sources/BodySoft/MUICustomClass/mui
LOPT =
CFLAGS = -O0
CPU = -m68040
LIB =

# Cancel automatic compliation
%.o: %.c
        
#Cancel automatic linking
%: %.o
        
# All
all: VRMLNode.o VRMLNode_GL.o VRMLNode_GLBox.o VRML2Node.o VRMLSupport.o VRMLParser.o VRMLSaver.o VRML2Saver.o GEOParser.o OpenGLSaver.o MWSaver.o GLConvert.o GLNode.o NProducer.o VRMLExtractor.o install

# VRMLNode
VRMLNode.o: VRMLNode.h Lists.hpp Other.hpp VRMLNode.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c VRMLNode.cc

# VRML2Node
VRML2Node.o: VRML2Node.h Lists.hpp VRML2Node.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c VRML2Node.cc

VRMLNode_GL.o: VRMLNode.h Lists.hpp Other.hpp VRMLNode_GL.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c VRMLNode_GL.cc

VRMLNode_GLBox.o: VRMLNode.h Lists.hpp Other.hpp VRMLNode_GLBox.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c VRMLNode_GLBox.cc

# VRMLSupport
VRMLSupport.o: VRMLSupport.h VRMLSupport.h VRMLParser.h GEOParser.h VRMLSaver.h OpenGLSaver.h VRMLSupport.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c VRMLSupport.cc

VRMLParser.o: VRMLParser.h VRMLSupport.h VRMLParser.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c VRMLParser.cc

VRMLSaver.o: VRMLSaver.h VRMLSupport.h VRMLSaver.cc
	$(CC) $(CPU) $(OPT) -O3 -c VRMLSaver.cc  # -O3 is important for the mui gauge to work

VRML2Saver.o: VRML2Saver.h VRMLSupport.h VRML2Saver.cc
	$(CC) $(CPU) $(OPT) -O3 -c VRML2Saver.cc  # -O3 is important for the mui gauge to work

GEOParser.o: GEOParser.h VRMLSupport.h GEOParser.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c GEOParser.cc

OpenGLSaver.o: OpenGLSaver.h VRMLSupport.h OpenGLSaver.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c OpenGLSaver.cc

MWSaver.o: MWSaver.h VRMLSupport.h MWSaver.cc
	$(CC) $(CPU) $(OPT) -O3  -c MWSaver.cc  # -O3 is important for the mui gauge to work

GLConvert.o: GLConvert.h VRMLSupport.h GLConvert.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c GLConvert.cc

NProducer.o: NProducer.h VRMLSupport.h NProducer.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c NProducer.cc

VRMLExtractor.o: VRMLExtractor.h VRMLSupport.h VRMLExtractor.cc
	$(CC) $(CPU) $(CFLAGS) $(OPT) -c VRMLExtractor.cc

#GLNode
GLNode.o: GLNode.h VRMLNode.h Lists.hpp Other.hpp GLNode.cc
	$(CC) $(CPU) $(OPT) -c GLNode.cc

# install
install:
	ar -r libvrmlsupport.a *.o
	copy libvrmlsupport.a to gg:os-lib

# Other
clean:
	rm *.o
	rm *.rpo
