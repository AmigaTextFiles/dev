/* :ts=4
 */

struct LocaleBase *LocaleBase;
struct Catalog *CXRef_Catalog=NULL;

#include <libraries/locale.h>
#include <proto/locale.h>

#define MSG_OK				0
#define MSG_REQERRTIT		1
#define MSG_DESCRIPTION		2
#define MSG_ERRUNKNOWNTYPE	3
#define MSG_ERRAREXX		4
#define MSG_ERRFILETYPE		5
#define MSG_ERRXREFNOTFOUND	6

STRPTR CXRef_Strings[]={
	"Ok",
	"FastCXRef Error",
	"Autodoc & Header reference system",
//	 1234567890123456789012345678901234567
	"Unknown CxMsg type",
	"ARexx error",
	"Wrong filetype",
	"Cannot open XREF file",
	NULL
};

void OpenCXRefCatalog(struct Locale *loc, STRPTR language)
{
	LONG tag, tagarg=0L;
	if (!LocaleBase) LocaleBase=(struct LocaleBase *)OpenLibrary("locale.library",37);
	if (language == NULL)
		tag=TAG_IGNORE;
	else
		{
		tag = OC_Language;
		tagarg = (LONG)language;
		}
	if (LocaleBase != NULL  &&  CXRef_Catalog == NULL)
		CXRef_Catalog = OpenCatalog(loc, (STRPTR) "CXRef.catalog",
											OC_BuiltInLanguage, (ULONG)"english",
											tag, tagarg,
											OC_Version, 1L,
											TAG_DONE);
}

STRPTR GetString(LONG strnum)
{
	if (CXRef_Catalog == NULL)
		return(CXRef_Strings[strnum]);
	return(GetCatalogStr(CXRef_Catalog, strnum, CXRef_Strings[strnum]));
}

void CloseCXRefCatalog(void)
{
	if (LocaleBase != NULL)
		CloseCatalog(CXRef_Catalog);
	CXRef_Catalog = NULL;
	if(LocaleBase) CloseLibrary((struct Library *)LocaleBase);
}


