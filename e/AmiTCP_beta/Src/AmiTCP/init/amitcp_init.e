OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/init/autoinit',
       'amitcp/init/dosio_init',
       'amitcp/init/init_usergroup',
       'amitcp/init/timerinit',
       'amitcp/arpa/ftp',
       'amitcp/arpa/telnet',
       'amitcp/protocols/routed',
       'amitcp/protocols/timed',
       'amitcp/sys/syslog'

PROC amitcp_init()
  openSockets()
  dosio_init()
  openUserGroup()
  openTimer()
  ftp_init_names()
  telnet_init_names()
  routed_init_names()
  timed_init_names()
  syslog_init_names()
ENDPROC

PROC amitcp_cleanup()
  closeTimer()
  closeUserGroup()
  closeSockets()
ENDPROC
