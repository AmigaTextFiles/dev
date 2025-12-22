OPT MODULE
OPT EXPORT

MODULE 'amitcp/netinet/in',
       'bsdsocket'

PROC select(nfds, readfds, writefds, exeptfds, timeout)
ENDPROC WaitSelect(nfds, readfds, writefds, exeptfds, timeout, NIL)

PROC inet_ntoa(addr:PTR TO in_addr)
ENDPROC Inet_NtoA(addr.addr)

-> inet_makeaddr returns an in_addr (just an addr), so use Inet_MakeAddr

PROC inet_lnaof(addr:PTR TO in_addr)
ENDPROC Inet_LnaOf(addr.addr)

PROC inet_netof(addr:PTR TO in_addr)
ENDPROC Inet_NetOf(addr.addr)
