
             ABasiC patches for Kickstart 2.0 (V36) and PAL/NTSC
             ===================================================

Please read the "HELP WANTED!" section below. Send comments or suggestions to
markk@clara.co.uk

See also the collections of ABasiC programs: dev/basic/ABasiC_progs.lha and
dev/basic/BasicProgs.lha on Aminet.


Version history
---------------
2012-03-17	0.4	Fixed issue on machines with more than 512KB chip RAM;
			arrays already in chip RAM could unnecessarily be
			moved. Added section about the VARPTR problem. Added
			experimental patch to enable detection of right mouse
			button state.

2012-03-06	0.3	Increased size of the sound task stack. Mention where
			the ABasiC user manual can be downloaded from. Updated
			Tips section.

2012-02-05	0.2	Added reverse patch, so you can revert a patched
			executable back to the original. Added NTSC-to-PAL/
			PAL-to-NTSC patch files and information.

2003-05-05	0.1	First public release. This can be considered
			preliminary; please report any problems!


Introduction
------------
Back in 1985, the first Amiga 1000 computers came with Metacomco's ABasiC
language. With version 1.1 of the Amiga OS, ABasiC was replaced by Microsoft's
AmigaBASIC. ABasiC and AmigaBASIC are very different. ABasiC is a more
"traditional" environment than AmigaBASIC, and seems faster and less buggy.
Unfortunately ABasiC does not work under Kickstart 2.0 (V36) and later, but
this patch fixes the problem.

ABasiC is hard-coded to use the default NTSC screen height (200 lines). While
ABasiC works fine on both NTSC and PAL Amigas, you can also patch it to use
256-line screens, so filling the whole PAL screen area.

Apart from historical interest, David Addison wrote some excellent games in
ABasiC which are available on early Fred Fish disks and Aminet. Now you can
take a virtual trip back to 1986 and play his versions of Klondike, Othello
and others! They are surprisingly good, considering they are written in BASIC
and run on a 256K machine.


Applying the Kickstart 2.0-compatibility patch
----------------------------------------------
You need a copy of the original ABasiC executable which is 95388 bytes long.
The datestamp on my copy is 11-Sep-85 06:19:12. The patched executable is
96348 bytes long. Don't modify your original ABasiC disk; work with a backup
copy instead.

Included in this archive is copy of GPatch 3.0, which is copyright © 1997-
2002 Ralf Gruner. You can get the full GPatch distribution from Aminet,
util/misc/gpatch.lha

To apply the patch, in a CLI/Shell window use a command like
	GPatch ABasiC ABasiC_patch_0.4.gpch ABasiC_new

If you want to revert the patched executable to its original state, use a
similar command:
	GPatch ABasiC_new ABasiC_patch_0.4.gpch ABasic_original


Applying the NTSC<->PAL patch
-----------------------------
The PAL-patched version of ABasiC opens 256-line (instead of 200-line) screens
and windows. Thus on PAL Amigas it fills the normal display area, with no
large border at the bottom. To create a PAL-patched version of ABasiC use a
command like
	GPatch ABasiC ABasiC_NTSC-PAL_0.4.gpch ABasiC_PAL
Or to reverse the process
	GPatch ABasiC_PAL ABasiC_NTSC-PAL_0.4.gpch ABasiC

That will work with original, Kickstart 2.0-patched and right-button-patched
ABasiC executables.


About the right button patch
----------------------------
This release contains an experimental patch to enable detection of the right
mouse button state. No existing ABasiC programs use that, so this will
probably only be of interest if you are writing your own ABasiC program and
want the ability to detect the right button.

The ASK MOUSE command can be used to query the pointer position and button
status. Left and middle button status can be detected, but not right button
state. Instead, when the right button is pressed a blank menu strip appears at
the top of the screen, and screen output halts until the button is released.

In some cases holding the right button to pause output can be useful, e.g. to
pause a scrolling program listing. But it would be useful to be able to detect
the right button state. For example, a drawing program could paint in
different colours depending on whether the left or right button is held down.

The right button patch changes ABasiC so the right button can be detected and
no empty menu strip is shown. To detect mouse buttons use ASK MOUSE like this:
	ASK MOUSE x%, y%, b%

The pointer X and Y positions (relative to the inner area of the window) are
put in variables x% and y%, and the button state in b%. Three bits are used
for the button state:
	bit 2 (4): left button
	bit 1 (2): right button
	bit 0 (1): middle button
So if the user is pressing the left and middle buttons, the value put in b%
will be 4+1 = 5.

To see the difference, try running this program on original and right-button-
patched versions of ABasiC:
	10 ASK MOUSE x%, y%, b% : PRINT b% : GOTO 10

To apply the right button patch, use a command like
	GPatch ABasiC ABasiC_RMBTRAP_patch_0.4.gpch ABasiC_new


Where to get ABasiC
-------------------
If you don't have ABasiC but would like to try it, it can be obtained from
Rainer Benda's web site at http://www.rbenda.de/commodore/software.html

Several archives which include ABasiC and various programs are available from
ftp.back2roots.org. See the corresponding .txt files for file listings:
http://ftp.back2roots.org/back2roots/disks/17bit/dms/00xx/17bit-0071.dms
http://ftp.back2roots.org/back2roots/disks/apdc/dms/00xx/apdc-0003.dms
http://ftp.back2roots.org/back2roots/disks/apdc/dms/00xx/apdc-0004.dms
http://ftp.back2roots.org/pub/back2roots/disks/bavarian/dms/00xx/bavarian-0031.dms
http://ftp.back2roots.org/pub/back2roots/disks/cam/lha/00xx/cam-0006.lha
http://ftp.back2roots.org/pub/back2roots/disks/slipdisk/dms/00xx/slipdisk-0001.dms
http://ftp.back2roots.org/pub/back2roots/disks/slipdisk/dms/00xx/slipdisk-0002.dms
http://ftp.back2roots.org/pub/back2roots/disks/slipdisk/dms/00xx/slipdisk-0026.dms


Where to get the ABasiC user manual
-----------------------------------
I recently took pictures of each page of my ABasiC user manual. The quality
isn't wonderful, but it should all be legible and is better than no manual at
all. At the time of writing that can be downloaded from
	http://www.fileserve.com/file/j98VfEW/ABasiC_manual_mark_k.zip

Someone converted the JPEG images to PDF. The URL is shown at
	http://eab.abime.net/showthread.php?p=801303


Details
-------
The patched ABasiC executable fixes three problems.

Attaching a CON handler to an existing window:
ABasiC uses a special technique involving the BCPL internals of AmigaDOS to
attach a CON: handler to its window on a custom screen. Metacomco was the
developer of AmigaDOS and there was no other way to achieve that under
Kickstart 1.x. The technique was publically documented by Andy Finkel of
Commodore-Amiga; see dev/src/Window.lha on Aminet. Despite that Commodore
chose to remove support for it in Kickstart 2.0. (It should be noted that the
exact technique which ABasiC and the Window example use to call BCPL routines
is a bit of a hack. It would have been possible to do that more legally, which
could have allowed Commodore to continue to support those programs in
Kickstart 2.0.)

Kickstart 2.0 and later support a different method for attaching a CON:
handler to an existing window. The patch modifies ABasiC to use the new method
under Kickstart 2.0 or later, and the original method under 1.x.

Insufficient sound task stack size:
The original ABasiC executable only allows 200 bytes for its sound task stack.
On a 68000 machine, that is cutting it very fine; I measured the sound task
using 196 bytes of its stack under Kickstart 3.1. On a 68020+ machine with FPU
or 68040/060, the amount of stack used is greater; I counted 274 bytes for
68020+68882. Because of that, using sound commands would cause a crash. This
version of the patch allows 1000 bytes for the sound task stack.

Chip RAM check assumes 512KB chip RAM:
ABasiC knows about the difference between chip RAM and fast RAM. The GSHAPE,
SSHAPE and WAVE commands need data to be in chip RAM. ABasiC checks whether
the array argument is in chip RAM and moves the array to chip RAM if
necessary.

ABasiC thinks that only addresses below $80000 are in chip RAM. On machines
with more than 512KB chip RAM, an array could be in chip RAM at an address
above $80000. ABasiC would unnecessarily allocate more chip RAM and copy the
array data to that. If none of the first 512KB of chip RAM is available, the
array would be "re-allocated" every time it is referenced by a GSHAPE/SSHAPE/
WAVE command. In most cases that is harmless -- but see the section below
about the "VARPTR problem". However it could result in poor performance if the
program e.g. uses many GSHAPE commands to blit images to the window.

The patched executable changes the check to consider any address under $200000
to be chip RAM, which is true for all real Amigas. The correct way to check
whether an address is in chip RAM would be to use the Exec TypeOfMem()
function, but that was not available in Kickstart 1.0.


Known problems
--------------
While the sound task stack size is fixed in this release, there still seem to
be sound-related problems, which may be specific to faster machines. Some
programs which use sound crash/hang sometimes. As a last resort you could edit
the program to remove all sound commands before running it.

In later Kickstart versions (starting with V39, 3.0), console.device was
optimised to only scroll those bitplanes it thinks are in use. To see the
effect of this, run one of the David Addison games which uses 16- or 32-colour
graphics. If you press Ctrl-C twice to break the program, then LIST, the
scrolling does not affect the higher bitplanes.

I may be able to fix this in a future version of the patch; see HELP WANTED!
below. In the mean time, forcing the ABasiC screen to be interleaved using
ModePro should cure this problem (and improve graphics performance). ModePro
is on Aminet, util/cdity/ModePro.lha

Running the David Addison program Polyfractals causes my Amiga to crash.

Please report any other problems you encounter.


The VARPTR problem
------------------
As mentioned above, GSHAPE, SSHAPE and WAVE need data to be in chip RAM. If
the array variable is not already in chip RAM, ABasiC moves it there when
those commands are used.

The fact that arrays may be moved is not documented in the ABasiC manual.
Moving an array causes its address to change. If the ABasiC program caches/
remembers the array address by using a command like
	address% = VARPTR(array%(0))
then if the array array% is moved, address% will no longer contain the address
of array%(0). Instead address% will point to recently-freed memory which may
be in use by another program! Thus references to address%, e.g. loading data
there using BLOAD, or using POKE to write values to it, will corrupt memory
leading to a crash.

There are two solutions to this problem:
 - To use existing ABasiC programs which are affected by this issue without
   modification, run NoFastMem before running the program. Then all arrays
   will be in chip RAM initially, so ABasiC will not move them. (You can run
   ABasiC and LOAD the program before running NoFastMem. Then ABasiC and the
   program load into fast RAM, so performance will be better than running
   NoFastMem before ABasiC.)

 - Modify the program to not cache array addresses. So for the example above,
   replace references to address% with VARPTR(array%(0)).

Programs known to be affected by this issue are:
 - Tools/Demo.bas (Amicus disk 1)
 - Polydraw (David Addison)


Tips
----
ABasiC only knows about low-res (320x200) and high-res (640x200) screen modes.
The code seems quite system legal however, so you should be able to use a
mode-promotion program to promote its screens if you have a graphics card.

If you don't have the ABasiC documentation, here is some information to get
you started.

Stack size needs to be at least 8000 bytes before running ABasiC. Use Ctrl-C
to break a running program.

At startup ABasiC looks for init.bas in the current directory and S:, and if
present loads and runs it. You could use that to set your preferred screen
depth, resolution and palette.

The default screen is 320x200 with 4 bitplanes (16 colours). Use the SCREEN
command to change that, for example
	SCREEN 0,5	5-bitplane low-res screen
	SCREEN 1,2	2-bitplane high-res screen
An optional third argument makes ABasiC open the screen lower on the display
and with a shorter window; try SCREEN 1,2,100 for example.

Some commands:
	CHDIR		Change current directory, e.g.
				CHDIR "RAM:"
	CHAIN		Load and run a program, e.g.
				CHAIN "my program.bas"
	DIR		Print directory listing, e.g.
				DIR
				DIR "DH0:"
	DIRECTORY	Synonym for DIR
	LOAD		Load a program, e.g.
				LOAD "my program.bas"
	RGB		Set palette colours, e.g. set colour 2 to yellow:
				RGB 2,15,15,0
	SCNCLR		Clear the screen
	SHELL		Run a CLI/Shell command, e.g.
				SHELL "List C:"
	SLEEP		Wait for the specfied number of microseconds, e.g.
			to wait for a quarter of a second:
				SLEEP 250000
	SYSTEM		Quit ABasiC
	TRACE		Typing this before running a program causes each
			line to be printed as it is executed, useful for
			debugging
	UNTRACE		Turn off a previous TRACE command

You can learn more by reading the source code of ABasiC programs. They are
plain text files, so can be loaded into any text editor.

ABasiC runs much faster on modern accelerated Amigas. Some programs use timing
which depends on the CPU speed, and therefore run too quickly. For example, a
program might use statements like
	FOR I=1 TO 1000: NEXT I
to create a short delay. You can replace those with equivalent SLEEP commands
(the SLEEP command is independent of CPU speed).


HELP WANTED!
------------
Is there a way to tell console.device to scroll all bitplanes, to fix the
scrolling problem mentioned above? Can I simply call SetWriteMask() for the
window's RastPort?

I have not tested the patched version of ABasiC extensively. Please let me
know if you encounter any problems.

Jim Cooper, formerly jamie@sas.com, apparently developed a similar patch for
ABasiC a few years ago but never released it. Does anyone know his current
email address? He mentioned it in a posting to comp.sys.amiga.programmer in
1999:
https://groups.google.com/group/comp.sys.amiga.programmer/msg/582ccb2b8fd8b45c
