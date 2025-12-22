/*************************************************
 *******       C_Z80 Ver.:2.00         ***********
 *************************************************
 **    Compilatore per Z80 by BIANCA SOFT       **
 **       (C) Maggio 1990,Maggio 1991           **
 **            Dicembre 1991                    **
 *************************************************/
/*************************************************
 *** DEFINIZIONE VARIABILI DEL PROGRAMMA       ***
 *************************************************/


#define P_CR printf("\n")
#define BUFF_SIZE 300

#define MAX_FILE 4-1  /* numero massimo di file apribili contemporaneamente */
#define MAX_OP 10 /*numero massimo di operandi per ogni riga */

#define E_U_C extern unsigned char
#define S_U_I extern unsigned short int
#define U_S_I unsigned short int
#define E_U_I extern unsigned int

#define VERO 1
#define FALSO 0
#define AND &&
#define OR ||

#define hbyte(vl) (vl>>8)
#define lbyte(vl) (vl & 0x000000FF)
#define bra(vl) (vl>indirizzo)?vl-indirizzo-2:254-indirizzo+vl
#define dpoke(vl,vl1) ((vl<<8)+vl1)

E_U_C  *o_tmp        ;     /* puntatore ad inizio area per file temporaneo */
E_U_I   l_tmp        ;     /* lunghezza totale area per file temporaneo */
E_U_I   p_tmp        ;     /* posizione attuale su area per file temporaneo */
E_U_C  bf_io[]       ;     /* area per per lettura da file */
extern int  p_bf     ;     /* puntatore a posizione su area precedente */
extern int  d_bf     ;     /* dimensioni effettive buffer */
E_U_C *lab           ;     /* stringa buffer per label,chiusa da 0x01 */
extern int l_lab     ;     /* lunghezza area label */
E_U_C  *labe         ;     /* puntatore ad area buffer per le label esterne */
E_U_I  l_labe        ;     /* lunghezza area buffer per label esterne */
E_U_I  s_labe        ;     /* start area dati in buffer per label esterne */
E_U_C  *labp         ;     /* puntatore ad area buffer per le label pubbliche */
E_U_I  l_labp        ;     /* lunghezza area buffer per label pubbliche */
E_U_C  *labr         ;     /* puntatore ad area buffer per le label rilocabili */
E_U_I  l_labr        ;     /* lunghezza area buffer per label rilocabili */
E_U_I  r_labr        ;     /* start area dati in buffer per label riloc. */
E_U_C  labele[]      ;     /* nome label esterna da aggiornare */
E_U_C  label[]       ;     /* stringa con campo label attuale */
E_U_C  istr[]        ;     /* stringa con campo istruzione attuale */
E_U_C  com[]         ;     /* stringa con campo commento attuale */
E_U_C  *op[]         ;     /* puntatore a stringhe con campo operandi attuali */
E_U_C  t_op[]        ;     /* tipo operandi su linea attuale */
S_U_I  v_op[]        ;     /* valore operandi su linea attuale */

S_U_I indirizzo ;  /* contatore indirizzo istruzione attuale */
S_U_I n_lin     ;  /* n# linea attuale compilata */
S_U_I n_error   ;  /* n# errori rilevati */
E_U_C c_error   ;  /* codice errore linea attuale */
E_U_C n_op      ;  /* n# operandi nella linea attuale */
E_U_C pref      ;  /* valore eventuale prefisso (se=0 non presente) */
S_U_I disp      ;  /* valore eventuale displacement */
S_U_I leni      ;  /* lunghezza linea compilata attuale */
extern int fe   ;  /* indica se variabile da rilocare (1),esterna(2) o norm. (0) */
extern int fc   ;  /* indica se settare condensed fine(1) o no (0) */

E_U_C pseudo[]  ;  /* elenco pseudo istruzioni */
E_U_C no_op[]   ;  /* elenco +lung.e cod. istruzioni senza operandi */
E_U_C si_op[]   ;  /* elenco istruzioni con argomento */
extern int fl_lst ; /* file per listato */
extern int deb  ; /* variabile per debug on(1) o off(0) */
extern int list ;  /* indica se generare listato(1) o no(0) */


extern char ms_err() ;  /* routin stampa errori */
extern int trov_str();  /* routin ricerca stringhe in array */
extern int p_err()   ;  /* routin stampa errori di compilazione */
extern int rd_cmp()  ;  /* estrazione campi dal file .TMP */
