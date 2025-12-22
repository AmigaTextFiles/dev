{$I "Include:Devices/InputEvent.i"}
{$I "Include:Devices/KeyMap.i"}
{$I "Include:Exec/Ports.i"}

VAR CxBase : Address;

{    **************
 * Broker stuff
 **************}

CONST
{     buffer sizes   }
      CBD_NAMELEN   =  24;
      CBD_TITLELEN  =  40;
      CBD_DESCRLEN  =  40;

{     CxBroker errors   }
      CBERR_OK      =  0;        {     No error                         }
      CBERR_SYSERR  =  1;        {     System error , no memory, etc    }
      CBERR_DUP     =  2;        {     uniqueness violation             }
      CBERR_VERSION =  3;        {     didn't understand nb_VERSION     }

      NB_VERSION    =  5;        {     Version of NewBroker structure   }

Type
  NewBroker = Record
   nb_Version   : Byte;  {     set to NB_VERSION                }
   nb_Name,
   nb_Title,
   nb_Descr     : String;
   nb_Unique,
   nb_Flags     : Short;
   nb_Pri       : Byte;
   {     new in V5   }
   nb_Port      : MsgPortPtr;
   nb_ReservedChannel  : Short;  {     plans for later port sharing     }
  END;
  NewBrokerPtr = ^NewBroker;

CONST
{     Flags for nb_Unique }
      NBU_DUPLICATE  = 0;
      NBU_UNIQUE     = 1;        {     will not allow duplicates        }
      NBU_NOTIFY     = 2;        {     sends CXM_UNIQUE to existing broker }

{     Flags for nb_Flags }
        COF_SHOW_HIDE = 4;

{    *******
 * cxusr
 *******}

{    * Fake data types for system private objects   }
Type
  CxObj = Integer;
  CxObjPtr = ^CxObj;
  CxMsg = Integer;
  CXMsgPtr = ^CxMsg;


CONST
{    ******************************}
{    * Commodities Object Types   *}
{    ******************************}
      CX_INVALID     = 0;     {     not a valid object (probably null)  }
      CX_FILTER      = 1;     {     input event messages only           }
      CX_TYPEFILTER  = 2;     {     filter on message type      }
      CX_SEND        = 3;     {     sends a message                     }
      CX_SIGNAL      = 4;     {     sends a signal              }
      CX_TRANSLATE   = 5;     {     translates IE into chain            }
      CX_BROKER      = 6;     {     application representative          }
      CX_DEBUG       = 7;     {     dumps kprintf to serial port        }
      CX_CUSTOM      = 8;     {     application provids function        }
      CX_ZERO        = 9;     {     system terminator node      }

{    ***************}
{    * CxMsg types *}
{    ***************}
      CXM_UNIQUE     = 16;    {     sent down broker by CxBroker()      }
{     Obsolete: subsumed by CXM_COMMAND (below)   }

{     Messages of this type rattle around the Commodities input network.
 * They will be sent to you by a Sender object, and passed to you
 * as a synchronous function call by a Custom object.
 *
 * The message port or function entry point is stored in the object,
 * and the ID field of the message will be set to what you arrange
 * issuing object.
 *
 * The Data field will point to the input event triggering the
 * message.
 }
      CXM_IEVENT     = 32;

{     These messages are sent to a port attached to your Broker.
 * They are sent to you when the controller program wants your
 * program to do something.  The ID field identifies the command.
 *
 * The Data field will be used later.
 }
      CXM_COMMAND    = 64;

{     ID values   }
      CXCMD_DISABLE   = (15);   {     please disable yourself       }
      CXCMD_ENABLE    = (17);   {     please enable yourself        }
      CXCMD_APPEAR    = (19);   {     open your window, if you can  }
      CXCMD_DISAPPEAR = (21);   {     go dormant                    }
      CXCMD_KILL      = (23);   {     go away for good              }
      CXCMD_UNIQUE    = (25);   {     someone tried to create a broker
                               * with your name.  Suggest you Appear.
                               }
      CXCMD_LIST_CHG  = (27);  {     Used by Exchange program. Someone }
                              {     has changed the broker list       }

{     return values for BrokerCommand(): }
      CMDE_OK        = (0);
      CMDE_NOBROKER  = (-1);
      CMDE_NOPORT    = (-2);
      CMDE_NOMEM     = (-3);

{     IMPORTANT NOTE: for V5:
 * Only CXM_IEVENT messages are passed through the input network.
 *
 * Other types of messages are sent to an optional port in your broker.
 *
 * This means that you must test the message type in your message handling,
 * if input messages and command messages come to the same port.
 *
 * Older programs have no broker port, so processing loops which
 * make assumptions about type won't encounter the new message types.
 *
 * The TypeFilter CxObject is hereby obsolete.
 *
 * It is less convenient for the application, but eliminates testing
 * for type of input messages.
 }

{    ********************************************************}
{    * CxObj Error Flags (return values from CxObjError())  *}
{    ********************************************************}
      COERR_ISNULL      = 1;  {     you called CxError(NULL)            }
      COERR_NULLATTACH  = 2;  {     someone attached NULL to my list    }
      COERR_BADFILTER   = 4;  {     a bad filter description was given  }
      COERR_BADTYPE     = 8;  {     unmatched type-specific operation   }


{    ****************************}
{     Input Expression structure }
{    ****************************}

      IX_VERSION        = 2;

Type
  InputXpression = Record
   ix_Version,               {     must be set to IX_VERSION  }
   ix_Class    : Byte;       {     class must match exactly   }

   ix_Code     : Short;      {     Bits that we want  }

   ix_CodeMask : Short;      {     Set bits here to indicate  }
                             {     which bits in ix_Code are  }
                             {     don't care bits.           }

   ix_Qualifier: Short;      {     Bits that we want  }

   ix_QualMask : Short;      {     Set bits here to indicate  }
                           {     which bits in ix_Qualifier }
                                                   {     are don't care bits        }

   ix_QualSame : Short;    {     synonyms in qualifier      }
  END;
  InputXpressionPtr = ^InputXpression;

   IX = InputXpression;
   IXPtr = ^IX;

CONST
{     QualSame identifiers }
      IXSYM_SHIFT = 1;     {     left- and right- shift are equivalent     }
      IXSYM_CAPS  = 2;     {     either shift or caps lock are equivalent  }
      IXSYM_ALT   = 4;     {     left- and right- alt are equivalent       }

{     corresponding QualSame masks }
      IXSYM_SHIFTMASK = (IEQUALIFIER_LSHIFT + IEQUALIFIER_RSHIFT);
      IXSYM_CAPSMASK  = (IXSYM_SHIFTMASK    + IEQUALIFIER_CAPSLOCK);
      IXSYM_ALTMASK   = (IEQUALIFIER_LALT   + IEQUALIFIER_RALT);

      IX_NORMALQUALS  = $7FFF;   {     for QualMask field: avoid RELATIVEMOUSE }


FUNCTION ActivateCxObj(co : Address; t : Integer) : Integer;
    External;

PROCEDURE AddIEvents(IE : InputEventPtr);
    External;

PROCEDURE AttachCxObj(headObj : CxObjPtr; co : CxObjPtr);
    External;

PROCEDURE ClearCxObjError(co : CxObjPtr);
    External;

FUNCTION CreateCxObj(Typ, Arg1, Arg2 : Integer) : CxObjPtr;
    External;

FUNCTION CxBroker(nb : NewBrokerPtr; error : Integer) : CxObjPtr;
    External;

FUNCTION CxMsgData(cxm : CxMsgPtr) : Address;
    External;

FUNCTION CxMsgID(cxm : CxMsgPtr) : Integer;
    External;

FUNCTION CxMsgType(cxm : CxMsgPtr) : Integer;
    External;

FUNCTION CxObjError(co : CxObjPtr) : Integer;
    External;

FUNCTION CxObjType(co : CxObjPtr) : Integer;
    External;

PROCEDURE DeleteCxObj(co : CxObjPtr);
    External;

PROCEDURE DeleteCxObjAll(co : CxObjPtr);
    External;

PROCEDURE DisposeCxMsg(cxm : CxMsgPtr);
    External;

PROCEDURE DivertCxMsg(cxm : CxMsgPtr; headObj, ReturnObj : CxObjPtr);
    External;

PROCEDURE EnqueueCxObj(HeadObj, co : CxObjPtr);
    External;

PROCEDURE InsertCxObj(headObj, co, pred : CxObjPtr);
    External;

FUNCTION InvertKeyMap(ansicode : Integer; event : InputEventPtr; km : KeyMapPtr) : Boolean;
    External;

FUNCTION ParseIX(description : String; i : IXPtr) : Integer;
    External;

PROCEDURE RemoveCxObj(co : CxObjPtr);
    External;

PROCEDURE RouteCxMsg(cxm : CxMsgPtr; co : CxObjPtr);
    External;

PROCEDURE SetCxObjPri(co : CxObjPtr; pri : Integer);
    External;

PROCEDURE SetFilter(co : CxObjPtr; txt : String);
    External;

PROCEDURE SetFilterIX(filter : CxObjPtr; i : IXPtr);
    External;

PROCEDURE SetTranslate(translator : CxObjPtr; Events : InputEventPtr);
    External;

{ functions in V38 and higher (Release 2.1) }

FUNCTION MatchIX(event : InputEventPtr; i : IXPtr) : Boolean;
    External;
