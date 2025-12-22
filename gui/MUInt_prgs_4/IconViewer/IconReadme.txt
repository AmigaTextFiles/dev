.info DataType 39.1
-------------------

Written by Oliver Seiler

Copyright © 1994-1995 Erisian Development Group. All Rights Reserved.


Disclaimer
----------

This program is basically FreeWare. It is *not* public domain. I do however
give commercial products (this includes ShareWare packages) the right to
include this in distributions, on the basis that I receive a free copy of
the package (although, given the simplicity of the implementation, I don't
see this being a very likely situation...)

In any case, anybody who wants to include this in some sort of distribution
or software package should contact me for my approval. I'd like to know
who's using it in the event I re-release it later...

I also would enjoy just getting a postcard in the mail...


Introduction
------------

This datatype was originally developed to help me learn about datatypes, and
'cause I wanted something to view icons from the shell...

The original release (39.0) had a bug or two, but that seems to be fixed...

Installation
------------

An Installer script is included with the distribution. Just double-click on
the Install icon from Workbench. It should work fine, although it's my first
Installer script. If it doesn't seem to work on your (probably whacked) system,
then manual installation is quite easy:

eg. (Assuming unarchived in RAM:)

6.RAM:> lha e infoDataType.lha

...

6.RAM:> cd infoDataType
6.RAM:infoDataType> copy info.datatype SYS:Classes/DataTypes

...

6.RAM:infoDataType> copy "Amiga .info#?" DEVS:DataTypes

...

6.RAM:infoDataType> AddDataTypes "DEVS:DataTypes/Amiga .info File" REFRESH

That's all folks...


Usage
-----

Assuming you aren't programming, the easiest way to use this datatype is
from MultiView. Just type:

MultiView <file>.info

Of course this only works if the file has an associated .info file. No
harm if it doesn't, so don't worry too much. (Unfortunately, if you use
MultiView's built-in file requester, you won't see any .info files in
the directory listing. You can still access the files though, by adding
a .info extension to the filename in the file requester...)


Limitations
-----------

The main limitation is that you only can view the unselected icon image
associated with the .info file you try to view. I might eventually add
support (in the form of a tag which can be passed to the object) to show
the selected image. Or maybe make it act like a gadget and toggle with
user mouse button presses.

The colour palette is obtained from the current Palette preferences setting,
so if you want to change the colours, you're going to have to change this.


Bugs
----

Not that I know of in this version. Color mapping still doesn't work 100%, but
this seems to be a problem with the picture datatype. Oh well. Works on everything
I threw at it.


History
-------

39.1            Doesn't use ENV:Sys/palette.prefs anymore for color information.
                This didn't work properly since the prefs format wasn't right.
                Instead, I just get the color information from the Workbench
                screen (much easier).

                Fixed some other little problems.

39.0            Initial release


Upcoming from Erisian
---------------------

As of yet, my RTF datatype and TIFF datatype are uncompleted. I'm trying to
find enough time to complete them, and also convert most of the code to C++
(which for both datatypes would be very helpful...)

Anyway, here are the announcements from the original documentation:

RTF DataType - That's right, the Rich Text Format, coming soon to an Amiga
               near you (assuming you have 3.0+). Current alpha version has
               support for multiple fonts, margins, and tables. Stylesheets
               are soon to be added, which will probably round out the first
               release. Future additions: pictures, colour, and real page
               support (based on Printer preferences)

TIFF DataType - It's big. Real big. Probably the biggest datatype ever seen
                (at least until a PostScript datatype appears...) and is
                currently in the very very alpha version. Once I figure out
                how to use the libtiff library properly, this will appear
                quite soon after... (NOTE: when and if this comes out,
                I don't think it will support all the various TIFF formats.
                There are way to many of them... Maybe have subsets of the
                TIFF format as separate datatypes...)

I've got some other software on hold right now (I'm pretty busy working now,
as well with assorted other non-Amiga related things...):

Erisian Class Library - A nice application framework for the Amiga which I
              plan to use on my own applications. Have finished a good portion
              of it (even have a menu class which makes it really easy to
              build menus in an object-oriented way in C++). Currently
              finishing up the GUI layout engine and support classes (using
              my own fast constraint network solver. Quite cool in it's own
              right...)

Gearing - This is the application I'm building concurrently with the class library
              above. Basically it's a simple application for interactively
              designing and evaluating bicycle gear patterns. It's simple enough
              so that it isn't a huge project in it's own right, and it's
              useful enough for me that I'd like to have it anyway...

Most of my programming time is spent on the class library, although I finally went
and fixed up the .info datatype for it's second, and likely final release.


Reaching the Author
-------------------

I may be reached at:

Oliver Seiler
Erisian Development Group
PO Box 3547 MPO
Vancouver, BC CANADA
V6B 3Y6

Phone:  (604) 683-5364
Fax:    (604) 683-6142
e-mail: oseiler@unixg.ubc.ca
        oseiler@nyx.cs.du.edu
        ollie@bix.com


I'm also available for contract programming work on the Amiga. My strengths
include complex interface design and implementation, a driving urge to make
elegant, useable programs, and I'm very productive. Please feel free to
call if interested.

And I do Macintosh programming as well now (well, I gotta pay the bills you
see...)
