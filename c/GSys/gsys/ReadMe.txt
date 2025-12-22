
GSys v2.0 by Anders Kjeldsen

This is a bunch files containing C++ classes
intented for AmigaOS and Windows. The whole
system is in some ways based on the Java API.
Each class has two files, a header and a
cpp-file. If you want to use a class, you
should just include the cpp-file. None of
these classes are complete, many of them
won't even compile correctly. This system
has been developed on both Win32 and AmigaOS,
and I've been a little bit lazy when it
comes to updating the classes on the other
platform. Often you'll see that I've missed
out a #define GWINDOWS for instance. The
reason why I put released this archive, is
that I want help from other programmers
who likes the idea behind this system and
who'd like to help me make it more complete.

Classes that works on amiga (none complete):
ggraphics/GScreen
ggraphics/GRequestDisplay
gmisc/GTextHandler
gmisc/GHTMLReader
gmisc/GWordArchive (I think)
gmisc/GSortNode
gmisc/GChunkHandler (I think)
gsystem/GError
gsystem/GObject
gsystem/GFile
gsystem/GBuffer

GBuffer is an example of a class that will
either be obsolete OR heavily changed.

The G3D-dir is neither usable. The classes
aren't 50% complete, and they are so far
based on based on the old system, which
sucked more. But have a look, you might
get the idea of how it might look like.

the example source (gangstahsystem.cpp) is 
a program that loads a 256*256 32bit array
from disk, and plots it on the screen. 

contact me at AndersK@gangstah.net

