#
# Makefile for AmigaOS
#
# Requires:
# - AmigaOS	4.0
# - GCC 3.4.1
# - clib2 1.172
#

CC = gcc
CXX = g++
MAKEDIR = makedir
CUR_DIR=$(shell cd)

TEST_EXE = eh_test
D_TEST_EXE = eh_test_d

STL_INCL = -I//stlport
OBJDIR = obj
D_OBJDIR = d_obj
CXXFLAGS = -Wall $(STL_INCL) -I$(CUR_DIR) -DEH_VECTOR_OPERATOR_NEW
D_CXXFLAGS = -Wall $(STL_INCL) -I$(CUR_DIR) -DEH_VECTOR_OPERATOR_NEW -D_STLP_DEBUG

AUX_LIST = TestClass.cpp main.cpp nc_alloc.cpp random_number.cpp

TEST_LIST = test_algo.cpp  \
	test_algobase.cpp test_list.cpp test_slist.cpp \
	test_bit_vector.cpp test_vector.cpp \
	test_deque.cpp test_set.cpp test_map.cpp \
	test_hash_map.cpp  test_hash_set.cpp test_rope.cpp \
	test_string.cpp test_bitset.cpp test_valarray.cpp

LIST = $(AUX_LIST) $(TEST_LIST)

OBJECTS = $(LIST:%.cpp=obj/%.o)
D_OBJECTS = $(LIST:%.cpp=d_obj/%.o)

LIBS =
LIBSTLPORT = -L//lib -lstlport_gcc
D_LIBSTLPORT = -L//lib -lstlport_gcc_stldebug

all: $(TEST_EXE) $(D_TEST_EXE) check

check: $(TEST_EXE) $(D_TEST_EXE)
	$(TEST_EXE) -s 100
	$(D_TEST_EXE) -s 100

$(OBJDIR):
	$(MAKEDIR) $(OBJDIR)

$(D_OBJDIR):
	$(MAKEDIR) $(D_OBJDIR)

$(TEST_EXE) : $(OBJDIR) $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(OBJECTS) $(LIBSTLPORT) $(LIBS) -o $(TEST_EXE)

$(D_TEST_EXE) : $(D_OBJDIR) $(D_OBJECTS)
	$(CXX) $(D_CXXFLAGS) $(D_OBJECTS) $(D_LIBSTLPORT) $(LIBS) -o $(D_TEST_EXE)

SUFFIXES: .cpp.o

d_obj/%.o : %.cpp
	$(CXX) $(D_CXXFLAGS) $< -c -o $@

obj/%.o : %.cpp
	$(CXX) $(CXXFLAGS) $< -c -o $@

