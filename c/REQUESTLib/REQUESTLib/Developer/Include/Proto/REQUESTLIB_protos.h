BOOL	set_text (char *dest, char *src);		/* set_text.c	*/
int	rtEZReq (char *titel, char *body, char *buttontext, int defreturn, BOOL centertext, BOOL noreturnkey, int position, int topoffset, int leftoffset, char *pubscreen);		/* rtEZReq.c	*/
int	rtFileReq (char *title, char *drawer, char *set_file, char *pattern, BOOL nobuf, BOOL mu_sel, BOOL sel_dirs, BOOL save, BOOL nofiles, BOOL patgad, int height, char *oktext, BOOL volreq, BOOL noass, BOOL nodisks, BOOL all, BOOL empty, int position, int top, int left, char *to_file, char *pubscreen);		/* rtFileReq.c	*/
