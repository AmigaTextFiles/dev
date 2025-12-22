OPT LINK='*boopsi.o'

MODULE 'intuition/classes',
       'intuition/classusr',
       'utility/hooks'

#define DoMethodA(o, m) CoerceMethodA(o::_Object[-1].Class.Dispatcher, o, m)
#define DoSuperMethodA(c, o, m) CoerceMethodA(c::IClass.Super.Dispatcher, o, m)
#define SetSuperAttrsA(c, o, m) CoerceMethodA(c::IClass.Super.Dispatcher, o, [OM_SET, m, NIL])

LIBRARY LINK
  CallHookA(h REG a0,o REG a2,m REG a1)='movem.l\ta2-a3,-(a7) \n\tmove.l\t(8,a0),a3\n\tjsr\t(a3) \n\tmovem.l\t(a7)+,a2-a3',
  CoerceMethodA(h,o,m),
  InstallHook(hook,func),
  DoMethod(o,m:LIST OF LONG)

