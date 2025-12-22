/*
 *  AmigaDOS specific code for a SAS/C version of the
 *  Gofer system.
 *
 *  The code in this file is hereby put in the public domain!
 *
 *  Torsten Poulin (torsten@diku.dk)
 *  3-Apr-94
 */

#include <exec/types.h>
#include <dos/dos.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <errno.h>


/*
 * Are we running in an AmigaDOS shell window?
 */

int amigaIsTrueConsole(void)
{
  BPTR filehandle = Input();
  struct Window *w;
  struct FileHandle *confilehandle;
  struct StandardPacket *sp;
  struct InfoData *id;
  struct MsgPort *mp;

  w = NULL;

  if((confilehandle = BADDR(filehandle))->fh_Type != NULL) {
    if(sp = AllocMem(sizeof(struct StandardPacket),
		     MEMF_PUBLIC | MEMF_CLEAR)) {
      if(id = AllocMem(sizeof(struct InfoData),
		       MEMF_PUBLIC | MEMF_CLEAR)) {
	if(mp = CreatePort(NULL, 0)) {
	  sp->sp_Msg.mn_Node.ln_Name = (char *)&sp->sp_Pkt;
	  sp->sp_Pkt.dp_Link         = &sp->sp_Msg;
	  sp->sp_Pkt.dp_Port         = mp;
	  sp->sp_Pkt.dp_Type         = ACTION_DISK_INFO;
	  sp->sp_Pkt.dp_Arg1         = MKBADDR(id);

	  PutMsg(confilehandle->fh_Type, &sp->sp_Msg);
	  WaitPort(mp);
	  GetMsg(mp);

	  if(sp->sp_Pkt.dp_Res1)
	    w = (struct Window *)id->id_VolumeNode;

	  DeletePort(mp);
	}
	FreeMem(id, sizeof(struct InfoData));
      }
      FreeMem(sp, sizeof(struct StandardPacket));
    }
  }
  return w ? 1 : 0;
}

/*  Replacement for the SAS/C 6.51 system() function.
 *  This version uses the UserShell which by default
 *  is the same as the boot shell but can be changed
 *  by the user; e.g., to WShell.
 *
 *  Does nothing if passed a NULL pointer or an empty string.
 */

int system(const char *s)
{
  int result;
  struct TagItem tags[2];

  if (!s || !*s) return 0;

  if (DOSBase->dl_lib.lib_Version < 36L) {
    Execute(s, NULL, NULL);
    result = 0; /* nothing reasonable is available... */
  }
  else {
    tags[0].ti_Tag = SYS_UserShell; tags[0].ti_Data = TRUE;
    tags[1].ti_Tag = TAG_END; tags[1].ti_Data = NULL;
    if ((result = (int) System(s, tags)) == -1) errno = EOSERR;
  }
  return result;
}
