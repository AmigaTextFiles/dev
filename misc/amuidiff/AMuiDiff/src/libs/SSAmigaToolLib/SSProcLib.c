/********************************************************************
*      Societe                   :
*      Projet                    :
*      Tache                     :  Librairie d'outils de base Amiga
*
*      Nom du module             :  $RCSfile: SSProcLib.c,v $
*      Version du module         :  $Revision: 1.5 $
*      Date de la version        :  $Date: 2004/01/24 19:01:59 $
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
#include <stdio.h> //SS-TBD : A virer a terme ?
#include <string.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>

#include <clib/debug_protos.h> //SS-TBD a virer


/*******************************************************************
 * TYPES
*******************************************************************/
typedef struct
{
	struct Node    sspn_node;
	struct Process *sspn_proc;
	struct MsgPort *sspn_msgport;
} ss_proclist_node_t;

typedef struct
{
	char *sspe_name;
	char *sspe_params;
} ss_procmsg_exedata_t;

typedef struct
{
	void (*sspf_func)(void*);
	void *sspf_arg;
} ss_procmsg_funcdata_t;

typedef enum
{
	SSPROC_CMD_REGISTER,
	SSPROC_CMD_UNREGISTER,
	SSPROC_CMD_TASKMGR_START,
	SSPROC_CMD_TASKMGR_STOP,
	SSPROC_CMD_LAUNCHEXE,
	SSPROC_CMD_LAUNCHFUNC,
	SSPROC_CMD_JOIN,
	SSPROC_CMD_SUSPEND,
} ss_procmsg_cmd_t;

typedef struct
{
	struct Message   spm_msg;	 /* Message Header */
	ss_procmsg_cmd_t spm_cmd;
	unsigned long    spm_commanddata;
	unsigned long    spm_replydata;
} ss_procmsg_t;

/*******************************************************************
 * DECLARATION DES VARIABLES LOCALES
*******************************************************************/
static struct List SsProcList;

static struct MsgPort *TaskMgrPort = NULL;
static struct Process *TaskMgrTask;
static struct MsgPort *SelfPort;


/*******************************************************************
 * DECLARATION DES FONCTIONS
*******************************************************************/
long CreateProcessExe(char *pm_exe, char *pm_args);
long CreateProcessFunc(void (*pm_func)(void*), void *pm_arg);
long ssproc_Init(void);
void ssproc_End(void);

static void ssproc_ProcManager(void);
static ss_proclist_node_t* ssproc_LaunchAmigaDos(char *pm_command, char *pm_arg, struct MsgPort *pm_msgport);
static ss_proclist_node_t* ssproc_LaunchFunc(void (*pm_func)(void*), void *pm_arg, struct MsgPort *pm_msgport);
static void ssproc_LaunchAmigaDos_Proc(void);
static void ssproc_LaunchFunc_Proc(void);
static ss_procmsg_exedata_t * NEW_ss_procmsg_exedata(char *pm_exe, char *pm_args);
static long DEL_ss_procmsg_exedata(ss_procmsg_exedata_t *pm_exedata);
static char *AmigaPublicStrdup(char *pm_str);
static char* AmigaPublicStrdup3(char *pm_str1, char *pm_str2, char *pm_str3);

//static LONG ssproc_Register(ULONG pm_tid);
//static void ssproc_Unregister(ULONG pm_taskid_reg);

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
long CreateProcessExe(char *pm_exe, char *pm_args)
{
	ss_procmsg_t   			*regmsg;
	ss_procmsg_t   			*retregmsg;
	ss_procmsg_exedata_t	*exedata;

	// -------------------
	// Args Tests
	// -------------------
	if((SelfPort == NULL)||(TaskMgrPort) == NULL||(pm_exe == NULL)) return -1;

	// -------------------
	// Start Message allocation
	// -------------------
	regmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(regmsg == NULL)
	{
		return -2;
	}
	regmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	regmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	regmsg->spm_msg.mn_ReplyPort    = SelfPort;
	regmsg->spm_cmd                 = SSPROC_CMD_LAUNCHEXE;

	exedata = NEW_ss_procmsg_exedata(pm_exe, pm_args);
	if(exedata == NULL)
	{
        FreeVec(regmsg);
		return -3;
	}
	regmsg->spm_commanddata = (unsigned long)exedata; //data sent

	// -------------------
	// Send message to the TaskManager
	// -------------------
	PutMsg(TaskMgrPort, (struct Message*)regmsg);

	// -------------------
	// Wait for the answer from the TaskManager
	// -------------------
	WaitPort(SelfPort);
	retregmsg = (ss_procmsg_t*)GetMsg(SelfPort);
	if(retregmsg == NULL)
	{	
		if(exedata != NULL) DEL_ss_procmsg_exedata(exedata);
		return -4;
	}

//	  printf("answer=%lu\n", retregmsg->spm_replydata); //data received

	if(exedata != NULL) DEL_ss_procmsg_exedata(exedata);
	if(regmsg != NULL) FreeVec(regmsg);

	return 0;
}


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
long CreateProcessFunc(void (*pm_func)(void*), void *pm_arg)
{
	ss_procmsg_t   			*regmsg;
	ss_procmsg_t   			*retregmsg;
	ss_procmsg_funcdata_t   *funcdata;

	// -------------------
	// Tests
	// -------------------
	if((SelfPort == NULL)||(TaskMgrPort) == NULL||(pm_func == NULL)) return -1;

	// -------------------
	// Start Message allocation
	// -------------------
	regmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(regmsg == NULL)
	{
		return -2;
	}
	regmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	regmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	regmsg->spm_msg.mn_ReplyPort    = SelfPort;
	regmsg->spm_cmd                 = SSPROC_CMD_LAUNCHFUNC;
	funcdata = AllocVec(sizeof(ss_procmsg_funcdata_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(funcdata == NULL)
	{
        FreeVec(regmsg);
		return -3;
    }
	funcdata->sspf_func = pm_func;
	funcdata->sspf_arg  = pm_arg;
	regmsg->spm_commanddata 		= (unsigned long)funcdata; //data sent

	// -------------------
	// Send message to the TaskManager
	// -------------------
	PutMsg(TaskMgrPort, (struct Message*)regmsg);

	// -------------------
	// Wait for the answer from the TaskManager
	// -------------------
	WaitPort(SelfPort);
	retregmsg = (ss_procmsg_t*)GetMsg(SelfPort);
	if(retregmsg == NULL)
	{
		if(funcdata != NULL) 	FreeVec(funcdata);
		return -4;
	}

//	  printf("answer=%lu\n", retregmsg->spm_replydata); //data received

	if(funcdata != NULL) 	FreeVec(funcdata);
	if(regmsg != NULL) 		FreeVec(regmsg);

	return 0;
}


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
long ssproc_Init(void)
{
	ss_procmsg_t   *regmsg;
	ss_procmsg_t   *retregmsg;

	// -------------------
	// Parent Port Creation
	// -------------------
	SelfPort = CreateMsgPort();
	if(SelfPort == NULL) return -1;


	// -------------------
	// Start Message allocation for TaskManager Process
	// -------------------
	regmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(regmsg == NULL)
	{
		DeleteMsgPort(SelfPort);
		SelfPort = NULL;
		return -2;	  
	}
	regmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	regmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	regmsg->spm_msg.mn_ReplyPort    = SelfPort;
	regmsg->spm_cmd                 = SSPROC_CMD_TASKMGR_START;


	// -------------------
	// TaskManager Process creation
	// -------------------
#ifdef __MORPHOS__
	TaskMgrTask = CreateNewProcTags(NP_Entry, ssproc_ProcManager,
									 NP_Name,  "SSTaskManager",
									 NP_CodeType, MACHINE_PPC,
									 TAG_DONE);
#else
	TaskMgrTask = CreateNewProcTags(NP_Entry, ssproc_ProcManager,
									 NP_Name,  "SSTaskManager",
									 TAG_DONE);
#endif
	if(TaskMgrTask == NULL)
	{
		FreeVec(regmsg);
		DeleteMsgPort(SelfPort);
		SelfPort = NULL;
		return -3;
	}

	// -------------------
	// Send "start message" to the TaskManager
	// -------------------
	PutMsg(&(TaskMgrTask->pr_MsgPort), (struct Message*)regmsg);

	// -------------------
	// Wait for the answer from the TastManager : means the TaskManager is OK
	// -------------------
	WaitPort(SelfPort);
	retregmsg = (ss_procmsg_t*)GetMsg(SelfPort);
	if(retregmsg == NULL)	return -4;

	TaskMgrPort =  (struct MsgPort*)(retregmsg->spm_replydata);
	FreeVec(regmsg);

	return 0;
}

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
void ssproc_End(void)
{
	ss_procmsg_t   *unregmsg;
	ss_procmsg_t   *retunregmsg;

	if((TaskMgrPort == NULL) || (TaskMgrTask == NULL) ||(SelfPort == NULL)) return;

	// -------------------
	// Start Message allocation for TaskManager Process
	// -------------------
	unregmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(unregmsg == NULL)  return;

	unregmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	unregmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	unregmsg->spm_msg.mn_ReplyPort    = SelfPort;
	unregmsg->spm_cmd                 = SSPROC_CMD_TASKMGR_STOP;

	// -------------------
	// Send "end message" to the TaskManager
	// -------------------
	PutMsg(TaskMgrPort, (struct Message*)unregmsg);

	// -------------------
	// Wait for the answer from the TastManager :
	// Means the TaskManager and all other task have completed
	// -------------------
	WaitPort(SelfPort);
	retunregmsg = (ss_procmsg_t*)GetMsg(SelfPort);
	if(retunregmsg == NULL)	return;

	FreeVec(unregmsg);
	DeleteMsgPort(SelfPort);

	return;
}

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
static ss_procmsg_exedata_t * NEW_ss_procmsg_exedata(char *pm_exe, char *pm_args)
{
	ss_procmsg_exedata_t	*exedata;

	if(pm_exe == NULL) return NULL;

	exedata = AllocVec(sizeof(ss_procmsg_exedata_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(exedata == NULL)
	{
		return NULL;
	}
	exedata->sspe_name = AllocVec(strlen(pm_exe) + 1, MEMF_PUBLIC|MEMF_CLEAR);
	if(exedata->sspe_name == NULL)
	{
        FreeVec(exedata);
		return NULL;
	}
	strncpy(exedata->sspe_name, pm_exe, strlen(pm_exe) + 1);
	if(pm_args != NULL)
	{
		exedata->sspe_params = AllocVec(strlen(pm_args) + 1, MEMF_PUBLIC|MEMF_CLEAR);
		if(exedata->sspe_params == NULL)
		{
			FreeVec(exedata->sspe_name);
			FreeVec(exedata);
			return NULL;
		}
		strncpy(exedata->sspe_params, pm_args, strlen(pm_args) + 1);
	}
	else
	{
		exedata->sspe_params = NULL;
	}

	return exedata;
}

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
static long DEL_ss_procmsg_exedata(ss_procmsg_exedata_t *pm_exedata)
{
	if(pm_exedata == NULL) return -1;

	if((pm_exedata->sspe_params) != NULL) 	FreeVec(pm_exedata->sspe_params);
	if((pm_exedata->sspe_name) != NULL) 	FreeVec(pm_exedata->sspe_name);
	if(pm_exedata != NULL) 				   FreeVec(pm_exedata);

	return 0;
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 1 Octobre 2003
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
static void ssproc_ProcManager(void)
{
	ss_procmsg_t   *die_msg        = NULL;
	ss_procmsg_t   *procmgr_msg    = NULL;
	struct MsgPort *procmgr_port   = NULL;
	struct MsgPort *parent_port    = NULL;
	struct Process *procmgr_task   = (struct Process*)FindTask(0);
	ss_proclist_node_t *node       = NULL;
	BOOL must_die                  = FALSE;
	BOOL can_die                   = TRUE;

	// -------------------
	// Wait for the parent startup msg
	// -------------------
	WaitPort(&(procmgr_task->pr_MsgPort));
	procmgr_msg = (ss_procmsg_t*)GetMsg(&(procmgr_task->pr_MsgPort));
	if(procmgr_msg == NULL) return; // It cannot happen...
	parent_port = (procmgr_msg->spm_msg).mn_ReplyPort;
	if(parent_port == NULL) return; // It cannot happen...

	// -------------------
	// Create the TaskManager MsgPort
	// -------------------
	procmgr_port = CreateMsgPort();
	if((procmgr_port == NULL))
	{
		procmgr_msg->spm_replydata = (unsigned long)NULL; // Inform the parent task CreateMsgPort() failed...
		Forbid();                 // Make the current task no more exists when the parent task is awaken
		ReplyMsg((struct Message*)procmgr_msg);        // Reply to the parent
		return;
	}

	// -------------------
	// Reply to the Parent which will register the task !!
	// -------------------
	else
	{
		procmgr_msg->spm_replydata = (unsigned long)procmgr_port;
		ReplyMsg((struct Message*)procmgr_msg);        // Reply to the parent
	}

	//
	// -------------------
	NewList(&SsProcList);

	// -------------------
	// Wait for Commands
	// -------------------
	while((must_die == FALSE) || (can_die == FALSE)) //forever
	{
		WaitPort(procmgr_port);
		while((procmgr_msg = (ss_procmsg_t*)GetMsg(procmgr_port)) != NULL)
		{
			switch(procmgr_msg->spm_cmd)
			{
				// From Application
				// -------------------
				case SSPROC_CMD_TASKMGR_STOP:
					die_msg  = procmgr_msg;
					must_die = TRUE;
				break;
		
				case SSPROC_CMD_LAUNCHEXE:
					{
						ss_procmsg_exedata_t *exe_data = (ss_procmsg_exedata_t*)(procmgr_msg->spm_commanddata);
						if((exe_data == NULL) || ((exe_data->sspe_name) == NULL)) break;

						node  = ssproc_LaunchAmigaDos(exe_data->sspe_name, exe_data->sspe_params, procmgr_port);
						if(node != NULL)
						{
							AddTail(&SsProcList, (struct Node*)node);
							can_die = FALSE;
						}
					}
				break;

				case SSPROC_CMD_LAUNCHFUNC:
					{
						ss_procmsg_funcdata_t *func_data = (ss_procmsg_funcdata_t*)(procmgr_msg->spm_commanddata);
						if((func_data == NULL) || ((func_data->sspf_func) == NULL)) break;

						node  = ssproc_LaunchFunc(func_data->sspf_func, func_data->sspf_arg, procmgr_port);
						if(node != NULL)
						{
							AddTail(&SsProcList, (struct Node*)node);
							can_die = FALSE;
						}
					}
				break;

				// From Tasks
				// -------------------
				case SSPROC_CMD_UNREGISTER:
					node = (ss_proclist_node_t*)(SsProcList.lh_Head);    //SS-TBD : tester liste pas NULL
					while(node != NULL)
					{
						if(node->sspn_proc == ((struct Process*)(procmgr_msg->spm_replydata)))
						{
							Remove((struct Node*)node);
							FreeVec(node);
							break;
						}

						if(node == (ss_proclist_node_t*)(SsProcList.lh_TailPred)) break;
						node = (ss_proclist_node_t*)(node->sspn_node.ln_Succ);
					}

					if(IsListEmpty(&SsProcList) == TRUE)
					{
						can_die = TRUE;
					}
					break;

				default:
				break;
			} // switch(procmgr_msg->spm_cmd)

			if((procmgr_msg->spm_cmd) != SSPROC_CMD_TASKMGR_STOP)
			{
				if((((procmgr_msg->spm_msg).mn_Node).ln_Type) == NT_MESSAGE)
					ReplyMsg((struct Message*)procmgr_msg);
				else
					FreeVec(procmgr_msg);
			}
		} //while((procmgr_msg = (...
	} //while(1)

	// -------------------
	// Release
	// -------------------
	Forbid();
	if(die_msg != NULL)
	{
		ReplyMsg((struct Message*)die_msg);
		DeleteMsgPort(procmgr_port);
	}
}                       

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 7 Decembre 2003
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
static ss_proclist_node_t* ssproc_LaunchAmigaDos(char *pm_command, char *pm_arg, struct MsgPort *pm_msgport)
{
	ss_procmsg_t   *regmsg;
	ss_procmsg_t   *retregmsg;
	struct Process *proc;
	ss_proclist_node_t *node;

	if((pm_msgport == NULL)||(pm_command == NULL))
	{
//		  SSDEBUG("cannot launch task\n");
		return NULL;
	}

	// -------------------
	// Start Message allocation for TaskManager Process
	// -------------------
	regmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(regmsg == NULL) return NULL;
	regmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	regmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	regmsg->spm_msg.mn_ReplyPort    = pm_msgport;
	regmsg->spm_cmd                 = SSPROC_CMD_REGISTER;
	regmsg->spm_commanddata         = (unsigned long)AmigaPublicStrdup3(pm_command, " ", pm_arg);

	// -------------------
	// TaskManager Process creation
	// -------------------
#ifdef __MORPHOS__
	proc = CreateNewProcTags(NP_Entry, ssproc_LaunchAmigaDos_Proc,
									 NP_Name,  "SSTask",
									 NP_CodeType, MACHINE_PPC,
									 TAG_DONE);
#else
	proc = CreateNewProcTags(NP_Entry, ssproc_LaunchAmigaDos_Proc,
									 NP_Name,  "SSTask",
									 TAG_DONE);
#endif
	if(proc == NULL)
	{
		FreeVec(regmsg);
		return NULL;
	}

	// -------------------
	// Send "start message" to the created task
	// -------------------
	PutMsg(&(proc->pr_MsgPort), (struct Message*)regmsg);

	// -------------------
	// Wait for the answer from the created task
	// -------------------
	WaitPort(pm_msgport);
	retregmsg = (ss_procmsg_t*)GetMsg(pm_msgport);
	if(retregmsg == NULL)	return NULL;

	// -------------------
	// Set return data
	// -------------------
	node = AllocVec(sizeof(ss_procmsg_t), MEMF_ANY);
	if(node == NULL)
	{
		FreeVec(regmsg);
		return NULL;
	}
	node->sspn_proc    = proc;
	node->sspn_msgport = (struct MsgPort*)(retregmsg->spm_replydata);
	if((regmsg->spm_commanddata) != ((unsigned long)NULL)) FreeVec((void*)(regmsg->spm_commanddata));
	FreeVec(regmsg);

	// -------------------
	// Send the UNREGISTER msg to make the task exit as soon the command is executed
	// -------------------
	regmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(regmsg == NULL)
	{
		FreeVec(node);
		return NULL;
	}
	regmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	regmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	regmsg->spm_msg.mn_ReplyPort    = pm_msgport;
	regmsg->spm_cmd                 = SSPROC_CMD_UNREGISTER;
	regmsg->spm_commanddata         = (unsigned long)NULL;
	PutMsg(node->sspn_msgport, (struct Message*)regmsg);

	return node;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 7 Decembre 2003
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
static ss_proclist_node_t* ssproc_LaunchFunc(void (*pm_func)(void*), void *pm_arg, struct MsgPort *pm_msgport)
{
	ss_procmsg_t   			*regmsg;
	ss_procmsg_t   			*retregmsg;
	struct Process 			*proc;
	ss_proclist_node_t 		*node;
	ss_procmsg_funcdata_t   *funcdata;

	if((pm_msgport == NULL)||(pm_func == NULL))
	{
//		  SSDEBUG("cannot launch task\n");
		return NULL;
	}

	// -------------------
	// Start Message allocation for TaskManager Process
	// -------------------
	regmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(regmsg == NULL) return NULL;
	regmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	regmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	regmsg->spm_msg.mn_ReplyPort    = pm_msgport;
	regmsg->spm_cmd                 = SSPROC_CMD_REGISTER;
	funcdata = AllocVec(sizeof(ss_procmsg_funcdata_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(funcdata == NULL)
	{
        FreeVec(regmsg);
		return NULL;
    }
	funcdata->sspf_func = pm_func;
	funcdata->sspf_arg  = pm_arg;
	regmsg->spm_commanddata         = (unsigned long)funcdata;

	// -------------------
	// TaskManager Process creation
	// -------------------
#ifdef __MORPHOS__
	proc = CreateNewProcTags(NP_Entry, ssproc_LaunchFunc_Proc,
									 NP_Name,  "SSTask",
									 NP_CodeType, MACHINE_PPC,
									 TAG_DONE);
#else
	proc = CreateNewProcTags(NP_Entry, ssproc_LaunchFunc_Proc,
									 NP_Name,  "SSTask",
									 TAG_DONE);
#endif
	if(proc == NULL)
	{
		FreeVec(regmsg);
		return NULL;
	}

	// -------------------
	// Send "start message" to the created task
	// -------------------
	PutMsg(&(proc->pr_MsgPort), (struct Message*)regmsg);

	// -------------------
	// Wait for the answer from the created task
	// -------------------
	WaitPort(pm_msgport);
	retregmsg = (ss_procmsg_t*)GetMsg(pm_msgport);
	if(retregmsg == NULL) return NULL;

	// -------------------
	// Set return data
	// -------------------
	node = AllocVec(sizeof(ss_procmsg_t), MEMF_ANY);
	if(node == NULL)
	{
		FreeVec(regmsg);
		return NULL;
	}
	node->sspn_proc    = proc;
	node->sspn_msgport = (struct MsgPort*)(retregmsg->spm_replydata);
	if((regmsg->spm_commanddata) != ((unsigned long)NULL)) FreeVec((void*)(regmsg->spm_commanddata));
	FreeVec(regmsg);

	// -------------------
	// Send the UNREGISTER msg to make the task exit as soon the command is executed
	// -------------------
	regmsg = AllocVec(sizeof(ss_procmsg_t), MEMF_PUBLIC|MEMF_CLEAR);
	if(regmsg == NULL)
	{
		FreeVec(node);
		return NULL;
	}
	regmsg->spm_msg.mn_Node.ln_Type = NT_MESSAGE;
	regmsg->spm_msg.mn_Length       = sizeof(ss_procmsg_t);
	regmsg->spm_msg.mn_ReplyPort    = pm_msgport;
	regmsg->spm_cmd                 = SSPROC_CMD_UNREGISTER;
	regmsg->spm_commanddata         = (unsigned long)NULL;
	PutMsg(node->sspn_msgport, (struct Message*)regmsg);

	return node;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 7 Decembre 2003
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
static void ssproc_LaunchFunc_Proc(void)
{
	BPTR 			con_out 		= NULL;
	ss_procmsg_t   	*parent_msg  	= NULL;
	struct MsgPort 	*self_port   	= NULL;
	struct MsgPort 	*parent_port 	= NULL;
	struct Process 	*self_proc   	= (struct Process*)FindTask(0);
	void 			(*func)(void*) 	= NULL;
	void 			*arg           	= NULL;
	BPTR 			old_output 		= NULL;

	// -------------------
	// - INITIALISATIONS -
	// -------------------

	// Wait for the parent startup msg
	// -------------------
	WaitPort(&(self_proc->pr_MsgPort));
	parent_msg = (ss_procmsg_t*)GetMsg(&(self_proc->pr_MsgPort));
	if(parent_msg == NULL) return; // It cannot happen...
	parent_port = (parent_msg->spm_msg).mn_ReplyPort;
	if(parent_port == NULL) return; // It cannot happen...

	if((parent_msg->spm_commanddata) != ((unsigned long)NULL))
	{
		ss_procmsg_funcdata_t   *funcdata = (ss_procmsg_funcdata_t*)(parent_msg->spm_commanddata);
		func = funcdata->sspf_func;
		arg  = funcdata->sspf_arg;
	}

	// Create the Task MsgPort
	// -------------------
	self_port = CreateMsgPort();
	if((self_port == NULL))
	{
		parent_msg->spm_replydata = (unsigned long)NULL; // Inform the parent task CreateMsgPort() failed...
		Forbid();                 // Make the current task no more exists when the parent task is awaken
		ReplyMsg((struct Message*)parent_msg);        // Reply to the parent
		return;
	}

	// Reply to the TaskManager which will register the task !!
	// -------------------
	else
	{
		parent_msg->spm_replydata = (unsigned long)self_port;
		ReplyMsg((struct Message*)parent_msg);        // Reply to the parent
	}

	// Wait for the UNREGISTER command
	// -------------------
	WaitPort(self_port);
	parent_msg = (ss_procmsg_t*)GetMsg(self_port);
	if(parent_msg == NULL)
	{
		if(self_port != NULL) 	DeleteMsgPort(self_port);
		return; // It cannot happen...
	}
	parent_msg->spm_replydata = (unsigned long)self_proc; // Inform the parent which tasks exited

	// -------------------
	// - Openning the output console -
	// -------------------
	con_out = Open("CON:80/450/500/250/SSTask Output/CLOSE/AUTO", MODE_READWRITE);
	if(con_out == NULL)
	{
		Forbid();                 // Make the current task no more exists when the parent task is awaken
		ReplyMsg((struct Message*)parent_msg);        // Reply to the parent
		DeleteMsgPort(self_port);
		return;
	}
    old_output = SelectOutput(con_out);

    // -------------------
	// - Launch the function -
	// -------------------
	if(func != NULL)
	{
		func(arg);
	}

    // -------------------
	// - Release...-
	// -------------------
	if(old_output != NULL) (void)SelectOutput(old_output); // Old output stream is set again
	if(con_out != NULL) 	Close(con_out);
	if(self_port != NULL) 	DeleteMsgPort(self_port);
	Forbid();
	ReplyMsg((struct Message*)parent_msg);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 7 Decembre 2003
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
static void ssproc_LaunchAmigaDos_Proc(void)
{
	BOOL 			ret 			= TRUE;
	BPTR 			con_out 		= NULL;
	ss_procmsg_t   	*parent_msg  	= NULL;
	struct MsgPort 	*self_port   	= NULL;
	struct MsgPort 	*parent_port 	= NULL;
	struct Process 	*self_proc   	= (struct Process*)FindTask(0);
	char 			*command 		= NULL;

	// -------------------
	// - INITIALISATIONS -
	// -------------------

	// Wait for the parent startup msg
	// -------------------
	WaitPort(&(self_proc->pr_MsgPort));
	parent_msg = (ss_procmsg_t*)GetMsg(&(self_proc->pr_MsgPort));
	if(parent_msg == NULL) return; // It cannot happen...
	parent_port = (parent_msg->spm_msg).mn_ReplyPort;
	if(parent_port == NULL) return; // It cannot happen...

	command = AmigaPublicStrdup((char*)(parent_msg->spm_commanddata));

	// Create the Task MsgPort
	// -------------------
	self_port = CreateMsgPort();
	if((self_port == NULL)||(command == NULL))
	{
		if(command != NULL) FreeVec(command);
		if(self_port != NULL) 	DeleteMsgPort(self_port);
		parent_msg->spm_replydata = (unsigned long)NULL; // Inform the parent task CreateMsgPort() failed...
		Forbid();                 // Make the current task no more exists when the parent task is awaken
		ReplyMsg((struct Message*)parent_msg);        // Reply to the parent
		return;
	}

	// Reply to the TaskManager which will register the task !!
	// -------------------
	else
	{
		parent_msg->spm_replydata = (unsigned long)self_port;
		ReplyMsg((struct Message*)parent_msg);        // Reply to the parent
	}

	// Wait for the UNREGISTER command
	// -------------------
	WaitPort(self_port);
	parent_msg = (ss_procmsg_t*)GetMsg(self_port);
	if(parent_msg == NULL)
	{
		if(command != NULL) FreeVec(command);
		if(self_port != NULL) 	DeleteMsgPort(self_port);
		return; // It cannot happen...
	}
	parent_msg->spm_replydata = (unsigned long)self_proc; // Inform the parent which tasks exited

	// -------------------
	// - Openning the output console -
	// -------------------
	con_out = Open("CON:80/450/500/250/SSTask Output/CLOSE/AUTO", MODE_READWRITE);
	if(con_out == NULL)
	{
		if(command != NULL) FreeVec(command);
		DeleteMsgPort(self_port);
		Forbid();                 // Make the current task no more exists when the parent task is awaken
		ReplyMsg((struct Message*)parent_msg);        // Reply to the parent
		return;
	}

    // -------------------
	// - Launch the AmigaDos command -
	// -------------------
	if(command != NULL)
	{
		ret = SystemTags(command,
						 SYS_Output, NULL,
						 SYS_Input, con_out,
						 TAG_DONE);
		if(ret == -1)
		{            //SS-TBD : handle error
//			  SSDEBUG("error\n");
		}
	}

    // -------------------
	// - Release...-
	// -------------------
	if(con_out != NULL) 	Close(con_out);
	if(command != NULL) 	FreeVec(command);
	if(self_port != NULL) 	DeleteMsgPort(self_port);
	Forbid();
	ReplyMsg((struct Message*)parent_msg);
}


/******************************************************************
 * Procedure         : ss_strdup3
 *
 * Description       :
 *
 * Parametre entree  :
 *
 * Parametre sortie  :
 *
 * Valeur retournee  :
 *
 * Date Fonction     : Tue Apr 15 14:10:35 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
static char* AmigaPublicStrdup3(char *pm_str1, char *pm_str2, char *pm_str3)
{
	char *new_str   = NULL;
	size_t new_str_len = 0;

	if((pm_str1 == NULL)&&(pm_str2 == NULL)&&(pm_str3 == NULL))
	{
		return NULL;
	}

	if(pm_str1 != NULL) new_str_len+= strlen(pm_str1);
	if(pm_str2 != NULL) new_str_len+= strlen(pm_str2);
	if(pm_str3 != NULL) new_str_len+= strlen(pm_str3);
	new_str_len+= 1; // '\0'
	new_str = AllocVec(new_str_len*sizeof(char), MEMF_PUBLIC|MEMF_CLEAR);
	if(new_str == NULL)
	{
		return NULL;
	}
	if(pm_str1 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str1);
	if(pm_str2 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str2);
	if(pm_str3 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str3);

	return new_str;
}

/******************************************************************
 * Procedure         : AmigaPublicStrdup
 *
 * Description       : Alloue une nouvelle chaine de caractères, y copie
 *		       celle passee en parametre.
 *
 * Parametre entree  : pm_str : chaine d'initialisation
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : char* : nouvelle chaine allouee par malloc,
 *				copie de pm_str.
 *
 * Date Fonction     : Tue Aug 13 11:37:51 2002,

 * Auteur            : SS
 *
 ******************************************************************/
static char *AmigaPublicStrdup(char *pm_str)
{
  char *str_tmp = NULL;

  if(pm_str == NULL) return NULL;

  str_tmp = AllocVec((strlen(pm_str)+1)*sizeof(char), MEMF_PUBLIC|MEMF_CLEAR);
  if(str_tmp == NULL) return NULL;

  strcpy(str_tmp, pm_str);
  return str_tmp;
}

