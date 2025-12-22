OPT MODULE

MODULE 'tools/EasyGUI',
       'intuition/intuition'

EXPORT OBJECT ticker OF plugin
ENDOBJECT

PROC min_size(ta,fh) OF ticker IS 0,0

PROC will_resize() OF ticker IS FALSE

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF ticker IS EMPTY

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF ticker
ENDPROC imsg.class=IDCMP_INTUITICKS

PROC message_action(class,qual,code,win) OF ticker IS TRUE
