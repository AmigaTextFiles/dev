// EnsSig: Dimanche 16-Août-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/ensSig.h>

EnsSig::EnsSig(LONGBITS es): Signaux(es) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": EnsSig.EnsSig("<<Signaux<<") {}\n";
   sode->vasY();
#endif
}

EnsSig::EnsSig(classe Signal s) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": EnsSig.EnsSig("<<s.Numero<<") {\n";
   sode->vasY();
#endif
   Signaux= 1<<s.Numero;
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

