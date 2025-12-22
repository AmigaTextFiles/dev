#define ISAMMAXKEYLEN 30  /* Nicht Ändern da intern in der Library verdrahtet */
typedef unsigned char IsamKeyStr [ISAMMAXKEYLEN +1];
typedef unsigned char Boolean;

typedef  __asm void ( *FBuildKey)(register __a0 void*,
                                         register __d1 unsigned,
                                         register __a1 char*) ;

typedef int far ( *t_FehlerFkt)(long Fehlernummer) ;
typedef enum {DAT=0,LOC,AUF,MAT,USER} e_Pfad;
/* Achtung LockDatei und ReadLock heben sich gegenseitig auf */
typedef enum {NoLock,LockSatz,LockKette,LockDatei,ReadLock} LockMode;

typedef struct{
  char  name[33];                /* Langname des Key */
  int  flag;                     /* Index-Datei göffnet oder geschlossen */
  unsigned char laenge;          /* länge des Key */
  Boolean  einein;               /* Eineindeutigkeit des Key */
  char etyp;         /*  Eingabetyp alphanum oder num... nach SAA- TOOLS   */
  IsamKeyStr Key;                /* augenblicklicher Key als String */
} Indextyp;

typedef struct{
  Indextyp *id;             /* Definitionen für die Indexdateien */
  char  name[18];           /* Dateiname: Datendatei..dat Indexdateien..ix*/
  int  flag;                /* Datei geöffnet oder geschlossen */
  int  LockAnz;             /* Anzahl der gelockten Records dieser Datei */
  int  LockDatei;           /* TRUE/FALSE Diese Datei wurde gelockt */
  e_Pfad  Pfad;             /* DAT=0 LOC=1 AUF=2 MAT=3 USER=4 */
  char pfadkey[9];          /* Bei User-Pfad der FConfig-Key  */
  Boolean Save;             /* Save-Modus Ja/Nein */
  Boolean ReadOnly;         /* ReadOnly   Ja/Nein */
  Boolean OvWrite;          /* True überschreibt alle Änderungen */
  Boolean SetDate;          /* True schreibt das SysZeit-Datum   */
  long  IsamLastError;      /* Letzter Status von IsamError dieser Datei */
  t_FehlerFkt FehlerFkt;    /* FktZeiger   Fehlerbearbeitungsteuerung */
  unsigned anzkey;          /* Anzahl der belegten Keys d.h. Indexdateien */
  long size;                /* Größe eines Datensatzes */
  void *daten[2];           /* Zeiger auf den ersten und zweiten Datensatz*/
  void *IFBPtr;             /* reserved */
  FBuildKey BuildKey;       /* Keys aufbauen */
} Datentyp;

int  ISAMInit(unsigned long FreeBytes);
void ISAMExit( void );
int  ISAMIsInit(void);
long ISAMGetError(void);
int  ISAMAddDatei(Datentyp *D);
void*ISAMDateiMalloc(Datentyp *Dt);
int  ISAMRemoveDatei(int id);
char*ISAMGetPfad(char *Key);
int  ISAMAddPfad(char *Key,char *Pfad);
int  ISAMChangeDateiPfad(int id,int pfad,char *Key);
char*ISAMGetDateiName(int id);
int  ISAMChangeDateiName(int id,char *Name);
int  ISAMFehler(long Fehlernr);
long ISAMGetPos(int id, unsigned keynr, unsigned scale,IsamKeyStr key);
int  ISAMCheckDatei(int id);
int  ISAMCloseDatei(int id);
int  ISAMLoeschDatei(int id);
long ISAMNextKey(int id,unsigned keynr, IsamKeyStr key);
long ISAMPrevKey(int id,unsigned keynr, IsamKeyStr key);
long ISAMSuchKey(int id,unsigned keynr, IsamKeyStr key,int flag);
long ISAMFindKey(int id,unsigned keynr,IsamKeyStr key);
int  ISAMSuchSatz(int id, unsigned keynr, IsamKeyStr key, int flag);
int  ISAMFindSatz(int id, unsigned keynr, IsamKeyStr key);
int  ISAMNextSatz(int id, unsigned keynr, IsamKeyStr key);
int  ISAMPrevSatz(int id, unsigned keynr, IsamKeyStr key);
int  ISAMSchreibSatz(int id);
int  ISAMFirstSatz(int id, unsigned keynr);
int  ISAMLastSatz(int id, unsigned keynr);
int  ISAMLoeschSatz(int id);
int  ISAMClearSatz(int id);
int  ISAMGetSatz(int id, long St);
int  ISAMLockSatz(int id, LockMode lmode);
long ISAMUsedSatz(int id);
long ISAMFreeSatz(int id);
int  ISAMCheckSatz (int id);
void ISAMGross(char *key);

