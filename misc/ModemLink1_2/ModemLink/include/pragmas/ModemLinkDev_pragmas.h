/* "modemlink.device"*/
#pragma libcall ModemLinkBase ML_BeginIO 1e 901
#pragma libcall ModemLinkBase ML_AbortIO 24 901
#pragma libcall ModemLinkBase ML_SendModemCMDTagList 2a A9803
#pragma libcall ModemLinkBase ML_DialTagList 30 A9803
#pragma libcall ModemLinkBase ML_AnswerTagList 36 9802
/**/
#pragma libcall ModemLinkBase ML_EstablishTagList 3c A9803
#pragma libcall ModemLinkBase ML_Terminate 42 801
/**/
#pragma libcall ModemLinkBase ML_AllocPkt 48 0
#pragma libcall ModemLinkBase ML_FreePkt 4e 801
#pragma libcall ModemLinkBase ML_FreePktList 54 801
/**/
#pragma libcall ModemLinkBase ML_PacketizeData 5a 909804
#pragma libcall ModemLinkBase ML_DePacketizeData 60 09803
