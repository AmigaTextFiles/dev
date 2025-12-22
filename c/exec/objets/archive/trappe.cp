// Trappe: Lundi 17-Août-1992 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/trappe.h>

Trappe::Trappe(OCTET n): Numero(n) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Trappe.Trappe("<<Numero<<") {}\n";
   sode->vasY();
#endif
}

