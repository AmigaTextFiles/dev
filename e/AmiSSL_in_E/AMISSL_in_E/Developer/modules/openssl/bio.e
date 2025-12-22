-> NOREV
OPT PREPROCESS
OPT MODULE
OPT EXPORT

MODULE  'amissl/amissl'

/*
 * Copyright 1995-2016 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the OpenSSL license (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */
/*
# include <openssl/crypto.h>

/* There are the classes of BIOs */
# define BIO_TYPE_DESCRIPTOR     = $0100 /* socket, fd, connect or accept */
# define BIO_TYPE_FILTER         = $0200
# define BIO_TYPE_SOURCE_SINK    = $0400

/* These are the 'types' of BIOs */
# define BIO_TYPE_NONE             0
# define BIO_TYPE_MEM            ( 1 OR BIO_TYPE_SOURCE_SINK)
# define BIO_TYPE_FILE           ( 2 OR BIO_TYPE_SOURCE_SINK)

# define BIO_TYPE_FD             ( 4 OR BIO_TYPE_SOURCE_SINK OR BIO_TYPE_DESCRIPTOR)
# define BIO_TYPE_SOCKET         ( 5 OR BIO_TYPE_SOURCE_SINK OR BIO_TYPE_DESCRIPTOR)
# define BIO_TYPE_NULL           ( 6 OR BIO_TYPE_SOURCE_SINK)
# define BIO_TYPE_SSL            ( 7 OR BIO_TYPE_FILTER)
# define BIO_TYPE_MD             ( 8 OR BIO_TYPE_FILTER)
# define BIO_TYPE_BUFFER         ( 9 OR BIO_TYPE_FILTER)
# define BIO_TYPE_CIPHER         (10 OR BIO_TYPE_FILTER)
# define BIO_TYPE_BASE64         (11 OR BIO_TYPE_FILTER)
# define BIO_TYPE_CONNECT        (12 OR BIO_TYPE_SOURCE_SINK OR BIO_TYPE_DESCRIPTOR)
# define BIO_TYPE_ACCEPT         (13 OR BIO_TYPE_SOURCE_SINK OR BIO_TYPE_DESCRIPTOR)

# define BIO_TYPE_NBIO_TEST      (16 OR BIO_TYPE_FILTER)/* server proxy BIO */
# define BIO_TYPE_NULL_FILTER    (17 OR BIO_TYPE_FILTER)
# define BIO_TYPE_BIO            (19 OR BIO_TYPE_SOURCE_SINK)/* half a BIO pair */
# define BIO_TYPE_LINEBUFFER     (20 OR BIO_TYPE_FILTER)
# define BIO_TYPE_DGRAM          (21 OR BIO_TYPE_SOURCE_SINK OR BIO_TYPE_DESCRIPTOR)
# define BIO_TYPE_ASN1           (22 OR BIO_TYPE_FILTER)
# define BIO_TYPE_COMP           (23 OR BIO_TYPE_FILTER)
# define BIO_TYPE_DGRAM_SCTP    (24 OR BIO_TYPE_SOURCE_SINK OR BIO_TYPE_DESCRIPTOR)

#define BIO_TYPE_START           128
*/
/*
 * BIO_FILENAME_READ OR BIO_CLOSE to open or close on free.
 * BIO_set_fp(in,stdin,BIO_NOCLOSE);
 */
CONST BIO_NOCLOSE             = $00
CONST BIO_CLOSE               = $01
/*
/*
 * These are used in the following macros and are passed to BIO_ctrl()
 */
CONST BIO_CTRL_RESET          1/* opt - rewind/zero etc */
CONST BIO_CTRL_EOF            2/* opt - are we at the eof */
CONST BIO_CTRL_INFO           3/* opt - extra tit-bits */
CONST BIO_CTRL_SET            4/* man - set the 'IO' type */
CONST BIO_CTRL_GET            5/* man - get the 'IO' type */
CONST BIO_CTRL_PUSH           6/* opt - internal, used to signify change */
CONST BIO_CTRL_POP            7/* opt - internal, used to signify change */
CONST BIO_CTRL_GET_CLOSE      8/* man - set the 'close' on free */
CONST BIO_CTRL_SET_CLOSE      9/* man - set the 'close' on free */
CONST BIO_CTRL_PENDING        10/* opt - is their more data buffered */
CONST BIO_CTRL_FLUSH          11/* opt - 'flush' buffered output */
CONST BIO_CTRL_DUP            12/* man - extra stuff for 'duped' BIO */
CONST BIO_CTRL_WPENDING       13/* opt - number of bytes still to write */
CONST BIO_CTRL_SET_CALLBACK   14/* opt - set callback function */
CONST BIO_CTRL_GET_CALLBACK   15/* opt - set callback function */

CONST BIO_CTRL_SET_FILENAME   30/* BIO_s_file special */

/* dgram BIO stuff */
CONST BIO_CTRL_DGRAM_CONNECT       31/* BIO dgram special */
CONST BIO_CTRL_DGRAM_SET_CONNECTED 32/* allow for an externally connected
                                         * socket to be passed in */
CONST BIO_CTRL_DGRAM_SET_RECV_TIMEOUT 33/* setsockopt, essentially */
CONST BIO_CTRL_DGRAM_GET_RECV_TIMEOUT 34/* getsockopt, essentially */
CONST BIO_CTRL_DGRAM_SET_SEND_TIMEOUT 35/* setsockopt, essentially */
CONST BIO_CTRL_DGRAM_GET_SEND_TIMEOUT 36/* getsockopt, essentially */

CONST BIO_CTRL_DGRAM_GET_RECV_TIMER_EXP 37/* flag whether the last */
CONST BIO_CTRL_DGRAM_GET_SEND_TIMER_EXP 38/* I/O operation tiemd out */

/* #ifdef IP_MTU_DISCOVER */
CONST BIO_CTRL_DGRAM_MTU_DISCOVER       39/* set DF bit on egress packets */
/* #endif */

CONST BIO_CTRL_DGRAM_QUERY_MTU          40/* as kernel for current MTU */
CONST BIO_CTRL_DGRAM_GET_FALLBACK_MTU   47
CONST BIO_CTRL_DGRAM_GET_MTU            41/* get cached value for MTU */
CONST BIO_CTRL_DGRAM_SET_MTU            42/* set cached value for MTU.
                                              * want to use this if asking
                                              * the kernel fails */

CONST BIO_CTRL_DGRAM_MTU_EXCEEDED       43/* check whether the MTU was
                                              * exceed in the previous write
                                              * operation */

CONST BIO_CTRL_DGRAM_GET_PEER           46
CONST BIO_CTRL_DGRAM_SET_PEER           44/* Destination for the data */

CONST BIO_CTRL_DGRAM_SET_NEXT_TIMEOUT   45/* Next DTLS handshake timeout
                                              * to adjust socket timeouts */
CONST BIO_CTRL_DGRAM_SET_DONT_FRAG      48

CONST BIO_CTRL_DGRAM_GET_MTU_OVERHEAD   49

/* Deliberately outside of OPENSSL_NO_SCTP - used in bss_dgram.c */
CONST BIO_CTRL_DGRAM_SCTP_SET_IN_HANDSHAKE    50
# ifndef OPENSSL_NO_SCTP
/* SCTP stuff */
CONST BIO_CTRL_DGRAM_SCTP_ADD_AUTH_KEY                51
CONST BIO_CTRL_DGRAM_SCTP_NEXT_AUTH_KEY               52
CONST BIO_CTRL_DGRAM_SCTP_AUTH_CCS_RCVD               53
CONST BIO_CTRL_DGRAM_SCTP_GET_SNDINFO         60
CONST BIO_CTRL_DGRAM_SCTP_SET_SNDINFO         61
CONST BIO_CTRL_DGRAM_SCTP_GET_RCVINFO         62
CONST BIO_CTRL_DGRAM_SCTP_SET_RCVINFO         63
CONST BIO_CTRL_DGRAM_SCTP_GET_PRINFO                  64
CONST BIO_CTRL_DGRAM_SCTP_SET_PRINFO                  65
CONST BIO_CTRL_DGRAM_SCTP_SAVE_SHUTDOWN               70
# endif

CONST BIO_CTRL_DGRAM_SET_PEEK_MODE      71
*/
/* modifiers */
CONST BIO_FP_READ             = $02
CONST BIO_FP_WRITE            = $04
CONST BIO_FP_APPEND           = $08
CONST BIO_FP_TEXT             = $10

CONST BIO_FLAGS_READ          = $01
CONST BIO_FLAGS_WRITE         = $02
CONST BIO_FLAGS_IO_SPECIAL    = $04
CONST BIO_FLAGS_RWS           = BIO_FLAGS_READ OR BIO_FLAGS_WRITE OR BIO_FLAGS_IO_SPECIAL
CONST BIO_FLAGS_SHOULD_RETRY  = $08

/*
 * "UPLINK" flag denotes file descriptors provided by application. It
 * defaults to 0, as most platforms don't require UPLINK interface.
 */
CONST BIO_FLAGS_UPLINK        = 0


CONST BIO_FLAGS_BASE64_NO_NL  = $100
/*
/*
 * This is used with memory BIOs:
 * BIO_FLAGS_MEM_RDONLY means we shouldn't free up or change the data in any way;
 * BIO_FLAGS_NONCLEAR_RST means we shouldn't clear data on reset.
 */
CONST BIO_FLAGS_MEM_RDONLY    = $200
CONST BIO_FLAGS_NONCLEAR_RST  = $400

typedef union bio_addr_st BIO_ADDR;
typedef struct bio_addrinfo_st BIO_ADDRINFO;

int BIO_get_new_index(void);
void BIO_set_flags(BIO *b, int flags);
int BIO_test_flags(const BIO *b, int flags);
void BIO_clear_flags(BIO *b, int flags);

CONST BIO_get_flags(b) BIO_test_flags(b, ~(= $0))
CONST BIO_set_retry_special(b) \
                BIO_set_flags(b, (BIO_FLAGS_IO_SPECIAL OR BIO_FLAGS_SHOULD_RETRY))
CONST BIO_set_retry_read(b) \
                BIO_set_flags(b, (BIO_FLAGS_READ OR BIO_FLAGS_SHOULD_RETRY))
CONST BIO_set_retry_write(b) \
                BIO_set_flags(b, (BIO_FLAGS_WRITE OR BIO_FLAGS_SHOULD_RETRY))

/* These are normally used internally in BIOs */
CONST BIO_clear_retry_flags(b) \
                BIO_clear_flags(b, (BIO_FLAGS_RWS OR BIO_FLAGS_SHOULD_RETRY))
CONST BIO_get_retry_flags(b) \
                BIO_test_flags(b, (BIO_FLAGS_RWS OR BIO_FLAGS_SHOULD_RETRY))

/* These should be used by the application to tell why we should retry */
CONST BIO_should_read(a)              BIO_test_flags(a, BIO_FLAGS_READ)
CONST BIO_should_write(a)             BIO_test_flags(a, BIO_FLAGS_WRITE)
CONST BIO_should_io_special(a)        BIO_test_flags(a, BIO_FLAGS_IO_SPECIAL)
CONST BIO_retry_type(a)               BIO_test_flags(a, BIO_FLAGS_RWS)
CONST BIO_should_retry(a)             BIO_test_flags(a, BIO_FLAGS_SHOULD_RETRY)

/*
 * The next three are used in conjunction with the BIO_should_io_special()
 * condition.  After this returns true, BIO *BIO_get_retry_BIO(BIO *bio, int
 * *reason); will walk the BIO stack and return the 'reason' for the special
 * and the offending BIO. Given a BIO, BIO_get_retry_reason(bio) will return
 * the code.
 */
/*
 * Returned from the SSL bio when the certificate retrieval code had an error
 */
CONST BIO_RR_SSL_X509_LOOKUP          = $01
/* Returned from the connect BIO when a connect would have blocked */
CONST BIO_RR_CONNECT                  = $02
/* Returned from the accept BIO when an accept would have blocked */
CONST BIO_RR_ACCEPT                   = $03

/* These are passed by the BIO callback */
CONST BIO_CB_FREE     = $01
CONST BIO_CB_READ     = $02
CONST BIO_CB_WRITE    = $03
CONST BIO_CB_PUTS     = $04
CONST BIO_CB_GETS     = $05
CONST BIO_CB_CTRL     = $06

/*
 * The callback is called before and after the underling operation, The
 * BIO_CB_RETURN flag indicates if it is after the call
 */
CONST BIO_CB_RETURN   = $80
CONST BIO_CB_return(a) ((a) OR BIO_CB_RETURN)
CONST BIO_cb_pre(a)   (!((a)&BIO_CB_RETURN))
CONST BIO_cb_post(a)  ((a)&BIO_CB_RETURN)

typedef long (*BIO_callback_fn)(BIO *b, int oper, const char *argp, int argi,
                                long argl, long ret);
BIO_callback_fn BIO_get_callback(const BIO *b);
void BIO_set_callback(BIO *b, BIO_callback_fn callback);
char *BIO_get_callback_arg(const BIO *b);
void BIO_set_callback_arg(BIO *b, char *arg);

typedef struct bio_method_st BIO_METHOD;

const char *BIO_method_name(const BIO *b);
int BIO_method_type(const BIO *b);

typedef void bio_info_cb(BIO *, int, const char *, int, long, long);

DEFINE_STACK_OF(BIO)

/* Prefix and suffix callback in ASN1 BIO */
typedef int asn1_ps_func (BIO *b, unsigned char **pbuf, int *plen,
                          void *parg);

# ifndef OPENSSL_NO_SCTP
/* SCTP parameter structs */
struct bio_dgram_sctp_sndinfo {
    uint16_t snd_sid;
    uint16_t snd_flags;
    uint32_t snd_ppid;
    uint32_t snd_context;
};

struct bio_dgram_sctp_rcvinfo {
    uint16_t rcv_sid;
    uint16_t rcv_ssn;
    uint16_t rcv_flags;
    uint32_t rcv_ppid;
    uint32_t rcv_tsn;
    uint32_t rcv_cumtsn;
    uint32_t rcv_context;
};

struct bio_dgram_sctp_prinfo {
    uint16_t pr_policy;
    uint32_t pr_value;
};
# endif
*/
/*
 * #define BIO_CONN_get_param_hostname BIO_ctrl
 */

CONST BIO_C_SET_CONNECT                      = 100
CONST BIO_C_DO_STATE_MACHINE                 = 101
CONST BIO_C_SET_NBIO                         = 102
/* CONST BIO_C_SET_PROXY_PARAM                   103 */
CONST BIO_C_SET_FD                           = 104
CONST BIO_C_GET_FD                           = 105
CONST BIO_C_SET_FILE_PTR                     = 106
CONST BIO_C_GET_FILE_PTR                     = 107
CONST BIO_C_SET_FILENAME                     = 108
CONST BIO_C_SET_SSL                          = 109
CONST BIO_C_GET_SSL                          = 110
CONST BIO_C_SET_MD                           = 111
CONST BIO_C_GET_MD                           = 112
CONST BIO_C_GET_CIPHER_STATUS                = 113
CONST BIO_C_SET_BUF_MEM                      = 114
CONST BIO_C_GET_BUF_MEM_PTR                  = 115
CONST BIO_C_GET_BUFF_NUM_LINES               = 116
CONST BIO_C_SET_BUFF_SIZE                    = 117
CONST BIO_C_SET_ACCEPT                       = 118
CONST BIO_C_SSL_MODE                         = 119
CONST BIO_C_GET_MD_CTX                       = 120
/* CONST BIO_C_GET_PROXY_PARAM                   121 */
CONST BIO_C_SET_BUFF_READ_DATA               = 122/* data to read first */
CONST BIO_C_GET_CONNECT                      = 123
CONST BIO_C_GET_ACCEPT                       = 124
CONST BIO_C_SET_SSL_RENEGOTIATE_BYTES        = 125
CONST BIO_C_GET_SSL_NUM_RENEGOTIATES         = 126
CONST BIO_C_SET_SSL_RENEGOTIATE_TIMEOUT      = 127
CONST BIO_C_FILE_SEEK                        = 128
CONST BIO_C_GET_CIPHER_CTX                   = 129
CONST BIO_C_SET_BUF_MEM_EOF_RETURN           = 130/* return end of input
                                                     * value */
CONST BIO_C_SET_BIND_MODE                    = 131
CONST BIO_C_GET_BIND_MODE                    = 132
CONST BIO_C_FILE_TELL                        = 133
CONST BIO_C_GET_SOCKS                        = 134
CONST BIO_C_SET_SOCKS                        = 135

CONST BIO_C_SET_WRITE_BUF_SIZE               = 136/* for BIO_s_bio */
CONST BIO_C_GET_WRITE_BUF_SIZE               = 137
CONST BIO_C_MAKE_BIO_PAIR                    = 138
CONST BIO_C_DESTROY_BIO_PAIR                 = 139
CONST BIO_C_GET_WRITE_GUARANTEE              = 140
CONST BIO_C_GET_READ_REQUEST                 = 141
CONST BIO_C_SHUTDOWN_WR                      = 142
CONST BIO_C_NREAD0                           = 143
CONST BIO_C_NREAD                            = 144
CONST BIO_C_NWRITE0                          = 145
CONST BIO_C_NWRITE                           = 146
CONST BIO_C_RESET_READ_REQUEST               = 147
CONST BIO_C_SET_MD_CTX                       = 148

CONST BIO_C_SET_PREFIX                       = 149
CONST BIO_C_GET_PREFIX                       = 150
CONST BIO_C_SET_SUFFIX                       = 151
CONST BIO_C_GET_SUFFIX                       = 152

CONST BIO_C_SET_EX_ARG                       = 153
CONST BIO_C_GET_EX_ARG                       = 154

CONST BIO_C_SET_CONNECT_MODE                 = 155

#define BIO_set_app_data(s,arg)         BIO_set_ex_data(s,0,arg)
#define BIO_get_app_data(s)             BIO_get_ex_data(s,0)

#define BIO_set_nbio(b,n)             BIO_ctrl(b,BIO_C_SET_NBIO,(n),NIL)
/*
# ifndef OPENSSL_NO_SOCK
/* IP families we support, for BIO_s_connect() and BIO_s_accept() */
/* Note: the underlying operating system may not support some of them */
CONST BIO_FAMILY_IPV4                         4
CONST BIO_FAMILY_IPV6                         6
CONST BIO_FAMILY_IPANY                        256

/* BIO_s_connect() */
CONST BIO_set_conn_hostname(b,name) BIO_ctrl(b,BIO_C_SET_CONNECT,0,(char *)name)
CONST BIO_set_conn_port(b,port)     BIO_ctrl(b,BIO_C_SET_CONNECT,1,(char *)port)
CONST BIO_set_conn_address(b,addr)  BIO_ctrl(b,BIO_C_SET_CONNECT,2,(char *)addr)
CONST BIO_set_conn_ip_family(b,f)   BIO_int_ctrl(b,BIO_C_SET_CONNECT,3,f)
CONST BIO_get_conn_hostname(b)      ((const char *)BIO_ptr_ctrl(b,BIO_C_GET_CONNECT,0))
CONST BIO_get_conn_port(b)          ((const char *)BIO_ptr_ctrl(b,BIO_C_GET_CONNECT,1))
CONST BIO_get_conn_address(b)       ((const BIO_ADDR *)BIO_ptr_ctrl(b,BIO_C_GET_CONNECT,2))
CONST BIO_get_conn_ip_family(b)     BIO_ctrl(b,BIO_C_GET_CONNECT,3,NIL)
CONST BIO_set_conn_mode(b,n)        BIO_ctrl(b,BIO_C_SET_CONNECT_MODE,(n),NIL)

/* BIO_s_accept() */
CONST BIO_set_accept_name(b,name)   BIO_ctrl(b,BIO_C_SET_ACCEPT,0,(char *)name)
CONST BIO_set_accept_port(b,port)   BIO_ctrl(b,BIO_C_SET_ACCEPT,1,(char *)port)
CONST BIO_get_accept_name(b)        ((const char *)BIO_ptr_ctrl(b,BIO_C_GET_ACCEPT,0))
CONST BIO_get_accept_port(b)        ((const char *)BIO_ptr_ctrl(b,BIO_C_GET_ACCEPT,1))
CONST BIO_get_peer_name(b)          ((const char *)BIO_ptr_ctrl(b,BIO_C_GET_ACCEPT,2))
CONST BIO_get_peer_port(b)          ((const char *)BIO_ptr_ctrl(b,BIO_C_GET_ACCEPT,3))
/* #define BIO_set_nbio(b,n)    BIO_ctrl(b,BIO_C_SET_NBIO,(n),NIL) */
CONST BIO_set_nbio_accept(b,n)      BIO_ctrl(b,BIO_C_SET_ACCEPT,2,(n)?(void *)"a":NIL)
CONST BIO_set_accept_bios(b,bio)    BIO_ctrl(b,BIO_C_SET_ACCEPT,3,(char *)bio)
CONST BIO_set_accept_ip_family(b,f) BIO_int_ctrl(b,BIO_C_SET_ACCEPT,4,f)
CONST BIO_get_accept_ip_family(b)   BIO_ctrl(b,BIO_C_GET_ACCEPT,4,NIL)

/* Aliases kept for backward compatibility */
CONST BIO_BIND_NORMAL                 = 0
CONST BIO_BIND_REUSEADDR              = BIO_SOCK_REUSEADDR
CONST BIO_BIND_REUSEADDR_IF_UNUSED    = BIO_SOCK_REUSEADDR
#define BIO_set_bind_mode(b,mode) BIO_ctrl(b,BIO_C_SET_BIND_MODE,mode,NIL)
#define BIO_get_bind_mode(b)    BIO_ctrl(b,BIO_C_GET_BIND_MODE,0,NIL)

/* BIO_s_accept() and BIO_s_connect() */
#define BIO_do_connect(b)       BIO_do_handshake(b)
#define BIO_do_accept(b)        BIO_do_handshake(b)
# endif /* OPENSSL_NO_SOCK */
*/
#define BiO_do_handshake(b)     BiO_ctrl(b,BIO_C_DO_STATE_MACHINE,0,NIL)

/* BIO_s_datagram(), BIO_s_fd(), BIO_s_socket(), BIO_s_accept() and BIO_s_connect() */
#define BiO_set_fd(b,fd,c)      BiO_int_ctrl(b,BIO_C_SET_FD,c,fd)
#define BiO_get_fd(b,c)         BiO_ctrl(b,BIO_C_GET_FD,0,c)

#define BiO_set_fp_amiga(b,fp,c) BiO_ctrl(b,BIO_C_SET_FILE_PTR,c,fp)
#define BiO_get_fp_amiga(b,fpp)  BiO_ctrl(b,BIO_C_GET_FILE_PTR,0,fpp)

/* BIO_s_fd() and BIO_s_file() */
#define BiO_seek(b,ofs) BiO_ctrl(b,BIO_C_FILE_SEEK,ofs,NIL)
#define BiO_tell(b)     BiO_ctrl(b,BIO_C_FILE_TELL,0,NIL)


/*
 * WARNING WARNING, this ups the reference count on the read bio of the SSL
 * structure.  This is because the ssl read BIO is now pointed to by the
 * next_bio field in the bio.  So when you free the BIO, make sure you are
 * doing a BIO_free_all() to catch the underlying BIO.
 */

CONST BIO_SOCK_REUSEADDR    = $01
CONST BIO_SOCK_V6_ONLY      = $02
CONST BIO_SOCK_KEEPALIVE    = $04
CONST BIO_SOCK_NONBLOCK     = $08
CONST BIO_SOCK_NODELAY      = $10


/* BEGIN ERROR CODES */
/*
 * The following lines are auto generated by the script mkerr.pl. Any changes
 * made after this point may be overwritten when the script is next run.
 */

/* Error codes for the BIO functions. */

/* Function codes. */
CONST BIO_F_ACPT_STATE                                = 100
CONST BIO_F_ADDR_STRINGS                              = 134
CONST BIO_F_BIO_ACCEPT                                = 101
CONST BIO_F_BIO_ACCEPT_EX                             = 137
CONST BIO_F_BIO_ADDR_NEW                              = 144
CONST BIO_F_BIO_CALLBACK_CTRL                         = 131
CONST BIO_F_BIO_CONNECT                               = 138
CONST BIO_F_BIO_CTRL                                  = 103
CONST BIO_F_BIO_GETS                                  = 104
CONST BIO_F_BIO_GET_HOST_IP                           = 106
CONST BIO_F_BIO_GET_NEW_INDEX                         = 102
CONST BIO_F_BIO_GET_PORT                              = 107
CONST BIO_F_BIO_LISTEN                                = 139
CONST BIO_F_BIO_LOOKUP                                = 135
CONST BIO_F_BIO_MAKE_PAIR                             = 121
CONST BIO_F_BIO_NEW                                   = 108
CONST BIO_F_BIO_NEW_FILE                              = 109
CONST BIO_F_BIO_NEW_MEM_BUF                           = 126
CONST BIO_F_BIO_NREAD                                 = 123
CONST BIO_F_BIO_NREAD0                                = 124
CONST BIO_F_BIO_NWRITE                                = 125
CONST BIO_F_BIO_NWRITE0                               = 122
CONST BIO_F_BIO_PARSE_HOSTSERV                        = 136
CONST BIO_F_BIO_PUTS                                  = 110
CONST BIO_F_BIO_READ                                  = 111
CONST BIO_F_BIO_SOCKET                                = 140
CONST BIO_F_BIO_SOCKET_NBIO                           = 142
CONST BIO_F_BIO_SOCK_INFO                             = 141
CONST BIO_F_BIO_SOCK_INIT                             = 112
CONST BIO_F_BIO_WRITE                                 = 113
CONST BIO_F_BUFFER_CTRL                               = 114
CONST BIO_F_CONN_CTRL                                 = 127
CONST BIO_F_CONN_STATE                                = 115
CONST BIO_F_DGRAM_SCTP_READ                           = 132
CONST BIO_F_DGRAM_SCTP_WRITE                          = 133
CONST BIO_F_FILE_CTRL                                 = 116
CONST BIO_F_FILE_READ                                 = 130
CONST BIO_F_LINEBUFFER_CTRL                           = 129
CONST BIO_F_MEM_WRITE                                 = 117
CONST BIO_F_SSL_NEW                                   = 118

/* Reason codes. */
CONST BIO_R_ACCEPT_ERROR                              = 100
CONST BIO_R_ADDRINFO_ADDR_IS_NOT_AF_INET              = 141
CONST BIO_R_AMBIGUOUS_HOST_OR_SERVICE                 = 129
CONST BIO_R_BAD_FOPEN_MODE                            = 101
CONST BIO_R_BROKEN_PIPE                               = 124
CONST BIO_R_CONNECT_ERROR                             = 103
CONST BIO_R_GETHOSTBYNAME_ADDR_IS_NOT_AF_INET         = 107
CONST BIO_R_GETSOCKNAME_ERROR                         = 132
CONST BIO_R_GETSOCKNAME_TRUNCATED_ADDRESS             = 133
CONST BIO_R_GETTING_SOCKTYPE                          = 134
CONST BIO_R_INVALID_ARGUMENT                          = 125
CONST BIO_R_INVALID_SOCKET                            = 135
CONST BIO_R_IN_USE                                    = 123
CONST BIO_R_LISTEN_V6_ONLY                            = 136
CONST BIO_R_LOOKUP_RETURNED_NOTHING                   = 142
CONST BIO_R_MALFORMED_HOST_OR_SERVICE                 = 130
CONST BIO_R_NBIO_CONNECT_ERROR                        = 110
CONST BIO_R_NO_ACCEPT_ADDR_OR_SERVICE_SPECIFIED       = 143
CONST BIO_R_NO_HOSTNAME_OR_SERVICE_SPECIFIED          = 144
CONST BIO_R_NO_PORT_DEFINED                           = 113
CONST BIO_R_NO_SUCH_FILE                              = 128
CONST BIO_R_NULL_PARAMETER                            = 115
CONST BIO_R_UNABLE_TO_BIND_SOCKET                     = 117
CONST BIO_R_UNABLE_TO_CREATE_SOCKET                   = 118
CONST BIO_R_UNABLE_TO_KEEPALIVE                       = 137
CONST BIO_R_UNABLE_TO_LISTEN_SOCKET                   = 119
CONST BIO_R_UNABLE_TO_NODELAY                         = 138
CONST BIO_R_UNABLE_TO_REUSEADDR                       = 139
CONST BIO_R_UNAVAILABLE_IP_FAMILY                     = 145
CONST BIO_R_UNINITIALIZED                             = 120
CONST BIO_R_UNKNOWN_INFO_TYPE                         = 140
CONST BIO_R_UNSUPPORTED_IP_FAMILY                     = 146
CONST BIO_R_UNSUPPORTED_METHOD                        = 121
CONST BIO_R_UNSUPPORTED_PROTOCOL_FAMILY               = 131
CONST BIO_R_WRITE_TO_READ_ONLY_BIO                    = 126
CONST BIO_R_WSASTARTUP                                = 122

