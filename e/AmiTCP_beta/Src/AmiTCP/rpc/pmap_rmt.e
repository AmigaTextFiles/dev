OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/sys/types',
       'amitcp/rpc/xdr'

OBJECT rmtcallargs
  prog, vers, proc, arglen
  args_ptr:caddr_t
  xdr_args:xdrproc_t
ENDOBJECT

OBJECT rmtcallres
  port_ptr:PTR TO LONG
  resultslen
  results_ptr:caddr_t
  xdr_results:xdrproc_t
ENDOBJECT
