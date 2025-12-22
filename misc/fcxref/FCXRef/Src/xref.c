/*:ts=4
 *		xref.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <rexx/storage.h>
#include <proto/exec.h>
#include <exec/memory.h>
#include <proto/intuition.h>
#include <exec/types.h>
#include <libraries/commodities.h>
#include <clib/commodities_protos.h>

char *findfunc(char *func,int *ln);
void setclose(int state);
int Quit=FALSE;
int SeaDisable=FALSE;
struct IntuitionBase *IntuitionBase=NULL;
struct Library *IconBase=NULL;
struct Library *CxBase=NULL;

#include "xref_loc.c"
#include "cxref_rxcl.c"
#include "cxref_rxif.c"

#define MAXFILENAME	300
#define MAGIC		0xFA57C8EF

struct dirvect {
	char *name;				// név
	int par;				// szülõ
};

struct index {
	char *id;
	int pos;
};

struct twobyte {
	unsigned char b1;
	unsigned char b2;
};

union convert {
	struct twobyte bytes;
	unsigned short word;
};

FILE *fxr;
int indexnum;
struct index *ind;
struct dirvect *dvt;
struct RexxHost *cxRexxHost;
UBYTE **cxArgs=NULL;
char *opt_xreffile;
int opt_close;
CxObj *cxBroker;

int xreq1(char *text) {
static struct EasyStruct s={
	sizeof(struct EasyStruct),0,NULL,NULL,NULL,
};
	int ret;
	s.es_Title=GetString(MSG_REQERRTIT);
	s.es_TextFormat=text;
	s.es_GadgetFormat=GetString(MSG_OK);
	ret=EasyRequestArgs(NULL,&s,NULL,NULL);
	return(ret);
}

void setclose(int state) {
	if(state==TRUE) {
		opt_close=1;
		if(fxr!=NULL) fclose(fxr);
		fxr=NULL;
	} else {
		opt_close=0;
		if(fxr==NULL) {
			if(NULL!=(fxr=fopen(opt_xreffile,"rb"))) xreq1(GetString(MSG_ERRXREFNOTFOUND));
		}
	}
}

inline char *makefullname(struct dirvect *dv,int index) {
static char fn[MAXFILENAME+2];
	int i;
	char *p,*s;
	p=&fn[MAXFILENAME];
	s=dv[index].name;
	while(*s!='\0') *p--=*s++;
	i=dv[index].par;
	do {
		s=dv[i].name;
		while(*s!='\0') *p--=*s++;
		i=dv[i].par;
	} while(i!=0);
	return(p+1);
}

/*
 * beolvas a bf-be max bflen chart az f-bõl, de csak \0 ig
 */
inline void readstring(char *bf,int len,FILE *f) {
	int i=0,c;
	do {
		if(EOF==(c=fgetc(f))) c=0;
		*bf=c;
	} while(*bf++!='\0'&&++i<len);
}


/*
 * beolvassa a neveket, és egy vektorba teszi + str-eknek helyet foglal
 * fxr szerint
 */
struct dirvect *buildnames() {
static char fn[MAXFILENAME];
static char empty[]="";
	int num,i,par;
	struct dirvect *dv;

	num=fgetc(fxr);
	num<<=8;
	num|=fgetc(fxr);
	dv=calloc((num+1),sizeof(struct dirvect));
	if(dv==NULL) return(NULL);
	dv[0].par=num;
	for(i=1;i<num;i++) {
		par=fgetc(fxr);
		par<<=8;
		par|=fgetc(fxr);
		dv[i].par=par;
		readstring(fn,MAXFILENAME,fxr);
		if(fn[0]!='\0') {
			if(NULL==(dv[i].name=malloc(strlen(fn)+1))) {
				free(dv);
				dv=NULL;
				break;
			}
			strcpy(dv[i].name,fn);
		} else dv[i].name=empty;
	}
	return(dv);
}

/*
 * az indexet építi fel, majd egy vektorba másolja õket
 * fxr szerint
 */
struct index *buildindex() {
static char fn[MAXFILENAME];
static char elso[]=" ";
	int num=0,done=0,i,c;
	long pos;
	struct index *in;

	pos=ftell(fxr);
	while(done==0) {
		if(0!=(c=fgetc(fxr))) {
			ungetc(c,fxr);
			readstring(fn,MAXFILENAME,fxr);
			fgetc(fxr);
			fgetc(fxr);
			fgetc(fxr);
			num++;
		} else done=1;
	}
	fseek(fxr,pos,SEEK_SET);
	indexnum=num+1;
	in=calloc((num+2),sizeof(struct index));
	if(in==NULL) return(NULL);
	in[0].id=elso;
	for(i=1;i<indexnum;i++) {
		readstring(fn,MAXFILENAME,fxr);
		if(NULL==(in[i].id=malloc(strlen(fn)+1))) {
			free(in);
			in=NULL;
			break;
		}
		strcpy(in[i].id,fn);
		pos=fgetc(fxr);
		pos<<=8;
		pos|=fgetc(fxr);
		pos<<=8;
		pos|=fgetc(fxr);
		in[i].pos=pos;
	}
	return(in);
}

/*
 * az összes indexbejegyzéshez hozzáadja base-t
 */
void correctindex(struct index *in,long base) {
	int i;
	base++;
	for(i=0;in[i].id!=NULL;i++) in[i].pos+=base;
	in[0].pos=base;
}

/*
 * kikeresi a legjobban illeszkedõ (még kisebb) elemet az indexbõl, 
 * visszaadja a pos-t (binsea)
 */
inline long searchindex(struct index *in,char *str) {
	int akt=0,mx,mn,s=-1;

	mn=0;
	mx=indexnum;
	while((mn+1)<mx) {
		akt=(mn+mx)>>1;
		s=strcmp(in[akt].id,str);
		if(s<0) mn=akt;				// akt < str
		else if(s>0) mx=akt;		// akt > str
		else if(s==0) mx=0;			// akt = str
	}
	if(s>0) akt--;
	return(in[akt].pos);
}

/*
 * seq file-ból kikeresi a pos-tól az s-t, a hozzátartozó lineno->ln,
 * fileno->fn, RET==0 ok megvan (-1 nincs ilyen) fix match!
 * fxr szerint
 */
inline int searchfile(long pos,char *s,int *ln,int *fn) {
static char fnam[256];
static union convert lineconv,fileconv;
	int of=0,l1,l2,f1,f2,c;

	fseek(fxr,pos,SEEK_SET);
	do {
		readstring(fnam+of,256,fxr);
		l1=fgetc(fxr);
		l2=fgetc(fxr);
		f1=fgetc(fxr);
		f2=fgetc(fxr);
		of=fgetc(fxr);
		if(of>32) { ungetc(of,fxr); of=0; }
		c=strcmp(fnam,s);
	} while(c<0&&f2!=EOF);
	if(c==0) {
		lineconv.bytes.b1=(unsigned char)l1;
		lineconv.bytes.b2=(unsigned char)l2;
		fileconv.bytes.b1=(unsigned char)f1;
		fileconv.bytes.b2=(unsigned char)f2;
		*ln=lineconv.word;
		*fn=fileconv.word;
	}
	return(c);
}

void freeindex(struct index *in) {
	int i;
	for(i=0;in[i].id!=NULL;i++) if(in[i].id!=NULL) free(in[i].id);
	free(in);
}

void freenames(struct dirvect *dv) {
	int i,num;
	num=dv[0].par;
	for(i=0;i<num;i++) if(dv[i].name[0]!='\0') free(dv[i].name);
	free(dv);
}

/*
 * MAIN func
 */
char *findfunc(char *func,int *ln) {
static char err[]="ERROR";
	long p;
	int fileno;
	char *ret=err;

	if(SeaDisable==TRUE) return("OFF");
	if(fxr!=NULL||NULL!=(fxr=fopen(opt_xreffile,"rb"))) {
		ret=NULL;
		p=searchindex(ind,func);
		if(0==(searchfile(p,func,ln,&fileno))) ret=makefullname(dvt,fileno);
		if(opt_close!=0) {
			fclose(fxr);
			fxr=NULL;
		}
	}
	return(ret);
}

struct MsgPort *CX_On_Off(int ac, char **av) {
static struct NewBroker cxNewBroker;
static int allocated_full=0;
static struct MsgPort *cxMsgPort;
	long pri;

	if(av!=NULL) {
		cxArgs=ArgArrayInit(ac,(UBYTE **)av);
		pri=ArgInt(cxArgs,"CX_PRIORITY",0);
		if((cxMsgPort=CreateMsgPort())==NULL) return(NULL);
		cxNewBroker.nb_Version=NB_VERSION;
		cxNewBroker.nb_Name="FastCXRef";
		cxNewBroker.nb_Title="FastCXRef © 1999 gega";
		cxNewBroker.nb_Descr=GetString(MSG_DESCRIPTION);
		cxNewBroker.nb_Unique=NBU_UNIQUE|NBU_NOTIFY;
		cxNewBroker.nb_Flags=0;
		cxNewBroker.nb_Pri=pri;
		cxNewBroker.nb_Port=cxMsgPort;
		if((cxBroker=CxBroker(&cxNewBroker,NULL))==NULL) return(NULL);
		ActivateCxObj(cxBroker,TRUE);
		allocated_full=1;
		return(cxMsgPort);
	} else {
		struct Message *delmsg;

		if(!allocated_full) return(NULL);
		DeleteCxObjAll(cxBroker);
		while((delmsg=GetMsg(cxMsgPort))) ReplyMsg(delmsg);
		DeleteMsgPort(cxMsgPort);
		ArgArrayDone();
		allocated_full=0;
	}
	return(NULL);
}

#define OPT_YES		"YES"
void GetToolTypes(void) {
	char *s;
	opt_xreffile=ArgString(cxArgs,"XREFFILE","PROGDIR:c.xref");
	s=ArgString(cxArgs,"CLOSEFILE",OPT_YES);
	if(strcmp(s,OPT_YES)==0) opt_close=1;
	else opt_close=0;
}

void handlecxMsgPort(struct MsgPort *cxMsgPort) {
	ULONG mtype,mid;
	CxMsg *gotmsg;

    while((gotmsg=(CxMsg *)GetMsg(cxMsgPort))) {
		mid=CxMsgID(gotmsg);
		mtype=CxMsgType(gotmsg);
		ReplyMsg((struct Message *)gotmsg);
		switch(mtype) {
			case CXM_COMMAND :
				switch(mid) {
					case CXCMD_UNIQUE :				// windowless cx
					case CXCMD_KILL :
						Quit=TRUE;
						break;
					case CXCMD_DISABLE :
						SeaDisable=TRUE;
						ActivateCxObj(cxBroker,FALSE);
						break;
					case CXCMD_ENABLE :
						SeaDisable=FALSE;
						ActivateCxObj(cxBroker,TRUE);
						break;
				}
				break;
			case CXM_IEVENT :
				break;
			default :
				xreq1(GetString(MSG_ERRUNKNOWNTYPE));
				break;
		}
	}
}

int OpenLibs(void) {
	if(!(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library",37))) return(-1);
	if(!(IconBase=OpenLibrary("icon.library",38))) return(-1);
	if(!(CxBase=OpenLibrary("commodities.library",38))) return(-1);
	return(0);
}

void CloseLibs(void) {
	if(IntuitionBase) CloseLibrary((struct Library *)IntuitionBase);
	if(IconBase) CloseLibrary((struct Library *)IconBase);
	if(CxBase) CloseLibrary((struct Library *)CxBase);
}

int main(int argc,char **argv) {
	unsigned long magic;
	struct MsgPort *cxMsgPort;
	ULONG l;

	SeaDisable=TRUE;
	if(0!=OpenLibs()) return(0);
	OpenCXRefCatalog(NULL,NULL);
	if(NULL!=(cxMsgPort=CX_On_Off(argc,argv))) {
		GetToolTypes();
		if(NULL!=(fxr=fopen(opt_xreffile,"rb"))) {
			magic=fgetc(fxr);
			magic<<=8;
			magic|=fgetc(fxr);
			magic<<=8;
			magic|=fgetc(fxr);
			magic<<=8;
			magic|=fgetc(fxr);
			if(magic==MAGIC) {
				dvt=buildnames();
				ind=buildindex();
				correctindex(ind,ftell(fxr));
				if(opt_close!=0) {
					fclose(fxr);
					fxr=NULL;
				}
				if((cxRexxHost=SetupARexxHost(NULL,NULL))!=NULL) {
					SeaDisable=FALSE;
					while(Quit==FALSE) {
						l=Wait((1L<<cxRexxHost->port->mp_SigBit)|(1L<<cxMsgPort->mp_SigBit));
						if(l&(1L<<cxRexxHost->port->mp_SigBit)) ARexxDispatch(cxRexxHost);
						if(l&(1L<<cxMsgPort->mp_SigBit)) handlecxMsgPort(cxMsgPort);
					}
					CloseDownARexxHost(cxRexxHost);
				} else xreq1(GetString(MSG_ERRAREXX));
				freeindex(ind);
				freenames(dvt);
			} else xreq1(GetString(MSG_ERRFILETYPE));
			if(fxr!=NULL) fclose(fxr);
		} else xreq1(GetString(MSG_ERRXREFNOTFOUND));
		CX_On_Off(0,NULL);
	}
	CloseCXRefCatalog();
	CloseLibs();
	return(0);
}
