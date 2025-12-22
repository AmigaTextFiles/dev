// Patient: Vendredi 02-Oct-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/patient.h>

extern TacMin *FindTask(TEXTE *);

Patient::Patient(): () {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Patient.Patient() {\n";
   sode->vasY();
#endif
   AdrPatient= FindTask(NULLE);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

