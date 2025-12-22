/********************************************************************
*      Societe                   :
*      Projet                   :
*      Tache                     :  Librairie d'outils de base Amiga
*
*      Nom du module             :  $RCSfile: ss_amiga_lib_tools.c,v $
*      Version du module         :  $Revision: 1.17 $
*      Date de la version        :  $Date: 2004/03/07 19:32:01 $
*
*      Description               :  Librairie d'outils de base pour l'aide au
*				    développement.
*
*      Auteurs                   :
*
*      Materiels necessaires     :
*      Systeme                   :
*
*      Langage de programmation  :  C ansi.
*      Date debut programmation  : Thu Aug 08 10:08:28 2002
*
*      Prefixe utilise           :
*      Taille du code (.o) en KO :
*
*      References                :
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*
*
*******************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/
// --------------------------------------------------------------------------
// C LIB
// --------------------------------------------------------------------------
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <clib/alib_protos.h>
#include <proto/dos.h>
#include <proto/asl.h>
#include <proto/exec.h>

#include <clib/debug_protos.h> //SS-TBD to be removed

#include <clib/muimaster_protos.h> //SS-TBD : pas bien... Voir cxomment faire...

#include <utility/hooks.h>
#include <intuition/intuition.h>

#include "ss_amiga_lib_tools_protos.h"


struct PathNode {
   BPTR next;
   BPTR dir;
};


//SS-TBD
extern VOID    MUI_FreeAslRequest     (APTR requester );


/*******************************************************************
 * VARIABLES GLOBALES EXPORTEES
*******************************************************************/

/*******************************************************************
 * SIGNATURE DES FONCTIONS
*******************************************************************/

ULONG getFileSize(BPTR pm_file_desc);
char* buildEntirePathWithDirAndFilename(const char *pm_dir, const char *pm_filename);
char* sslib_req_getFile(const char *pm_reqtitle, const char *pm_dir, const struct Hook *pm_intuimsghook, const ULONG pm_requserdata);
int sskprintf(char *fmt, ...);
char* RelativePathToAbsolute(char *pm_rel_path);
LONG sslib_GetStackSizeOfCurrentProcess(void);
LONG sslib_InstallNewStack(ULONG pm_size, void (*pm_func)(void *), void *pm_arg);
char* sslib_NameFromLock(BPTR pm_lock);

LONG NEW_sslib_filereq(sslib_filereq_t *pm_this, const struct Window *pm_win, const char *pm_reqtitle, const char *pm_dir, const struct Hook *pm_intuimsghook, const ULONG pm_requserdata);
LONG DEL_sslib_filereq(sslib_filereq_t *pm_this);
LONG NEW_sslib_filenotify(	sslib_filenotify_t *pm_this, 
							const struct MsgPort *pm_msgport,
							const struct Task *pm_task,
							const void *pm_userdata);
LONG DEL_sslib_filenotify(sslib_filenotify_t *pm_this);

BPTR CloneWorkbenchPath(struct WBStartup *wbmsg);
void FreeWorkbenchPath(BPTR path);


static void sslib_InstallNewStack_Func(ULONG  pm_arg1,
								ULONG  pm_arg2,
								ULONG  pm_arg3,
								ULONG  pm_arg4,
								ULONG  pm_arg5,
								ULONG  pm_arg6,
								ULONG  pm_arg7,
								ULONG  pm_arg8);
static char* sslib_ssfr_OpenFileReq(sslib_filereq_t *pm_this);
static void ss_nothing(void);
static BOOL sslib_fn_Start(	sslib_filenotify_t *pm_this,
							char *pm_filename);
static BOOL sslib_fn_Stop(sslib_filenotify_t *pm_this);

#ifndef __MORPHOS__        // AmigaOS ;)
VOID LVORawPutChar( UBYTE MyChar );
#endif

/*******************************************************************
 * DEFINITION DES FONCTIONS
*******************************************************************/

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
static void ss_nothing(void)
{
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le
// ******************
//
// Parametres en ENTREE : BPTR pm_file_desc : descripter returned by Open()
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE : entire_file must be deallocated by calling function
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
ULONG getFileSize(BPTR pm_file_desc)
{
    struct FileInfoBlock   *file_info_block = NULL;
	ULONG  ret_size = 0;

	if(pm_file_desc == NULL)   return 0;

    // Obtain the file size
    //-------------------------------
    file_info_block = (struct FileInfoBlock *)AllocDosObject(DOS_FIB, NULL);
	if(file_info_block == NULL)    return 0;
    if(ExamineFH(pm_file_desc, file_info_block) != 0)
    {
        ret_size = file_info_block->fib_Size;
	}
	FreeDosObject(DOS_FIB, file_info_block);

	return ret_size;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 06 Juillet 2002
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE : entire_file must be deallocated by calling function
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
char* buildEntirePathWithDirAndFilename(const char *pm_dir, const char *pm_filename)
{
	char *entire_file;

	if((pm_dir == NULL)||(pm_filename == NULL))
	{
		return NULL;
    }

	entire_file = (char*)malloc(strlen(pm_dir) + strlen(pm_filename) + 1 + 1);
	if(entire_file == NULL)
	{
		return NULL; //SS-TBD : handle error ?
	}

	if((pm_dir[strlen(pm_dir)-1]) == ':')
	{
		sprintf((char*)entire_file, "%s%s", pm_dir, pm_filename);
	}
	else if((pm_dir[strlen(pm_dir)-1]) == '/')
	{
		sprintf((char*)entire_file, "%s%s", pm_dir, pm_filename);
	}
	else
	{
		if(strcmp(pm_dir, "") == 0) // SS : local dir ?
		{
			sprintf((char*)entire_file, "%s", pm_filename);
		}
		else
		{
			sprintf((char*)entire_file, "%s/%s", pm_dir, pm_filename);
		}
	}

	return entire_file;
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 06 Juillet 2002
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE : entire_file must be deallocated by calling function
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :   THE USER HAVE TO DEALLOCATE THE RETURNED STRING
// **********
//
// *************************************************************************
static char* sslib_ssfr_OpenFileReq(sslib_filereq_t *pm_this)
{
	char *file_to_open = NULL;

	if((pm_this == NULL)||((pm_this->ssfr_req) == NULL)) return NULL;

	// -------------------
	// Use REQUESTER to obtain file name
	// -------------------
	if (AslRequest(pm_this->ssfr_req,NULL))
	{
		// OK was selected
		file_to_open = (char*)buildEntirePathWithDirAndFilename((const char*)((pm_this->ssfr_req)->fr_Drawer), (const char*)((pm_this->ssfr_req)->fr_File));
	}

	return file_to_open;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, 
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE : 
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :   
// **********
//
// *************************************************************************
LONG NEW_sslib_filenotify(	sslib_filenotify_t *pm_this, 
							const struct MsgPort *pm_msgport,
							const struct Task *pm_task,
							const void *pm_userdata)
{
	if((pm_this == NULL)||(pm_msgport == NULL)||(pm_task == NULL)) return -1;

	pm_this->ssfn_StartWithFile = (BOOL (*)(sslib_filenotify_t*, char*))ss_nothing;
	pm_this->ssfn_Stop          = (void (*)(sslib_filenotify_t*))ss_nothing;
	pm_this->ssfn_isStarted     = FALSE;

	pm_this->ssfn_not = AllocVec(sizeof(struct NotifyRequest), MEMF_PUBLIC|MEMF_CLEAR);
	if((pm_this->ssfn_not) == NULL) return -1;

	(pm_this->ssfn_not)->nr_Name     = NULL;
	(pm_this->ssfn_not)->nr_Flags    = NRF_SEND_MESSAGE | NRF_WAIT_REPLY;
	(pm_this->ssfn_not)->nr_UserData = (ULONG)pm_userdata;
	(pm_this->ssfn_not)->nr_stuff.nr_Msg.nr_Port = pm_msgport;
/*	(pm_this->ssfn_not)->nr_stuff.nr_Signal.nr_Task      = pm_task;
	(pm_this->ssfn_not)->nr_stuff.nr_Signal.nr_SignalNum = pm_signalbyte;*/

	pm_this->ssfn_StartWithFile = sslib_fn_Start;
	pm_this->ssfn_Stop          = sslib_fn_Stop;

	return 0;
}

LONG DEL_sslib_filenotify(sslib_filenotify_t *pm_this)
{
	if(pm_this == NULL) return -1;

	if((pm_this->ssfn_isStarted) == TRUE)
	{
		pm_this->ssfn_Stop(pm_this);
	}

	pm_this->ssfn_StartWithFile = (BOOL (*)(sslib_filenotify_t*, char*))ss_nothing;
	pm_this->ssfn_Stop          = (void (*)(sslib_filenotify_t*))ss_nothing;

	if((pm_this->ssfn_not) != NULL) 
	{
		FreeVec(pm_this->ssfn_not);
		pm_this->ssfn_not = NULL;
	}

	return 0;
}

static BOOL sslib_fn_Start(sslib_filenotify_t *pm_this,
					char *pm_filename)
{
	if((pm_this == NULL)||(pm_filename == NULL)||((pm_this->ssfn_not) == NULL)) return FALSE;

	if((pm_this->ssfn_isStarted) == TRUE) pm_this->ssfn_Stop(pm_this);

	(pm_this->ssfn_not)->nr_Name  = strdup(pm_filename);
	if(((pm_this->ssfn_not)->nr_Name) == NULL) return FALSE;
		
	if(StartNotify(pm_this->ssfn_not) == DOSTRUE)
	{
		pm_this->ssfn_isStarted = TRUE;
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

static BOOL sslib_fn_Stop(sslib_filenotify_t *pm_this)
{
	if((pm_this == NULL)||((pm_this->ssfn_not) == NULL)) return FALSE;
	
	if((pm_this->ssfn_isStarted) == TRUE)
	{
		EndNotify(pm_this->ssfn_not);
		if(((pm_this->ssfn_not)->nr_Name) != NULL) 
		{
			free((pm_this->ssfn_not)->nr_Name);
			(pm_this->ssfn_not)->nr_Name = NULL;
		}
		pm_this->ssfn_isStarted = FALSE;
	}
	
	return TRUE;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 06 Juillet 2002
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE : entire_file must be deallocated by calling function
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :   THE USER HAVE TO DEALLOCATE THE RETURNED STRING
// **********
//
// *************************************************************************
LONG NEW_sslib_filereq(	sslib_filereq_t *pm_this, 
			const struct Window *pm_win, 
			const char *pm_reqtitle, 
			const char *pm_dir, 
			const struct Hook *pm_intuimsghook, 
			const ULONG pm_requserdata)
{
	if((pm_this == NULL)||(pm_win == NULL)) return -1;
SSDEBUG("NEW_sslib_filereq : pass1 (pm_win=0x%lx, pm_reqtitle=0x%lx)\n",
	pm_win, pm_reqtitle);
SSDEBUG("NEW_sslib_filereq : pass1.1 (pm_dir=0x%lx, pm_intuimsghook=0x%lx)\n",
	pm_dir, pm_intuimsghook);

	pm_this->ssfr_OpenFileReq = (char* (*)(struct SSLIB_FILEREQ_T *pm_this))ss_nothing;
SSDEBUG("NEW_sslib_filereq : pass2\n");
//SS-TBD : protect all NULL values passed to AllocAslRe..
	pm_this->ssfr_req = 
		(struct FileRequester *) /*MUI_*/AllocAslRequestTags(ASL_FileRequest ,
			   ASLFR_Window, 	(ULONG)pm_win,
			   ASLSM_TitleText,     (ULONG)((pm_reqtitle != NULL) ? pm_reqtitle : ""),
			   ASLFR_InitialDrawer, (ULONG)((pm_dir != NULL) ? pm_dir : ""),
			   ASLFR_IntuiMsgFunc,  (ULONG)(pm_intuimsghook),
			   ASLFR_UserData,      (ULONG)pm_requserdata,
			   TAG_END );
SSDEBUG("NEW_sslib_filereq : pass3\n");
	if((pm_this->ssfr_req) == NULL) return -2;

	pm_this->ssfr_OpenFileReq = sslib_ssfr_OpenFileReq;
SSDEBUG("NEW_sslib_filereq : pass4\n");

	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 06 Juillet 2002
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE : entire_file must be deallocated by calling function
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :   THE USER HAVE TO DEALLOCATE THE RETURNED STRING
// **********
//
// *************************************************************************
LONG DEL_sslib_filereq(sslib_filereq_t *pm_this)
{
	if(pm_this == NULL) return -1;

	if((pm_this->ssfr_req) == NULL) return -2;
	/*MUI_*/FreeAslRequest(pm_this->ssfr_req);
	return 0;
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 30 March 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
#define SSKPRINTF_BUFSIZE 1024
int sskprintf(char *fmt, ...)
{
	static char	str_tmp[SSKPRINTF_BUFSIZE];
	va_list  	ap;
	int 		result;
	int 		i;

	va_start(ap, fmt);
	result = vsnprintf(str_tmp, SSKPRINTF_BUFSIZE-1, fmt, ap);
	va_end(ap);

   for(i=0; (i < SSKPRINTF_BUFSIZE)&&(str_tmp[i] != '\0'); i++)
   {
#ifndef __MORPHOS__   // AmigaOS ;)
	   LVORawPutChar(str_tmp[i]);
#else
	   RawPutChar(str_tmp[i]);
#endif
   }

   return result;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 16 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :  The calling function HAVE TO RELEASE THE BUFFER !!!
// **********
//
// *************************************************************************
#define RPTA_BUFFLEN 1024
char* RelativePathToAbsolute(char *pm_rel_path)
{
	BPTR fh = NULL;
	BPTR lock = NULL;
	char *str_tmp = NULL;
	char *abs_path = NULL;
	static char currenr_dir_name[RPTA_BUFFLEN] = {0};

	// Test parameter
	// -------------------
	if(pm_rel_path == NULL) return NULL;

	// Try to open the provided file
	// -------------------
	fh = Open(pm_rel_path, MODE_OLDFILE);
	if(fh == NULL) return NULL;

	// Check if it is not already an absolute path
	// -------------------
	str_tmp = strrchr(pm_rel_path, ':');
	if(str_tmp != NULL)
	{
		Close(fh);
		abs_path = strdup(pm_rel_path);
		return abs_path;
	}

	// Obtain the name file associated to the lock
	// -------------------
	lock = Lock(pm_rel_path, ACCESS_READ);
	NameFromLock(lock, currenr_dir_name, RPTA_BUFFLEN-1);
	UnLock(lock);

	Close(fh);

	abs_path = strdup(currenr_dir_name);

	return abs_path;
}
#undef RPTA_BUFFLEN




// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 16 Aout 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :  This ONLY WORKS FOR PROCESSES !!!! DO NOT CALL IT FOR TASKS
// **********
//
// *************************************************************************
LONG sslib_GetStackSizeOfCurrentProcess(void)
{
	struct Process *proc = (struct Process*)FindTask(0L);

	if(proc == NULL) return -1;

	return (proc->pr_StackSize);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 16 Aout 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
LONG sslib_InstallNewStack(ULONG pm_size, void (*pm_func)(void *), void *pm_arg)
{
	register struct StackSwapStruct *stackstruct = AllocVec(sizeof(struct StackSwapStruct), MEMF_PUBLIC|MEMF_CLEAR);
	register char *newstack = AllocVec(pm_size+16, MEMF_PUBLIC|MEMF_CLEAR); //+16 because I fear from a compiler fantasy

	if((newstack == NULL) ||(stackstruct == NULL)) return -1;

	stackstruct->stk_Lower   = (APTR)newstack;
	stackstruct->stk_Upper   = (ULONG) &(newstack[pm_size]);
	stackstruct->stk_Pointer = (APTR)(stackstruct->stk_Upper);

#ifdef __MORPHOS__
	{
		struct PPCStackSwapArgs	args;
		args.Args[0]	=	pm_func;
		args.Args[1]	=	pm_arg;
		NewPPCStackSwap(stackstruct,
				&sslib_InstallNewStack_Func,
				&args);
	}		
#else
	{
		register void (*func)(void *) = pm_func;
		register void *arg = pm_arg;
	
		StackSwap(stackstruct);
		func(arg);
		StackSwap(stackstruct);
	}
#endif

	FreeVec(newstack);
	FreeVec(stackstruct);

	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 29 Septembre 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
static void sslib_InstallNewStack_Func(ULONG  pm_arg1,
								ULONG  pm_arg2,
								ULONG  pm_arg3,
								ULONG  pm_arg4,
								ULONG  pm_arg5,
								ULONG  pm_arg6,
								ULONG  pm_arg7,
								ULONG  pm_arg8)
{
	void (*func)(void *arg) = (void(*)(void *arg))pm_arg1;
	func((void*)pm_arg2);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
#define SSLIB_NFL_BUFSIZE 256
char* sslib_NameFromLock(BPTR pm_lock)
{
	char *buffer = NULL;
	int i = 1;
	LONG ret;

	if(pm_lock == NULL) return NULL;
	do
	{
		buffer = (char*) malloc((i*SSLIB_NFL_BUFSIZE)+1);
		if(buffer == NULL) return NULL;

		ret = NameFromLock(pm_lock, buffer, i*SSLIB_NFL_BUFSIZE);
		if(ret == DOSTRUE)
		{
			return buffer;
		}
		else if((ret != DOSTRUE)&&(IoErr() == ERROR_LINE_TOO_LONG))
		{
			i++;
			free(buffer);
		}
		else
		{
			free(buffer);
			return NULL;
		}

	}while(i < 100);

	free(buffer);
	return NULL;
}
#undef SSLIB_NFL_BUFSIZE


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
BPTR CloneWorkbenchPath(struct WBStartup *wbmsg)
{
   BPTR path = 0;

   if(wbmsg == NULL) return 0;

   Forbid();
   if (wbmsg->sm_Message.mn_ReplyPort)
   {
      if (((LONG)wbmsg->sm_Message.mn_ReplyPort->mp_Flags & PF_ACTION) == PA_SIGNAL)
      {
         struct Process *wbproc = wbmsg->sm_Message.mn_ReplyPort->mp_SigTask;

		 if ((wbproc != NULL)&&(wbproc->pr_Task.tc_Node.ln_Type == NT_PROCESS))
         {
            struct CommandLineInterface *cli = BADDR(wbproc->pr_CLI);

            if (cli)
            {
               BPTR *p = &path;
               BPTR dir = cli->cli_CommandDir;

               while (dir)
               {
                  BPTR dir2;
                  struct FileLock *lock = BADDR(dir);
                  struct PathNode *node;

                  dir = lock->fl_Link;
                  dir2 = DupLock(lock->fl_Key);
                  if (!dir2) break;
                  node = AllocVec(sizeof(struct PathNode), MEMF_PUBLIC);
                  if (!node)
                  {
                     UnLock(dir2);
                     break;
                  }
                  node->next = 0;
                  node->dir = dir2;
                  *p = MKBADDR(node);
                  p = &node->next;
               }
            }
         }
      }
   }
   Permit();

   return path;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void FreeWorkbenchPath(BPTR path)
{
   while (path)
   {
      struct PathNode *node = BADDR(path);
      path = node->next;
      UnLock(node->dir);
      FreeVec(node);
   }
}

