#define DEBUG
#include <debug.h>

#include <clib/extras/exec_protos.h>
#include <proto/gadtools.h>
#include <proto/locale.h>


struct Library *GadToolsBase, *VirtualBrainBase;
struct LocaleBase *LocaleBase;
struct Libs MyLibs[]=
{
  &GadToolsBase,  "gadtools.library",   39, 0,
  &LocaleBase,    "locale.library",     37, OLF_OPTIONAL,
  &VirtualBrainBase, "virtualbrain.library", 40, 0,
  0
};

void main(int argc, char **argv)
{
  if(ex_OpenLibs(argc, "TestProgram",0,0,0,MyLibs))
  {
    ex_CloseLibs(MyLibs);
  }
}

