#ifndef AMD_DIFFCMDWRAPPING_PROTOS_H
#define AMD_DIFFCMDWRAPPING_PROTOS_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :
*
*      Nom du module             :  $RCSfile: AMD_DiffCmdWrapping_protos.h,v $
*      Version du module         :  $Revision: 1.4 $
*      Date de la version        :  $Date: 2003/05/17 23:41:04 $
*
*      Description               :
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

#include <stdlib.h>
#include "SSListLib_protos.h"
#include "AMD_DiffCmdWrapping.h"

/*******************************************************************
 * PROTOTYPES
*******************************************************************/
extern "C" ss_list_t*  amd_analyse_files(const char *pm_file1, const char *pm_file2, const char *pm_options, char **pm_resultfile);
extern "C" void amd_af_release_result_list(ss_list_t *pm_diff_list);


#endif //AMD_DIFFCMDWRAPPING_PROTOS_H
