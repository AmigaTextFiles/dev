include "inc/exec/types.inc";
include "inc/exec/ports.inc";
include "inc/exec/tasks.inc";

def NOTIFY_CLASS = $40000000;

def NOTIFY_CODE = $1234;

struct NotifyMessage is
  nm_ExecMessage:Message;
  nm_Class:ulong;
  nm_Code:uword;
  nm_NReq:ulong;
  nm_DoNotTouch:ulong;
  nm_DoNotTouch2:ulong;
;

struct NotifyRequest is
  nr_Name:ulong;
  nr_FullName:ulong;
  nr_UserData:ulong;
  nr_Flags:ulong;
  nr_stuff:union is
    nr_Msg:struct is
      nr_Port:ulong;
    ;
    nr_Signal:struct is
      nr_Task:ulong;
      nr_SignalNum:ubyte;
      nr_pad[3]:ubyte;
    ;
  ;
  nr_Reserved[4]:ulong;
  nr_MsgCount:ulong;
  nr_Handler:ulong;
;

def NRF_SEND_MESSAGE = 1;
def NRF_SEND_SIGNAL = 2;
def NRF_WAIT_REPLY = 8;
def NRF_NOTIFY_INITIAL = 16;

def NRF_MAGIC = $80000000;

def NRB_SEND_MESSAGE = 0;
def NRB_SEND_SIGNAL = 1;
def NRB_WAIT_REPLY = 3;
def NRB_NOTIFY_INITIAL = 4;

def NRB_MAGIC = 31;

def NR_HANDLER_FLAGS = $ffff0000;

