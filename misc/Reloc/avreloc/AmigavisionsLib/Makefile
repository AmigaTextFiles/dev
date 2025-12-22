SRCS= DOSError.a OpenData.a Print.a
OBJS= $(SRCS:.a=.o)

amigavisions.lib: $(SRCS)
	sc $?
	touch $@
	oml -b $@ a $(OBJS)
	Delete $(OBJS) quiet

$(SRCS): xref.i call.i
	touch $>.a

clean:; @delete amigavisions.lib QUIET FORCE
