/* poly.c */
void recti(long x1,long y1,long x2,long y2);
void rectfi(long x1,long y1,long x2,long y2);
void rects(short x1,short y1,short x2,short y2);
void rectfs(short x1,short y1,short x2,short y2);
void rect(float x1,float y1,float x2,float y2);
void rectf(float x1,float y1,float x2,float y2);
void rectvert(float x1,float y1,float x2,float y2,long line);
void bgnpoint(void);
void endpoint(void);
void bgnline(void);
void endline(void);
void bgnpolygon(void);
void endpolygon(void);
void render_vertex(short vert[2]);
void mapcolor(long m,long r,long g,long b);
void getmcolor(long m,long *r,long *g,long *b);
void color(long c);
long getcolor(void);
void clear(void);

