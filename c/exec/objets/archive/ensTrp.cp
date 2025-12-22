// EnsTrp: Lundi 01-Fév-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/ensTrp.h>

EnsTrp::EnsTrp(MOTN trp): Trappes(trp) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": EnsTrp.EnsTrp("<<Trappes<<") {}\n";
   sode->vasY();
#endif
}

EnsTrp::EnsTrp(classe Trappe trp) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": EnsTrp.EnsTrp("<<trp.Numero<<") {\n";
   sode->vasY();
#endif
   Trappes= 1<<trp.Numero;
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

