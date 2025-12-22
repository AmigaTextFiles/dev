CXX := ppc-amigaos-g++
AR := ppc-amigaos-ar
RM := rm -f

CXXFLAGS := -O2 -g -Wall -Werror -Iinclude
PICFLAGS := -fno-common -fPIC -DPIC
LDFLAGS := -use-dynld

STATIC_LIB := libyaml-cpp.a
SHARED_LIB := libyaml-cpp.so.0.3
SRCS := $(wildcard src/*.cpp) $(wildcard src/contrib/*.cpp)
STATIC_OBJS := $(SRCS:.cpp=.o)
SHARED_OBJS := $(SRCS:.cpp=.lo)

TEST := test/test
TEST_SRCS := $(wildcard test/*.cpp) $(wildcard test/old-api/*.cpp)
TEST_OBJS := $(TEST_SRCS:.cpp=.o)

.PHONY: all
all: $(STATIC_LIB) $(SHARED_LIB) $(TEST)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.lo: %.cpp
	$(CXX) $(PICFLAGS) $(CXXFLAGS) -c -o $@ $<

$(STATIC_LIB): $(STATIC_OBJS)
	$(AR) -crv $@ $^

$(SHARED_LIB): $(SHARED_OBJS)
	$(CXX) -shared -o $@ $^

$(TEST): $(TEST_OBJS) $(SHARED_LIB)
	$(CXX) $(LDFLAGS) -o $@ $^

$(TEST_OBJS): CXXFLAGS += -Itest

.PHONY: clean
clean:
	$(RM) $(STATIC_LIB) $(SHARED_LIB)
	$(RM) $(STATIC_OBJS) $(SHARED_OBJS)
	$(RM) $(TEST) $(TEST_OBJS)

