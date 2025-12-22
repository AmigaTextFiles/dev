/*
 * amisslinit - amissl helper subsystem
 * version 0.1 by megacz@usa.com
 *
*/



#include <proto/exec.h>
#include <exec/types.h>
#include <utility/tagitem.h>

#include <proto/amisslmaster.h>
#include <proto/amissl.h>
#include <libraries/amisslmaster.h>
#include <libraries/amissl.h>
#include <amissl/amissl.h>

#include <fixamissl.h>
#include <asiheader.h>



int asi_InitAmiSSL(int *errnoptr)
{
  if ((SocketBase = ns_ObtainBSDSocketBase()))
  {
    if ((AmiSSLMasterBase = OpenLibrary("amisslmaster.library", AMISSLMASTER_MIN_VERSION)))
    {
      if ((InitAmiSSLMaster(AMISSL_CURRENT_VERSION, TRUE)))
      {
        if ((AmiSSLBase = OpenAmiSSL()))
        {
          if ((___IASSL = InitAmiSSL(AmiSSL_ErrNoPtr, (LONG)errnoptr, AmiSSL_SocketBase, (LONG)SocketBase, TAG_DONE, 0)) == 0)
          {
            SSLeay_add_ssl_algorithms();

            SSL_load_error_strings();

            return 1;
          }
        }
      }
    }
  }

  asi_CleanupAmiSSL();

  return 0;
}

void asi_CleanupAmiSSL(void)
{
  if (___IASSL == 0)
  {
    CleanupAmiSSL(TAG_DONE);

    ___IASSL = 1;
  }

  if (AmiSSLBase)
  {
    CloseAmiSSL();

    AmiSSLBase = NULL;
  }

  if (AmiSSLMasterBase)
  {
    CloseLibrary(AmiSSLMasterBase);

    AmiSSLMasterBase = NULL;
  }
}
