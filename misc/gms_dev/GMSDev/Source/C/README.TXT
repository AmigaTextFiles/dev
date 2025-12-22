
Each C compiler requires a special set up or command line to compile the
demos.  Here are the details on the most popular compilers:


SAS/C

  Each directory has a SCOPTIONS file that contains the necessary
  parameters.  To compile a demo, just go to its directory and run:

   1> SC [file.c]

Dice C

  This is like SAS/C, only the command line is a bit longer:

  1> dcc -l0 -mD dpk.o tags.o [file.c] -o [executable]

  You will need to copy the dpk.o and tags.o files to the DLIB: directory
  (you can find these files in GMSDev:Includes/lib/).

Storm C

  There is a StormC project in the Blitter/ source directory.  You can use
  it to compile the PixelList demo, and the template can be applied to the
  other demos.

VBCC

  In order to get this compiler to work, it requires conversion of the .fd
  files to its inline file format.  Or alternatively the fd2lib program
  can be used to create a special gms.lib file.  I have not tried to do
  either yet, I am too busy to do this.  If anyone out there does the
  necessary work, please send me the resulting files so that I can include
  them in future releases.

