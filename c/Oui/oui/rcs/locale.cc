head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	97.09.17.08.16.17;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	97.07.14.04.20.40;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.10;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.3
log
@*** empty log message ***
@
text
@// $Id: locale.cc 1.2 1997/07/14 04:20:40 dlorre Exp dlorre $
#include <exec/types.h>
#include <dos/dos.h>
#include "locale.h"

#if defined( LOCALISE )
#include <stdio.h>
#include <string.h>
#endif

#if defined( LOCALISE )
#include <proto/dos.h>
#endif
#include <proto/locale.h>
#include <mydebug.h>

#if defined( LOCALISE )
static char ch[255] ;
static char cdfilename[255] ;
static char ctfilename[255] ;
static BPTR fh ;

static void AppendString(STRPTR def, STRPTR string, int id, STRPTR desc, catalog *lc)
{
int l ;
    sprintf(ch, lc->catname) ;
    l = strlen(ch) ;
    if (l > 8 && !strcmp(ch+l-8, ".catalog")) {
        ch[l-8] = '\0' ;
    }
    sprintf(cdfilename, "RAM:%s.cd", ch) ;
    sprintf(ctfilename, "RAM:%s_%s.ct", ch, lc->langname) ;

    if (fh = Open(cdfilename, MODE_READWRITE)) {
        if (Seek(fh, 0, OFFSET_END) != -1) {
            if (id != -1)
                sprintf(ch, "%s (%ld//)\n%s\n", desc, id, def) ;
            else
                sprintf(ch, "%s (//)\n%s\n", desc, def) ;
            Write(fh, ch, strlen(ch)) ;
            Flush(fh) ;
        }
        Close(fh) ;
    }
    if (fh = Open(ctfilename, MODE_READWRITE)) {
        if (Seek(fh, 0, OFFSET_END) != -1) {
            sprintf(ch, "%s\n%s\n;%s\n;\n", desc, string, def) ;
            Write(fh, ch, strlen(ch)) ;
            Flush(fh) ;
        }
        Close(fh) ;
    }
}
#endif


catalog::catalog(char *name, char *deflang, char *lang) : locnum(0)
{
    if (LocaleBase) {
#if defined( LOCALISE )
int l ;
    strcpy(catname, name) ;
    strcpy(langname, lang ? lang : "default") ;
    sprintf(ch, catname) ;
    l = strlen(ch) ;
    if (l > 8 && !strcmp(ch+l-8, ".catalog")) {
        ch[l-8] = '\0' ;
    }
    sprintf(cdfilename, "RAM:%s.cd", ch) ;
    sprintf(ctfilename, "RAM:%s_%s.ct", ch, langname) ;
    if (fh = Open(cdfilename, MODE_NEWFILE))
        Close(fh) ;
    if (fh = Open(ctfilename, MODE_NEWFILE))
        Close(fh) ;

#endif
        cat = OpenCatalog(NULL, name,
            OC_BuiltInLanguage, deflang,
            OC_Language,        lang,
            TAG_DONE) ;
    }
    else
        cat = NULL ;
}
catalog::~catalog() { if (LocaleBase) CloseCatalog(cat) ; }


#ifdef LOCALISE
lstring::lstring(catalog *lc, char *def, char *desc, int id)
{
    if (lc && LocaleBase) {
        if (id != -1) lc->locnum  = id ;
        string = GetCatalogStr(lc->cat, lc->locnum, def) ;
        AppendString(def, string, id, desc, lc) ;
        lc->locnum++ ;
    }
    else
        string = def ;
}
#else
lstring::lstring(catalog *lc, char *def, int id)
{
    if (lc && LocaleBase) {
        if (id != -1) lc->locnum  = id ;
        string = GetCatalogStr(lc->cat, lc->locnum, def) ;
        lc->locnum++ ;
    }
    else
        string = def ;
}

#endif
@


1.2
log
@Now is catcomp compatible
@
text
@d1 1
a1 1
// $Id$
d61 1
d63 13
a75 1
    strcpy(langname, lang) ;
@


1.1
log
@Initial revision
@
text
@d1 1
d12 1
a12 1
#include <cxxproto/dos.h>
d14 2
a15 2
#include <cxxproto/locale.h>
#include <cclib/debug_protos.h>
d19 2
a20 3
const STRPTR filename = "RAM:locale.txt" ;
const STRPTR fmt = "%05ld %s\n" ;
static void AppendString(char *def, char *id) ;
d23 1
a23 1
static void AppendString(STRPTR def, int id)
d25 8
d34 1
a34 2
    fh = Open(filename, MODE_READWRITE) ;
    if (fh) {
d36 12
a47 1
            sprintf(ch, fmt,id, def) ;
d59 5
a63 1
    if (LocaleBase)
d68 1
d75 2
a76 2

lstring::lstring(catalog *lc, char *def, int id)
d79 4
a82 5
        string = GetCatalogStr(lc->cat, id, def) ;
#if defined( LOCALISE )
        AppendString(string, id) ;
#endif
        lc->locnum = id + 1 ;
d87 2
a88 2

lstring::lstring(catalog *lc, char *def)
d91 1
a92 3
#if defined( LOCALISE )
        AppendString(string, lc->locnum) ;
#endif
d99 1
@
