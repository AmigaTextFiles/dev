/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_psnprintf()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  static UBYTE btext[] = {3, 'A', 'b', 'c'};
  static UBYTE mtext[] = {'d', 'e', 'f'};
  static UBYTE *ntext = "xyZ";
  static UBYTE buf[1024];
  LONG res;


  res = txt_psnprintf(buf, sizeof(buf),
                          "BINARY (u32): %032lB\n"
                          "BINARY (u64): %064qB\n"
                          "BSTR        : %b\n"
                          "BSTR Pad    : %8b\n"
                          "BSTR U      : %+b\n"
                          "BSTR L      : %-b\n"
                          "BSTR  (NULL): %Nb\n"
                          "MEM         : %M%m\n"
                          "MEM  Pad    : %M%8m\n"
                          "MEM  U      : %M%+m\n"
                          "MEM  L      : %M%-m\n"
                          "MEM   (NULL): %M%Nm\n"
                          "CHAR        : %c\n"
                          "DEC    (s32): %ld\n"
                          "DEC    (s64): %qd\n"
                          "DEC    (u32): %lu\n"
                          "DEC    (u64): %qu\n"
                          "OCTAL  (u32): %lo\n"
                          "OCTAL  (u64): %qo\n"
                          "TEXT        : %s\n"
                          "TEXT Pad    : %8s\n"
                          "TEXT U      : %+s\n"
                          "TEXT L      : %-s\n"
                          "TEXT  (NULL): %Ns\n"
                          "HEX  L (u32): %08lx\n"
                          "HEX  L (u64): %016qx\n"
                          "HEX  U (u32): %08lX\n"
                          "HEX  U (u64): %016llX\n"
                          "BITS        : %tld\n",
                                         35007,
                      (QUAD)350000000000000007,
                       QDEV_HLP_MKBADDR(btext),
                       QDEV_HLP_MKBADDR(btext),
                       QDEV_HLP_MKBADDR(btext),
                       QDEV_HLP_MKBADDR(btext),
                        QDEV_HLP_MKBADDR(NULL),
                          sizeof(mtext), mtext,
                          sizeof(mtext), mtext,
                          sizeof(mtext), mtext,
                          sizeof(mtext), mtext,
                                       0, NULL,
                                           '!',
                                   -1234567890,
                    (QUAD)-1234567890123456789,
                                     987654321,
                      (QUAD)987654321098765432,
                                     666999666,
                         (QUAD)666999666999666,
                                         ntext,
                                         ntext,
                                         ntext,
                                         ntext,
                                          NULL,
                                    0xFFAADDEE,
                      (QUAD)0xCC0000FFCC0000FF,
                                    0xFFAADDEE,
                      (QUAD)0xCC0000FFCC0000FF,
                                        32767);

  FPrintf(Output(),
              "%s\nres = %ld\n", (LONG)buf, res);

  return 0;
}
