/* que.c */
void qinit(void);
void tie(long dev,long valuator1,long valuator2);
void qdevice(long dev);
void unqdevice(long dev);
long isqueued(long dev);
void qenter(long dev,short val);
long qtest(void);
void delay(void);
long qread(short *data);
void qreset(void);
long getvaluator(long val);
long getbutton(long num);
void clear_buttons(long init);
void update_queue(short waitid);
void qenter_tie(long device,short data);
void quekeys(USHORT code,short inside);
short is_inside(long wid,short x,short y,short border);
short border_edge(long wid,short x,short y);
void border_action(long wid,short ox,short oy,short middle);
void do_move_and_resize(long wid,long movefirst,long movex,long movey,long sizex,long sizey);
void move_and_resize(long wid,long movefirst,long movex,long movey,long sizex,long sizey);
void clear_void(long wid,short x,short y);

