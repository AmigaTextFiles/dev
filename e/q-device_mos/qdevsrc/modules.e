OPT PREPROCESS
OPT MODULE
OPT EXPORT

-> automatcally activate CODE_AMIGAOS if compiled with EC/CreativE
#ifndef ECX_VERSION
#define CODE_AMIGAOS
#endif

#ifdef CODE_MORPHOS
#define m_muicustomclass 'muiabox/muicustomclass'
#define m_installhook 'toolsabox/installhook'
#define m_boopsi 'aboxlib/boopsi'
#define m_lists 'aboxlib/lists'
#define m_time 'aboxlib/time'
#define m_tasks 'aboxlib/tasks'
#define m_random 'aboxlib/random'
#define m_ports 'aboxlib/ports'
#define m_io 'aboxlib/io'
#define m_cx 'aboxlib/cx'
#define m_argarray 'aboxlib/argarray'
#endif

#ifdef CODE_AMIGAOS
#define m_muicustomclass 'mui/muicustomclass'
#define m_installhook 'tools/installhook'
#define m_boopsi 'amigalib/boopsi'
#define m_lists 'amigalib/lists'
#define m_time 'amigalib/time'
#define m_tasks 'amigalib/tasks'
#define m_random 'amigalib/random'
#define m_ports 'amigalib/ports'
#define m_io 'amigalib/io'
#define m_cx 'amigalib/cx'
#define m_argarray 'amigalib/argarray'
#endif



