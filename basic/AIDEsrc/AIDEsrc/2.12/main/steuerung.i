*   AIDE 2.12, an environment for ACE
*   Copyright (C) 1995/97 by Herbert Breuer
*		  1997/99 by Daniel Seifert
*
*                 contact me at: dseifert@berlin.sireco.net
*
*                                Daniel Seifert
*                                Elsenborner Weg 25
*                                12621 Berlin
*                                GERMANY
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 2 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, write to the
*          Free Software Foundation, Inc., 59 Temple Place, 
*          Suite 330, Boston, MA  02111-1307  USA

*--------------------------------------
steuerung

	moveq.l #0,d0   		;kein zusätzliches Signal
	moveq.l #1,d1   		;mit Wait()
	move.l  _WinMsgPort,a0  	;Zeiger auf MsgPort => a0

	bsr     gt_win_event    	;Ereignis besorgen

	bsr     sperren 		;keine weiteren Ereignisse zugelassen

	btst    #2,d0   		;RefreshWindow?
	beq.s   .window_close   	;nein

	move.l  _MainWinPtr,a0  	;ja, auffrischen
	bsr     gt_begin_refresh
	bsr     gt_end_refresh

	bsr     border_ausgeben
	bsr     beschriftung_ausgeben
	move.w  StartZeile,d0
	bsr     module_neu_ausgeben
	bra.s   .loop

.window_close
	btst    #9,d0   		;WindowClose?
	beq.s   .gadgetup       	;nein

	bsr     prg_beenden     	;Requester ausgeben
	tst.l   d0      		;beenden?
	bmi.s   .ende   		;ja
	bpl.s   .loop   		;nein

.gadgetup
	btst    #6,d0   		;GadgetUp?
	beq.s   .gadgetdown     	;nein

	bsr     react_on_gadget 	;ja, auswerten
	bra.s   .loop   		;auf neues Ereignis warten

.gadgetdown
	btst    #5,d0   		;GadgetDown?
	beq.s   .menue  		;nein

	bsr     react_on_gadget 	;ja, auswerten
	bra.s   .loop   		;auf neues Ereignis warten
.menue
	btst    #8,d0   		;Menü?
	beq.s   .loop   		;nein

	bsr     menue   		;ja, auswerten
	tst.l   d0      		;Programmende?
	bmi.s   .ende   		;ja
.loop
	bsr     freigeben       	;Ereignisse wieder zulassen
	bra     steuerung       	;und auf ein Neues
.ende
	rts
*--------------------------------------
