OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'exec/tasks'

#define uid_t LONG

#define gid_t LONG

OBJECT _tc OF tc
ENDOBJECT

#define pid_t PTR TO _tc

#define mode_t INT

#define time_t LONG
