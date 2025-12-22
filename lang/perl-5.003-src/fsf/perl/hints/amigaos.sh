# hints/amigaos.sh
#
# talk to pueschel@imsdd.meb.uni-bonn.de if you want to change this file.
#
# misc stuff
archname='m68k-cbm-amigaos'
cc='gcc'
firstmakefile='GNUmakefile'

usenm='y'
usemymalloc='n'
usevfork='true'

d_eofnblk='define'

# libs

libpth="$prefix/lib"
glibpth="$libpth"
xlibpth="$libpth"

libswanted='dld m c gdbm'
so='none'

# dynamic loading

dlext='o'
cccdlflags='none'
ccdlflags='none'
lddlflags='-oformat a.out-amiga -r'

# Avoid telldir prototype conflict in pp_sys.c  (AmigaOS uses const DIR *)
# Configure should test for this.  Volunteers?
pp_sys_cflags='ccflags="$ccflags -DHAS_TELLDIR_PROTOTYPE"'
