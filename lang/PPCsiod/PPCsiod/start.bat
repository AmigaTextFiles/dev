assign SIOD: SIOD
cd SIOD:
setenv siod-heap-size 20000
setenv siod-symtab-size 1000
setenv siod-fixtab-size 500
setenv siod-quiet 1
setenv siod-small 0
runelf siod.elf
