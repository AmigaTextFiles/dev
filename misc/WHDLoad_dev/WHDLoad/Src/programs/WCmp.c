/*
	$Id: WCmp.c 1.2 2000/09/24 15:17:13 jah Exp jah $

	a little, simple, quick cmp program
	advantages against the thousend other cmp's out there:
		- command line only
		- wide output hex And ascii (this was the reason for writing)
		- does not need to load whole file at once
		- std c, should be eatable by every compiler

	released under GNU Public License
	wepl, sometime ago ...
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define strcasecmp stricmp

#define buflen 32768/2
#define error1 { perror(argv[1]); exit(20); }
#define error2 { perror(argv[2]); exit(20); }
#define maxpl 16	/* displayed diffs per line */

int opt_quick=1;

/**********************/

void cmpout(unsigned char *c1, unsigned char *c2, int p1, int p2, int len) {
  int j;
  unsigned char *t;

  if (opt_quick == 0) return;
  
  printf("%06x ",p1);				/* file1 offset */
  for (t=c1,j=0;j<len;j++) printf("%02x",*t++);
  for (j=0;j<=2*(maxpl-len);j++) putchar(' ');
  for (j=0;j<len;j++,c1++) putchar(*c1 < ' ' || *c1 > 127 ? '.' : *c1);
  for (j=0;j<=maxpl-len;j++) putchar(' ');
  if  (p1 != p2) printf("%06x ",p2);		/* file2 offset */
  for (t=c2,j=0;j<len;j++) printf("%02x",*t++);
  for (j=0;j<=2*(maxpl-len);j++) putchar(' ');
  for (j=0;j<len;j++,c2++) putchar(*c2 < ' ' || *c2 > 127 ? '.' : *c2);
  putchar('\n');
}

/**********************/

int cmp(char *m1, char *m2, int o1, int o2, int len) {
  int i, diffs=0;
  char t1[maxpl+1]="", t2[maxpl+1]="";
  int dc=0;	/* count of bytes in buff */
  int ds=0;	/* filepos of first stored byte in buff */
  
  for (i=0;i<len;i++) {
    if (*m1++ != *m2++) {
      /* output if the new cannot appended */
      if ( dc > 0 && ds+dc != i) {
        cmpout(t1,t2,o1+ds,o2+ds,dc);
        dc = 0;
      }
      /* append */
      if (dc == 0) ds = i;
      t1[dc]   = *(m1-1);
      t2[dc++] = *(m2-1);
      /* output if buff full */
      if (dc == maxpl) {
        cmpout(t1,t2,o1+ds,o2+ds,dc);
        dc=0;
      }
      diffs++;
    }
  }
  /* output if bytes left in buff */
  if (dc > 0 )
    cmpout(t1,t2,o1+ds,o2+ds,dc);
  return diffs;
}

/**********************/

long getfilesize(FILE *fp) {
  fseek(fp,0,SEEK_END);
  return ftell(fp);
}

/**********************/

int main(int argc, char *argv[]) {
  FILE *fp1,*fp2;
  int len1, len2, strt1=0, strt2=0, pos1, pos2;
  static char b1[buflen], b2[buflen]; /* Amiga !!! */
  int l, diffs=0,i;
  
  if (argc < 3 || argc >4 || (argc == 4 && (opt_quick=strcasecmp(argv[3],"quick")))) {
    fprintf(stderr,"Cmp 0.2 (%s)\n",__DATE__);
    fprintf(stderr,"usage: %s file file [QUICK]\n",argv[0]);
    exit(20);
  }
  
  if (NULL == (fp1 = fopen(argv[1],"r"))) error1;
  if (NULL == (fp2 = fopen(argv[2],"r"))) error2;
  len1 = getfilesize(fp1);
  len2 = getfilesize(fp2);
  if (fseek(fp1,strt1,SEEK_SET)) error1;
  if (fseek(fp2,strt2,SEEK_SET)) error2;
  pos1 = strt1; pos2 = strt2;
  
  printf("       %s ",argv[1]);
  for (i=strlen(argv[1]);i<49;i++) putchar(' ');
  printf("%s\n",argv[2]);

  l = buflen;
  while (pos1!=len1 && pos2!=len2) {
    if (len1-pos1 < l) l = len1-pos1;
    if (len2-pos2 < l) l = len2-pos2;
    if (1 != fread(b1, l, 1, fp1)) error1;
    if (1 != fread(b2, l, 1, fp2)) error2;
    diffs += cmp (b1, b2, pos1, pos2, l);
    pos1 += l; pos2 += l;
  }
  
  printf(diffs == 0 ? "files are equal\n" : "files have %d differences\n",diffs);
  if (len1 != len2) printf("file '%s' is %d bytes %s than file '%s'\n",
    argv[1],abs(len1-len2),len1>len2?"larger":"shorter",argv[2]);
  
  if (diffs == 0) return 0; else return 5;
}

