Native Developer Kit for AmigaOS 3.2 (NDK 3.2 Release 4)
========================================================

At last, here is the long overdue update to the Native Developer Kit.
More than seventeen years after the last AmigaOS 68k NDK, several
changes were made to improve the robustness and quality of the new and
shiny NDK 3.2.

We would like to first point out that out of necessity the NDK will
have to become a work-in-progress. So updates will have to be made as
needed and released, because AmigaOS is now a force in motion, not a
stationary object anymore.

It is also worth noting that tools, examples, and other components from
previous NDKs are not needlessly duplicated here, so it may be a
worthwhile endeavor to also seek out on earlier NDKs for complementary
material.

The current NDK content is laid out as follows:


Autodocs - Autodocs are documentation that reference calling
--------   conventions for Amiga routines.

Autodocs/AG - Autodocs documentation in AmigaGuide format.
-----------

Examples - ReAction examples (this includes both their sources and
--------   binaries).

FD - These are library function description files.
--

Include_H - C language header files that contain declarations for
---------   functions and values.

Include_I - Assembler language header files that contain declarations
---------   for functions and values.

lib - A Lib file is a library of functions that are statically linked
---   to a program.

MuManual - Contains the development documentation for the
--------   mmu.library, describing its functions and its purposes
           along with examples.

MuTools - Set of tools that provide debugging facilities.
-------

ReleaseNotes - Release Notes are a short summary of the changes
------------   involved at the different stages of a component's
               development process.
            
SANA+RoadshowTCP-IP - Developer documentation for the SANA-II
-------------------   networking driver standard and also source code
                      for the Roadshow TCP-IP stack management,
                      monitoring and file transfer commands.

SFD - These are library function description files.
---

Tools - Several tools that should make life easier for developers.
-----


Inquiries, bug reports & enhancement requests referring to the NDK 3.2
should be directed to:

https://forum.hyperion-entertainment.com/viewforum.php?f=26

If you have never been bitten by the urge to develop for the Amiga,
what are you waiting for?

Enjoy the journey, not the destination.
The AmigaOS Team

----------------------------------------------------------------------

Thanks to these kind individuals for their permission to include their
work:

Olaf Barthel who gave us permission to include his Roadshow related
development material.

Thomas Richter who gave us permission to include his MMULib development
material and its associated tools.

Dirk Stoecker and the fd2pragma open source project available at:
https://github.com/adtools/fd2pragma

Frank Wille for providing both the necessary advice on how to make the
vbcc inline header files as well as the right tool for the job.

----------------------------------------------------------------------

Changelog:

NDK 3.2 R1: Initial Release - 13.04.2021

NDK 3.2 R2: First update - 31.05.2021
   - Autodoc, BumpRev, CatComp and Localize integrated in the
     Tools directory.
   - Added missing entries to Shell and Layers Release Notes.

NDK 3.2 R3: Second update - 22.06.2021
   - Updated gadgets/radiobutton.h include.
   - Added NDK3.2/Include_H/inline directory.
   - Updated amiga_lib.doc, exec.doc and alib_lib.doc
   - Added macros.h and stubs.h from fd2pragma.
   - Added vbcc-specific header files as well as the
     proto/#?.h files which make use of them.

NDK 3.2 R4: Third update - 06.02.2022
   - Updated AutoDocs for amiga_lib.doc, audio.doc, commodities.doc,
     dos.doc, exec.doc, graphics.doc, locale.doc and wb.doc which for
     the first time in 35 years contain documentation on bugs and
     features never covered in detail before in the RKM text or in the
     AutoDocs.
   - Updated ReAction AutoDocs for bitmap_ic.doc, chooser_gc.doc,
     fuelgauge_gc.doc, getcolor_gc.doc, led_ic.doc,
     listbrowser_gc.doc, listview_gc.doc, picture_dtc.doc,
     sketchboard_gc.doc, speedbar_gc.doc and texteditor_gc.doc.
   - Removed AutoDocs for aiff_dtc.doc, deficons.doc and gif_dtc.doc
     which did not contain enough relevant information to justify
     their inclusion.
   - ReAction example code has been updated and revised. The
     LED example now demonstrates some new 3.2.1 features, and the
     ListBrowser1 example no longer assumes the thicknesses
     of the window borders.
   - Added "DAControl+trackfile" example code.
   - Reworked the SFD files which could trip up the sfdc conversion
     script, leading to functions to get omitted. The problem was with
     blank spaces in the register list specification which are
     permitted and should always be ignored during processing.
   - Added "FD" directory containing FD files, generated from the
     updated SFD files.
   - Almost every single 'C' header file in the "Include_H" directory
     has been updated and revised, or rebuilt from the SFD files.
     Updated header files can contain new documentation on purpose and
     features of macros, data structures and constants. Macros have
     been reviewed and again revised for more robustness, if possible.
   - Include files for TextEdit plugins have been added in the
     "Include_H/tools" directory.
   - All new full support for vbcc inline header files, which was
     neglected in previous NDK 3.2 releases. Our thanks go to Frank
     Wille who kindly provided advice and his time to verify that the
     header files are up to the task :-)
   - All new interface header files in the "Include_H/pragma"
     directory, for the Aztec 'C', Maxon 'C' and StormC compilers.
   - The header files in the "Include_H" directory found in the
     "clib", "inline" and "pragmas" subdirectories have been tidied
     up, removing redundant or unsupported functionality.
   - Updated the "pragmas/cia_pragmas.h" and "pragma/cia_lib.h" 
     header files to provide better compatibility with the Lattice,
     SAS/C and Aztec 'C' compilers in offering a replacement for the
     amiga.lib interface for the ciaa.resource/ciab.resource API.
   - Assembly language header files in the "Include_I" directory have
     been updated: datatypes/pictureclass.i, devices/newstyle.i,
     dos/datetime.i, dos/dos_lib.i, exec/exec_lib.i,
     graphics/copper.i, images/led.i, libraries/asl.i,
     libraries/expansion.i, libraries/locale.i,
     libraries/mathresource.i, prefs/pointer.i and prefs/workbench.i.
   - All new "Include_I/lvo" directory containing library vector
     offsets for every single Amiga operating system library/device
     which has a public API. We still recommend linking against
     amiga.lib or small.lib, which contain the same information and is
     likely faster to process than the LVO definitions found in the
     header files.
   - Updated and rebuilt amiga.lib, small.lib, debug.lib and
     ddebug.lib.
   - Roadshow SDK now has full support for vbcc.
   - Updated SFD files, with full ReAction support.
   - Updated "Tools/CatComp" to version 40.7.
   - Added new developer documentation and debugging aids,
     namely for the operating system interface header files
     and for the memory pools. You can find these in the
     "DeveloperDocumentation" drawer. "InterfaceHeaderFiles"
     describes how the clib/proto/pragmas/pragma/inline work,
     how they came about and how to use them. "MemoryPools"
     describe the exec.library memory pool feature, introduced
     with Kickstart 3.0: how to use it, how to get the best
     performance out of memory pools and how to monitor them.
