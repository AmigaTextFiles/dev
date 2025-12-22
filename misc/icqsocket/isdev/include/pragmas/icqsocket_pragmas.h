#ifndef ICQSOCKETPRGMA_H
#define ICQSOCKETPRGMA_H

#pragma libcall ICQSocketBase is_Debug 1e 1002
#pragma libcall ICQSocketBase is_InitA 24 8002
#pragma libcall ICQSocketBase is_Free 2a 801
#pragma libcall ICQSocketBase is_Disconnect 30 801
#pragma libcall ICQSocketBase is_ConnectA 36 9802
#pragma libcall ICQSocketBase is_InstallHook 3c 90803
#pragma libcall ICQSocketBase is_NetWait 42 802
#pragma libcall ICQSocketBase is_AddUIN 48 802
#pragma libcall ICQSocketBase is_AddUINQ 4e 802
#pragma libcall ICQSocketBase is_RemUIN 54 802
#pragma libcall ICQSocketBase is_SendA 5a a9803
#pragma libcall ICQSocketBase is_AddAckNot 60 109804
#pragma libcall ICQSocketBase is_RemAckNot 66 802
#pragma libcall ICQSocketBase is_OpenMsgLog 6c 801
#pragma libcall ICQSocketBase is_CloseMsgLog 72 801
#pragma libcall ICQSocketBase is_GetLoggedMsg 78 802
#pragma libcall ICQSocketBase is_OpenMsgQueue 7e 801
#pragma libcall ICQSocketBase is_CloseMsgQueue 84 801
#pragma libcall ICQSocketBase is_GetQueuedMsg 8a 802
#pragma libcall ICQSocketBase is_OpenDatabase 90 802
#pragma libcall ICQSocketBase is_CloseDatabase 96 802
#pragma libcall ICQSocketBase is_GetEntry 9c 802
#pragma libcall ICQSocketBase is_FindUIN a2 802
#pragma libcall ICQSocketBase is_RegNewUserA a8 9802
#pragma libcall ICQSocketBase is_RegNewUserCleanUp ae 801

#pragma tagcall ICQSocketBase is_Init 24 8002
#pragma tagcall ICQSocketBase is_Connect 36 9802
#pragma tagcall ICQSocketBase is_Send 5a a9803
#pragma tagcall ICQSocketBase is_RegNewUser a8 9802

#endif
