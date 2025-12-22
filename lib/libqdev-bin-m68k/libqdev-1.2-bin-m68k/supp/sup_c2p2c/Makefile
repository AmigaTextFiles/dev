#
# 'qdev'
# by Burnt Chip Dominators
#
# PlanarToChunkyAsm(), ChunkyToPlanarAsm() by Morten Eriksen.
#
-include ../../tools/Makefile.i
-include ../Makefile.i


all: platform

platform: $(SUP_C2P2COBJS) $(SUP_C2P2COBJSB) $(SUP_C2P2COBJSB32)

.s.o:
	$(AS) $(ASOPTLEV) $(STDASCPU) $(STDASFLAGS) $< to $@.$(ASSUFFIX)
	-rm -f obj.*
	$(H2A) >/nil $@.$(ASSUFFIX)
	-mv -f -v obj.* $@

.s.ob:
	$(AS) $(ASOPTLEV) $(RESASCPU) $(RESASFLAGS) $< to $@.$(ASSUFFIX)
	-rm -f obj.*
	$(H2A) >/nil $@.$(ASSUFFIX)
	-mv -f -v obj.* $@

.s.ob32:
	$(AS) $(ASOPTLEV) $(RES32ASCPU) $(RES32ASFLAGS) $< to $@.$(ASSUFFIX)
	-rm -f obj.*
	$(H2A) >/nil $@.$(ASSUFFIX)
	-mv -f -v obj.* $@

.SUFFIXES: .o .ob .ob32

clean:
	-rm -f *.$(ASSUFFIX) obj.*

cleanall:
	-rm -f *.$(ASSUFFIX) obj.* *.o*
