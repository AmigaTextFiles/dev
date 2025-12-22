/* $Id: errors.h,v 1.12 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
{#include <rexx/errors.h>}
NATIVE {REXX_ERRORS_H} CONST

NATIVE {ERRC_MSG}  CONST ERRC_MSG  = 0             /* error code offset */
NATIVE {ERR10_001} CONST ERR10_001 = (ERRC_MSG+1)  /* program not found */
NATIVE {ERR10_002} CONST ERR10_002 = (ERRC_MSG+2)  /* execution halted */
NATIVE {ERR10_003} CONST ERR10_003 = (ERRC_MSG+3)  /* no memory available */
NATIVE {ERR10_004} CONST ERR10_004 = (ERRC_MSG+4)  /* invalid character in program */
NATIVE {ERR10_005} CONST ERR10_005 = (ERRC_MSG+5)  /* unmatched quote */
NATIVE {ERR10_006} CONST ERR10_006 = (ERRC_MSG+6)  /* unterminated comment */
NATIVE {ERR10_007} CONST ERR10_007 = (ERRC_MSG+7)  /* clause too long */
NATIVE {ERR10_008} CONST ERR10_008 = (ERRC_MSG+8)  /* unrecognized token */
NATIVE {ERR10_009} CONST ERR10_009 = (ERRC_MSG+9)  /* symbol or string too long */

NATIVE {ERR10_010} CONST ERR10_010 = (ERRC_MSG+10) /* invalid message packet */
NATIVE {ERR10_011} CONST ERR10_011 = (ERRC_MSG+11) /* command string error */
NATIVE {ERR10_012} CONST ERR10_012 = (ERRC_MSG+12) /* error return from function */
NATIVE {ERR10_013} CONST ERR10_013 = (ERRC_MSG+13) /* host environment not found */
NATIVE {ERR10_014} CONST ERR10_014 = (ERRC_MSG+14) /* required library not found */
NATIVE {ERR10_015} CONST ERR10_015 = (ERRC_MSG+15) /* function not found */
NATIVE {ERR10_016} CONST ERR10_016 = (ERRC_MSG+16) /* no return value */
NATIVE {ERR10_017} CONST ERR10_017 = (ERRC_MSG+17) /* wrong number of arguments */
NATIVE {ERR10_018} CONST ERR10_018 = (ERRC_MSG+18) /* invalid argument to function */
NATIVE {ERR10_019} CONST ERR10_019 = (ERRC_MSG+19) /* invalid PROCEDURE */

NATIVE {ERR10_020} CONST ERR10_020 = (ERRC_MSG+20) /* unexpected THEN/ELSE */
NATIVE {ERR10_021} CONST ERR10_021 = (ERRC_MSG+21) /* unexpected WHEN/OTHERWISE */
NATIVE {ERR10_022} CONST ERR10_022 = (ERRC_MSG+22) /* unexpected LEAVE or ITERATE */
NATIVE {ERR10_023} CONST ERR10_023 = (ERRC_MSG+23) /* invalid statement in SELECT */
NATIVE {ERR10_024} CONST ERR10_024 = (ERRC_MSG+24) /* missing THEN clauses */
NATIVE {ERR10_025} CONST ERR10_025 = (ERRC_MSG+25) /* missing OTHERWISE */
NATIVE {ERR10_026} CONST ERR10_026 = (ERRC_MSG+26) /* missing or unexpected END */
NATIVE {ERR10_027} CONST ERR10_027 = (ERRC_MSG+27) /* symbol mismatch on END */
NATIVE {ERR10_028} CONST ERR10_028 = (ERRC_MSG+28) /* invalid DO syntax */
NATIVE {ERR10_029} CONST ERR10_029 = (ERRC_MSG+29) /* incomplete DO/IF/SELECT */

NATIVE {ERR10_030} CONST ERR10_030 = (ERRC_MSG+30) /* label not found */
NATIVE {ERR10_031} CONST ERR10_031 = (ERRC_MSG+31) /* symbol expected */
NATIVE {ERR10_032} CONST ERR10_032 = (ERRC_MSG+32) /* string or symbol expected */
NATIVE {ERR10_033} CONST ERR10_033 = (ERRC_MSG+33) /* invalid sub-keyword */
NATIVE {ERR10_034} CONST ERR10_034 = (ERRC_MSG+34) /* required keyword missing */
NATIVE {ERR10_035} CONST ERR10_035 = (ERRC_MSG+35) /* extraneous characters */
NATIVE {ERR10_036} CONST ERR10_036 = (ERRC_MSG+36) /* sub-keyword conflict */
NATIVE {ERR10_037} CONST ERR10_037 = (ERRC_MSG+37) /* invalid template */
NATIVE {ERR10_038} CONST ERR10_038 = (ERRC_MSG+38) /* invalid TRACE request */
NATIVE {ERR10_039} CONST ERR10_039 = (ERRC_MSG+39) /* uninitialized variable */

NATIVE {ERR10_040} CONST ERR10_040 = (ERRC_MSG+40) /* invalid variable name */
NATIVE {ERR10_041} CONST ERR10_041 = (ERRC_MSG+41) /* invalid expression */
NATIVE {ERR10_042} CONST ERR10_042 = (ERRC_MSG+42) /* unbalanced parentheses */
NATIVE {ERR10_043} CONST ERR10_043 = (ERRC_MSG+43) /* nesting level exceeded */
NATIVE {ERR10_044} CONST ERR10_044 = (ERRC_MSG+44) /* invalid expression result */
NATIVE {ERR10_045} CONST ERR10_045 = (ERRC_MSG+45) /* expression required */
NATIVE {ERR10_046} CONST ERR10_046 = (ERRC_MSG+46) /* boolean value not 0 or 1 */
NATIVE {ERR10_047} CONST ERR10_047 = (ERRC_MSG+47) /* arithmetic conversion error */
NATIVE {ERR10_048} CONST ERR10_048 = (ERRC_MSG+48) /* invalid operand */

/*
 * Return Codes for general use
 */
NATIVE {RC_OK}     CONST RC_OK     = 0 /* success */
NATIVE {RC_WARN}   CONST RC_WARN   = 5 /* warning only */
NATIVE {RC_ERROR} CONST RC_ERROR = 10 /* something's wrong */
NATIVE {RC_FATAL} CONST RC_FATAL = 20 /* complete or severe failure */
