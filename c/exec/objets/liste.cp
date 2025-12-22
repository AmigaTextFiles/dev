// Liste: Samedi 15-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/liste.h>

Liste::Liste(Type_Noeud type): (), Type(type), Bourre(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Liste.Liste("<<Type<<") {}\n";
   sode->vasY();
#endif
}

