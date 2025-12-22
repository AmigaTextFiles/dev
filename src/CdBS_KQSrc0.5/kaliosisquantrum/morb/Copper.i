*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Equates & structures for copper stuff
* $Id: Copper.i 0.2 1997/08/22 18:31:28 MORB Exp MORB $
*

MaxCopperLayers    = 10
MaxCopperDamages   = 50

         rsreset
CopperEntry        rs.b      0
ce_Next            rs.l      1
ce_Prev            rs.l      1
ce_YPos            rs.w      1
ce_Type            rs.w      1
ce_Data            rs.l      1

ce_SubType         rs.l      0         ; Uniquement pour CET_LONG
ce_CopperTable     rs.l      1         ; Uniquement pour CET_BREAK

ce_BytesPerLine    rs.l      1         ; Uniquement pour LST_BLOCK

CET_LATE           = -2
CET_SHORT          = -1      ; Série d'instruction courte
CET_LONG           = 0       ; Gros paté
CET_BREAK          = 1       ; Nouvelle table ou fin

*** Valeurs pour ce_SubType si ce_Type=CET_LONG ***

LST_NOMANSLAND     = 0       ; Buffer où les instructions sont ajoutées
                             ; les unes à la suite des autres (correspond
                             ; à une zone 'vide' de l'écran, du moins du
                             ; point de vue du copper)

LST_BLOCK          = 1       ; Bloc d'instructions répétées à chaque ligne
                             ; où devront être insérées les éventuelles
                             ; séries d'instructions courtes
