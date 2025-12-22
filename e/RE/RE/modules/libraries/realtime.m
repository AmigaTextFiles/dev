#ifndef LIBRARIES_REALTIME_H
#define LIBRARIES_REALTIME_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif
#ifndef UTILITY_HOOKS_H
MODULE  'utility/hooks'
#endif


#define TICK_FREQ 1200


OBJECT Conductor

         Link:Node
    Reserved0:UWORD
      Players:MinList		 
    ClockTime:LONG	 
    StartTime:LONG	 
    ExternalTime:LONG	 
    MaxExternalTime:LONG  
    Metronome:LONG	 
    Reserved1:UWORD
    Flags:UWORD		 
    State:UBYTE		 
ENDOBJECT


#define CONDUCTF_EXTERNAL (1<<0)   
#define CONDUCTF_GOTTICK  (1<<1)   
#define CONDUCTF_METROSET (1<<2)   
#define CONDUCTF_PRIVATE  (1<<3)   
#define CONDUCTB_EXTERNAL 0
#define CONDUCTB_GOTTICK  1
#define CONDUCTB_METROSET 2
#define CONDUCTB_PRIVATE  3

#define CONDSTATE_STOPPED     0	  
#define CONDSTATE_PAUSED      1	  
#define CONDSTATE_LOCATE      2	  
#define CONDSTATE_RUNNING     3	  

#define CONDSTATE_METRIC     -1	  
#define CONDSTATE_SHUTTLE    -2	  
#define CONDSTATE_LOCATE_SET -3	  


OBJECT Player

            Link:Node
    Reserved0:BYTE
    Reserved1:BYTE
           Hook:PTR TO Hook		 
      Source:PTR TO Conductor	 
           Task:PTR TO Task		 
    MetricTime:LONG	 
    AlarmTime:LONG	 
    UserData:PTR TO LONG	 
    PlayerID:UWORD	 
    Flags:UWORD	 
ENDOBJECT


#define PLAYERF_READY	  (1<<0)   
#define PLAYERF_ALARMSET  (1<<1)   
#define PLAYERF_QUIET	  (1<<2)   
#define PLAYERF_CONDUCTED (1<<3)   
#define PLAYERF_EXTSYNC   (1<<4)   
#define PLAYERB_READY	  0
#define PLAYERB_ALARMSET  1
#define PLAYERB_QUIET	  2
#define PLAYERB_CONDUCTED 3
#define PLAYERB_EXTSYNC   4


#define PLAYER_Base	    (TAG_USER+64)
#define PLAYER_Hook	    (PLAYER_Base+1)   
#define PLAYER_Name	    (PLAYER_Base+2)   
#define PLAYER_Priority     (PLAYER_Base+3)   
#define PLAYER_Conductor    (PLAYER_Base+4)   
#define PLAYER_Ready	    (PLAYER_Base+5)   
#define PLAYER_AlarmTime    (PLAYER_Base+12)  
#define PLAYER_Alarm	    (PLAYER_Base+13)  
#define PLAYER_AlarmSigTask (PLAYER_Base+6)   
#define PLAYER_AlarmSigBit  (PLAYER_Base+8)   
#define PLAYER_Conducted    (PLAYER_Base+7)   
#define PLAYER_Quiet	    (PLAYER_Base+9)   
#define PLAYER_UserData     (PLAYER_Base+10)
#define PLAYER_ID	    (PLAYER_Base+11)
#define PLAYER_ExtSync	    (PLAYER_Base+14)  
#define PLAYER_ErrorCode    (PLAYER_Base+15)  


#define PM_TICK     0
#define PM_STATE    1
#define PM_POSITION 2
#define PM_SHUTTLE  3

OBJECT pmTime

    Method:LONG	     
    Time:LONG
ENDOBJECT


OBJECT pmState

    Method:LONG	     
    OldState:LONG
ENDOBJECT



#define RT_CONDUCTORS 0   


#define RTE_NOMEMORY	801   
#define RTE_NOCONDUCTOR 802   
#define RTE_NOTIMER	803   
#define RTE_PLAYING	804   


OBJECT RealTimeBase

      LibNode:Library
    Reserved0[2]:UBYTE
    Time:LONG	     
    TimeFrac:LONG     
    Reserved1:UWORD
    TickErr:WORD      
ENDOBJECT			     

#define RealTime_TickErr_Min -705
#define RealTime_TickErr_Max  705

#endif 
