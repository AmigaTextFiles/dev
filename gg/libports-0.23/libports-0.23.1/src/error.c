#include "error.h"

char *porterror(int err) {
	switch(err) {
		case -1: return ERR_SOCKET; break;
		case -2: return ERR_SETOPT; break;
		case -3: return ERR_BIND; break;
		case -4: return ERR_LISTEN; break;
		case -5: return ERR_DNSFAIL; break;
		case -6: return ERR_CONNECT; break;
		case -7: return ERR_SELECT; break;
		case -8: return ERR_CONNEND; break;
		case -9: return ERR_NOSOCKET; break;
		default: return ERR_UNKNOWN; break;
	}
}
