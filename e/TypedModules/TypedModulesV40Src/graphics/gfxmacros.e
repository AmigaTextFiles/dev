OPT MODULE
OPT EXPORT

OPT PREPROCESS

#define ON_DISPLAY      custom.dmacon:=BITSET OR DMAF_RASTER;
#define OFF_DISPLAY     custom.dmacon:=BITCLR OR DMAF_RASTER;
#define ON_SPRITE       custom.dmacon:=BITSET OR DMAF_SPRITE;
#define OFF_SPRITE      custom.dmacon:=BITCLR OR DMAF_SPRITE;

#define ON_VBLANK       custom.intena:=BITSET OR INTF_VERTB;
#define OFF_VBLANK      custom.intena:=BITCLR OR INTF_VERTB;

#define SetDrPt(w,p)    w.lineptrn:=p; w.flags:=w.flags OR FRST_DOT; w.linpatcnt:=15;
#define SetAfPt(w,p,n)  w.areaptrn:=p; w.areaptsz:=n;

#define SetOPen(w,c)    w.aolpen:=c; w.flags:=w.flags OR AREAOUTLINE;
#define SetWrMsk(w,m)   w.mask:=m;

#define GetOutlinePen(rp) GetOPen(rp)

#define BNDRYOFF(w)     w.flags:=w.flags AND Not(AREAOUTLINE);

#define CINIT(c,n)      UCopperListInit(c,n);
#define CMOVE(c,a,b)    CMove(c,{a},b); CBump(c);
#define CWAIT(c,a,b)    CWait(c,a,b); CBump(c);
#define CEND(c)         CWAIT(c,10000,255);

#define DrawCircle(rp,cx,cy,r)  DrawEllipse(rp,cx,cy,r,r);
#define AreaCircle(rp,cx,cy,r)  AreaEllipse(rp,cx,cy,r,r);
