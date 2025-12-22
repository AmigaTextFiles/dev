
		section	Test.QUE,DATA

;test question file - Test.QUE

Que:		dc.b	"Ques"		;Header
NumQ:		dc.w	1		;Number of questions

Desc:		dc.b	"Translate to Swedish"
		dcb.b	DesLeng-20,0

Que1:		dc.b	"Koira"
		dcb.b	QuesLeng-5,0

Ans1:		dc.b	"Hund"
		dcb.b	AnsLeng-4,0
Ans2:		dcb.b	AnsLeng,0
Ans3:		dcb.b	AnsLeng,0
Ans4:		dcb.b	AnsLeng,0
Ans5:		dcb.b	AnsLeng,0
Ans6:		dcb.b	AnsLeng,0
Ans7:		dcb.b	AnsLeng,0
Ans8:		dcb.b	AnsLeng,0
Ans9:		dcb.b	AnsLeng,0
Ans10:		dcb.b	AnsLeng,0

;... NumQ times Que1 and Ans1-10

Que_END:	dc.b	"QEND"		;End

		END
