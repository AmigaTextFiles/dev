/* Programmheader

	Name:		master.c
	Main:		plugin demo
	Versionstring:	$VER: master.c 1.0 (10.06.2003)
	Author:		SDI
	Distribution:	PD
	Description:	the master program to use the plugins

 1.0   10.06.03 : first version
*/

#include <string.h>
#include <proto/dos.h>

#include "plugin.h"

#define VERSION 1 /* the version of this master */

const UBYTE version[] = 
"$VER: master 1.0 (10.06.2003) (PD) by Dirk Stöcker <stoecker@epost.de>";

/* Needs DOS >= V37, The arguments plugin and head must be pseudo entries,
as this makes list handling lots easier! */
void InitPlugins(STRPTR plugindir, struct Plugin *plugin,
struct PluginHead *head)
{
  struct Plugin *list;
  struct FileInfoBlock *fib;

  list = plugin;
  if((fib = (struct FileInfoBlock *) AllocDosObject(DOS_FIB, 0)))
  {
    BPTR lock;

    /* Lock the directory */
    if((lock = Lock(plugindir, SHARED_LOCK)))
    {
      /* examine it */
      if(Examine(lock, fib))
      {
        /* really a directory */
        if(fib->fib_DirEntryType > 0)
        {
	  BPTR oldlock;

	  oldlock = CurrentDir(lock);

	  /* in case we already loaded some, go to end of list */
  	  while(list->p_Next)
  	    list = list->p_Next;

          /* go through the list of files */
          while(ExNext(lock, fib))
          {
            BPTR realsl;
            UBYTE *sl;

            /* load the file */
            if((realsl = LoadSeg(fib->fib_FileName)))
            {
              ULONG i, size, need = 0;
              struct PluginHead *h = 0;

              /* convert BPTR to APTR */
              sl = (APTR)(realsl<<2);
              /* We need the size of the loaded block, so we lock into
                 the segment list. For ease of use, we only scan the first
                 segment for identifier. */
              size = *((ULONG *) (sl-4));

              /* now subtract the minimum size of the data structure */
              size -= sizeof(struct PluginHead);

	      /* scan the first segment for a head structure */
              for(i = 0; !need && i < size; i += 2)
              {
                /* divided into 2 parts to disable recognition of
                   this program as a plugin itself */
	        if((*((UWORD *) (sl+4+i)) == (PLUGINHEAD_ID>>16)) &&
	        (*((UWORD *) (sl+6+i)) == (PLUGINHEAD_ID&0xFFFF)))
	        {
                  struct Plugin *p, *p2;

	          h = (struct PluginHead *) (sl+4+i-4);
	          for(p = h->ph_FirstPlugin; p; p = p2)
	          {
		    p2 = p->p_Next;
		    p->p_Next = 0;

 		    if(p->p_MasterVersion <= VERSION)
		    {
		      need = 1;
		      /* something to replace? */
		      if(p->p_Identifier)
		      {
			struct Plugin *list2 = plugin;

                        /* the next element is the one we look for */
                        while(list2->p_Next && p->p_Identifier !=
		  	list2->p_Next->p_Identifier)
		  	  list2 = list2->p_Next;
		  	if(list2->p_Next) /* replace */
		  	{
			  if(!(p->p_Next = list->p_Next->p_Next))
			    list = p; /* the new one is last */
			  list2->p_Next = p;
		  	}
		  	else
		  	{
	                  list->p_Next = p; list = p;
		  	}
		      }
		      else
		      {
	                list->p_Next = p; list = p;
	              } /* check Indentifier */
		    } /* check mastervseion */
		  } /* loop around plugins */
	        } /* check head ID */
	      } /* scan segment */
	      if(!need)
	        UnLoadSeg(realsl);
	      else /* add this seglist */
	      {
                h->ph_SegList = realsl;
                h->ph_Next = head->ph_Next;
                head->ph_Next = h;
                /* add reversed, is easier */
	      }
            } /* LoadSeg */
          } /* ExNext */
          SetIoErr(0);
	  CurrentDir(oldlock);
        } /* Is Directory ? */
      } /* Examine */
      UnLock(lock);
    } /* Lock */
    FreeDosObject(DOS_FIB, fib);
  } /* AllocDosObject */
}

void ReleasePlugins(struct Plugin *plugin, struct PluginHead *head)
{
  struct PluginHead *p, *p2;

  p = head->ph_Next;
  while(p)
  {
    p2 = p->ph_Next;
    if(p->ph_SegList)
      UnLoadSeg(p->ph_SegList);
    p = p2;
  }

  head->ph_Next = 0;
  plugin->p_Next = 0;
}


void PlaySomething(struct Plugin *p)
{
  if(!p)
    Printf("No plugin found!\n");
  else
  {
    while(p)
    {
      Printf("\nType: %s\n", p->p_Description);
      if(p->p_Func1)
        Printf("Function 1 says: %s\n", p->p_Func1());
      else
        Printf("No function 1\n");
      if(p->p_Func2)
        Printf("Function 2 says: %s\n", p->p_Func2("Demo text"));
      else
        Printf("No function 2\n");
      p = p->p_Next;
    }
  }
}

STRPTR Int_Func1(void)
{
  return "Internal Function 1";
}

STRPTR Int_Func2(STRPTR txt)
{
  return "Internal Function 2";
}

#define MASTER_VERSION VERSION
#define INT_VERSION    1
#define INT_REVISION   0

const struct Plugin Int_Plugin = {
  0,
  PLUGIN_VERSION,
  MASTER_VERSION,
  INT_VERSION,
  INT_REVISION,
  0,
  0,

  "Internal plugin",
  Int_Func1,
  Int_Func2
};

int main(void)
{
  struct Plugin plugin;   /* dummy to make work easier */
  struct PluginHead head; /* dummy to make work easier */
  memset(&plugin, 0, sizeof(plugin));
  memset(&head, 0, sizeof(head));

  plugin.p_Next = (struct Plugin *) &Int_Plugin;
  InitPlugins("plugins", &plugin, &head);

  PlaySomething(plugin.p_Next);

  ReleasePlugins(&plugin, &head);
  return 0;
}

