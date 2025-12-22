/*** IPC_lib.fd ****/
/**/
/* -- PPIPC Library function descriptors*/
/* -- Pete Goodeve 89 April 17*/
/**/
#pragma libcall IPCBase FindIPCPort 1e 801
#pragma libcall IPCBase GetIPCPort 24 801
#pragma libcall IPCBase UseIPCPort 2a 801
#pragma libcall IPCBase DropIPCPort 30 801
#pragma libcall IPCBase ServeIPCPort 36 801
#pragma libcall IPCBase ShutIPCPort 3c 801
#pragma libcall IPCBase LeaveIPCPort 42 801
#pragma libcall IPCBase CheckIPCPort 48 802
#pragma libcall IPCBase PutIPCMsg 4e 9802
#pragma libcall IPCBase CreateIPCMsg 54 81003
#pragma libcall IPCBase DeleteIPCMsg 5a 801
#pragma libcall IPCBase LoadIPCPort 60 801
#pragma libcall IPCBase MakeIPCId 66 801
#pragma libcall IPCBase FindIPCItem 6c 90803
