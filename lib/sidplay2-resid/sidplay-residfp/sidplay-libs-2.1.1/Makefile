CROSS := ppc-amigaos
CC := $(CROSS)-gcc
CXX := $(CROSS)-g++
AR := $(CROSS)-ar
RANLIB := $(CROSS)-ranlib
RM := rm -f

CXXFLAGS := -O2 -g -Wall -I. -DHAVE_CONFIG_H
PICFLAGS := -fPIC -DPIC
LDFLAGS := -shared
LIBS := 

SIDPLAY_CPP := $(wildcard sidplay/*.cpp) $(wildcard sidplay/*/*.cpp)
SIDPLAY_C := $(wildcard sidplay/*.c)
SIDPLAY_O := $(SIDPLAY_CPP:.cpp=.o) $(SIDPLAY_C:.c=.o)
SIDPLAY_LO := $(SIDPLAY_O:.o=.lo)

UTILS_CPP := $(wildcard utils/*.cpp) $(wildcard utils/*/*.cpp)
UTILS_O := $(UTILS_CPP:.cpp=.o)
UTILS_LO := $(UTILS_O:.o=.lo)

RESID_BUILDER_CPP := $(wildcard builders/resid-builder/*.cpp)
RESID_BUILDER_CC := $(wildcard builders/resid-builder/resid/*.cc)
RESID_BUILDER_O := $(RESID_BUILDER_CPP:.cpp=.o) $(RESID_BUILDER_CC:.cc=.o)
RESID_BUILDER_LO := $(RESID_BUILDER_O:.o=.lo)

all: libsidplay2.a libsidplay2.so \
	libsidutils.a libsidutils.so \
	libresid-builder.a libresid-builder.so

libsidplay2.a: $(SIDPLAY_O)
	$(AR) -crv $@ $^

libsidplay2.so: $(SIDPLAY_LO)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

libsidutils.a: $(UTILS_O)
	$(AR) -crv $@ $^

libsidutils.so: $(UTILS_LO)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

libresid-builder.a: $(RESID_BUILDER_O)
	$(AR) -crv $@ $^

libresid-builder.so: $(RESID_BUILDER_LO)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CXXFLAGS) -c -o $@ $<

%.lo: %.c
	$(CC) $(CXXFLAGS) $(PICFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.lo: %.cpp
	$(CXX) $(CXXFLAGS) $(PICFLAGS) -c -o $@ $<

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.lo: %.cc
	$(CXX) $(CXXFLAGS) $(PICFLAGS) -c -o $@ $<

clean:
	$(RM) lib*.a lib*.so */*.o */*/*.o */*/*/*.o */*.lo */*/*.lo */*/*/*.lo
