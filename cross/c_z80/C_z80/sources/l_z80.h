/**********************************
 **   l_z80.h : LINKER PER       **
 ** C_Z80 ASSEMBLER Ver.:1.00    **
 **       INCLUDE FILE           **
 **********************************
 ** by BIANCASOFT                **
 **         (c) 1992 GENNAIO     **
 **********************************/

#define MAX_FILE 50

#define U_C unsigned char
#define U_S_I unsigned short int

#define AND &&
#define OR ||
#define NULL 0L

#define hbyte(vl) (vl>>8)
#define lbyte(vl) (vl & 0x000000FF)
#define bra(vl) (vl>indirizzo)?vl-indirizzo-2:254-indirizzo+vl
#define dpoke(vl,vl1) ((vl<<8)+vl1)

/** VARIABILI PUBBLICHE **/

extern U_S_I mod[]          ;  /* tabella per nuove origini di ogni blocco */
extern int n_mod            ;  /* puntatore su precedente tabella */
extern unsigned char *ar_p  ;  /* area per le variabili pubbliche */
extern unsigned int l_ap    ;  /* lunghezza area variabili pubbliche */
extern unsigned char *ar_c  ;  /* area per codici macchina */
extern unsigned int l_ac    ;  /* lunghezza area per codici macchina */
extern unsigned char *ar_f  ;  /* area per nomi file da linkare */
extern unsigned int l_af    ;  /* lunghezza area precedente */
extern unsigned int nf      ;  /* numero totale file richiesti */
       /* area per n#canali dei file aperti */
extern unsigned int f_l[MAX_FILE]   ;
extern int nerror           ;  /* numero errori rilevati */
extern short orig           ;  /* origine attuale codici */

/** FUNZIONI ESTERNE **/

extern trov_str();
extern est_lb();
