StormWIZARD V2.3
===========

Thanks to Haage & Partner Storm Wizard may now be freely downloaded and
further developed on 68k and further thanks go to Alinea for sending me
the source of OS4 GCC wizard.library port on 3.12.2009.
The 68k version is now built with GCC too.

To clarify this, i have no permission to release the source or give
the source to others, or build MOS or AROS native versions currently.

For qustions or bug reports please do not write to Haage&Partner,
instead ask in amiforce-forum or send a message to bernd_

Storm Wizard is a tool to make designing of GUIs easy and efficient.
You will get an AmigaOS compliant UI very quickly without programming
one line of code.

You can create a GUI in a hierarchical list. Clicking in your GUI preview window
on a place/gadget shows the current entry in the editor list. You can move entries in the
list using keys, cut, copy, paste, load, save groups or single entries in the list
and pressing a key or klicking a gadget you can immediately see the designed window.

Resizeable and Font Sensitiv

The automatic layout engine of StormWIZARD places and resizes every
part of a window or requester (if you want). You can choose every
font you want - it will be no problem for StormWIZARD to handle it.


Boopsi Classes

StormWIZARD is built on Boopsi classes, the prefered technology for
programming the GUI of the Amiga. You will be compatible to future
AmigaOS releases and Storm Wizard Editor show custom classes correct.


Automatic Localistation

StormWIZARD will build a Local cataloge for you every time you are
saving your GUI. So it is no problem for you to do the translate
of your program.


For any Programming Language

StormWIZARD does not generate source code because this is not the
best way to do it. There will be a file that you can use with your
programming language and a library that handles all the actions.
Its also possible to include this file static if you want.


NEW FEATURES (in compare to Aminet Demo Version)

+ use frameiclass on default for system look on modern systems.
  there is a autodetect that use the best mode your OS frameiclass support.
  But you can overwrite this by set the env var wizardstyle to one of this values.
  intern -> the old look
  system -> framiclass that support no FRAME_PROPKNOB and FRAME_PROPBORDER (need for MOS and AOS)
  system2 -> framiclass that support no FRAME_WINDOW = 30 / FRAME_REQUESTER = 31 /FRAME_PAGE 32/ FRAME_GROUP 33 (need for OS4)
  system3 -> the full mode that support window patterns, (AFA )

+ Some usefull groups in library/gadgets add that you can add with menu Edit Insert.
   slider+text+value: add a horiz group that contain a label, a slider, and a linked number gad.
   listview: Add a group that contain a Listview with linked scroller and arrows.
   2string+lefttext+flebutton: add 2 stringgadgets with diffrent length text and a filebutton

+  More examples .wizard file.
   ped.wizard. The amiblitz GUI
   synthi.wizard. a software Synthesizer GUI with Tabs

+ new example for GCC make

For more examples you can load arteffect.wizard in if you have Arteffect.
Here you can see 3 custom classes in Brush_Settings_win

Or try this example
http://aminet.net/package/biz/haage/StormWizard_EG

SPECIAL REQUIREMENTS

- Amiga 68k (and compatible) with at least 68020 CPU.
- AmigaOS 3.1 or higher required
- 2 MB RAM

