MODULE Today;

FROM SYSTEM IMPORT ADR,ADDRESS,TAG;
IMPORT dt:DateConversions,DosL,DosD,ReqTools;

VAR 
  DateStr,TimeStr:ARRAY[0..10] OF CHAR;
  date:DosD.Date;
  tagBuf:ARRAY[0..50] OF LONGINT;
  adr:ADDRESS;

BEGIN
  DosL.DateStamp(ADR(date));
  dt.DateToStr(date,"%d-%m-%y",DateStr);
  dt.DateToStr(date,"%H:%M:%S",TimeStr);
  adr:=TAG(tagBuf,ADR(DateStr),ADR(TimeStr));
  ReqTools.vEZRequest(ADR("Today's date is : %s\nand the time is : %s"),
              ADR("Continue"), NIL, NIL, adr);

END Today.
