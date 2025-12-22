/* ASCIITable Version 1.00, Chez Corbin, 12 février 1997, © R.Florac */
/* Version 1.01, ajout d'une séparation entre les boutons "caractères" et "gammes" */
/* Compilation: sc link ASCIITable.c */

#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/bgui.h>
#include <proto/intuition.h>

#include <stdlib.h>
#include <string.h>

#include "français.h"


struct Library *BGUIBase;
Object * objet_principal;

vide __regargs init_textes_gadgets (char lettre, char * lettres)
{   long i = 0, j;
    pour (j = 0;  j < 32;  j++)
    {	lettres[i++] = lettre++;    lettres[i++]=0; }
}

Object * __regargs groupe_horizontal (char * lettres, long ligne)
{   renvoi HGroupObject, Spacing (4),
	StartMember, XenButton (&lettres[0],  ligne + 0), FixMinHeight, EndMember,
	StartMember, XenButton (&lettres[2],  ligne + 1), FixMinHeight, EndMember,
	StartMember, XenButton (&lettres[4],  ligne + 2), FixMinHeight, EndMember,
	StartMember, XenButton (&lettres[6],  ligne + 3), FixMinHeight, EndMember,
	StartMember, XenButton (&lettres[8],  ligne + 4), FixMinHeight, EndMember,
	StartMember, XenButton (&lettres[10], ligne + 5), FixMinHeight, EndMember,
	StartMember, XenButton (&lettres[12], ligne + 6), FixMinHeight, EndMember,
	StartMember, XenButton (&lettres[14], ligne + 7), FixMinHeight, EndMember,
    EndObject;
}

struct Window * __regargs ouverture_fenêtre (ULONG *signal, char * ligne, long groupe)
{
    struct Window *fenêtre = NULL;

    groupe *= 32;
    objet_principal = WindowObject,
	WINDOW_Title,		"ASCIITable 1.01 (©) R.Florac",
	WINDOW_SmartRefresh,	VRAI,
	WINDOW_RMBTrap, 	VRAI,
	WINDOW_SizeGadget,	FAUX,
	WINDOW_CloseOnEsc,	VRAI,
	WINDOW_Position,	POS_CENTERMOUSE,
	WINDOW_AutoAspect,	VRAI,
	WINDOW_HelpText,	ISEQ_C"Les boutons du haut vous\ndonnent les codes des\ncaractères correspondants\ndans la barre de titre\n\nCeux situés en bas\ndonnent accès aux diverses\ngammes de caractères",
	WINDOW_MasterGroup,
	    VGroupObject, HOffset(4), VOffset(4), Spacing(4), GROUP_BackFill, SHINE_RASTER,
		StartMember, groupe_horizontal (ligne, 0), EndMember,
		StartMember, groupe_horizontal (ligne+16, 8), EndMember,
		StartMember, groupe_horizontal (ligne+32, 16), EndMember,
		StartMember, groupe_horizontal (ligne+48, 24), EndMember,
		StartMember, TitleSeperator ("Sélection caractères"),
		EndMember,
		StartMember,
		    HGroupObject, EqualWidth, Spacing(4),
			StartMember, XenButton (" .? ", 100), FixMinHeight, EndMember,
			StartMember, XenButton ("\x40M\x5F", 101), FixMinHeight, EndMember,
			StartMember, XenButton ("\x60m\x7F", 102), FixMinHeight, EndMember,
			StartMember, XenButton ("\xA0.\xBF", 104), FixMinHeight, EndMember,
			StartMember, XenButton ("\xC0.\xDF", 105), FixMinHeight, EndMember,
			StartMember, XenButton ("\xE0.\xFF", 106), FixMinHeight, EndMember,
		    EndObject,
	    EndObject,
    EndObject;

    si (objet_principal)
	si (fenêtre = WindowOpen (objet_principal))
	    GetAttr (WINDOW_SigMask, objet_principal, signal);
    renvoi fenêtre;
}

vide main (vide)
{   struct Window * fenêtre;
    ULONG signal = 0, rc;	long groupe = 0;
    BOOL continuer = 1;
    char ligne[16*4], titre[32];
    init_textes_gadgets (' ', ligne);
    si (BGUIBase = OpenLibrary (BGUINAME, BGUIVERSION))
    {	si (fenêtre = ouverture_fenêtre (&signal, ligne, groupe))
	{   faire
	    {	Wait (signal);
		tant_que ((rc = HandleEvent (objet_principal)) != WMHI_NOMORE)
		{   selon (rc)
		    {	égal WMHI_CLOSEWINDOW:
			    continuer = 0;	arrêt;
			défaut:
			    si (rc >=0  ET  rc <= 31)   /* un caractère a été cliqué */
			    {	strcpy (titre, ligne+rc*2);
				strcat (titre, "  Hexa: ");
				stcl_h (titre+9, *(unsigned char *)(ligne+rc*2));
				strcat (titre, "  Décimal: ");
				stcl_d (titre+22, *(unsigned char *)(ligne+rc*2));
				SetWindowTitles (fenêtre, titre, (char *) -1);
			    }
			    sinon si (rc >= 100  ET  rc < 108)      /* gadget de page */
			    {	groupe = rc - 100;
				init_textes_gadgets (' ' + groupe*32, ligne);
				RefreshGadgets (fenêtre->FirstGadget, fenêtre, 0);
			    }
			    arrêt;
		    }
		}
	    }
	    tant_que (continuer);
	}
	si (objet_principal)
	    DisposeObject (objet_principal);
	CloseLibrary (BGUIBase);
    }
}
