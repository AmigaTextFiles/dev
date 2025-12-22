OPT MODULE, PREPROCESS
OPT EXPORT

CONST MAX_MACHINE_NAME=255,
      MAX_PATH_LEN=1024,
      MAX_FILEID=32,
      IP_ADDR_TYPE=1

#define bp_machine_name_t PTR TO CHAR
#define bp_path_t PTR TO CHAR
#define bp_fileid_t PTR TO CHAR

OBJECT ip_addr_t
  net:CHAR
  host:CHAR
  lh:CHAR
  impno:CHAR
ENDOBJECT

OBJECT bp_address
  address_type
  ip_addr:ip_addr_t
ENDOBJECT

OBJECT bp_whoami_arg
  client_address:bp_address
ENDOBJECT

OBJECT bp_whoami_res
  client_name:bp_machine_name_t
  domain_name:bp_machine_name_t
  router_address:bp_address
ENDOBJECT

OBJECT bp_getfile_arg
  client_name:bp_machine_name_t
  file_id:bp_fileid_t
ENDOBJECT

OBJECT bp_getfile_res
  server_name:bp_machine_name_t
  server_address:bp_address
  server_path:bp_path_t
ENDOBJECT

CONST BOOTPARAMPROG=100026,
      BOOTPARAMVERS=1,
      BOOTPARAMPROC_WHOAMI=1,
      BOOTPARAMPROC_GETFILE=2
