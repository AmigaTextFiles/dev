// $Id: locale.cc 1.3 1997/09/17 08:16:17 dlorre Exp dlorre $
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
