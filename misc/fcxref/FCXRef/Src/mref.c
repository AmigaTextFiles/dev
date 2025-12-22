/* :ts=4
 * mref.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>

#include "dirwalker.h"
#include "stack.h"

extern void scanhead(char *file);

struct dirstruct {
	struct dirstruct *next;
	char *name;				// név (malloced)
	int par;				// parent (0==root)
	int num;				// sorszám
	int type;				// 0-file, 1-dir, 2-root
};

struct dirvect {
	char *name;				// név
	int par;				// szülõ
	int type;				// 0-file, 1-dir, 2-root
	int minus;
};

struct fnlist {
	struct fnlist *next;
	struct fnlist *prev;
	char *name;				// függvénynév
	int ln;					// linenumber	(-1: delted!!)
	int fn;					// filenumber
};

struct optin {
	int dif;				// különbség
	struct fnlist *f;		// elem
};

#define MAGIC		0xFA57C8EF

#define ED_CED		1
#define ED_GED		0
int opt_edit;
int opt_quiet;
int opt_unique;
int opt_struct;

#define ADOC_TERM	12
#define LINEBUFFLEN	300
#define TAB			9
#define MAXFILENAME	300
#define TMPFILE		"T:cqref.TMP"

#define ST_NULL		0
#define ST_FILE		1
#define ST_DIR		2
#define ST_ROOT		3

struct dirvect *dvec;
int maxnum;
struct dirstruct *first;
struct stack *stk;
struct fnlist *mainfnlist;
int parent;
int number;
int funcnumber,totalfuncnumber;
int chunksize,playsize;
int filenumber;
char *databasename;
static char line[LINEBUFFLEN+1];
FILE *TmpFile;
FILE *OutFile;

/*
 * egy teljes path+file-névbõl elkészíti a filenevet
 */
void getpurename(char *fullname,char *name) {
	int i;

	if(fullname==NULL) return;
	i=strlen(fullname);
	for(;i>=0&&fullname[i]!=':'&&fullname[i]!='/';i--);
	strcpy(name,&fullname[i+1]);
} // getpurename()



/* behelyezi a listába rendezetten a megadott
 * függvényt
 * ha duplikált, akkor
 * törli az eredeti elemet is.
 * üreslistát nem kezel
 * RET: 1-ok, -1-törölt elem! 0-nem helyezte be
 */
int insertfnlist(struct fnlist *f) {
	struct fnlist *f2,*fo;
	int ret=1;

	f2=mainfnlist;
	fo=NULL;
	while(f2!=NULL&&strcmp(f2->name,f->name)<0) {
		fo=f2;
		f2=f2->next;
	}
	if(strcmp(f2->name,f->name)==0) {
		if(opt_quiet==0) fprintf(stderr,"***Warning: identical keys detected (%s)\n",f->name);
		free(f->name);
		free(f);
		ret=0;
		if(opt_unique!=0) {
			if(f2->ln>=0) {
				f2->ln=-1;			// DELETED
				ret=-1;
			}
		}
	} else if(fo==NULL) {
		// insert start
		mainfnlist->prev=f;
		f->next=mainfnlist;
		f->prev=NULL;
		mainfnlist=f;
	} else if(f2==NULL) {
		// insert tail
		fo->next=f;
		f->prev=fo;
		f->next=NULL;
	} else {
		// insert before 'f2'
		if(f2->prev!=NULL) f2->prev->next=f;
		f->next=f2;
		f->prev=f2->prev;
		f2->prev=f;
	}
	return(ret);
}


/* behelyezi a listába rendezetten a megadott
 * függvényt
 * ha duplikált, akkor
 * törli az eredeti elemet is. (opt_unique)
 */
int AddFunc(char *file, char *func,int linenum) {
	struct fnlist *f;

	if(NULL==(f=malloc(sizeof(struct fnlist)))) {
		fprintf(stderr,"***Nomem\n");
		return(-1);
	}
	if(NULL==(f->name=malloc(strlen(func)+1))) {
		fprintf(stderr,"***Nomem\n");
		return(-1);
	}
	strcpy(f->name,func);
	f->ln=linenum;
	f->fn=filenumber;
	if(mainfnlist!=NULL) {
		funcnumber+=insertfnlist(f);
	} else {
		funcnumber++;
		mainfnlist=f;
		f->next=NULL;
		f->prev=NULL;
	}
	return(0);
}

void freefnlist(struct fnlist *fnl) {
	struct fnlist *f2;
	while(fnl!=NULL) {
		f2=fnl->next;
		if(fnl->name!=NULL) free(fnl->name);
		free(fnl);
		fnl=f2;
	}
}

void outword(int a,FILE *o) {
	unsigned char lo,hi;
	lo=(unsigned char)(a&0xff);
	hi=(unsigned char)(a>>8);
	fputc(hi,o);
	fputc(lo,o);
}

/*
 * kiírja az out-ot, de, ha az elsõ valahány karaktere megegyezik
 * before-éval, akkor azok helyett csak 1 byte-ot ír ki,
 * értéke: az azonos char-ok száma
 * (egy azonos nem elég)
 * RET: az azonos karakterek az elején (0-0,1 2-2 stb)
 */
int outstr(char *out,char *before) {
	int i;
	if(before==NULL) {
		fprintf(TmpFile,"%s",out);
		return(0);
	}
	for(i=0;out[i]==before[i];i++);
	if(i>=2) {
		fputc(i,TmpFile);
		fprintf(TmpFile,"%s",&out[i]);
	} else {
		fprintf(TmpFile,"%s",out);
	}
	return(i);
}

/*
 * OutFile-ba kiír egy index bejegyzést:
 * a 'name' stringet, addig, hogy legalább egy charjában különbözzék
 * 'before'-tõl, formátum:
 * name		\0		pos
 * chars..	byte	3byte
 */
void outindexitem(char *name,char *before,long pos) {
	int i;
	unsigned char c,f1,f2,f3;

	if(pos>0xffffff) fprintf(stderr,"***Filepos overflow\n");
	for(i=0;name[i]==before[i];i++) {
		fputc(name[i],OutFile);
	}
	fputc(name[i],OutFile);
	fputc(0,OutFile);
	f1=c=(pos>>16)&0xff;
	fputc(c,OutFile);
	f2=c=(pos>>8)&0xff;
	fputc(c,OutFile);
	f3=c=pos&0xff;
	fputc(c,OutFile);
}

/*
 * index és tmpfile készítés
 */
void output(struct fnlist *fnl) {
	char *before=NULL;
	char *beforeold=NULL;
	int counter=0,j,i;
	int mini,minv;
	struct optin *op;

	op=calloc(sizeof(struct optin),playsize+1);
	if(op==NULL) {
		fprintf(stderr,"***Nomem\n");
		return;
	}
	while(fnl!=NULL) {
		if(fnl->ln>=0) {
			if(++counter<chunksize) {
				outstr(fnl->name,before);
				before=fnl->name;
				fputc(0,TmpFile);
				outword(fnl->ln,TmpFile);
				outword(fnl->fn,TmpFile);
			} else if(counter<(chunksize+playsize)) {
				j=counter-chunksize;
				if(j==0) beforeold=before;
				op[j].f=fnl;
				for(i=0;fnl->name[i]==before[i];i++);
				op[j].dif=i;
			} else {
				minv=9999;
				mini=0;
				for(i=0;i<playsize;i++) if(op[i].dif<minv) { minv=op[i].dif; mini=i; }
				before=beforeold;
				for(i=0;i<playsize;i++) {
					if(mini==i) {
						outindexitem(op[i].f->name,before,ftell(TmpFile));
						outstr(op[i].f->name,NULL);
					} else {
						outstr(op[i].f->name,before);
					}
					before=op[i].f->name;
					fputc(0,TmpFile);
					outword(op[i].f->ln,TmpFile);
					outword(op[i].f->fn,TmpFile);
				}
				counter=mini;
				outstr(fnl->name,before);
				before=fnl->name;
				fputc(0,TmpFile);
				outword(fnl->ln,TmpFile);
				outword(fnl->fn,TmpFile);
			}
		}
		fnl=fnl->next;
	}
	fputc(0,OutFile);			// index vége
	free(op);
}

int scanheader(char *name) {
	scanhead(name);
	return(0);
}

int scanautodoc(char *name) {
	FILE *f;
	int c=0,i,ln;
	char *l,*onlyname;

	if(NULL==(onlyname=malloc(strlen(name)+1))) return(-1);
	f=fopen(name,"rb");
	if(f==NULL) return(0);
	getpurename(name,onlyname);
	ln=1;
	while(c!=EOF) {
		while((c=fgetc(f))!=ADOC_TERM&&c!=EOF) if(c=='\n') ln++;
		if(c!=EOF) {
			ln+=opt_edit;
			line[0]='\0';
			if(NULL==(fgets(line,LINEBUFFLEN,f))) break;
			if(line[0]=='\n') {
				if(NULL==(fgets(line,LINEBUFFLEN,f))) break;
				ln++;
			}
			if(line[strlen(line)-1]=='\n') line[strlen(line)-1]='\0';
			for(i=0;line[i]!='/'&&line[i]!='\0';i++);
			if(line[i]=='\0') l=line;
			else l=&line[i+1];
			for(i=0;l[i]!='\0'&&l[i]!=' '&&l[i]!=TAB&&l[i]!='/';i++);
			if(isalpha(l[0])) {
				if(l[i]=='\0'||l[i]=='/') if(!opt_quiet) fprintf(stderr,"***Warning: Too long line in %s at line %d\n",name,ln);
				l[i]='\0';
				AddFunc(name,l,ln);
			}
			ln++;
		}
	}
	fclose(f);
	free(onlyname);
	return(0);
}

int dfil2(char *name) {
	int ret=-1;
	switch(name[strlen(name)-1]) {
		case 'c' :
			ret=scanautodoc(name);
			break;
		case 'h' :
			ret=scanheader(name);
			break;
		default :
			fprintf(stderr,"***Wrong filetype: %s\n",name);
			break;
	}
	return(ret);
}


/* functions for filename generation
 */
struct dirstruct *store(char *name,int type) {
static struct dirstruct *last=NULL;
	struct dirstruct *ds;
	int len;
	if(name==NULL||type==ST_NULL) {
		last=NULL;
		return(NULL);
	}
	ds=malloc(sizeof(struct dirstruct));
	if(ds==NULL) return(NULL);
	ds->num=++number;
	ds->par=parent;
	ds->next=NULL;
	ds->type=type;
	if(NULL==(ds->name=malloc(strlen(name)+2))) {
		free(ds);
		return(NULL);
	}
	switch(type) {
		case ST_FILE :					// FILE
			getpurename(name,ds->name);
			break;
		case ST_DIR :					// DIR
			getpurename(name,ds->name);
			strcat(ds->name,"/");
			break;
		case ST_ROOT :					// ROOT
			strcpy(ds->name,name);
			len=strlen(ds->name)-1;
			if(ds->name[len]!=':'&&ds->name[len]!='/') strcat(ds->name,"/");
			break;
	}
	if(last!=NULL) last->next=ds;
	last=ds;
	return(ds);
}

int din1(char *name) {
	store(name,ST_DIR);
	parent=number;
	if(0!=push(stk,number)) {
		fprintf(stderr,"***Error on PUSH\n");
		return(-1);
	}
	return(0);
}

int dout1(char *name) {
	long l;
	top(stk,&l);
	if(0!=pop(stk,&l)) {
		fprintf(stderr,"***Error on POP\n");
		return(-1);
	}
	top(stk,&l);
	parent=l;
	return(0);
}

int dfil1(char *name) {
	store(name,ST_FILE);
	return(0);
}

struct dirvect *makevect(struct dirstruct *f) {
	struct dirvect *dv;
	int i;
	if(f==NULL) return(NULL);
	dv=calloc(sizeof(struct dirvect),number+2);
	if(dv==NULL) return(NULL);
	dv[0].name=NULL;
	dv[0].type=ST_NULL;
	for(i=1;f!=NULL;i++) {
		dv[i].name=f->name;
		f->name=NULL;
		dv[i].par=f->par;
		dv[i].type=f->type;
		f=f->next;
	}
	dv[0].par=i;
	return(dv);
}

void freelist(struct dirstruct *f) {
	struct dirstruct *f2;
	while(f!=NULL) {
		f2=f->next;
		if(f->name!=NULL) free(f->name);
		free(f);
		f=f2;
	}
	store(NULL,ST_NULL);
}

/* 's' elé fûzi 'n'-et
 * 's'-ben kell elég helynek lennie
 */
int strbefore(char *s,char *n, int slen) {
	int ls,ln;
	char *t;
	ls=strlen(s);
	ln=strlen(n);
	if((ls+ln+1)>slen) return(-1);
	if(NULL==(t=malloc(slen))) return(-1);
	strcpy(t,n);
	strcat(t,s);
	strcpy(s,t);
	free(t);
	return(0);
}

char *makefullname(struct dirvect *dv,int index) {
static char fn[MAXFILENAME];
	int p;
	// elkészíti a teljes nevet
	strcpy(fn,dv[index].name);
	p=dv[index].par;
	do {
		strbefore(fn,dv[p].name,MAXFILENAME);
		p=dv[p].par;
	} while(p!=0);
	return(fn);
}

/*
 * s-t fordított sorrendben kiírja f-re
 */
void reversewrite(FILE *f,char *s) {
	int i;
	for(i=strlen(s)-1;i>=0;i--) {
		fputc(s[i],f);
	}
}

/*
 * ez írja ki a dir/files részt
 */
void makefnlist(struct dirvect *dv) {
	int j,num,deleted;

	deleted=0;
	totalfuncnumber=0;
	num=dv[0].par;
	for(j=1;j<num;j++) {
		if(dv[j].type==ST_FILE) {
			funcnumber=0;
			filenumber=j-deleted;
			dfil2(makefullname(dv,j));
			if(funcnumber==0) {
				// No match in file!!
				free(dv[j].name);
				dv[j].name=NULL;
				deleted++;
			}
			totalfuncnumber+=funcnumber;
		}
		if(dv[j].name!=NULL) dv[j].minus=deleted;
	}
	dv[0].minus=0;
	outword(num-deleted,OutFile);						// num of dirs/files
	for(j=1;j<num;j++) {
		if(dv[j].name!=NULL) {
			outword(dv[j].par-dv[dv[j].par].minus,OutFile);
			reversewrite(OutFile,dv[j].name);
			fputc(0,OutFile);
		}
	}
}

void freevect(struct dirvect *dv) {
	int i,j;
	i=dv[0].par;
	for(j=1;j<i;j++) if(dv[j].name!=NULL) free(dv[j].name);
	free(dv);
}

/*
 * OutFile mögé fûzi TmpFile-t
 */
void merge(void) {
	int i;	
	fseek(TmpFile,0,SEEK_SET);
	while(EOF!=(i=fgetc(TmpFile))) fputc(i,OutFile);
}


int main(int argc,char **argv) {
	struct dirstruct *f;
	int i;

	opt_edit=ED_CED;
	opt_quiet=0;
	opt_unique=0;
	opt_struct=0;
	if(argc<3) {
		fprintf(stderr,"Autodoc & Include database builder\n");
		fprintf(stderr,"Usage: %s [options] New-Database Dir/ [Dir/,Dir/,...]\n",argv[0]);
		fprintf(stderr," -q\tQuiet\n");
		fprintf(stderr," -g\tGoldED mode (default: CED mode)\n");
		fprintf(stderr," -u\tUnique keys only\n");
		fprintf(stderr," -s\tAdd structure definitions too\n");
		return(0);
	}
	if(NULL!=(stk=newstack())) {
		for(i=1;i<argc&&argv[i][0]=='-';i++) {
			switch(argv[i][1]) {
				case 'q' :
					opt_quiet=1;
					break;
				case 'g' :
					opt_edit=ED_GED;
					break;
				case 'u' :
					opt_unique=1;
					break;
				case 's' :
					opt_struct=1;
					break;
				default :
					fprintf(stderr,"***Invalid option '%c'\n",argv[i][1]);
					return(0);
					break;
			}
		}
		if(argc==i) {
			fprintf(stderr,"***Missing database name\n");
			return(0);
		}
		databasename=argv[i++];
		if(argc==i) {
			fprintf(stderr,"***Missing source directory\n");
			return(0);
		}
		OutFile=fopen(databasename,"wb");
		if(OutFile==NULL) {
			fprintf(stderr,"***Can't open database\n");
			return(0);
		}
		TmpFile=fopen(TMPFILE,"wb");
		if(TmpFile==NULL) {
			fprintf(stderr,"***Can't open tmp-file\n");
			return(0);
		}
		fputc(0xFA,OutFile);			// Magic
		fputc(0x57,OutFile);
		fputc(0xC8,OutFile);
		fputc(0xEF,OutFile);
		number=0;
		mainfnlist=NULL;
		first=NULL;
		for(;i<argc;i++) {
			chdir(argv[i]);
			parent=0;
			f=store(argv[i],ST_ROOT);
			if(first==NULL) first=f;
			push(stk,number);
			parent=number;
			dirwalker(argv[i],"#?","#?.(doc|h)",din1,dout1,dfil1);
		}
		dvec=makevect(first);
		freelist(first);
		makefnlist(dvec);				// fill 'mainfnlist'
		chunksize=totalfuncnumber/100;
		if(chunksize<2) chunksize=2;
		playsize=chunksize/3;
		if(playsize==0) playsize=1;
		output(mainfnlist);
		merge();
		freefnlist(mainfnlist);
		freevect(dvec);
		freestack(stk);
		fclose(OutFile);
		fclose(TmpFile);
		unlink(TMPFILE);
	}
	return(0);
}
