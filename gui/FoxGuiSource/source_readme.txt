In order to compile the FoxGUI source unmodified, you will need the
following:

SAS/C 6.58.  Patches to update SAS/C 6.5x to 6.58 are available for
download from Aminet.

DMake.  An alternative to smake.  DMake is downloadable from Aminet.

The standard Amiga header files (these come with SAS/C and other
compilers).

IFFParse.library and the associated header files (the headers can be found
on the Amiga Developer CD v2.1 in the drawer
NDK/NDK_3.1/Examples2/IFF/iffp).  I believe that these files may also be
found on Aminet (gfx/misc/NewIFF.lha) but I'm not certain that these are
the same version.



To Build FoxGUI:

Unpack the archive, preserving paths (e.g. lha x FoxGUISource).
Create a drawer called objects and a drawer called foxlib in the directory
containing the make file.
Make sure that a directory called iffp containing the iffparse.library
headers exists in your INCLUDE: assign (usually work:sc/include).
Edit iffp/ilbm.h - remove the definitions of IntuitionBase and GfxBase.
From the command line, cd to the drawer containing the dmakefile.
Type "dmake" at the command line.
