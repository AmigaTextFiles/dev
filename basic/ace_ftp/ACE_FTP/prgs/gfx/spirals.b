{  Here's a little program I whipped up today to see if I could
remember enough math to write a utility for POVRay.  In this
incarnation it accepts various parameters for a spiral consisting
of circles, which is drawn in a window on the workbench.
  The POVRay utility will actually produce a .inc file containing
a union of spheres in a spiral shape.  Those of you who have
played with POVRay will know what that means.  Hopefully this
will make those of you who haven't seen POVRay curious enough to
go out and look at it.  You can find a complete Amiga archive
for POVRay at ftp.povray.org in the pub/povray/official/amiga
directory (I think).
  Some things to know first.  As I run workbench on a 800x600
screen, this program opens a 600x600 window.  If your workbench
is smaller, you should adjust the xwin and ywin variables
accordingly.  Also, because the default aspect ratio is .44,
and my workbench screen has an aspect ratio of 1:1, I added
the variable 'ar', which is derived from the xwin and ywin
variables.  This means you either should choose a window size
that is congruent with your workbench size, or hard-code 'ar'
to your workbench's aspect ratio.

  Some good values to try are:    Simple      Starfish
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Number of circles per spiral  :    50           5.01
Starting spiral radius        :  (A bit less than yoff)
Ending spiral radius          :     1             1
Number of spirals             :     5            20
Starting circle radius        :    15            10
Ending circle radius          :     1            10

  Well, there it is.  I'll post the final utility when it's
finished.  If any of you have other utilites you've written
or collected for POVRay, let's talk!

Rich Allen
rico@wsnet.com }

'Spiral.b - An experiment in spirals
'  by Rich Allen

CONST xwin = 640
CONST ywin = 480
CONST rad = 0.017453292

ar=ABS(xwin/ywin)

xoff = xwin/2     'Offset values (middle of spiral is at
yoff = ywin/2     '0,0 in x/y space)

window 1,,(0,0)-(xwin,ywin)

on break goto quit
break on

while -1
   locate 1
   input "Number of circles per spiral (0 to quit)";dots
    if dots = 0 then quit
   input "Starting spiral radius";rstart
   input "Ending spiral radius";rstop
   input "Number of spirals";loops
   input "Starting circle radius";cirstart
   input "Ending circle radius";cirstop

   tdegs = 360*loops
   dstep = 360/dots
   rstep = (rstart-rstop)/(tdegs/dstep)
   cstep = (cstart-cstop)/(tdegs/dstep)
   r = rstart
   c = cirstart

   cls
   for deg = 1 to tdegs step dstep
      x = r*cos(deg*rad)+xoff
      y = r*sin(deg*rad)+yoff
      circle (x,y),c,1,0,359,ar
      r = r - rstep
   next

wend

quit:
   window close 1
   end
