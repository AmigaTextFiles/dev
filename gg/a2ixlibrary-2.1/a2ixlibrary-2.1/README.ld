
Read on...

Put 'ld' from this distro to your compiler under:
   '/gg/lib/gcc-lib/m68k-amigaos/X.X/ld'(where X.X is compiler version).
If there is 'ld' already then move it to '/bin' first and then copy this
one. This is important in order to be able to link against shared libs!

megacz@usa.com
