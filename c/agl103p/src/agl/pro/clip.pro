/* clip.c */
void scrmask(Screencoord left,Screencoord right,Screencoord bottom,Screencoord top);
void getscrmask(Screencoord *left,Screencoord *right,Screencoord *bottom,Screencoord *top);
void activate_clipping(long wid);
void deactivate_clipping(long wid);
void unclip_window(struct Window *window);
struct Region *clip_window(struct Window *window,long minx,long miny,long maxx,long maxy);

