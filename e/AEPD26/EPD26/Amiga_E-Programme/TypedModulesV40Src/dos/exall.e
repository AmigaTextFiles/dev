OPT MODULE
OPT EXPORT

MODULE 'exec/libraries',
       'graphics/view',
       'intuition/intuition',
       'intuition/screens'

CONST DMODECOUNT=2,
      HIRESPICK=0,
      LOWRESPICK=1,
      EVENTMAX=10,
      RESCOUNT=2,
      HIRESGADGET=0,
      LOWRESGADGET=1,
      GADGETCOUNT=8,
      UPFRONTGADGET=0,
      DOWNBACKGADGET=1,
      SIZEGADGET=2,
      CLOSEGADGET=3,
      DRAGGADGET=4,
      SUPFRONTGADGET=5,
      SDOWNBACKGADGET=6,
      SDRAGGADGET=7

OBJECT intuitionbase
  libnode:lib
  viewlord:view
  activewindow:PTR TO window
  activescreen:PT