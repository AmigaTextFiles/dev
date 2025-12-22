#ifndef __SYSV_H__
#define __SYSV_H__

LONG sysv_add(LONG x, LONG y);
LONG sysv_sub(LONG x, LONG y);
LONG sysv_mul(LONG x, LONG y);
LONG sysv_div(LONG x, LONG y);
VOID sysv_output1(struct MyLibrary *LibBase, LONG x, LONG y);
VOID sysv_output2(LONG x, LONG y, struct MyLibrary *LibBase);

#endif /* __SYSV_H__ */