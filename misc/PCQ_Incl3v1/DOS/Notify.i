
{$I   "Include:Exec/Types.i"}
{$I   "Include:Exec/Ports.i"}
{$I   "Include:Exec/Tasks.i"}



CONST
{     use of Class and code is discouraged for the time being - we might want to
   change things }
{     --- NotifyMessage Class ------------------------------------------------ }
     NOTIFY_CLASS  =  $40000000;

{     --- NotifyMessage Codes ------------------------------------------------ }
     NOTIFY_CODE   =  $1234;


{     Sent to the application if SEND_MESSAGE is specified.                    }

Type
{     Do not modify or reuse the notifyrequest while active.                   }
{     note: the first LONG of nr_Data has the length transfered                }

    nr_Msg = Record
     nr_Port : MsgPortPtr;
    END;
    nr_MsgPtr = ^nr_Msg;

    nr_Signal = Record
     nr_Task : TaskPtr;
     nr_Signalnum : Byte;
     nr_pad : Array[0..2] of Byte;
    END;
    nr_SignalPtr = ^nr_Signal;

       NotifyRequest = Record
        nr_Name,
        nr_FullName :  String;             {     set by dos - don't touch }
        nr_UserData,                       {     for applications use }
        nr_Flags    : Integer;
        nr_stuff    : Array[0..7] of Byte;
        nr_Reserved : Array[0..3] of Integer;           {     leave 0 for now }

        {     internal use by handlers }
        nr_MsgCount : Integer;              {     # of outstanding msgs }
        nr_Handler  : MsgPortPtr;           {     handler sent to (for EndNotify) }
       END;
       NotifyRequestPtr = ^NotifyRequest;

   NotifyMessage = Record
    nm_ExecMessage : Message;
    nm_Class       : Integer;
    nm_Code        : Short;
    nm_NReq        : NotifyRequestPtr;   {     don't modify the request! }
    nm_DoNotTouch,                       {     like it says!  For use by handlers }
    nm_DoNotTouch2 : Integer;            {     ditto }
   END;
   NotifyMessagePtr = ^NotifyMessage;


CONST
{     --- NotifyRequest Flags ------------------------------------------------ }
     NRF_SEND_MESSAGE      =  1 ;
     NRF_SEND_SIGNAL       =  2 ;
     NRF_WAIT_REPLY        =  8 ;
     NRF_NOTIFY_INITIAL    =  16;

{     do NOT set or remove NRF_MAGIC!  Only for use by handlers! }
     NRF_MAGIC             = $80000000;

{     bit numbers }
     NRB_SEND_MESSAGE      =  0;
     NRB_SEND_SIGNAL       =  1;
     NRB_WAIT_REPLY        =  3;
     NRB_NOTIFY_INITIAL    =  4;

     NRB_MAGIC             =  31;

{     Flags reserved for private use by the handler: }
     NR_HANDLER_FLAGS      =  $ffff0000;


PROCEDURE EndNotify(NR : NotifyRequestPtr);
    External;

FUNCTION StartNotify(nr : NotifyRequestPtr) : Boolean;
    External;

