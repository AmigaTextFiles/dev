/*
 * asiheader.h
 * version 0.1 by megacz@usa.com
 *
*/



#ifndef __ASIHEADER_H__
#define __ASIHEADER_H__

#include <sys/types.h>
#include <proto/exec.h>

int asi_InitAmiSSL(int *);
void asi_CleanupAmiSSL(void);
struct Library *ns_ObtainBSDSocketBase(void);
int ns_ObtainBSDSocketFD(int);

#ifdef _ASI_BASES_
ULONG ___IASSL = 1;
struct Library *AmiSSLMasterBase = NULL;
struct Library *AmiSSLBase = NULL;
struct Library *SocketBase = NULL;
#else
extern ULONG ___IASSL;
extern struct Library *AmiSSLMasterBase;
extern struct Library *AmiSSLBase;
extern struct Library *SocketBase;
#endif

#endif
