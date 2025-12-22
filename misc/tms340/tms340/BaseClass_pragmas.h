/* "tms340class.library"*/
/**/
/*   Class Basic Functions*/
/**/
#pragma libcall TMS340ClassBase WriteTMSReg 1e 08D03
#pragma libcall TMS340ClassBase ReadTMSReg 24 8D02
#pragma libcall TMS340ClassBase WriteTMSPixl 2a 08D03
#pragma libcall TMS340ClassBase ReadTMSPixel 30 8D02
#pragma libcall TMS340ClassBase WriteTMSDataArray 36 098D04
#pragma libcall TMS340ClassBase ReadTMSDataArray 3c 098D04
#pragma libcall TMS340ClassBase WriteTMSPixelXY 42 5432BA1098D0B
#pragma libcall TMS340ClassBase ReadTMSPixelXY 48 5432BA1098D0B
#pragma libcall TMS340ClassBase SetTMSClock 4e 10D03
#pragma libcall TMS340ClassBase ExecuteTMSCommand 54 80D03
#pragma libcall TMS340ClassBase ExecuteTMSModule 5a 98D03
/**/
/*   Class Support Functions*/
/**/
#pragma libcall TMS340ClassBase CreateTMSClass 60 801
#pragma libcall TMS340ClassBase CreateTMSSubClass 66 8D02
#pragma libcall TMS340ClassBase ObtainTMSClass 6c 801
/* do not use : */
#pragma libcall TMS340ClassBase ReleaseTMSClass 72 D01
#pragma libcall TMS340ClassBase AddTMSMethod 78 80D03
