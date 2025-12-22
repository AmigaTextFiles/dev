-> NOREV
OPT MODULE
OPT EXPORT

CONST AMISSL_V2           = $01  /* OBSOLETE NAME */
CONST AMISSL_V096g        = $01  /* AmiSSL v2 */
CONST AMISSL_V097g        = $02  /* AmiSSL v3.6/3.7 */
CONST AMISSL_V097m        = $03  /* unreleased version */
CONST AMISSL_V098y        = $04  /* unreleased version */
CONST AMISSL_V102f        = $05  /* unreleased version */
CONST AMISSL_V110c        = $06  /* unreleased version */
CONST AMISSL_V110d        = $07  /* AmiSSL v4.0 */
CONST AMISSL_V110e        = $08  /* AmiSSL v4.1 */
CONST AMISSL_V110g        = $09  /* AmiSSL v4.2 */
CONST AMISSL_V111a_OBS    = $0a  /* AmiSSL v4.3 (obsolete incompatible API) */
CONST AMISSL_V111d        = $0b  /* AmiSSL v4.4 */

CONST AMISSL_V10x         = AMISSL_V102f /* Latest AmiSSL/OpenSSL 1.0.x compatible version */
CONST AMISSL_V11x         = AMISSL_V111d /* Latest AmiSSL/OpenSSL 1.1.x compatible version */

CONST AMISSL_CURRENT_VERSION   = AMISSL_V11x

CONST AMISSLMASTER_MIN_VERSION = 4
