CC			= gcc
CFLAGS	= -Wall -noixemul -s -O2 -resident -mregparm=4 -msmall-code
APP		= Bump
REQ		= $(APP).c $(APP).h $(APP)_rev.h

$(APP): $(REQ)
	@echo Making $@...
	@$(CC) $(CFLAGS) -o $(APP) $(APP).c

$(APP).020: $(REQ)
	@echo Making $@...
	@$(CC) $(CFLAGS) -m68020 -o $(APP).020 $(APP).c

$(APP).030: $(REQ)
	@echo Making $@...
	@$(CC) $(CFLAGS) -m68030 -o $(APP).030 $(APP).c

$(APP).040: $(REQ)
	@echo Making $@...
	@$(CC) $(CFLAGS) -m68040 -o $(APP).040 $(APP).c

$(APP).060: $(REQ)
	@echo Making $@...
	@$(CC) $(CFLAGS) -m68060 -o $(APP).060 $(APP).c

$(APP)_rev.h: $(APP)_rev.ver
	@echo Making version code...
	@Bump $(APP) C NOREVISION QUIET

version:
	@echo Bumping version...
	@Bump $(APP) VERSION

revision:
	@echo Bumping revision...
	@Bump $(APP)

patches: all
	@echo Making patches...
	@scompare -o$(APP).020.pch $(APP) $(APP).020
	@scompare -o$(APP).030.pch $(APP) $(APP).030
	@scompare -o$(APP).040.pch $(APP) $(APP).040
	@scompare -o$(APP).060.pch $(APP) $(APP).060
	@rm -f $(APP).020 $(APP).030 $(APP).040 $(APP).060

all: $(APP) $(APP).020 $(APP).030 $(APP).040 $(APP).060

clean:
	@echo Cleaning distribution...
	@rm -f $(APP) $(APP).020 $(APP).030 $(APP).040 $(APP).060 $(APP).020.pch $(APP).030.pch $(APP).040.pch $(APP).060.pch $(APP)_rev.h
