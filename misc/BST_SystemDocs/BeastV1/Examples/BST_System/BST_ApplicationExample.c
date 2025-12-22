/****h* Beast/BST_ApplicationExample.c ****************
*
*	NAME
*	  BST_ApplicationExample -- (V1 Bravo)
*
*	COPYRIGHT
*	  Maverick Software Development
*
*	FUNCTION
*
*	AUTHOR
*	  Jacco van Weert
*
*	CREATION DATE
*	  2-Apr-96
*
*	MODIFICATION HISTORY
*
*	NOTES
*
****************************************************
*/
#include <BEAST:Include/proto/Beast.h>
#include <proto/exec.h>
#include <stdio.h>
#include <exec/memory.h>
#include <dos/dos.h>

struct Library *BeastBase;

struct TagItem EmptyList[] =
{
  {TAG_DONE, 0}
};


/*********************************/
/**** M A I N - P R O G R A M ****/
/*********************************/
main()
{
  struct BST_Object *AppObject;

  printf("*** Beast General ApplicationExample START ***\n");

  /************************************************
   **** Open beast.library 2 or higher 2 = V1 Bravo
   ****/
  if (BeastBase = (struct Library *)OpenLibrary( "beast.library", 2 ))
    {
      if (AppObject = OBJ_NewObject( NULL, "BST_ApplicationClass", NULL ))
	{

	  /********************************
	   **** Trigger the OBM_INIT method
	   ****/
	  OBJ_DoMethod( AppObject, OBM_INIT, EmptyList, 0 );

	  struct TagItem TL_SetAppAttr[] =
		{ {BTA_NumberOf,   2},
		  {BTA_Signals_OR, SIGBREAKF_CTRL_C},
		  {BTA_Title, 	   (ULONG)"My_Application"},
		  {TAG_DONE, 	   0}
		};
	  OBJ_DoMethod( AppObject, OBM_SETATTR, TL_SetAppAttr, 0 );

	  OBJ_DoMethod( AppObject, OBM_EVENTLOOP, EmptyList, 0 );

	}

      /**************************
       **** Get rid of our object
       ****/
      OBJ_DestroyObject( AppObject, MTHF_DOCHILDREN );

      CloseLibrary( BeastBase );
    }
  printf("*** Beast General ApplicationExample END ***\n");
}
