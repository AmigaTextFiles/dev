#
# General makefile
#

all: spredit aomedit aomedit2 bgedit3 benton64 pic2chr d642prg prg2d64 d64ren c64pack c64unp packprg pic2spr prg2bin sprrip makedisk tbgedit bofhedit spredit2 symbols filejoin filespli cs cpack cdepack pmap pchunk bin2hex pack
	mv spredit ../linux
	mv spredit2 ../linux
	mv benton64 ../linux
	mv pic2chr ../linux
	mv d642prg ../linux
	mv d64ren ../linux
	mv c64pack ../linux
	mv c64unp ../linux
	mv packprg ../linux
	mv pic2spr ../linux
	mv prg2bin ../linux
	mv prg2d64 ../linux
	mv sprrip ../linux
	mv makedisk ../linux
	mv bofhedit ../linux
	mv tbgedit ../linux
	mv bgedit3 ../linux
	mv aomedit ../linux
	mv aomedit2 ../linux
	mv filejoin ../linux
	mv pack ../linux
	mv pchunk ../linux
	mv pmap ../linux
	mv cpack ../linux
	mv cdepack ../linux
	mv cs ../linux
	mv symbols ../linux
	mv bin2hex ../linux

editor.dat: editor.lbm editfont.lbm
	bmeconv -s -t255 -r254 -h253 editor.lbm editor.spr
	bmeconv -s -t255 -r254 -h253 editfont.lbm editfont.spr
	bmeconv -p editor.lbm editor.pal
	datafile editor.dat filelist

editdata.c: editor.dat
	dat2inc editor.dat editdata.c

.c.o:
	cc -c -O3 -funsigned-char -Wall $<

spredit: spredit.o editdata.o
	cc editdata.o spredit.o ../linux/libbme.a -ospredit `sdl-config --libs --cflags`
	strip spredit

spredit2: spredit2.o fileio.o editdata.o
	cc editdata.o spredit2.o fileio.o ../linux/libbme.a -ospredit2 `sdl-config --libs --cflags`
	strip spredit2

bgedit3: bgedit3.o editdata.o
	cc editdata.o bgedit3.o ../linux/libbme.a -obgedit3 `sdl-config --libs --cflags`
	strip bgedit3

bofhedit: bofhedit.o editdata.o
	cc editdata.o bofhedit.o ../linux/libbme.a -obofhedit `sdl-config --libs --cflags`
	strip bofhedit

tbgedit: tbgedit.o editdata.o
	cc editdata.o tbgedit.o ../linux/libbme.a -otbgedit `sdl-config --libs --cflags`
	strip tbgedit

aomedit: aomedit.o editdata.o
	cc editdata.o aomedit.o ../linux/libbme.a -oaomedit `sdl-config --libs --cflags`
	strip aomedit

aomedit2: aomedit2.o editdata.o
	cc editdata.o aomedit2.o ../linux/libbme.a -oaomedit2 `sdl-config --libs --cflags`
	strip aomedit2

benton64: benton64.o fileio.o
	cc benton64.o fileio.o -obenton64
	strip benton64

makedisk: makedisk.o
	cc makedisk.o -omakedisk
	strip makedisk

pic2chr: pic2chr.o fileio.o
	cc pic2chr.o fileio.o -opic2chr
	strip pic2chr

d642prg: d642prg.o
	cc d642prg.o -od642prg
	strip d642prg

prg2d64: prg2d64.o
	cc prg2d64.o -oprg2d64
	strip prg2d64

d64ren: d64ren.o
	cc d64ren.o -od64ren
	strip d64ren

c64pack: c64pack.o
	cc c64pack.o -oc64pack
	strip c64pack

c64unp: c64unp.o
	cc c64unp.o -oc64unp
	strip c64unp

packprg: packprg.o
	cc packprg.o -opackprg
	strip packprg

pic2spr: pic2spr.o fileio.o
	cc pic2spr.o fileio.o -opic2spr
	strip pic2spr

prg2bin: prg2bin.o
	cc prg2bin.o -oprg2bin
	strip prg2bin

sprrip: sprrip.o
	cc sprrip.o -osprrip
	strip sprrip

symbols: symbols.o
	cc symbols.o -osymbols
	strip symbols

filejoin: filejoin.o
	cc filejoin.o -ofilejoin
	strip filejoin

filespli: filespli.o
	cc filespli.o -ofilespli
	strip filespli

cpack: cpack.o
	cc cpack.o -ocpack
	strip cpack

cdepack: cdepack.o
	cc cdepack.o -ocdepack
	strip cdepack

bin2hex: bin2hex.o
	cc bin2hex.o -obin2hex
	strip bin2hex

pack: pack.o
	cc pack.o -opack
	strip pack

pchunk: pchunk.o
	cc pchunk.o -opchunk
	strip pchunk

pmap: pmap.o
	cc pmap.o -opmap
	strip pmap

cs: cs_tab.o lex.yy.o tree.o tree.h symbol.o symbol.h codegen.o codegen.h types.h
	cc cs_tab.o lex.yy.o tree.o symbol.o codegen.o -ocs
	strip cs

cs_tab.c: cs.y
	bison --defines --verbose cs.y

lex.yy.c: cs.l
	flex cs.l

