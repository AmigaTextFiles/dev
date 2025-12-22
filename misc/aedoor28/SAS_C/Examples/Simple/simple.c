/*

  ***********************************************************************

     Simple example file to show how to use the AEDoor.library from C

                           Written by SiNTAX/WøT
                           added the dif==NULL check by Rikki Ratboy/DhB

  ***********************************************************************


NOTE: You can find the same example written in E. (Amiga_E/Sources/Example.e)
      I took the liberty to make a little comparison:

				E	|	C
---------------------------------------------------------
Time to compile		|    1.4 secs	|    22.7 secs	|
on 68000/7.14Mhz	|		|		|
---------------------------------------------------------
Executable size		|   1876 bytes	|   4884 bytes	|
---------------------------------------------------------

As you can see, E is quite a powerful language, and I think it's perfect for
writting doors.. since it's easy to use, fast in compiling and not too hard
to master + it has some nice features that come in handy for doors (like the
exception handling) So, have a look at it! Afterall, what have you got to
lose?

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libraries/aedoor.h>
#include <proto/aedoor.h>
#include <proto/exec.h>

struct	Library	*AEDBase;

struct	DIFace	*d;
char	*strf,*res,usern[50],str[256],location[100];


main(argc, argv)
int argc;
char *argv[];
{
	if((AEDBase=(struct Library *)OpenLibrary(AEDoorName,0))==NULL)
	{
		printf("Needs AEDoor.library V1.10+ to run\n");
		exit(10);
	}
	if(d=CreateComm(argv[1][0]))	/* Establish link with /X */
	{
		strf= GetString(d);		/* Get a pointer to the JHM_String  */
					/* field. Only need to do this once */

		GetDT(d,DT_NAME,0);		/* Get USER name, no string input   */
					/* here, so use 0 as last parameter */
		strcpy(usern,strf);		/* Copy result from JHM_String to   */
					/* our own string. Don't forget this*/
		GetDT(d,DT_LOCATION,0);
		strcpy(location,strf);

		WriteStr(d,"User name : ",NOLF);	/* Write some text */
		WriteStr(d,usern,LF);
		WriteStr(d,"Location  : ",NOLF);
		WriteStr(d,location,LF);

		GetDT(d,DT_DUMP,"T:user.dump");		/* Dump user's data struct */

		if( (res=Prompt(d,80,"\nGimme some input: ")) )
		{						/* Ask some input */
			strcpy(str,res);
			WriteStr(d,"Entered: ",NOLF);
			WriteStr(d,str,LF);
			if( (res=GetStr(d,3,"YES")) )
			{
				if(!strcmp(res,"YES"))
				{
					ShowFile(d,"S:User-Startup");
					ShowGFile(d,"BBS:BULL30");
				}
			}
			else WriteStr(d,"\n\nLOST CARRIER!",LF);

		}
		else WriteStr(d,"\n\nLOST CARRIER!",LF);

		DeleteComm(d);
	}
	else
	{
		printf("This is supposed to be launched as an AmiExpress door!\n");
		exit(20);
	}
	CloseLibrary(AEDBase);
}

