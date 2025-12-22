/*-----------------------------------------------------------------*/
/* Filename : egsrequest.fd*/
/* Release  : 1.0*/
/**/
/* fd file for egsrequest.library*/
/**/
/* (c) Copyright 1990/92 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Ulrich Sigmund*/
/* Created     : 24. Sept 1992*/
/* Updated     : 14. Sept 1992*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGSRequestBase ER_CreateReqContext 1E 0
#pragma libcall EGSRequestBase ER_DeleteReqContext 24 801
#pragma libcall EGSRequestBase ER_FindRequest 2A 9802
#pragma libcall EGSRequestBase ER_DoRequest 30 801
#pragma libcall EGSRequestBase ER_OpenRequest 36 9802
#pragma libcall EGSRequestBase ER_IterateRequest 3C 9802
#pragma libcall EGSRequestBase ER_CancelRequest 42 801
#pragma libcall EGSRequestBase ER_ChangeRequestPos 48 10803
#pragma libcall EGSRequestBase ER_ChangeRequestSize 4E 10803
#pragma libcall EGSRequestBase ER_CreateFileReq 54 801
#pragma libcall EGSRequestBase ER_DeleteRequest 5A 801
#pragma libcall EGSRequestBase ER_PutValuesInFileReq 60 BA9804
#pragma libcall EGSRequestBase ER_CreateSimpleRequest 66 A9803
