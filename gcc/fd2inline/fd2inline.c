/*
 * fd2inline
 *
 * should be able to parse CBM fd files and generate vanilla inline calls
 * for gcc. Works as a filter. This is a 0.9 evaluation version. Don't expect
 * miracles (yet...).
 *
 * by Wolfgang Baron, all rights reserved.
 *
 * improved, updated, simply made workable by Rainer F. Trunz
 *
 */

/* $Id$ */

#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

/*
 * The program has a few sort of class definitions, which are the result of
 * object oriented thinking, to be imlemented in plain C. I just haven't
 * had the time to learn C++ or install the compiler. The design does however
 * improve robustness, which allows the source to be used over and over again.
 * if you use this code, please leave a little origin note.
 *
 */

const char *version_str= "$VER$ $Revision$ $Date$";

/*
 * These are general definitions including types for defining registers etc.
 */

#ifdef DEBUG

#define DBP(a) printf2(a)

static __inline void printf2( const char *fmt, ... )
{
  fprintf (stderr, fmt, (char *)(&fmt+1) );
}

#else

#define DBP(a)

#endif


#define REGS 16  /* d0=0,...,a7=15 */

typedef enum {
  d0, d1, d2, d3, d4, d5, d6, d7, a0, a1, a2, a3, a4, a5, a6, a7, illegal
} regs;

typedef unsigned char uchar, shortcard;
typedef unsigned long ulong;

typedef enum { false, nodef, real_error } Error;

static char *IHead =
	"#ifndef _INLINE_%s_H\n"
	"#define _INLINE_%s_H\n\n"
	"#ifndef _CDEFS_H_\n"
	"#include <sys/cdefs.h>\n"
	"#endif\n"
	"#ifndef _INLINE_STUBS_H_\n"
	"#include <inline/stubs.h>\n"
	"#endif\n\n"
	"__BEGIN_DECLS\n\n"
	"#ifndef BASE_EXT_DECL\n"
	"#define BASE_EXT_DECL\n"
	"#define BASE_EXT_DECL0 extern struct Library *%sBase;\n"
	"#endif\n"
	"#ifndef BASE_PAR_DECL\n"
	"#define BASE_PAR_DECL\n"
	"#define BASE_PAR_DECL0 void\n"
	"#endif\n"
	"#ifndef BASE_NAME\n"
	"#define BASE_NAME %sBase\n"
	"#endif\n\n"
	"BASE_EXT_DECL0\n\n";

static char *IFoot =
	"#undef BASE_EXT_DECL\n"
	"#undef BASE_EXT_DECL0\n"
	"#undef BASE_PAR_DECL\n"
	"#undef BASE_PAR_DECL0\n"
	"#undef BASE_NAME\n\n"
	"__END_DECLS\n\n"
	"#endif /* _INLINE_%s_H */\n";

char BaseName[32];
char BaseNamU[32];

/*
 * just some support functions, no checking
 */

char *NewString( char **new, const char * old )
{
    const char *high;
    ulong len;

  while ( *old && (' ' == *old || '\t' == *old) ) old++;
  len= strlen( old );
  for (high=old+len-1; high>=old && (' ' == *high || '\t' == *high); high-- );
  high++;
  len= high-old;
  *new = (char *)malloc( 1+len );
  if (*new) {
    strncpy( *new, old, len );
    (*new)[len]= '\0'; }
  else {
    fprintf (stderr, "no mem for string\n" ); }
  return *new;
}

static __inline void illparams (const char *funcname)
{
  fprintf (stderr, "%s: illegal Parameters\n", funcname );
}

static __inline const char * RegStr( regs reg )
{
    const char *myregs[]= {
      "d0", "d1", "d2", "d3", "d4", "d5", "d6", "d7",
      "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "illegal" };

  if ( reg > illegal ) reg= illegal;
  if ( reg < d0 )      reg= d0;
  return myregs[reg];
}

/*
 *    StrNRBrk
 *
 * searches string in from position at downwards, as long as in does not
 * contain any character in not.
 *
 */

const char * StrNRBrk( const char * in, const char *not, const char * at )
{
    const char *chcheck;
    Error ready;

  chcheck = "";   /* if at<in, the result will be NULL */
  for (ready=false; ready==false && at>=in; ) {
    for (chcheck=not; *chcheck && *chcheck != *at; chcheck++);
    if (*chcheck) ready= real_error;
    else at--;
  }
  DBP(( "{%c}", *chcheck ));
  return *chcheck ? at : NULL;
}

/*
 *    binSearch
 *
 * A binary search routine, wich operates on an array like you would use
 * for qsort. The prototype does not contain the (*) bug...
 *
 * returns the address of the (a?) fitting object, or NULL;
 *
 * the binary intersection is (low+high)/2, so the highest value will never
 * be reached, but the lowest value will. In the while condition, the diff
 * has to be called last in case we got an empty array.
 *
 */

void *binSearch (void ** array, size_t elements, const void *lookfor,
		 int cmpfunc(const void **, const void **))
{
    size_t low, high, index;
    int    diff;

  DBP(( "bs(%ld): ", (long)elements ));

  diff = 1;	/* this needs to be so in case we got an empty array... */

  low=0, high= elements;  /* our algorithm never reaches elements */

  while( index= (high+low)/2,  /* somewhere inbetween */
	 high!=low && (diff= cmpfunc((const void **)array+index,&lookfor)) ) {
    if (0<diff) {
      high= index;  /* our value was too big, so grow downwards */
      DBP(( "<" )); }
    else {
      low= index + 1;	   /* the low value will be reached */
      DBP(( ">" )); }
    DBP(( "%ld ", (long)index ));
  }
  DBP(( "->%ld\n", diff ? -1L : (long)index ));
  return diff ? NULL : array[index];  /* bingo */
}

/*
 *    CLASS fdFile
 *
 * stores a file with a temporary buffer (static length, sorry), a line number,
 * an offset (used for library offsets and an error field.
 * When there's no error, line will contain line #lineno and offset will be
 * the last offset set by the interpretation of the last line. If there's been
 * no ##bias line, this field assumes a bias of 30, which is the standard bias.
 * It is assumed offsets are always negative.
 */

#define fF_BUFSIZE 1024
#define fF_BUFFMT  "%1024[~ß]"

/* all you need to know about an fdFile you parse */

typedef struct {
    FILE * file;		/* the file we're reading from  */
    char   line[ fF_BUFSIZE ];	/* the current line		*/
    ulong  lineno;		/* current line number		*/
    long   offset;		/* current fd offset (-bias)    */
    Error  error;		/* is everything o.k.		*/
} fdFile;


fdFile *fF_ctor(const char *fname);
static __inline
void	     fF_dtor(             fdFile *obj );
static __inline
void	     fF_SetError(         fdFile *obj, Error error );
static __inline 
void	     fF_SetOffset(        fdFile *obj, long at );
Error	     fF_readln(           fdFile *obj );
static __inline
Error	     fF_GetError(   const fdFile *obj );
static __inline
long	     fF_GetOffset(  const fdFile *obj );
char	   * fF_FuncName(         fdFile *obj );       /* return name or null */


fdFile * fF_ctor( const char *fname )
{
  fdFile * result;

  if (fname) {
    result= (fdFile *) malloc( sizeof(fdFile) );
    if (result) {
      result->file= fopen( fname, "r" );
      if (result->file) {
	result->lineno= 0;
	fF_SetOffset( result, -30);
	fF_SetError( result, false );
	result->line[0]= '\0';
      }
    } }
  else {
    result= NULL;
    illparams( "fF_ctor" ); }
  return result;
}


static __inline
void fF_dtor( fdFile *obj )
{
  fclose( obj->file );
  free( obj );
}


static __inline void fF_SetError( fdFile *obj, Error error )
{
  if (obj)
    obj->error= error;
  else
    illparams( "fF_SetError" );
}


static __inline void fF_SetOffset( fdFile *obj, long at )
{
  if (obj)
    obj->offset= at;
  else
    illparams( "fFSetOffset" );
}


Error fF_readln( fdFile *obj )
{
  char *low, *bpoint;
  long glen, /* the length we read until now */
  len;       /* the length of the last segment */

  if (obj) {
    low= obj->line;
    glen= 0;
    do {
      obj->lineno++;
      if (!fgets( low, fF_BUFSIZE-1-glen, obj->file )) {
	fF_SetError( obj, real_error );
	obj->line[0]= '\0';
	return real_error; }
      if (low==strpbrk(low,"*#/")) {
	DBP(( "in# %s\n", obj->line ));
	return false; }
      len= strlen( low );
      bpoint= low+len-1;
      if ('\n'==*bpoint) *bpoint='\0', bpoint--, len--;
      if (';'==*bpoint || ')'==*bpoint ) {
	DBP(( "\nin: %s\n", obj->line ));
	return false; }
      glen+= len;
      low+= len;
      if (glen >= fF_BUFSIZE-10) {      /* somewhat pessimistic ? */
	fF_SetError(obj, real_error);
	fprintf (stderr, "line %lu too long.\n", obj->lineno );
	return real_error;
      }
      DBP(( "+" ));
    } while (!0);
  }
  illparams( "fF_readln" );
  return real_error;
}

/*
 *    fF_FuncName
 *
 * checks if it can find a function-name and return it's address, or NULL
 * if the current line does not seam to contain one. The return value will
 * be a pointer into a malloced buffer, thus the caller will have to free().
 */

char * fF_FuncName (fdFile *obj)
{
  const char *lower;
  const char *upper;
  char *buf;
  long obraces;		/* count of open braces */
  Error ready;		/* ready with searching */

  if (!obj || real_error==fF_GetError(obj)) {
    illparams( "fF_FuncName" );
    return NULL;
  }
  if (obj->line==strpbrk(obj->line, "#*/")) {
    fF_SetError( obj, nodef );
    return NULL;
  }

  lower= NULL;
  buf= NULL;

  if (obj && false == fF_GetError(obj)) {
    if ( upper=strrchr(obj->line, ')' )) {
      DBP(( "end:%s:", upper ));
      for(obraces= 1, ready= false; false== ready; upper=lower ) {
	lower= StrNRBrk( obj->line, "()", --upper );
	if (lower) {
	  switch (*lower) {
	    case ')': {
	      obraces++;
	      DBP(( " )%ld%s", obraces, lower ));
	      break; }
	    case '(': {
	      obraces--;
	      DBP(( " (%ld%s", obraces, lower ));
	      if (!obraces) ready= nodef;
	      break; }
	    default: {
	      fprintf (stderr, "faulty StrNRBrk\n" );
	    }
	  } }
	else {
	  fprintf (stderr, "'(' or ')' expected in line %lu.\n", obj->lineno );
	  ready= real_error;
	}
      }
      if (nodef==ready) {   /* we found the matching '(' */
	  long newlen;
	upper--;

	while (upper>=obj->line && (' ' == *upper || '\t' == *upper) ) upper--;

	lower= StrNRBrk( obj->line, " \t*)", upper );

	if (!lower) lower=obj->line;
	else lower++;

	newlen= upper-lower+2;
	buf= malloc( newlen );

	if (buf) {
	  strncpy( buf, lower, --newlen );
	  buf[newlen]= '\0';
	}
	else fprintf (stderr, "no mem for fF_FuncName" );
      }
    }
  }
  else illparams( "fF_FuncName" );
  return buf;
}



static __inline Error fF_GetError( const fdFile *obj )
{
  if (obj) return obj->error;
  illparams( "fF_GetError" );
  return real_error;
}



static __inline long fF_GetOffset( const fdFile *obj )
{
  if (obj) return obj->offset;
  illparams( "fF_GetOffset" );
  return -1;
}

/* ####################################################################### */
/* ####################################################################### */
/* ####################################################################### */

/*
 *    CLASS fdDef
 */

typedef struct {
  char * name;
  char * type;
  long	 offset;
  regs	 reg[REGS];
  char * param[REGS];
  char * proto[REGS];
} fdDef;

fdDef	   * fD_ctor(      void );
void	     fD_dtor(            fdDef *obj );
static __inline
void	     fD_NewName(         fdDef *obj, const char *newname );
void	     fD_NewParam(        fdDef *obj, shortcard at, const char * newstr );
void	     fD_NewProto(        fdDef *obj, shortcard at, const char * newstr );
static __inline
void	     fD_NewReg(          fdDef *obj, shortcard at, regs reg );
static __inline
void	     fD_NewType(         fdDef *obj, const char * newstr );
static __inline
void	     fD_SetOffset(       fdDef *obj, long off );
Error	     fD_parsefd(         fdDef *obj, fdFile * infile );
Error	     fD_parsepr(         fdDef *obj, fdFile * infile );
static __inline
const char * fD_GetName(   const fdDef *obj );
static __inline
long	     fD_GetOffset( const fdDef *obj );
static __inline
const char * fD_GetParam(  const fdDef *obj, shortcard at );
static __inline
regs	     fD_GetReg(    const fdDef *obj, shortcard at );
static __inline
const char * fD_GetRegStr( const fdDef *obj, shortcard at );
static __inline
const char * fD_GetType(   const fdDef *obj );
static __inline
shortcard    fD_ParamNum(  const fdDef *obj );
static __inline
shortcard    fD_ProtoNum(  const fdDef *obj );
static __inline
shortcard    fD_RegNum(    const fdDef *obj );
int	     fD_cmpName(   const fdDef **big, const fdDef **small );
void	     fD_write(     const fdDef *obj );

char * fD_nostring = "";


fdDef * fD_ctor( void )
{
  fdDef * result;
  regs    count;

  result= (fdDef *) malloc(sizeof(fdDef));
  if (result) {
    result->name= fD_nostring;
    result->type= fD_nostring;
    for ( count=d0; count<illegal; count++ ) {
      result->reg[count]= illegal;
      result->param[count]= fD_nostring;   /* if (!strlen) dont't free() */
      result->proto[count]= fD_nostring;
    } }
  return result;
}

/* free all resources and make the object as illegal as possible */

void fD_dtor( fdDef * obj )
{
  regs count;

  if (obj) {
    if (!obj->name) fprintf (stderr, "fD_dtor: null name" );
    else if (obj->name != fD_nostring) free( obj->name );
    if (!obj->type) fprintf (stderr, "fD_dtor: null type" );
    else if (obj->type != fD_nostring) free( obj->type );
    obj->name= obj->type= NULL;

    for (count= d0; count<illegal; count++) {
      obj->reg[count]= illegal;
      if (!obj->param[count]) fprintf (stderr, "fD_dtor: null param" );
      else if (obj->param[count] != fD_nostring) free(obj->param[count]);
      if (!obj->proto[count]) fprintf (stderr, "fD_dtor: null proto" );
      else if (obj->proto[count] != fD_nostring) free(obj->proto[count]);
      obj->param[count]= obj->proto[count]= NULL; }
    free(obj);
  }
  else fprintf (stderr, "dfDef_dtor(NULL)\n" );
}



static __inline
void fD_NewName (fdDef *obj, const char *newname)
{
  if (obj && newname) {
    if (obj->name && fD_nostring != obj->name ) free( obj->name );
    if (!NewString( &obj->name, newname )) obj->name= fD_nostring;
  }
  else illparams( "fD_NewName" );
}


void fD_NewParam (fdDef *obj, shortcard at, const char * newstr)
{
  char *pa;

  if (newstr && obj && at>=d0 && at<illegal) {
    pa = obj->param[at];

    if (pa && fD_nostring != pa) free(pa);

    while (*newstr == ' ' || *newstr == '\t')
		newstr++;

    if (NewString (&pa, newstr))
      obj->param[at]= pa;
    else
      obj->param[at]= fD_nostring;
  }
  else illparams( "fD_NewParam" );
}


static __inline
void RealProto (char *wrgp)
{
 char *t;
 t = wrgp + strlen(wrgp)-1;

 while (*t != ' ' && *t != '\t' && *t != '*') t--;

 if (*t == '*')
   *++t = '\0';
 else
   *t = '\0';
}

void fD_NewProto (fdDef *obj, shortcard at, const char *newstr)
{
  char *pr;

  if (newstr && obj && at>=d0 && at<illegal) {
    pr = obj->proto[at];

    if (pr && fD_nostring != pr) free(pr);

    RealProto (newstr);

    if (NewString (&pr, newstr))
      obj->proto[at]= pr;
    else
      obj->proto[at]= fD_nostring;
  }
  else illparams( "fD_NewProto" );
}


static __inline
void fD_NewReg( fdDef *obj, shortcard at, regs reg )
{
  if (obj && at>=d0 && at<illegal && reg>=d0 && reg<=illegal)
    obj->reg[at] = reg;
  else illparams( "fD_NewReg" );
}


static __inline
void fD_NewType( fdDef *obj, const char *newtype )
{
  if (obj && newtype) {
    if (obj->type && fD_nostring != obj->type ) free( obj->type );
    if (!NewString( &obj->type, newtype )) obj->type= fD_nostring; }
  else illparams( "fD_NewType" );
}


static __inline
void fD_SetOffset( fdDef *obj, long off )
{
  if (obj)
    obj->offset=off;
  else
    illparams( "fD_SetOffset" );
}

/*    fD_parsefd
 *
 *  parse the current line. Needs to copy input, in order to insert \0's
 *  RETURN
 *    fF_GetError(infile):
 *	false = read a definition.
 *	nodef = not a definition on line (so try again)
 *	error = real error
 */

Error fD_parsefd( fdDef * obj, fdFile * infile )
{
  enum  parse_info { name, params, regs, ready } parsing;
  char  *buf, *bpoint, *bnext;
  ulong index;

  if (obj && infile && (false == fF_GetError(infile))) {
    parsing= name;

    if (!NewString( &buf, infile->line )) {
      fprintf (stderr, "no mem for line %lu\n", infile->lineno );
      fF_SetError( infile, real_error );
    }
    bpoint = buf;  /* so -Wall keeps quiet */

    /* printf("copied %lu: %s", infile->lineno, buf ); */

    /* try to parse the line until there's an error or we are done */

    while (ready != parsing && false == fF_GetError(infile)) {

      switch (parsing) {

	case name: {

	  switch (buf[0]) {

	    case '#': {

	      if (strncmp("##base", buf, 6) == 0) {
		bnext = buf + 6;
		while (*bnext == ' ' || *bnext == '\t')
		  bnext++;
		strncpy (BaseName, bnext, strstr (bnext, "Base")-bnext);
	      } else
	      if (strncmp("##bias", buf, 6) == 0) {
		if (!sscanf(buf+6, "%ld", &infile->offset)) {
		  fprintf (stderr, "illegal ##bias in line %lu: %s\n",
			   infile->lineno, infile->line );
		  fF_SetError( infile, real_error );
		  break;	/* avoid nodef */
		}
		else {
		  if (fF_GetOffset(infile) > 0)
		    fF_SetOffset(infile, -fF_GetOffset(infile));

		  /* printf("set offset to %ld\n", fFGetOffset(infile); */
		}
	      }		/* drop through for error comment */
	    }
	    case '*':

	      fF_SetError( infile, nodef ); /* try again somewhere else */
	      break;

	    default: {		/* assume a regular line here */

	      parsing = name;	/* switch (parsing) */

	      for (index=0; buf[index] && buf[index]!='('; index++);

	      if (!buf[index]) {	/* oops, no fd ? */
		fprintf (stderr, "not an fd, line %lu: %s\n",
			 infile->lineno, buf /* infile->line */ );
		fF_SetError(infile, nodef); } /* maybe next time */
	      else {
		buf[index]=0;

		fD_NewName (obj, buf);
		fD_SetOffset (obj, fF_GetOffset(infile));

		bpoint  = buf+index+1;
		parsing = params;	/* continue the loop */
	      }
	    } }
	  break; }

	case params: {

	  char *bptmp;	/* needed for fD_NewParam */

	  /* look for parameters now */

	  for ( bnext = bpoint;
		*bnext && *bnext!=',' && *bnext!=')';
		bnext++ );

	  if (*bnext) {
	    bptmp=bpoint;

	    if (*bnext == ')') {
	      if (bnext[1] != '(') {
		fprintf (stderr, "registers expected in line %lu: %s\n",
			 infile->lineno, infile->line );
		fF_SetError(infile, nodef); }
	      else {
		parsing = regs;
		bpoint  = bnext+2;
	      }
	    }
	    else bpoint = bnext+1;

	    /* terminate string and advance to next item */

	    *bnext= '\0';
	    fD_NewParam (obj, fD_ParamNum(obj), bptmp);
	  }
	  else {
	    fF_SetError(infile, nodef);
	    fprintf (stderr, "param expected in line %lu: %s\n",
		     infile->lineno, infile->line );
	  }
	  break; } /* switch parsing */

	case regs: {		/* look for parameters now */

	  for ( bnext= bpoint
	      ; *bnext && *bnext!='/' && *bnext!=',' && *bnext!=')'
	      ; bnext++ );

	  if (*bnext) {
	    if (')'==*bnext) {    /* wow, we've finished */
	      fF_SetOffset( infile, fF_GetOffset(infile)-6 );
	      parsing= ready;
	    }
	    *bnext= '\0';

	    bpoint[0] = tolower (bpoint[0]);

	    if (('d'==bpoint[0] || 'a'==bpoint[0])
		&& '0'<=bpoint[1] && '8'>=bpoint[1] && bnext == bpoint+2)
	      fD_NewReg( obj, fD_RegNum(obj),
			 bpoint[1]-'0'+(bpoint[0]=='a'?8:0) );
	    else if (bnext!=bpoint) { /* it is when our function is void */
	      fprintf (stderr, "illegal register %s in line %ld\n",
		       bpoint, infile->lineno );
	      fF_SetError(infile, nodef); }
	    bpoint= bnext+1;
	  }
	  else {
	    fF_SetError(infile, nodef);
	    fprintf (stderr, "reg expected in line %lu\n", infile->lineno );
	  }
	  break; }  /* switch parsing */

	case ready: {
	  fprintf (stderr, "internal error, use another compiler.\n" );
	  break;
	}
      } }
    free( buf );
    return fF_GetError(infile); }
  else {
    illparams( "fD_parsefd" );
    return real_error;
  }
}

Error fD_parsepr (fdDef *obj, fdFile * infile)
{
  char	*buf;	   /* a copy of infile->line			 */
  char	*bpoint,   /* cursor in buf				 */
	*bnext,    /* looking for the end			 */
	*lowarg;   /* beginning of this argument		 */
  long	obraces;   /* count of open braces			 */
  regs	count,     /* count parameter number			 */
	args;	   /* the number of arguments for this function  */

  if (!(obj && infile && false==fF_GetError(infile))) {
    illparams ("fD_parsepr");
    fF_SetError (infile, real_error);
    return real_error;
  }
  if (!NewString (&buf, infile->line)) {
    fprintf (stderr, "no mem for fD_parsepr\n");
    fF_SetError (infile, real_error);
    return real_error;
  }
  fF_SetError (infile, false);

  if (bpoint = strstr (buf, fD_GetName(obj))) {

    while (--bpoint>=buf && (' '== *bpoint || '\t'== *bpoint));
    *++bpoint= '\0';

    fD_NewType (obj, buf);

    while (bpoint && '('!=*bpoint++);        /* one beyond '(' */

    lowarg  = bpoint;
    obraces = 0;

    for (count=0, args=fD_RegNum(obj); count<args; bpoint= bnext+1) {

      while (*bpoint && (*bpoint==' ' || *bpoint=='\t')) /* ignore spaces */
	bpoint++;	

      bnext= strpbrk(bpoint, "(),");

      if (bnext) {
	switch (*bnext) {

	  case '(': {

	    obraces++;
	    DBP(( "< (%ld%s >", obraces, bnext ));
	    break; }

	  case ')': {

	    if (obraces) {
	      DBP(( "< )%ld%s >", obraces, bnext ));
	      obraces--; }
	    else {
	      *bnext= '\0';
	      DBP(( "< )0> [LAST PROTO=%s]", lowarg ));
	      fD_NewProto( obj, count, lowarg );
	      lowarg= bnext+1;

	      if (count!=args-1) {
		/*
			fprintf (stderr, "%s needs %u arguments and got %u.\n",
			 fD_GetName(obj), args, count+1 );
		*/
		fF_SetError( infile, nodef ); }
	      count++; }
	    break; }

	  case ',': {

	    if (!obraces) {
	      *bnext= '\0';
	      DBP(( " [PROTO=%s] ", lowarg ));
	      fD_NewProto( obj, count, lowarg );
	      lowarg= bnext+1;
	      count++; }
	    break; }

	  default: {
	    fprintf (stderr, "faulty strpbrk in line %lu.\n", infile->lineno );
	  }
	} }
      else {
	/* fprintf (stderr, "faulty argument %u in line %lu.\n",
		count+1, infile->lineno );
	 */
	count=args; /* this will effectively quit the for loop */
	fF_SetError( infile, nodef );
      }
    }
    if (fD_ProtoNum(obj) != fD_RegNum(obj)) {
      fF_SetError( infile, nodef );
    }
  }
  else {
    fprintf (stderr, "fD_parsepr was fooled in line %lu\n", infile->lineno );
    fprintf (stderr, "function , definition %s.\n",
	     /* fD_GetName(obj),*/ infile->line );
    fF_SetError( infile, nodef );
  }

  free( buf );
  return fF_GetError(infile);
}


static __inline
const char * fD_GetName( const fdDef *obj )
{
  if (obj && obj->name) {
    return obj->name; }
  else {
    illparams( "fD_GetName" );
    return fD_nostring;
  }
}


static __inline
long fD_GetOffset( const fdDef *obj )
{
  if (obj) {
    return obj->offset; }
  else {
    illparams( "fD_GetOffset" );
    return 0;
  }
}


static __inline
const char * fD_GetProto (const fdDef *obj, shortcard at)
{
  if (obj && at>=d0 && at<illegal && obj->proto[at]) {
    return obj->proto[at]; }
  else {
    illparams( "fD_GetProto" );
    return fD_nostring;
  }
}


static __inline
const char * fD_GetParam( const fdDef *obj, shortcard at )
{
  if (obj && at>=d0 && at<illegal && obj->param[at]) {
    return obj->param[at]; }
  else {
    illparams( "fD_GetParam" );
    return fD_nostring;
  }
}


static __inline
regs fD_GetReg( const fdDef *obj, shortcard at )
{
  if (obj && at>=d0 && at<illegal) {
    return obj->reg[at]; }
  else {
    illparams( "fD_GetReg" );
    return illegal;
  }
}


static __inline
const char *fD_GetRegStr( const fdDef *obj, shortcard at )
{
  if (obj && at>=d0 && at<illegal)
    return RegStr( obj->reg[at] );
  else {
    illparams( "fD_GetReg" );
    return RegStr( illegal );
  }
}


static __inline
const char * fD_GetType( const fdDef *obj )
{
  if (obj && obj->type) {
    return obj->type; }
  else {
    illparams( "fD_GetType" );
    return fD_nostring;
  }
}

/* get first free param or illegal */

static __inline
shortcard fD_ParamNum( const fdDef *obj )
{
  shortcard count;

  if (obj) {
    for ( count= d0; count<illegal && fD_nostring!=obj->param[count]; count++ );
    return count; }
  else {
    illparams( "fD_ParamNum" );
    return illegal;
  }
}


static __inline
shortcard fD_ProtoNum( const fdDef *obj )
{
  shortcard count;

  if (obj) {
    for ( count= d0; count<illegal && fD_nostring!=obj->proto[count]; count++ );
    return count; }
  else {
    illparams( "fD_ProtoNum" );
    return illegal;
  }
}

/* get first free *reg or illegal */

static __inline
shortcard fD_RegNum( const fdDef *obj )
{
  shortcard count;

  if (obj) {
    for ( count= d0; count<illegal && illegal!=obj->reg[count]; count++ );
    return count; }
  else {
    illparams( "fD_RegNum" );
    return illegal;
  }
}


int fD_cmpName (const fdDef **big, const fdDef **small)	/* for qsort */
{
  int res;
  res = strcmp (fD_GetName (*big), fD_GetName(*small));
  return res;
}


void fD_write (const fdDef * obj)
{
  shortcard count, numregs;
  char *chtmp;
  int vd;

  DBP(("func %s\n", fD_GetName(obj)));

  vd = 0;
  numregs = fD_RegNum(obj);

  if ((chtmp = fD_GetType(obj)) == fD_nostring) {
    fprintf (stderr, "%s has no prototype.\n", fD_GetName(obj));
    return;
  }
  if (  tolower(chtmp[0]) == 'v' &&
	tolower(chtmp[1]) == 'o' &&
	tolower(chtmp[2]) == 'i' &&
	tolower(chtmp[3]) == 'd')
    vd = 1;

  if (fD_ProtoNum(obj) != numregs) {
    fprintf (stderr, "%s gets %ld fd args and %ld proto%s.\n",
	     fD_GetName(obj), numregs, fD_ProtoNum(obj),
	     fD_ProtoNum(obj) != 1 ? "s" : "");
    return;
  }
  printf ("extern __inline %s\n%s (BASE_PAR_DECL", chtmp, fD_GetName(obj));

  if (numregs > 0) {
    for (count=d0; count<numregs-1; count++)
       printf (" %s %s,",fD_GetProto(obj,count),
			fD_GetParam(obj,count));

    printf (" %s %s",fD_GetProto(obj,count),
			fD_GetParam(obj,count));
  }
  else
    putchar('0');

  if (vd)
    puts (")\n{\n\tBASE_EXT_DECL");
  else
    puts (")\n{\n\tBASE_EXT_DECL\n\tregister res __asm(\"d0\");");

  puts ("\tregister struct Library *a6 __asm(\"a6\") = BASE_NAME;");

  for (count=d0; count<numregs; count++) {
    chtmp = fD_GetRegStr (obj,count);
    printf ("\tregister %s %s __asm(\"%s\") = %s;\n",
	    fD_GetProto (obj,count), chtmp, chtmp, fD_GetParam (obj,count));
  }
  printf ("\t__asm __volatile (\"jsr a6@(-0x%lx)\"\n", -fD_GetOffset(obj));

  if (vd)
    puts ("\t: /* No Output */");
  else
    puts ("\t: \"=r\" (res)");

  printf ("\t: \"r\" (a6)");

  for (count=d0; count<numregs; count++)
    printf (", \"r\" (%s)", fD_GetRegStr(obj,count));

  printf ("\n\t: \"d0\", \"d1\", \"a0\", \"a1\"");

  for (count=d0; count<numregs; count++) {
    switch (fD_GetReg(obj,count)) {
      case d0:
      case d1:
      case a0:
      case a1: break;
      default: {
	printf (", \"%s\"", fD_GetRegStr(obj,count));
	break;
      }
    } }

  if (vd)
    printf (");\n}\n");
  else
    printf (");\n\treturn res;\n}\n");
}

#define FDS 1000

void main (int argc, char **argv)
{
  fdDef **mydef;
  fdDef *tmpdef= NULL,   /* a dummy to contain the name to look for */
	*founddef;	 /* the fdDef for which we found a prototype */

  fdFile *myfile;

  char *tmpstr;

  long count, fds;
  Error lerror = false;

  if (argc != 3) {
    fprintf (stderr, "Usage: %s fdfilename protofilename\n", argv[0] );
    exit(20);
  }

  mydef = malloc (FDS*sizeof(fdDef *));

  if (mydef) {

    for (count=0; count<FDS; count++) mydef[count]= NULL;

    myfile = fF_ctor (argv[1]);

    if (myfile) {
      lerror = false;

      for (count= 0; count<FDS && false==lerror; count++) {
	mydef[count]= fD_ctor();
	do {
	  if (false == (lerror = fF_readln (myfile))) {
	    fF_SetError(myfile, false);
	    lerror=fD_parsefd(mydef[count], myfile);
	  }
	} while (nodef==lerror);
      }
      if (count<FDS) {
	count--;
	fD_dtor( mydef[count] );
	mydef[count]= NULL;
      }
      fds = count;

      /* the gnu stdlib.h seems to have a bug for qsort: int (*)(etc.) */

      qsort (mydef, count, sizeof(fdDef *), (void *)fD_cmpName);

      fF_dtor( myfile );
      myfile = fF_ctor( argv[2] );

      if (myfile) {
	if (!tmpdef) tmpdef= fD_ctor();
	for (lerror= false; false==lerror; ) {
	  do {
	    if (false==(lerror=fF_readln(myfile))) {
	      fF_SetError( myfile, false );   /* continue even on errors */
	      tmpstr= fF_FuncName( myfile );
	      if (tmpstr) {
		fD_NewName( tmpdef, tmpstr );
		founddef= binSearch( (void **)mydef, fds, tmpdef, (void *)fD_cmpName );
		if (founddef) {
		  DBP(("found (%s).\n", fD_GetName( founddef ) ));
		  fF_SetError(myfile, false);
		  lerror= fD_parsepr(founddef, myfile);
		}
		else fprintf (stderr, "did not find <%s> in line %lu.\n",
			      tmpstr, myfile->lineno );
		free( tmpstr );
	      }
	      else lerror= nodef;
	    }
	  } while (nodef==lerror);
	}
	fD_dtor(tmpdef);
	tmpdef= NULL;
      }
    }
    else fprintf (stderr, "Couldn't open file.\n" );

    strcpy (BaseNamU, BaseName);
    strupr (BaseNamU);

    printf (IHead,BaseNamU,BaseNamU,BaseName,BaseName);

    for (count=0; count<FDS && mydef[count]; count++) {

      /* printf("outputting %ld...\n", count); */

      fD_write (mydef[count]);
      fD_dtor  (mydef[count]);
      mydef[count]= NULL;
    }

    printf (IFoot,BaseNamU);

    fF_dtor( myfile );
    myfile= NULL;

    switch (lerror) {
      case false:      exit(0);
      case nodef:      exit(20);
      case real_error: exit(20);
      default:	       exit(30);
    } }
  else {
    fprintf (stderr, "No mem for FDs\n" );
    exit(20);
  }
}

