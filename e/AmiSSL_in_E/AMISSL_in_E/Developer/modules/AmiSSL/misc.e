-> NOREV
OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE  'amissl'
MODULE  'utility/tagitem'

-> openssl/ssl.h
#define SsLv23_client_method    TlS_client_method
CONST SSL_VERIFY_NONE                 = $00
CONST SSL_VERIFY_PEER                 = $01
CONST SSL_VERIFY_FAIL_IF_NO_PEER_CERT = $02
CONST SSL_VERIFY_CLIENT_ONCE          = $04
/* More backward compatibility */
#define SsL_get_cipher(s) SsL_CIPHER_get_name(SsL_get_current_cipher(s))
#define SsL_get_cipher_bits(s,np) SsL_CIPHER_get_bits(SsL_get_current_cipher(s),np)
#define SsL_get_cipher_version(s) SsL_CIPHER_get_version(SsL_get_current_cipher(s))
#define SsL_get_cipher_name(s) SsL_CIPHER_get_name(SsL_get_current_cipher(s))

-> openssl/opensslconf.h
#define OPENSSL_FILE ''
#define OPENSSL_LINE 0

-> openssl/crypto.h
#define OpENSSL_free(addr) CrYPTO_free(addr, OPENSSL_FILE, OPENSSL_LINE)

PROC ssL_library_init() IS OpENSSL_init_ssl([0,0]:LONG, NIL)
PROC ssLeay_add_ssl_algorithms() IS ssL_library_init()

-> openssl/crypto.h
CONST OPENSSL_INIT_LOAD_CRYPTO_STRINGS = $00000002

-> openssl/ssl.h
CONST OPENSSL_INIT_LOAD_SSL_STRINGS    = $00200000

PROC ssL_load_error_strings() IS OpENSSL_init_ssl(OPENSSL_INIT_LOAD_SSL_STRINGS OR OPENSSL_INIT_LOAD_CRYPTO_STRINGS, NIL)
