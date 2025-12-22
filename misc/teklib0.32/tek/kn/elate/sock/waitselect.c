
#include "tek/kn/elate/sock.h"

int kn_waitselect(kn_sockenv_t *sockenv, int n, fd_set *r, fd_set *w, fd_set *e, struct timeval *t, TKNOB *evt, TBOOL *signal)
{ 
	int numready = select(n, r, w, e, t);
	*signal = kn_timedwaitevent(evt, TNULL, TNULL);
	return numready;
}
