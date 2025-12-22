OPT MODULE, EXPORT, PREPROCESS

#define MANDARGS fx:REAL,fy:REAL,fxc:REAL,fyc:REAL,tresh:REAL,iters:LONG,ret:PTR TO mandret

#define FloatMin(x,y) (IF ! (x) < (y) THEN x ELSE y)
#define FloatMax(x,y) (IF ! (x) > (y) THEN x ELSE y)


#define GETTRESH !fx*fx+(!fy*fy) * tresh
