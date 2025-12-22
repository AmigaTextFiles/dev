*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Support include file
* $Id: Support.i 0.6 1997/09/10 22:27:43 MORB Exp MORB $
*

         rsreset
BlitNode rs.b      0

bn_Next            rs.l      1
bn_Count           rs.l      1
bn_Code            rs.l      1
bn_CPUCode         rs.l      1
bn_HData           rs.l      1
bn_Data            rs.l      10

;bn_bltcon0         rs.w      1
;bn_bltcon1         rs.w      1
;bn_bltafwm         rs.w      1
;bn_bltalwm         rs.w      1
;bn_bltcpt          rs.l      1
;bn_bltbpt          rs.l      1
;bn_bltapt          rs.l      1
;bn_bltdpt          rs.l      1
;bn_bltsize         rs.w      1
;bn_bltcon0l        rs.w      1
;bn_bltsizv         rs.w      1
;bn_bltsizh         rs.w      1
;bn_bltcmod         rs.w      1
;bn_bltbmod         rs.w      1
;bn_bltamod         rs.w      1
;bn_bltdmod         rs.w      1

;bn_couin           rs.l      4

;bn_bltcdat         rs.w      1
;bn_bltbdat         rs.w      1
;bn_bltadat         rs.w      1

bn_Size  rs.b      0

         rsreset
GardenDwarf        rs.b      0
gdw_Data           rs.l      1
gdw_Attach         rs.l      1
gdw_X              rs.w      1
gdw_Y              rs.w      1
gdw_Height         rs.w      1
gdw_Size           rs.b      0
