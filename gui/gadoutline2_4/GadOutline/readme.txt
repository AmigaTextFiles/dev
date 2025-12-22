
GadOutline Library v2.0
~~~~~~~~~~~~~~~~~~
Copyright (C)1993 by Dianne Hackborn.

=========================================================================
This program is shareware.  If you like it and use it in your
programs, please consider becoming a registered by sending $20 me.
(My address is below.)  This will allow me to provide answers to
questions you may have about its use and the resources to continue to
develop the library.

There is admittedely a very limited amount of documentation on the
library right now.  It was originally written for use in my own
programs and, while it has grown quite a bit beyond that, I can not
justify putting in the time to write up extensive documentation that
I don't need.  This will change if there is a good response to the
library [read: money :)], but for now I can not guarantee anything
beyond what is already here.  If you do decided to register, however,
I will be able to provide you with more support.

This library is freely distributable as long as all of its files are
included with no modifications.  By becoming registered, you will be
allowed to include a subset of the library distribution with your program
if you so desire.  The library is provided as-is, with no warranties of
any kind.

People interested in using this in a commercial product should
contact me to discuss it.  [I'm not greedy.  Really. ;)]
=========================================================================

INTRODUCTION

Gadoutline.library is intended to provide you with a means of
describing the general layout of your GUI in a font-independant
manner, and take care of the details of determining the exact
placement of the individual elements of the display and the drudgery
of creating and managing all of the gadgets.  In addition, it
provides a very generalized mechanism for tracking the state of all
of its gadgets to support automatic resizing and closing and opening
of a window without loss of context, automatic hotkey support, a
vector based drawing module that can be used for everything from
drawing frames around groups of gadgets to creating custom images
for BOOPSI gadgets to adding complex drawings and textual information
to a window, the ability to transparently use both GadTools and
BOOPSI gadgets, and to use new GadTools and BOOPSI gadgets without
having to write a single line of code.

WHAT IS A "GADOUTLINE?"

The library draws its name from the primary data structure used to
describe the entire gadget layout - a ULONG array 'outline' which is
composed of individual 'commands.'  A command is used to define a
single element of the display - a gadget, the wrapper around a group
of gadgets, or an image - and additional 'control' commands are used
to control how groups are organized, provide additional information to
the library, and mark the end of the array.  This array is an entirely
static structure; the library only uses it to determine the dynamic
data which is needed by the layout and after that it is never
referenced again.  This brings a number of important consequences:

    - An application almost never refers to the elements of the
      outline in terms of pointers.  While ultimately all of the
      commands are referenced as normal pointers to C structures, the
      application almost entirely refers to the commands and their
      associated gadgets in terms of an ID code which is assigned to
      the command.  Every command must have either a unique ID code,
      or the special "none" code of 0, and everything from assigning
      hotkeys to setting a gadget's attributes uses this unique ID
      code to determine which command is being refered to.

    - Almost all of the information needed to create a gadget is
      localized into one place in the outline array, making it much
      easier to see what a gadget actually is.  In addition, the layout
      of the gadgets is primarily determined by their position in the
      array, so it is relatively easy to understand their
      relationship to the rest of the window.  Moving the layout
      around is as easy as using cut and paste in your text editor.
      
    - Defining connections between objects no longer requires
      absolute pointers to them.  Instead, you simply include the
      command ID along with the rest of the definition of your
      gadget, and the library takes care of resolving the pointer when
      the gadget is actually created.
    
    - All of the tags used to define the orginal layout are
      dynamically tracked by the library as the gadgets are changed
      and your program makes changes, so that the layout and all of its
      objects can be restored to their previous state even when closing
      a window and opening it on a new screen.  And because all of
      the library's state tracking is based on the object's tags, new
      kinds of gadgets are automatically tracked by the library.

With the addition of a "translation" callback hook, automatic
localization can easily be implemented, or it is even possible to
design a method of removing all absolute memory references within the
static outline so that it could, for example, be loaded off disk when
needed by the application.

THE EXAMPLE PROGRAMS

    Included with this archive are the example programs example1,
    example2 and example3.  In addition, my separate public screen
    manager program "PSM" [yes, I'm naming-impaired ;)] should be
    available, which provided a full demonstration of a working
    application with multiple windows.  The most useful of these is
    probably example3, which is fully commented and plays some tricks
    with the library to allow you to see how it does a full layout of
    the outline by forcing one every time the window resizes.
    
    Example1 is probably only useful to see a simple implementation of
    a shared IDCMP port, and PSM has a more complicated, complete
    implementation of this.
    
    Example2 is only notable for its utterly garish display and
    unreadable source code. :)

WHERE TO GO NOW

    The two main sources of documentation are the autodocs and the
    header file.  If you have AmigaGuide, read the file "GadOutline"
    in the includes directory.  This is the fully linked AmigaGuide
    version of the autodocs, with appropriate connections to the
    header file [and the system header files, too, if you have them in
    your AmigaGuide search path.]
    
    Otherwise, the autodocs are suppled as a plain text file in
    "GadOutline.doc".
    
    The first entries you will probably want to read are
    AllocGadOutlineA(), GO_GetGOIMsg(), GO_GetCmdInfo(),
    GO_InterpretTypedSize() and GO_OpenWindowA(), and just follow
    their links.
    
WHAT ISN'T HERE

Before putting any more work into this library, I would like to see
what the response is going to be in order to judge whether it is
worth it.  This doesn't mean that it is in any way incomplete as it
is; in fact, the reason that I'm releasing it now is because I have a
bunch of projects that I would like to work on and have been waiting
for the library to be usable.  However, it does mean that the only
things implemented at the moment are what that I need.  So:

    - BOOPSI support is barely implemented and has been tested even
      less.  There are a couple of small things that definately need
      to be implemented to fully support BOOPSI, and will probably be
      added at some point, but for now creating images and attaching
      button gadgets is about all you can expect.  That part does
      work pretty well, however. ;)
      
    - Gadgets in window borders aren't supported.
    
    - The only real documentation is what is in the autodocs and the
      header file gadoutline.h.  About the only real overview on how
      everthing works is the program example3.c.  This hopefully will
      be enough to get a basic, usable understanding of how it works.
      And, if you want more...  well, register. :)
      
    - There is absolutely no documentation on the vector drawing
      commands beyond what is in the header file, and currently no
      programmer interface to them besides the integrated support in
      the outline draw groups, boxes and images.
      
    - No V39 specific support.  Someday...

HOW TO REACH ME

EMail -     BIX: dhack@bix.com
            SCHOOL: hackbod@xanth.cs.orst.edu

SnailMail - Dianne Hackborn
            2895 Los Altos Drive
            Meridian, ID 83642
            
THANKS TO

    David Junod, Michael Cianflone, Gary Milliorn, John Basile and
    Doug Keller for their comments and suggestions.

FINALLY

    Have fun, and I hope you find the library useful.  All comments,
    suggestions and bug reports are more than welcome.
