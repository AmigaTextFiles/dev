// Resident: Jeudi 22-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/resident.h>
#include <string.h>

extern int atoi(const char *);
extern NEANT asmPrologueRes();

Resident::Resident(TEXTE *nomRes, TEXTE *chaineId, OCTETN type, OCTET pri):
                   InsILLEGAL(0x4AFC),
                   Signature(moiMeme),
                   AdrDePoursuite(tailleDe(Resident)),
                   Drapeaux(0),
                   Type(type), Priorite(pri),
                   Nom(nomRes), ChaineId(chaineId),
                   Init(asmPrologueRes) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Resident.Resident(\""<<Nom<<
          "\",\n "<<ChaineId<<", "<<type<<", "<<pri<<") {\n";
   sode->vasY();
#endif
// chaineId= "nom version.revision (dd MON yyyy)",<cr>,<lf>,<null>
   Version= 0;
   TEXTE *ptrB= strchr(chaineId, ' ');
   si ( ptrB ) {
      TEXTE *chChif= "0123456789";
      TEXTE *ptrC= strpbrk(ptrB, chChif);
      si ( ptrC ) {
         TEXTE verRev[15];
         strncpy(verRev, ptrC, 14); verRev[14]= '\0';
         TEXTE *ptrVR= strtok(verRev, " .");
         si ( ptrVR ) Version= (OCTETN)atoi(ptrVR);
      }
   }
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT Resident::prologue() { 
	*sode<<long(this)<<": Resident.prologue()\n";
}
