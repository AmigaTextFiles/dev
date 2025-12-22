#ifndef PLUGIN_H
#define PLUGIN_H

/* Includeheader

	Name:		plugin.h
	Main:		plugin demo
	Version:	$VER: plugin.h 1.0 (10.06.2003)
	Description:	headerfile for demo plugins
	Author:		SDI
	Distribution:	PD

 1.0   10.06.03 : first version
*/

#include <exec/types.h>
#include <dos/dos.h>

/************************************************************************
*									*
*    plugin support stuff						*
*									*
************************************************************************/

/* This is the link structure, which allows us to detect a proper plugin */
struct PluginHead {
  ULONG 	      ph_Security;    /* should be PLUGINHEAD_SECURITY */
  ULONG 	      ph_ID;	      /* must be PLUGINHEAD_ID */
  BPTR                ph_SegList;     /* set to zero in plugins */
  struct PluginHead * ph_Next;        /* set to zero in plugins */
  UWORD 	      ph_Version;     /* set to PLUGINHEAD_VERSION */
  UWORD 	      ph_Reserved;    /* only for alignment */
  STRPTR	      ph_VersString;  /* pointer to $VER: string */
  struct Plugin *     ph_FirstPlugin; /* pointer to first plugin */
};

#define PLUGINHEAD_SECURITY	0x70FF4E75 /* MOVEQ #-1,D0 and RTS */
#define PLUGINHEAD_ID		0x504C5547 /* 'PLUG' identification ID */
#define PLUGINHEAD_VERSION	1

/* There should be no need to modify the PluginHead structure! Only the
   ID field should be changed for each project, as this part must be
   individual.
*/

/* And this is the data structure we use */
struct Plugin {
  struct Plugin * p_Next;           /* pointer to next plugin */
  UWORD 	  p_Version;        /* set to PLUGIN_VERSION */
  UWORD 	  p_MasterVersion;  /* the version of master required to work */
  UWORD 	  p_PluginVersion;  /* the version of this plugin */
  UWORD 	  p_PluginRevision; /* and the revision */
  UWORD           p_Identifier;     /* an ID to replace internal plugins */
  UWORD           p_Flags;          /* some flags to define plugin type */

  /* Now the real data comes */
  STRPTR          p_Description;
  STRPTR          (*p_Func1)(void);
  STRPTR          (*p_Func2)(STRPTR inp);
};

#define PLUGIN_VERSION	1

#endif /* PLUGIN_H */
