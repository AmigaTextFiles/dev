/* PortablE callback kludge for C++ */
OPT NATIVE, INLINE

PROC call0empty(func:PTR) IS NATIVE {((void (*)(void))(} func {))()} ENDNATIVE
PROC call0     (func:PTR) IS NATIVE {((long (*)(void))(} func {))()} ENDNATIVE !!VALUE
PROC call0many (func:PTR) IS NATIVE {((long (*)(void))(} func {))()} ENDNATIVE !!VALUE, ret2, ret3, ret4, ret5
PROC call1empty(func:PTR, p1) IS NATIVE {((void (*)(long))(} func {))(} p1 {)} ENDNATIVE
PROC call1     (func:PTR, p1) IS NATIVE {((long (*)(long))(} func {))(} p1 {)} ENDNATIVE !!VALUE
PROC call1many (func:PTR, p1) IS NATIVE {((long (*)(long))(} func {))(} p1 {)} ENDNATIVE !!VALUE, ret2, ret3, ret4, ret5
PROC call2empty(func:PTR, p1, p2) IS NATIVE {((void (*)(long,long))(} func {))(} p1 {,} p2 {)} ENDNATIVE
PROC call2     (func:PTR, p1, p2) IS NATIVE {((long (*)(long,long))(} func {))(} p1 {,} p2 {)} ENDNATIVE !!VALUE
PROC call2many (func:PTR, p1, p2) IS NATIVE {((long (*)(long,long))(} func {))(} p1 {,} p2 {)} ENDNATIVE !!VALUE, ret2, ret3, ret4, ret5
PROC call3empty(func:PTR, p1, p2, p3) IS NATIVE {((void (*)(long,long,long))(} func {))(} p1 {,} p2 {,} p3 {)} ENDNATIVE
PROC call3     (func:PTR, p1, p2, p3) IS NATIVE {((long (*)(long,long,long))(} func {))(} p1 {,} p2 {,} p3 {)} ENDNATIVE !!VALUE
PROC call3many (func:PTR, p1, p2, p3) IS NATIVE {((long (*)(long,long,long))(} func {))(} p1 {,} p2 {,} p3 {)} ENDNATIVE !!VALUE, ret2, ret3, ret4, ret5
PROC call4empty(func:PTR, p1, p2, p3, p4) IS NATIVE {((void (*)(long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {)} ENDNATIVE
PROC call4     (func:PTR, p1, p2, p3, p4) IS NATIVE {((long (*)(long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {)} ENDNATIVE !!VALUE
PROC call4many (func:PTR, p1, p2, p3, p4) IS NATIVE {((long (*)(long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {)} ENDNATIVE !!VALUE, ret2, ret3, ret4, ret5
PROC call5empty(func:PTR, p1, p2, p3, p4, p5) IS NATIVE {((void (*)(long,long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {,} p5 {)} ENDNATIVE
PROC call5     (func:PTR, p1, p2, p3, p4, p5) IS NATIVE {((long (*)(long,long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {,} p5 {)} ENDNATIVE !!VALUE
PROC call5many (func:PTR, p1, p2, p3, p4, p5) IS NATIVE {((long (*)(long,long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {,} p5 {)} ENDNATIVE !!VALUE, ret2, ret3, ret4, ret5
PROC call6empty(func:PTR, p1, p2, p3, p4, p5, p6) IS NATIVE {((void (*)(long,long,long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {,} p5 {,} p6 {)} ENDNATIVE
PROC call6     (func:PTR, p1, p2, p3, p4, p5, p6) IS NATIVE {((long (*)(long,long,long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {,} p5 {,} p6 {)} ENDNATIVE !!VALUE
PROC call6many (func:PTR, p1, p2, p3, p4, p5, p6) IS NATIVE {((long (*)(long,long,long,long,long,long))(} func {))(} p1 {,} p2 {,} p3 {,} p4 {,} p5 {,} p6 {)} ENDNATIVE !!VALUE, ret2, ret3, ret4, ret5

