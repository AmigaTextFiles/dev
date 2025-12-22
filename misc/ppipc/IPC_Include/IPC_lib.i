* PPIPC Shared Library Vector Definitions
* -- version 2.2 --
*   Pete Goodeve 1989 April 18

 IFND IPC_LIB_I
IPC_LIB_I   SET 1

    INCLUDE 'exec/types.i'
    INCLUDE 'exec/libraries.i'

LVODEF  MACRO   * FunctionName
            LIBDEF _LVO\1
        ENDM

*******************************

        LIBINIT
        LVODEF  FindIPCPort
        LVODEF  GetIPCPort
        LVODEF  UseIPCPort
        LVODEF  DropIPCPort
        LVODEF  ServeIPCPort
        LVODEF  ShutIPCPort
        LVODEF  LeaveIPCPort
        LVODEF  CheckIPCPort
        LVODEF  PutIPCMsg
        LVODEF  CreateIPCMsg
        LVODEF  DeleteIPCMsg
        LVODEF  LoadIPCPort
        LVODEF  MakeIPCId
        LVODEF  FindIPCItem

*******************************

    ENDC

