#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <stdio.h>

struct GfxBase *GfxBase;
struct IntuitionBase *IntuitionBase;
struct library *MUIMasterBase;
struct library *LocaleBase;

BOOL OpenIntuitionLibrary( int version )
{ 
  IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library", version );
  if ( IntuitionBase == NULL )
    {
      return 0;
    }

  return 1;
}
BOOL OpenMUILibrary( int version )
{ 
  MUIMasterBase = OpenLibrary("muimaster.library", version );
  if ( MUIMasterBase == NULL )
    {
      return 0;
    }

  return 1;
}
BOOL OpenLocaleLibrary( int version )
{ 
  LocaleBase = OpenLibrary("locale.library", version );
  if ( LocaleBase == NULL )
    {
      return 0;
    }

  return 1;
}

BOOL OpenGraphicsLibrary( int version )
{ 
  GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", version );
  if ( GfxBase == NULL )
    {
      return 0;
    }
  return 1;
}

void CloseIntuitionLibrary()
{
  CloseLibrary(IntuitionBase);
}

void CloseMUILibrary()
{
  CloseLibrary(MUIMasterBase);
}

void CloseLocaleLibrary()
{
  CloseLibrary(LocaleBase);
}

void CloseGraphicsLibrary()
{
  CloseLibrary(GfxBase);
}
