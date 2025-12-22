MODULE 'graphics/regions','intuition/intuition'

#define REQ_Dummy 				(REACTION_Dummy + $45000)
#define REQS_Dummy 				(REQ_Dummy + $100)
#define REQI_Dummy 				(REQ_Dummy + $200)
#define REQP_Dummy 				(REQ_Dummy + $300)
#define REQ_Type 				(REQ_Dummy+1)
#define REQ_TitleText 			(REQ_Dummy+2)
#define REQ_BodyText 			(REQ_Dummy+3)
#define REQ_GadgetText 			(REQ_Dummy+4)
#define REQ_ReturnCode 			(REQ_Dummy+5)
#define REQ_TabSize 				(REQ_Dummy+6)
#define REQI_Minimum  			(REQI_Dummy+1)
#define REQI_Maximum  			(REQI_Dummy+2)
#define REQI_Invisible 			(REQI_Dummy+3)
#define REQI_Number 				(REQI_Dummy+4)
#define REQI_Arrows 				(REQI_Dummy+5)
#define REQI_MaxChars 			(REQI_Dummy+6)
#define REQS_AllowEmpty  		(REQS_Dummy+1)
#define REQS_Invisible 			(REQI_Invisible)
#define REQS_Buffer 				(REQS_Dummy+2)
#define REQS_ShowDefault 		(REQS_Dummy+3)
#define REQS_MaxChars 			(REQS_Dummy+4)
#define REQS_ChooserArray 		(REQS_Dummy+5)
#define REQS_ChooserActive 	(REQS_Dummy+6)
#define REQP_Total 				(REQP_Dummy+1)
#define REQP_Current 			(REQP_Dummy+2)
#define REQP_AbortText 			REQ_GadgetText
#define REQP_ProgressText 		REQ_BodyText
#define REQP_OpenInactive 		(REQP_Dummy+3)
#define REQP_NoText 				(REQP_Dummy+4)
#define REQP_Dynamic 			(REQP_Dummy+5)
#define REQP_CenterWindow 		(REQP_Dummy+6)
#define REQP_LastPosition 		(REQP_Dummy+7)
#define REQP_Percent 			(REQP_Dummy+8)
#define REQP_Ticks 				(REQP_Dummy+9)
#define REQP_ShortTicks 			(REQP_Dummy+10)
#define RM_OPENREQ 		($650001)
OBJECT orRequest
	MethodID:ULONG,
	Attrs:PTR TO TagItem,
	Window:PTR TO Window,
	Screen:PTR TO Screen

#define REQTYPE_INFO 		0	
#define REQTYPE_INTEGER 		1	
#define REQTYPE_STRING 		2	
#define REQTYPE_PROGRESS 	3	
#define OpenRequester(obj,win)	DoMethod(obj, RM_OPENREQ, NULL, win, NULL, TAG_DONE)
#define RequesterObject 			NewObject(REQUESTER_GetClass(), NULL
