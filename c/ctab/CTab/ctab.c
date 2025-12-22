/*
	CTab V1.40
	
	(c) 1992 Alexander Rawass

	Alexander Rawass
	Wilhelminenstr. 44
	6700 Ludwigshafen 15
	Germany
	0621/57 75 98

	E-Mail : rawass@sun.rhrk.uni-kl.de
*/

#include <exec/types.h>
#include <stdio.h>

#define TAB 9		/* tabulator	 */
#define SPC 32		/* space	 */
#define RET 10		/* return	 */
#define INVCOM 34	/* inverted comma, hochkomma, gaensefuesschen */
#define APO 39		/* apostroph	 */
#define STREQU(x,y) !(strcmp(x,y))
#define EOS '\0'

FILE *new_file,*old_file;
char new_name[40];
STRPTR name_end=".ct";
char chr,lchr;

BOOL flag_bol;	/* begin of line	*/
BOOL flag_apo;	/* apostroph	*/
BOOL flag_ic;	/* hochkomma	*/
BOOL flag_ovrd;	/* ueberlesen	*/
BOOL flag_spc;	/* ???		*/
BOOL flag_done;	/* done		*/

UWORD num_rems,num_tabs,num_spc;	/* Anzahl Remarks,zu schreibender Tabs */

VOID CloseW()
{

	if(old_file)	fclose(old_file);
	if(new_file)	fclose(new_file);
	exit(NULL);
}

VOID chrput(c,f)
char c;
FILE *f;
{
	if(fputc(c,f)==EOF){
		printf("Error while writing!\n");
		CloseW();
	}
}

char chrget(f)
FILE *f;
{
	char r;

	if((r=fgetc(f))==EOF){
		CloseW();
	}
	return(r);
}

VOID main(argc,argv)
UWORD argc;
STRPTR argv[];
{
	UWORD a,b,c,d;

	printf("\033[1mCTab V1.40\033[0m - (c) 1992 Alexander Rawass\n");
	if(*argv[1]=='?' || argc<2){
		printf("Usage  : %s <filename> [SPC n]\n",argv[0]);
		printf("         destination is <filename>.ct\n");
		printf("Options: SPC n : will use n spaces instead of a tab\n");
		CloseW();
	}
	new_name[0]=EOS;
	flag_bol=TRUE;
	flag_apo=flag_ic=flag_ovrd=flag_spc=flag_done=FALSE;
	num_rems=num_tabs=num_spc=0;
	if(!(old_file=fopen(argv[1],"r"))){
		printf("Error : File not found\n");
		CloseW();
	}
	strcpy(&new_name,argv[1]);
	strcat(&new_name,name_end);
	if(!(new_file=fopen(&new_name,"w"))){
		printf("Error : could not open output\n");
		CloseW();
	}
	if(argc==4){
		if(STREQU(argv[2],"SPC") || STREQU(argv[2],"spc")){
			flag_spc=TRUE;
			num_spc=atoi(argv[3]);
		}
	}
	while(!feof(old_file)){
		chr=chrget(old_file);
		if(chr==INVCOM && !flag_apo && !num_rems){
			flag_ic=~flag_ic;
		}
		else if(chr==APO && !flag_ic && !num_rems){
			flag_apo=~flag_apo;
		}
		else if(lchr=='/' && chr=='*' && !flag_ic && !flag_apo){
			num_rems++;
		}
		else if(lchr=='*' && chr=='/' && !flag_ic && !flag_apo){
			num_rems--;
		}
		if(!flag_ic && !flag_apo && !num_rems){
			if(flag_bol && chr!=RET){
				while(chr==TAB || chr==SPC){
					 chr=chrget(old_file);
				}
				if(chr=='}'){
					lchr=chr;
					num_tabs--;
					flag_done=TRUE;
				}
				if(flag_spc){
					for(a=0;a<num_tabs;a++)
					for(b=0;b<num_spc;b++)
					chrput(SPC,new_file);
				}
				else{
					for(a=0;a<num_tabs;a++)
					chrput(TAB,new_file);
				}
				flag_bol=FALSE;
			}
			if(chr=='{'){
				chrput(chr,new_file);
				chrput(RET,new_file);
				lchr=chr;
				num_tabs++;
				flag_bol=TRUE;
			}
			else if(chr=='}'){
				chrput(chr,new_file);
				chrput(RET,new_file);
				lchr=chr;
				if(!flag_done) num_tabs--;
				flag_done=FALSE;
				flag_bol=TRUE;
			}
			else if(chr==RET){
				if(lchr!='{' && lchr!='}'){
					chrput(chr,new_file);
				}
				flag_bol=TRUE;
				lchr=chr;
			}
			else if(!((chr==TAB || chr==SPC) && flag_ovrd)){
				chrput(chr,new_file);
				lchr=chr;
			}
		}
		else{
			chrput(chr,new_file);
			if(chr==RET) flag_bol=TRUE;
			else flag_bol=FALSE;
			lchr=chr;
		}
	}
	CloseW();
}
