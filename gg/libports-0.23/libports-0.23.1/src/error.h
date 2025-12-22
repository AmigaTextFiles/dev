#include "common.h"

char *porterror(int err);

#define ERR_SOCKET	"unable to create initial socket"
#define ERR_SETOPT	"unable to set listening options"
#define ERR_BIND	"unable to bind socket"
#define ERR_LISTEN	"unable to open socket for listening"
#define ERR_UNKNOWN	"unforseen error"
#define ERR_DNSFAIL	"unable to resolve hostname"
#define ERR_CONNECT	"unable to connect"
#define ERR_SELECT	"select failed"
#define ERR_CONNEND	"connection closed by foriegn host"
#define ERR_NOSOCKET	"listening socket was closed"
