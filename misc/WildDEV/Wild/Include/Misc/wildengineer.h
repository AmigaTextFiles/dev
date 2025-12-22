/*
**      $VER: wildengineer.h 0.02 (20.10.98)
**
**      definition of WildEngineer
**
*/

#ifndef WILDENGINEER_H
#define WILDENGINEER_H

#ifndef  EXEC_LIBRARIES
#include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */

#ifndef	UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#include <exec/lists.h>
#include <wild/wild.h>

// My library base.

struct WildEngineerBase
{
 struct Library         exb_LibNode;
 BPTR	                exb_SegList;
 struct ExecBase        *web_SysBase;
};

#define exb_SysBase web_SysBase		// Just to be compatible with std StartUp.c

struct WEModuleInfo
{
 struct	MinNode		mi_Node;		// When HaveBestModules, they have to be linked.
 struct WildTypes	mi_Types;		// Types of the module
 char			mi_Name[32];		// Name of the module (the significant part: in BrokerTiX+.library, TiX+ is the significant part.
 UWORD			mi_Score;		// When HaveBestModules, may be useful...
}; 

struct WEBestModules
{
 struct MinList		bm_Modules;		// list of WEModuleInfo
};

#endif 
