
OPT MODULE
OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

MODULE 'intuition/intuition'

EXPORT OBJECT ticker OF plugin
ENDOBJECT

PROC min_size(ta,fh) OF ticker IS 0,0

PROC will_resize() OF ticker IS FALSE

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF ticker IS EMPTY

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF ticker
ENDPROC imsg.class=IDCMP_INTUITICKS

PROC message_action(class,qual,code,win) OF ticker IS TRUE
