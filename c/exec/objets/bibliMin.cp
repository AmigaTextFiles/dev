// BibliMin: Samedi 07-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/bibliMin.h>
#include <string.h>

extern int atoi(const char *);

BibliMin::BibliMin(TEXTE *nomBibli, TEXTE *chaineId):
                   (nomBibli, TN_BIBLIOTHEQUE),
                   Statut(1<<BS_SURSITAIRE|1<<BS_SOMDECTRL),
                   Bourre(0),
                   TaillePositive(tailleDe(*moiMeme)),
                   ChaineId(chaineId),
                   SommeDeControle(0), Abonnes(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": BibliMin.BibliMin(\""<<Nom<<
          "\",\n "<<ChaineId<<") {\n";
   sode->vasY();
#endif
// chaineId= "nom version.revision (dd MON yyyy)",<cr>,<lf>,<null>
   Version= Revision= 0;
   TEXTE *ptrB= strchr(chaineId, ' ');
   si ( ptrB ) {
      TEXTE *chChif= "0123456789";
      TEXTE *ptrC= strpbrk(ptrB, chChif);
      si ( ptrC ) {
         TEXTE verRev[15];
         strncpy(verRev, ptrC, 14); verRev[14]= '\0';
         TEXTE *ptrVR= strtok(verRev, " .");
         si ( ptrVR ) {
            Version= (MOTN)atoi(ptrVR);
            si ( ptrVR= strtok(NULLE, " .") ) Revision= (MOTN)atoi(ptrVR);
         }
      }
   }
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

