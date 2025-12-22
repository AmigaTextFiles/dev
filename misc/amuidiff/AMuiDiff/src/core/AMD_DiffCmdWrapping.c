/****************************************************************************
*      Society                   :  -
*      Project                   :  AMuiDiff
*
*      Creation author           :  Stephane SARAGAGLIA
*      Module name               :  $RCSfile: AMD_DiffCmdWrapping.c,v $
*      Module version            :  $Revision: 1.13 $
*      Current version date      :  $Date: 2004/03/16 20:18:26 $
*
*      Description               :
*
*      System                    :  AmigaOS/MorphOS
*
*      Programmation language    :  ISO-C (sometimes)
*      Creation date             :
*
*      Prefixe                   : -
*
*      References                : -
*
*         No Copyright - Please send me a version of
*         any modification of this source...
*                ----------------------------------
*
*      CVS history               :
*         $Log: AMD_DiffCmdWrapping.c,v $
*         Revision 1.13  2004/03/16 20:18:26  sara
*         SS : CHG : FreeWorkbenchPath(path) is now performed only if System() fails.
*
*         Revision 1.12  2004/03/13 12:21:27  sara
*         SS : CHG : system() replaced by Execute() when AMuidiff have its own PATH
*
*         Revision 1.11  2004/03/07 19:37:29  sara
*         SS : ADD : The diff command is now launched differently accordind to the
*         		   way AMuiDiff is launched : WB or cli. If launched from WB,
*         		   AMuiDiff retrieve the PATH from the WB...
*
*         Revision 1.10  2003/11/15 17:13:41  sara
*         SS : DEL : removed all sskprintf
*
*         Revision 1.9  2003/09/28 14:45:48  sara
*         SS : ADD : debug traces
*
*         Revision 1.8  2003/06/21 16:39:10  sara
*         SS : CHG : Added comments
*         	 CHG : Changed the debug log management
*
*
*****************************************************************************/

/****************************************************************************
 * INCLUDES.
 ****************************************************************************/

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <exec/types.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <workbench/startup.h>
#include <proto/dos.h>

// --------------------------------------------------------------------------
// SS Lib
// --------------------------------------------------------------------------
#include "SSListLib_protos.h"
#include "SSIoLib_protos.h"
#include "SSStrLib_protos.h"

// --------------------------------------------------------------------------
// AMuiDiff
// --------------------------------------------------------------------------
#include "ss_lib_tools_protos.h"
#include "ss_amiga_lib_tools_protos.h"
#include "AMD_DiffCmdWrapping.h"

/****************************************************************************
 * DEFINES.
 ****************************************************************************/
#define DIFF_CMD 			"diff"
#define DIFF_RESULT_FILE    "T:amuidiff"

/****************************************************************************
 * TYPES.
 ****************************************************************************/
typedef enum
{
	AMDAF_INIT,
	AMDAF_LIGNE1A,
	AMDAF_LIGNE1B,
	AMDAF_TYPEDIFF,
	AMDAF_LIGNE2A,
	AMDAF_LIGNE2B,
	AMDAF_FIN
}amd_af_t;


extern struct WBStartup * WBmsg;

/****************************************************************************
 * SIGNATURES DE FONCTIONS.
 ****************************************************************************/

// --------------------------------------------------------------------------
// Fonctions exportees
// --------------------------------------------------------------------------
ss_list_t* amd_analyse_files(const char *pm_file1, const char *pm_file2, const char *pm_options, char **pm_resultfile);
void amd_af_release_result_list(ss_list_t *pm_diff_list);

// --------------------------------------------------------------------------
// Fonctions locales
// --------------------------------------------------------------------------
static char* amd_af_build_result(const char *pm_file1, const char *pm_file2, const char *pm_options);
static ss_list_t* amd_af_analyse_result(const char *pm_result_file);


/****************************************************************************
 * DEFINITION DE FONCTIONS.
 ****************************************************************************/

// *************************************************************************
// amd_analyse_files()
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
ss_list_t* amd_analyse_files(const char *pm_file1, const char *pm_file2, const char *pm_options, char **pm_resultfile)
{
	ss_list_t *diff_list = NULL;

	// -------------------
	// Test d'integrite des parametres
	// -------------------
	if((pm_file1 == NULL)||(pm_file2 == NULL))	  return NULL;

	// -------------------
	// Invocation de la commande diff et fabrication du fichier de resultat
	// -------------------
	*pm_resultfile = amd_af_build_result(pm_file1, pm_file2, (pm_options != NULL) ? pm_options : "");
	if((*pm_resultfile) != NULL)
	{
		// Analyse de ce fichier de resultat
		// -------------------
		diff_list = amd_af_analyse_result(*pm_resultfile);
	}
#if DEBUG
	else
	{
		SS_ADDLOG_DEBUG("amd_analyse_files/amd_af_build_result : error");
	}
	if(diff_list == NULL) SS_ADDLOG_DEBUG("amd_af_analyse_result : error");
#endif

	return diff_list;
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
static char* amd_af_build_result(const char *pm_file1, const char *pm_file2, const char *pm_options)
{
	char *commande    = NULL;
	int  commande_len = 0;
	char *diff_result_file = NULL;
	int i = 0;
	char str_filenumber[8];
	int ret = 0;

	// -------------------
	// Test d'integrite des parametres
	// -------------------
	if((pm_file1 == NULL)||(pm_file2 == NULL)||(pm_options == NULL))	return NULL;

	for(i=0; i<20; i++)
	{
		FILE *fd = NULL;
		sprintf(str_filenumber, ".%ld", (long)i);
		diff_result_file = (char*)ss_strdup2(DIFF_RESULT_FILE, str_filenumber);
		if(diff_result_file != NULL)
		{
			fd = fopen(diff_result_file, "w");
			if(fd != NULL)
			{
				fclose(fd);
				fd = NULL;
				break;
			} // if(fd != NULL)
		} // if(diff_result_file != NULL)
	} // for(i=0; i<20; i++)
	if(diff_result_file == NULL) return NULL;

	// -------------------
	// Fabrication de la commande d'invocation
	// -------------------
	commande_len = strlen(DIFF_CMD)
					+ strlen(" ")
					+ strlen(pm_options)
					+ strlen(" \"")
					+ strlen(pm_file1)
					+ strlen("\" \"")
					+ strlen(pm_file2)
					+ strlen("\" >")
					+ (4*strlen("\""))
					+ strlen(diff_result_file)   //SS-TBD : prevoir de gerer protection ecriture...
					+ 1; // "\0"
	commande = malloc(commande_len*sizeof(char));
	if(commande == NULL)	
	{
		if(diff_result_file != NULL) {free(diff_result_file); diff_result_file = NULL;}
		return NULL;
	}

	sprintf(commande, "%s%s%s%s%s%s%s%s%s", DIFF_CMD, " ", pm_options, " \"", pm_file1, "\" \"", pm_file2, "\" >", diff_result_file);

	// -------------------
	// Invocation de la commande diff et fabrication du fichier resultat
	// -------------------
	if(WBmsg == NULL) // If launched from cli, the PATH should be OK...
	{
		//system(commande);
		BPTR in  = Open("NIL:", MODE_READWRITE);
		BPTR out = Open("NIL:", MODE_READWRITE);
		Execute(commande, in, out);
		Close(in);
		Close(out);
	}
	else              // If launched from WB, we add the WB PATH
	{
		BPTR path = CloneWorkbenchPath(WBmsg);
		if(path != 0)
		{
			ret = SystemTags(commande, NP_Path, path, TAG_DONE);
//SS : It seems the free is performed in SystemTags...			  FreeWorkbenchPath(path);
			if(ret == -1) FreeWorkbenchPath(path);
		}
	}

#ifdef DEBUG
	if(ret == -1) SS_ADDLOG_DEBUG("amd_af_build_result : system call error");
#endif

	// -------------------
	// Liberation
	// -------------------
	if(commande != NULL)
	{
		free(commande);
		commande = NULL;
	}

	return diff_result_file;
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
static ss_list_t* amd_af_analyse_result(const char *pm_result_file)
{
	FILE *fd = NULL;
	char *buffer = NULL;
	char ligne1a[32];
	char ligne1b[32];
	char ligne2a[32];
	char ligne2b[32];
	long tmp_long = 0;
	amd_af_t state = AMDAF_INIT;
	ss_list_t *diff_list = NULL;
	BOOL is_buffer_empty = TRUE;

	// -------------------
	// Test d'integrite des parametres
	// -------------------
	if(pm_result_file == NULL) return NULL;

	// -------------------
	// Ouverture du fichier d'analyse de diff
	// -------------------
	fd = fopen(pm_result_file, "r");
	if(fd == NULL)	return NULL;

	// -------------------
	// Allocation de la liste des resultats
	// -------------------
	diff_list = malloc(sizeof(ss_list_t));
	if(diff_list == NULL)
	{
		if(fd != NULL)
		{
			fclose(fd);
			fd = NULL;
		}
		return NULL;
	}
	ss_lst_Init(diff_list);

	// -------------------
	// Lecture de toutes les lignes du fichier
	// -------------------
	buffer = ss_fgetline(fd);
	while(buffer != NULL)
	{
		char            	*curr_char = buffer;
		amd_diff_type_t 	diff_type  = AMD_DIFFTYPE_NONE;
		ss_noeud_t      	*noeud     = NULL;
		amd_difference_t    *curr_diff = NULL;

		is_buffer_empty = FALSE;

		ligne1a[0] = '\0'; //sprintf(ligne1a, "");
		ligne1b[0] = '\0'; //sprintf(ligne1b, "");
		ligne2a[0] = '\0'; //sprintf(ligne2a, "");
		ligne2b[0] = '\0'; //sprintf(ligne2b, "");
        state = AMDAF_INIT;

		// -------------------
		// Recherche des differences en construisant
		// la liste des differences via un automate d'etat
		// -------------------
        while(state != AMDAF_FIN)
		{
			switch(state)
			{
				case AMDAF_INIT:
					if(isdigit(*curr_char) != NULL)
					{
						state = AMDAF_LIGNE1A;
					}
					else
					{
						state = AMDAF_FIN;
					}
					break;
				case AMDAF_LIGNE1A:
					snprintf(ligne1a, 31, "%s%c", ligne1a, *curr_char);
					curr_char++;
					if(isdigit(*curr_char) != NULL)
					{
						state = AMDAF_LIGNE1A;
					}
					else if((*curr_char) == ',')
					{
						curr_char++;
						if(isdigit(*curr_char) != NULL)
						{
							state = AMDAF_LIGNE1B;
						}
						else
						{
							state = AMDAF_FIN;
						}
					}
					else if(((*curr_char) == 'a')||((*curr_char) == 'd')||((*curr_char) == 'c'))
					{
						state = AMDAF_TYPEDIFF;
					}
					else
					{
						state = AMDAF_FIN;
					}
					break;
				case AMDAF_LIGNE1B:
					snprintf(ligne1b, 31, "%s%c", ligne1b, *curr_char);
					curr_char++;
					if(isdigit(*curr_char) != NULL)
					{
						state = AMDAF_LIGNE1B;
					}
					else if(((*curr_char) == 'a')||((*curr_char) == 'd')||((*curr_char) == 'c'))
					{
						state = AMDAF_TYPEDIFF;
					}
					else
					{
						state = AMDAF_FIN;
					}
					break;
				case AMDAF_TYPEDIFF:
					if((*curr_char) == 'a')
					{
						diff_type = AMD_DIFFTYPE_ADD;
						curr_char++;
						if(isdigit(*curr_char) != NULL)
						{
							state = AMDAF_LIGNE2A;
						}
						else
						{
							state = AMDAF_FIN;
						}
					}
					else if((*curr_char) == 'd')
					{
						diff_type = AMD_DIFFTYPE_DELETE;
						curr_char++;
						if(isdigit(*curr_char) != NULL)
						{
							state = AMDAF_LIGNE2A;
						}
						else
						{
							state = AMDAF_FIN;
						}
					}
					else if((*curr_char) == 'c')
					{
						diff_type = AMD_DIFFTYPE_CHANGE;
						curr_char++;
						if(isdigit(*curr_char) != NULL)
						{
							state = AMDAF_LIGNE2A;
						}
						else
						{
							state = AMDAF_FIN;
						}
					}
					else
					{
						state = AMDAF_FIN;
					}
					break;
				case AMDAF_LIGNE2A:
					snprintf(ligne2a, 31, "%s%c", ligne2a, *curr_char);
					curr_char++;
					if(isdigit(*curr_char) != NULL)
					{
						state = AMDAF_LIGNE2A;
					}
					else if((*curr_char) == ',')
					{
						curr_char++;
						if(isdigit(*curr_char) != NULL)
						{
							state = AMDAF_LIGNE2B;
						}
						else
						{
							state = AMDAF_FIN;
						}
					}
					else
					{
						state = AMDAF_FIN;
					}
					break;
				case AMDAF_LIGNE2B:
					snprintf(ligne2b, 31, "%s%c", ligne2b, *curr_char);
					curr_char++;
					if(isdigit(*curr_char) != NULL)
					{
						state = AMDAF_LIGNE2B;
					}
					else
					{
						state = AMDAF_FIN;
					}
					break;
				default:
					state = AMDAF_FIN;
					break;
			} // switch(state)
		} //while(state != AMDAF_FIN)

		// Un nouvelle difference a ete detectee
		// -------------------
		if((strcmp(ligne1a, "") != 0)&&(strcmp(ligne2a, "") != 0)&&(diff_type != AMD_DIFFTYPE_NONE))
		{
			curr_diff = malloc(sizeof(amd_difference_t));
			if(curr_diff != NULL)
			{
				if(ss_atol(ligne1a, &tmp_long) == 0)
				{
					curr_diff->m_line1_begin = tmp_long;
				}
				else
				{
					curr_diff->m_line1_begin = -1;
				}
				if(ss_atol(ligne1b, &tmp_long) == 0)
				{
					curr_diff->m_line1_end = tmp_long;
				}
				else
				{
					curr_diff->m_line1_end = -1;
				}
				if(ss_atol(ligne2a, &tmp_long) == 0)
				{
					curr_diff->m_line2_begin = tmp_long;
				}
				else
				{
					curr_diff->m_line2_begin = -1;
				}
				if(ss_atol(ligne2b, &tmp_long) == 0)
				{
					curr_diff->m_line2_end = tmp_long;
				}
				else
				{
					curr_diff->m_line2_end = -1;
				}
				curr_diff->m_diff_type = diff_type;
				noeud = ss_lst_AlloueNoeudAvecElt(curr_diff);
				if(noeud == NULL)
				{
					if(curr_diff != NULL)
					{
						free(curr_diff);
						curr_diff = NULL;
					}
				}
				ss_lst_AjouteQueue(diff_list, noeud);
			} // if(curr_diff != NULL)
		} // if((strcmp(ligne1a, "") != 0)&&(strcmp(ligne2a, "") != 0)&&(diff_type != AMD_DIFFTYPE_NONE))

		if(buffer != NULL){free(buffer);buffer = NULL;}
		buffer = ss_fgetline(fd);
	} // while(buffer != NULL)

	// -------------------
	// Check if the diff result file
	// is correctly decoded...
	// -------------------
	if((is_buffer_empty == FALSE)&&(ss_lst_GetNbElt(diff_list) == 0))
	{ 
		amd_difference_t    *curr_diff = NULL;

		// If not, a dummy node is added to inform a trouble occured
		curr_diff = malloc(sizeof(amd_difference_t));
		if(curr_diff != NULL)
		{
			curr_diff->m_line1_begin = 0;
			curr_diff->m_line1_end   = 0;
			curr_diff->m_line2_begin = 0;
			curr_diff->m_line2_end   = 0;
			curr_diff->m_diff_type = AMD_DIFFTYPE_ERROR;
			ss_highlst_AjouteQueue(diff_list, curr_diff);
		} // if(curr_diff != NULL)
	}

	// -------------------
	// Liberations/Fermetures
	// -------------------
	if(buffer != NULL){free(buffer);buffer = NULL;}
	if(fd != NULL)
	{
		fclose(fd);
		fd = NULL;
	}

	return diff_list;
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
void amd_af_release_result_list(ss_list_t *pm_diff_list)
{
  ss_noeud_t *noeud_tmp = NULL;
  noeud_tmp = ss_lst_RetireTete(pm_diff_list);
  while(noeud_tmp != NULL)
    {
		ss_lst_LibereNoeud(noeud_tmp); //SS-TBD: Nothing to release in contenu ????
		noeud_tmp = ss_lst_RetireTete(pm_diff_list);
    }
}


