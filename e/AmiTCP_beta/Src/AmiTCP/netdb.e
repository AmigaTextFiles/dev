OPT MODULE, PREPROCESS
OPT EXPORT

#define _PATH_DB            'AmiTCP:db'
#define _PATH_AMITCP_CONFIG 'AmiTCP:db/AmiTCP.config'
#define	_PATH_HEQUIV        'AmiTCP:db/hosts.equiv'
#define	_PATH_INETDCONF     'AmiTCP:db/inetd.conf'

OBJECT hostent
  name:PTR TO CHAR
  aliases:PTR TO LONG
  addrtype
  length
  addr_list:PTR TO LONG
ENDOBJECT

OBJECT netent
  name:PTR TO CHAR
  aliases:PTR TO LONG
  addrtype
  net
ENDOBJECT

OBJECT servent
  name:PTR TO CHAR
  aliases:PTR TO LONG
  port
  proto:PTR TO CHAR
ENDOBJECT

OBJECT protoent
  name:PTR TO CHAR
  aliases:PTR TO LONG
  proto
ENDOBJECT

ENUM HOST_NOT_FOUND=1, TRY_AGAIN, NO_RECOVERY, NO_DATA
CONST NO_ADDRESS=NO_DATA
