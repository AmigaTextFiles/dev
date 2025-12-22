
===============================================================================
 Hollywood Player 10.0                      (C) by Andreas Falkenhahn 2002-2023
===============================================================================


I. Introduction
===============

The Hollywood Player is a program which can run applets created by the full
version of Hollywood. Applets are compiled Hollywood scripts and can contain
data sections as well. The advantage of the Hollywood Player is that people
who want to publish their own projects can now simply save them as Hollywood
applets, and these applets can then be started on every platform that the
Hollywood Player supports. Previously, Hollywood projects often came in the
form of many binaries for each of the various platforms supported by Hollywood
which made many distributions rather large. With the Hollywood Player, there is
no need to include several executables any longer - just put the applet into
your distribution archive and tell the user to install the respective Hollywood
Player for his platform!


II. How can I create my own applets?
====================================

You cannot create your own applets with the Hollywood Player. Hollywood Player
can only run applets; it can't build them. To create your own applets, you have
to use the full version of Hollywood. Please visit the official Hollywood portal
at http://www.hollywood-mal.com/ for more information on Hollywood and an
order form.


III. Installation
=================

a) AmigaOS and compatibles:
Please use the provided installer script. The Hollywood Player executable will be
copied to your SYS:Utilities drawer. You should not change this location because
many applets will simply use "HollywoodPlayer" as the default tool which means
that the Hollywood Player must reside somewhere in your path.

b) Windows:
Please use the provided installer.

c) macOS and Linux:
Simply drag the Hollywood Player to the desired location on your HD.


IV. System requirements
=======================

AmigaOS version:
- Kickstart 3.0 (V39)
- 68020+ or PowerPC
- CyberGraphX or Picasso96
- codesets.library on AmigaOS 3 and 4, WarpOS, and AROS
- charsets.library on MorphOS
- MUI 3.8 or better
- a JPEG datatype
- optional: AHI by Martin Blom for sound output
- optional: reqtools.library for the StringRequest() function (except on OS4)
  and for the ColorRequest() function (also on OS4)
- optional: popupmenu.library for popup menu function (except on MorphOS)

Win32 version:
- requires at least Windows 2000

macOS version:
- arm64 build: requires at least macOS 11.0 (Big Sur)
- Intel build: requires at least macOS 10.6 (Snow Leopard)
- PowerPC build: requires at least macOS 10.4 (Tiger)

Linux version:
- requires an X11 server and glibc
- optional: ALSA library for sound output
- optional: gtk for dialog boxes support
- optional: XFree86 video mode extension library, Xfixes, Xrender, Xcursor for
  some advanced functionality

Android version:
- Android 4.0 or higher
- an ARM CPU (32-bit or 64-bit)


V. Usage
========

When running the Hollywood Player it will open a file requester allowing you to
select the applet to run. Additionally, you can also start the Hollywood Player
from a console or as an applet's default tool.

The following hotkeys are supported by most applets:

   CMD+RETURN: switches between full screen and windowed mode
   CMD+h: iconifies the aplet
   CTRL-C: quits the applet

Furthermore, Hollywood Player accepts all arguments that Hollywood does (unless
blocked by the applet).	Please refer to the Hollywood documentation for a description
on how to use these arguments. The Hollywood documentation is available online
at http://www.hollywood-mal.com/


VI. Contact
===========

The Hollywood Player is an Airsoft Softwair product. You can reach us here:

E-Mail: andreas@airsoftsoftwair.de
WWW: http://www.hollywood-mal.com/


VII. License
============

The Hollywood Player (the program) is © Copyright 2002-2023 by Andreas Falkenhahn
(in the following referred to as "the author"). All rights reserved.

The program is provided "as-is" and the author can not be made responsible
of any possible harm done by it. You are using this program absolutely at
your own risk. No warranties are implied or given by the author.

It is generally forbidden to spread this program without a written permission by
the author. This program is exclusively available for download from the official
Hollywood portal at http://www.hollywood-mal.com/. It is not allowed to upload this
program to other servers or distribute it through any other means. It is also
forbidden to include this program along with your applet. Instead, you have to
point the user to the official Hollywood portal so that he can download this
program from there.

It is generally not allowed to release any kind of wrapper programs that
make Hollywood commands available to other programming languages or the
end-user. It is also generally not allowed to release any sort of mediator
programs that would enable the user to access Hollywood commands through
a mediating software.

No changes may be made to the programs without the permission of the author.

This software uses Lua by Roberto Ierusalimschy, Waldemar Celes and Luiz
Henrique de Figueiredo. See License_Lua.txt for details.

This software uses libjpeg by the Independent JPEG Group.

This software uses libpng by the PNG Development Group and zlib by Jean-loup
Gailly and Mark Adler.

This software uses PTPlay © Copyright 2001, 2003, 2004 by Ronald Hof, Timm S.
Mueller, Per Johansson.

This software uses the OpenCV library by Intel Corporation. See
License_OpenCV.txt for details.
    
This software uses ImageMagick by ImageMagick Studio LLC. See
License_ImageMagick.txt for details.
    
This software uses the GD Graphics Library by Thomas Boutell. See License_GD.txt
for details.
    
This software uses the pixman library. See License_Pixman.txt for details.
    
Portions of this software are copyright © 2010 The FreeType Project
(www.freetype.org).  All rights reserved.    
    
Hollywood uses the Bitstream Vera font family. See License_BitstreamFonts.txt
for details.

The Amiga versions of this software use codesets.library by the codesets.library
Open Source Team. See License_LGPL.txt for details.
    
The Linux version of this software uses gtk, glibc, and the Advanced Linux Sound
Architecture (ALSA). See License_LGPL.txt for details.
    
The Android version of Hollywood uses the Simple DirectMedia Layer (SDL) by Sam
Lantinga. See License_SDL.txt for details.

This software uses LuaSocket by Diego Nehab. See License_LuaSocket.txt for
details. 

This software uses librs232 by Petr Stetiar. See License_librs232.txt for
details.

This software uses UsbSerial by Felipe Herranz. See License_UsbSerial.txt for
details.

All trademarks are the property of their respective owners.

DISCLAIMER: THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDER AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE
COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY REDISTRIBUTE THE
PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS
OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR
THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.


VIII. History
=============

Version 10.0  (25-Feb-23)
- Updated to Hollywood 10.0

Version 9.1   (23-Apr-22)
- Updated to Hollywood 9.1

Version 9.0   (20-Mar-21)
- Updated to Hollywood 9.0

Version 8.0   (08-Feb-19)
- Updated to Hollywood 8.0

Version 7.1   (10-Feb-18)
- Updated to Hollywood 7.1

Version 7.0   (16-Mar-17)
- Updated to Hollywood 7.0

Version 6.1   (10-Mar-16)
- Updated to Hollywood 6.1

Version 6.0   (07-Mar-15)
- Updated to Hollywood 6.0

Version 5.3   (20-Jul-14)
- First release
- Uses Hollywood kernel 5.3 from 05-Jul-13
