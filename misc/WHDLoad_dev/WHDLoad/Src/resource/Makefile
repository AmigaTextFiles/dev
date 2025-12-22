#
# Makefile for ReSource stuff
# ©2003 Bert Jahn, All Rights Reserved
#
# $Id: Makefile 1.6 2004/10/21 11:26:16 wepl Exp wepl $
#
# 13.03.03 created
#
# $@ target
# $< first dependency
# $^ all dependencies

ASM=basm -v+ -x-
CP=copy clone
RM=delete

OBJS = WHDLoadResload WHDLoadSetCPUFlags WHDLoadSlave WHDLoadSlaveFlags \
	WHDLoadTags WHDLoadTermReason WHDLoadPatch \
	PatcherBase PatcherTags \
	RawDICBase RawDICSlaveFlags RawDICDiskFlags RawDICErrors

all: $(OBJS) /RS/RS.macros.backup macros-rs

/RS/RS.macros.backup:
	$(CP) RS:RS.macros RS:RS.macros.backup

%: %.s
	$(ASM) $^

/RS/RS.macros: macros-rs.s macros.s 
	$(ASM) $<

macros-rs.s: macros-prep.pl
	/RS/ShowMacros RS:RS.Macros >T:rsmacros
	perl macros-prep.pl <T:rsmacros >$@

clean:
	$(RM) $(OBJS) *.bak macros-rs.s

