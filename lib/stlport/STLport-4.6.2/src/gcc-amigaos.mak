#
# Makefile for AmigaOS
#
# Requires:
# - AmigaOS	4.0
# - GCC 3.4.1
# - clib2 1.172
#

.PHONY : all install


CC = gcc
CXX = g++ -ftemplate-depth-32

LIB_BASENAME = libstlport_gcc

LINK=ar cr
OBJEXT=o
STEXT=a
RM=delete
PATH_SEP=/
PATH_UP=/
MKDIR=makedir
COMP=GCC$(ARCH)
CUR_DIR=$(shell cd)

all: all_static

install:
	Copy /stlport SDK:Local/include/stlport all clone quiet
	Copy /lib/$(LIB_BASENAME).a SDK:Local/lib clone quiet


include common_macros.mak

WARNING_FLAGS= -Wall -W -Wno-sign-compare -Wno-unused -Wno-uninitialized

CXXFLAGS_COMMON = -I/stlport ${WARNING_FLAGS}

CXXFLAGS_RELEASE_static = $(CXXFLAGS_COMMON) -O2

CXXFLAGS_DEBUG_static = $(CXXFLAGS_COMMON) -ggdb

CXXFLAGS_STLDEBUG_static = $(CXXFLAGS_DEBUG_static) -D_STLP_DEBUG

include common_percent_rules.mak
include common_rules.mak

