

               T H E   G A M E S   M A S T E R   S Y S T E M

                                VERSION 2.1

                               OCTOBER 1998



Welcome to the latest GMS release.  This latest version includes the
following enhancements:

 + Music support added by G.W Thomassen.

 + Completely new ObjectFile format.  Develop your object definitions 
   using standard text files!

 + Now you can draw Bitmap pixels using the fastest possible native
   routines.

 + Inspector now supports all of the system objects.

 + Highly evolved pens support - draw transparent circles, shadow squares,
   sparkling shapes and create your own custom effects.

Please see the end of this document for a list of all changes to V2.1.

The latest news is that support for AMOS is due in November, through Peter
Cahill's "The Game Extension".  Gøran Thomassen is working on compact disc
support, so you will soon be able to play your favourite CD's as well as
the standard music modules.  Look out for a review of GMS in the latest
issue of Amiga Informer as well.

Note for Dice users: Copy the GMSDev:Includes/lib/tags.o to your DLIB:
directory.  In future you will now need to link your programs with this
file, or alternatively specify "#define _DCCTAGS TRUE" at the top of your
main source files.


  - Paul Manias
    Author of the Amiga Games Master System
    EMail: pmanias@ihug.co.nz
      WWW: http://homepages.ihug.co.nz/~pmanias/




                                  N E W S



GMS Archives
------------
Looking for the latest GMS files?  Here is a list of all of the GMS files
currently available on Aminet:

  Main
  ----
  dev/misc/gms_dev.lha        Main developer archive.
  dev/misc/gms_user.lha       Main user archive.

  Modules
  -------
  dev/misc/gms_sounds.lha     Sound module.
  dev/misc/gms_config.lha     Config module.
  dev/misc/gms_joyports.lha   Joyports module.
  dev/misc/gms_strings.lha    Strings module.
  dev/misc/gms_colours.lha    Colours module.
  dev/misc/gms_pictures.lha   Pictures module.
  dev/misc/gms_music.lha      Music module.

  Documentation
  -------------
  dev/misc/gms_french.lha     French Autodocs.

  Programs
  --------
  dev/e/ufo_src.lha           An unfinished asteroids style game.


Discussion List
---------------
There is a discussion list available for talking about all things that are
GMS related.  This is about the only place that you can talk to other GMS
developers, so it is worth joining.  There is also a lot of inside
information about future development, and things not mentioned here or on
the web site.

To join the list, point your web browser at:

  http://www.onelist.com/subscribe.cgi/gms

Follow the on screen instructions and you will be joined to the list.
Currently the list stands at 30 members.


Licensing
---------
Before you can distribute a game written in GMS you will need to pay a
licence fee, which goes to the continuation of the project.  Make sure that
you read the entire licensing file before you even begin programming in
GMS!

Also, when distributing your program, make sure you include the file
GMSDev:Extras/GMS_README.TXT, which tells users where to get the GMS files
from.


Announcement List
-----------------
If you just want to receive announcements of new GMS releases, please send
an e-mail to pmanias@ihug.co.nz with "SUBSCRIBE GMS-ANNOUNCE" in the header.
Announcements are posted around every 3-4 months when a major version
(2.0, 3.0 etc) appears.


PC Conversion
-------------
Yes, GMS is being converted to the PC as part of a multiple-platform
development programme.  This will make it possible for you to compile your
programs on both the Amiga and the PC, and therefore earn more money :-).
If you want to help with the conversion, write to pmanias@ihug.co.nz asking
to help.


Anyone want to write an editor?
-------------------------------
Someone other than myself needs to write the object editor for GMS.  It
will have a GUI front end and lots of boxes and windows for the user to
enter data for all currently available structures.  It needs to be able to
write out data in the ObjectFile format (now that this is in a standard
text format, this is very easy).  Look at ObjectFiles in the autodocs for
detailed information.

[NB: You do get a free GMS licence for as long as you work on this.]


Translation of autodocs
-----------------------
If you're interested in converting the docs to your own language, then
write to me and I will give you my support.  Currently there is only a
French translation, so I would like a few more.  The usual free GMS licence
applies.

Note:  To anyone that would like the French documentation, go to
       Aminet and download dev/misc/gms_french.lha.




                               C H A N G E S



VERSION 2.1
-----------
24 Aug Bumped Bitmap object up to V3.
       Bitmap->DrawPixel() and Bitmap->DrawRGBPixel() implemented.  It is
        now much faster to just jump straight to these routines for C and
        asm users.
25 Aug Added SetPenShape()
30 Aug Revised the Reference structure (now V2)
       Totally new Reference file format created.
       Fixed 2 bugs in config module.
31 Aug Added PenLinePxl(), updated PenLine().
01 Sep Edited CopyBuffer() to be a bit faster.
       Enhanced picture module pixel functionality.
03 Sep Fixed ReadRGBPixel(), changed to ReadUCRPixel() and ReadUCPixel().
04 Sep All of the Bitmap->*Pixel functions are UC based (except DrawPen()).
05 Sep Added new demo, c/misc/3DShape.c
       Fixed ReadPixelList().
12 Sep Added Container and ResourceList fields to Stats structure.
       Added Idle(), GetContainer(), AddResource(), FreeResource()
13 Sep Init() now records the container of an object.
14 Sep FreeMemBlock() and Free() now return error codes.
16 Sep The System Task object has been created, and from now on FindDPKTask()
        will almost always return this structure when there is no current task.
       Untracked objects can now be tracked right back to the system task
        for the shut-down process.
       Added SetContext().  This changes the behaviour of Get(), AllocMemBlock()
        and other resource based functions so that they allocate their resources
        to the object currently in context.
19 Sep Added a MEM_RESOURCED flag.  This reflects a memory block which has been
        resourced as a different type.
       Setting the context to the system task seems to have fixed our module
        loading problem.
       Modified TotalMem() so that it can count memory for any given object.
20 Sep Fixed pens error.
       The field structure (which belongs to the SysObject) has been modified
        to allow two new functions, GetField() and SetField().
       SysObject->FieldSize added.
26 Sep Inspector has been updated.
27 Sep Replaced CheckField() with FindField().
29 Sep Modified Load() so that classes that do not support CheckFile() can
        still support Load() and succeed.
03 Oct Fixed up IceBreaker.
04 Oct Added FieldDef structure for defining flags and lookup tables.
       Added SysObject->ObjectSize field.
05 Oct Added SysObject->ClassVersion.
19 Oct Music object fully implemented.


VERSION 2.0
-----------
11 Jul Fixed error between Task->Name memory management and StartDPK.
       The DPKTask is now a proper object and not a simple structure.
       Added GetByName(), FindObjName(), AllocObjectID(), FindReference().
       Added Reference->Activate(), Reference->Deactivate().
12 Jul Added CheckField(), GetField(), GetFieldName().
14 Jul Added MEM_NOCLEAR.
       Added FlipHBitmap(), FlipVBitmap(), PenCircle(), PenEllipse()
       Added IMG_NOCOMPARE, modified Picture unpacking code.
       Added c/blitter/circles and c/blitter/ellipse demos.
18 Jul Module expunging now attempts to make multiple passes.
19 Jul Segment loading rewritten, you can now get the correct Segment->Size
        and initialising child segments is allowed.
       Sound module released.
20 Jul Added CloneMemBlock().
21 Jul Modified the Task handling so that we can cope if tc_UserData is in
        use or is trashed.
23 Jul Implemented the strings module.
01 Aug Config module implemented.
02 Aug Changed Bitmap->CopyStructure() so that it will duplicate the source
        palette rather than taking a pointer (which was technically illegal).
       Added SetField(), SetFieldName().
       Added DebugOn(), DebugOff()
       Improved picture debugging.
03 Aug IceBreaker: Renamed NOMEM to SHOWMEM, added LOW, MEDIUM, HIGH, EXTREME
        detail settings.
04 Aug Improved Bob error output.
       New demos: c/misc/configloader, c/misc/strings
14 Aug Added c/misc/colours.c
       Added c/blitter/Rabbit.c
16 Aug Added c/blitter/BlitArea.c
17 Aug Init(Bob) now checks if SrcBitmap is in blitter memory.
20 Aug Added Bitmap->Query().


VERSION 1.2
-----------
The  blitter now supports pen based functions such as PenPixel(), PenLine()
etc.  There is also a new function that draws rectangles.  The following
list details major changes that have been made since the last release:

13 Jun Depth setting in GMSPrefs changed to reflect the amount of colours.
20 Jun Pictures module now loads progressively rather than in one big chunk.
       The Bitmap->AmtColours field is now checked for illegal values.
28 Jun Completely new IceBreaker interface added.  You can now observe
        what the kernel does on initialisation and expunge sequences.
       Fixed memory allocation bug in keyboard module.
       Fixed bad module function base management - memory left in system
        after a library expunge.
29 Jun Fixed bug in module function building for situations where the
        function list was specified as null.
02 Jul New demo "Source/C/Blitter/Rectangles.c".
03 Jul Added "Own Blitter" to the screen preferences.
       New blitter management implemented.
04 Jul Added many new blitter functions.

