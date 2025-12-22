all: common/common.lib ar65/ar65 ca65/ca65 cc65/cc65 cl65/cl65 da65/da65 grc/grc \
ld65/ld65 od65/od65 sim65/sim65

common/common.lib:
	execute <<
cd common
smake -f make/sc.mak
<

ar65/ar65:
	execute <<
cd ar65
smake -f make/sc.mak
<

ca65/ca65:
	execute <<
cd ca65
smake -f make/sc.mak
<

cc65/cc65:
	execute <<
cd cc65
smake -f make/sc.mak
<

cl65/cl65:
	execute <<
cd cl65
smake -f make/sc.mak
<

da65/da65:
	execute <<
cd da65
smake -f make/sc.mak
<

grc/grc:
	execute <<
cd grc
smake -f make/sc.mak
<

ld65/ld65:
	execute <<
cd ld65
smake -f make/sc.mak
<

od65/od65:
	execute <<
cd od65
smake -f make/sc.mak
<

sim65/sim65:
	execute <<
cd sim65
smake -f make/sc.mak
<


archive:
	lha -rF u RAM:cc65-src /// cc65-2.9.2/src
