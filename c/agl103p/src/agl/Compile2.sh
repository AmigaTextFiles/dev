cat window.c matrix.c mice.c poly.c que.c sprite.c text.c >glob.c
sc glob.c
rm usr:lib/gl.lib
oml usr:lib/gl.lib r glob.o
mv glob.c glob.x
