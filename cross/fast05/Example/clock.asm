*********************************************************
*							*
*                  EXAMPLE CLOCK MODULE                 *
*							*
*********************************************************
*********************************************************
*							*
*							*
*							*
*********************************************************

*********************************************************
* SUB                OPEN CLOCK                         *
*********************************************************

clk_open	JSR clk_rst		; reset clock values
		RTS			;

*********************************************************
* SUB                CLOCK UPDATE                       *
*********************************************************

clk_upd		LDA ClkInc		; if no clock inc
		BNE clk_tik		;   return
		RTS			;

*********************************************************
*                 Bump Clock Tick                       *
*********************************************************

clk_tik		DEC ClkInc		;
		LDA ClkTik		; bump ticks
		INC A			;
		STA ClkTik		;
		CMP #$32		; if ticks < 50
		BHS clk_sec		;   return
		RTS

*********************************************************
*                 Bump Clock Sec                        *
*********************************************************

clk_sec		LDA #$00		;
		STA ClkTik		; zero ticks
		SMB ClkSEC		; set the ctrl sec flag
		LDA ClkSec		; bump seconds
		INC A			;
		CMP #$3C		; if sec < 60
		BHS clk_min		;   return
		STA ClkSec		;
		RTS

*********************************************************
*                 Bump Clock Min                        *
*********************************************************

clk_min		LDA #$00		;
		STA ClkSec		; zero sec
		SMB ClkMIN		; set the ctrl min flag
		LDA ClkMin		; bump min
		INC A			;
		CMP #$3C		; if min < 60
		BHS clk_hrs		;   return
		STA ClkMin		;
		RTS

*********************************************************
*                 Bump Clock Hrs                        *
*********************************************************

clk_hrs		LDA #$00		;
		STA ClkMin		; zero min
		LDA ClkHrs		; bump hrs
		INC A			;
		CMP #$18		; if hrs < 24
		BHS clk_day		;   return
		STA ClkHrs		;
		RTS

*********************************************************
*                 Bump Clock Day                        *
*********************************************************

clk_day		LDA #$00		;
		STA ClkHrs		; zero hrs
		LDA ClkDay		; bump day
		INC A			;
		LDX ClkMth		; look up days in mth
		CMP clk_mth,X		; if =< days in mth
		BHI clk_mth		;   set day
		STA ClkDay		;   return
		RTS

*********************************************************
*                 Bump Clock Month                      *
*********************************************************

clk_mth		LDA #$01		;
		STA ClkDay		; set back day
		LDA ClkMth		; bump mth
		INC A			;
		CMP #$0C		; if mth =< 12
		BHI clk_yr		;   set mth
		STA ClkMth		;   return
		RTS			;
clk_yr		LDA #$01		; else
		STA ClkMth		;   set back mth
		RTS			;   return

*********************************************************
* SUB                RESET CLOCK                        *
*********************************************************

clk_rst		LDA #$00	; zero
		STA ClkInc	; interupt bump
		STA ClkTik	; tick
		STA ClkSec	; seconds
		STA ClkMin	; minutes
		STA ClkHrs	; hours
		STA ClkFlgs	; flags
		LDA #$01	; set 1
		STA ClkDay	; day
		STA ClkMth	; month
		RTS

*********************************************************
* TBL              DAYS IN MONTH                        *
*********************************************************

*		Nul Jan Feb Mar Apr May Jun Jly Aug Sep Oct Nov Dec
* month           0   1   2   3   4   5   6   7   8   9  10  11  12
* days		     31  28  31  30  31  30  31  31  30  31  30  31
clk_dim		$00,$1F,$1C,$1F,$1E,$1F,$1E,$1F,$1F,$1E,$1F,$1E,$1F

