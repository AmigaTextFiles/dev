@DATABASE "gg:doc/NDK/Guide/Include/libraries/realtime.h"
@MASTER   "gg:os-include/libraries/realtime.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:59
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/realtime.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/realtime.h" LINK File}


@{b}Structures@{ub}

@{"Conductor" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 58}  @{"Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106}  @{"pmState" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 174}  @{"pmTime" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 167}  @{"RealTimeBase" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 204}


@{b}#defines@{ub}

@{"CONDSTATE_LOCATE" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 87}      @{"CONDSTATE_LOCATE_SET" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 95}  @{"CONDSTATE_METRIC" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 93}
@{"CONDSTATE_PAUSED" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 86}      @{"CONDSTATE_RUNNING" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 88}     @{"CONDSTATE_SHUTTLE" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 94}
@{"CONDSTATE_STOPPED" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 85}     @{"CONDUCTB_EXTERNAL" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 79}     @{"CONDUCTB_GOTTICK" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 80}
@{"CONDUCTB_METROSET" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 81}     @{"CONDUCTB_PRIVATE" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 82}      @{"CONDUCTF_EXTERNAL" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 74}
@{"CONDUCTF_GOTTICK" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 75}      @{"CONDUCTF_METROSET" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 76}     @{"CONDUCTF_PRIVATE" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 77}
@{"PLAYER_Alarm" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 146}          @{"PLAYER_AlarmSigBit" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 148}    @{"PLAYER_AlarmSigTask" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 147}
@{"PLAYER_AlarmTime" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 145}      @{"PLAYER_Base" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 139}           @{"PLAYER_Conducted" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 149}
@{"PLAYER_Conductor" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 143}      @{"PLAYER_ErrorCode" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 154}      @{"PLAYER_ExtSync" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 153}
@{"PLAYER_Hook" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 140}           @{"PLAYER_ID" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 152}             @{"PLAYER_Name" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 141}
@{"PLAYER_Priority" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 142}       @{"PLAYER_Quiet" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 150}          @{"PLAYER_Ready" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 144}
@{"PLAYER_UserData" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 151}       @{"PLAYERB_ALARMSET" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 129}      @{"PLAYERB_CONDUCTED" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 131}
@{"PLAYERB_EXTSYNC" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 132}       @{"PLAYERB_QUIET" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 130}         @{"PLAYERB_READY" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 128}
@{"PLAYERF_ALARMSET" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 123}      @{"PLAYERF_CONDUCTED" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 125}     @{"PLAYERF_EXTSYNC" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 126}
@{"PLAYERF_QUIET" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 124}         @{"PLAYERF_READY" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 122}         @{"PM_POSITION" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 163}
@{"PM_SHUTTLE" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 164}            @{"PM_STATE" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 162}              @{"PM_TICK" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 161}
@{"RealTime_TickErr_Max" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 218}  @{"RealTime_TickErr_Min" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 217}  @{"RT_CONDUCTORS" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 185}
@{"RTE_NOCONDUCTOR" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 193}       @{"RTE_NOMEMORY" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 192}          @{"RTE_NOTIMER" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 194}
@{"RTE_PLAYING" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 195}           @{"TICK_FREQ" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 46}             

@ENDNODE
@NODE File "libraries/realtime.h"
#ifndef LIBRARIES_REALTIME_H
#define LIBRARIES_REALTIME_H
/*
**      $VER: realtime.h 40.3 (5.4.1993)
**      Includes Release 45.1
**
**      @{"realtime.library" LINK "gg:doc/NDK/Guide/realtime/MAIN"} timing and syncing system
**
**      (C) Copyright 1993-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif


/*****************************************************************************/


/* @{"realtime.library" LINK "gg:doc/NDK/Guide/realtime/MAIN"}'s idea of time is based on a clock which emits a pulse
 * 1200 times a second (1.2kHz). All time values maintained by @{"realtime.library" LINK "gg:doc/NDK/Guide/realtime/MAIN"}
 * are based on this number. For example, the field RealTimeBase->rtb_Time
 * expresses an amount of time equivalent to (RealTimeBase->rtb_Time/@{"TICK_FREQ" LINK File 46})
 * seconds.
 */
#define TICK_FREQ 1200


/*****************************************************************************/


/* Each Conductor represents a group of applications which wish to remain
 * synchronized together.
 *
 * This structure must only be allocated by @{"realtime.library" LINK "gg:doc/NDK/Guide/realtime/MAIN"} and is
 * READ-ONLY!
 */
struct Conductor
{
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}    cdt_Link;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}          cdt_Reserved0;
    @{"struct MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31} cdt_Players;          /* this conductor's players      */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          cdt_ClockTime;        /* current time of this sequence */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          cdt_StartTime;        /* start time of this sequence   */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          cdt_ExternalTime;     /* time from external unit       */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          cdt_MaxExternalTime;  /* upper limit on sync'd time    */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          cdt_Metronome;        /* MetricTime highest pri node   */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}          cdt_Reserved1;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}          cdt_Flags;            /* conductor flags               */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}          cdt_State;            /* playing or stopped            */
};

/* Flag bits for Conductor.cdt_Flags */
#define CONDUCTF_EXTERNAL (1<<0)   /* clock is externally driven */
#define CONDUCTF_GOTTICK  (1<<1)   /* received 1st external tick */
#define CONDUCTF_METROSET (1<<2)   /* cdt_Metronome filled in    */
#define CONDUCTF_PRIVATE  (1<<3)   /* conductor is private       */

#define CONDUCTB_EXTERNAL 0
#define CONDUCTB_GOTTICK  1
#define CONDUCTB_METROSET 2
#define CONDUCTB_PRIVATE  3

/* constants for Conductor.cdt_State and @{"SetConductorState()" LINK "gg:doc/NDK/Guide/realtime/SetConductorState"} */
#define CONDSTATE_STOPPED     0   /* clock is stopped              */
#define CONDSTATE_PAUSED      1   /* clock is paused               */
#define CONDSTATE_LOCATE      2   /* go to 'running' when ready    */
#define CONDSTATE_RUNNING     3   /* run clock NOW                 */

/* These do not actually exist as Conductor states, but are used as additional
 * arguments to @{"SetConductorState()" LINK "gg:doc/NDK/Guide/realtime/SetConductorState"}
 */
#define CONDSTATE_METRIC     -1   /* ask high node to locate       */
#define CONDSTATE_SHUTTLE    -2   /* time changing but not running */
#define CONDSTATE_LOCATE_SET -3   /* maestro done locating         */


/*****************************************************************************/


/* The Player is the connection between a Conductor and an application.
 *
 * This structure must only be allocated by @{"realtime.library" LINK "gg:doc/NDK/Guide/realtime/MAIN"} and is
 * READ-ONLY!
 */
struct Player
{
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}       pl_Link;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}              pl_Reserved0;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}              pl_Reserved1;
    @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28}      *pl_Hook;           /* player's hook function       */
    @{"struct Conductor" LINK File 58} *pl_Source;         /* pointer to parent context    */
    @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24}      *pl_Task;           /* task to signal for alarm     */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}              pl_MetricTime;     /* current time in app's metric */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}              pl_AlarmTime;      /* time to wake up              */
    void             *pl_UserData;       /* for application use  */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}             pl_PlayerID;       /* for application use  */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}             pl_Flags;  /* general Player flags         */
};

/* Flag bits for Player.pl_Flags */
#define PLAYERF_READY     (1<<0)   /* player is ready to go!        */
#define PLAYERF_ALARMSET  (1<<1)   /* alarm is set                  */
#define PLAYERF_QUIET     (1<<2)   /* a dummy player, used for sync */
#define PLAYERF_CONDUCTED (1<<3)   /* give me metered time          */
#define PLAYERF_EXTSYNC   (1<<4)   /* granted external sync         */

#define PLAYERB_READY     0
#define PLAYERB_ALARMSET  1
#define PLAYERB_QUIET     2
#define PLAYERB_CONDUCTED 3
#define PLAYERB_EXTSYNC   4


/*****************************************************************************/


/* Tags for @{"CreatePlayer()" LINK "gg:doc/NDK/Guide/realtime/CreatePlayer"}, @{"SetPlayerAttrs()" LINK "gg:doc/NDK/Guide/realtime/SetPlayerAttrs"}, and @{"GetPlayerAttrs()" LINK "gg:doc/NDK/Guide/realtime/GetPlayerAttrsA"} */
#define PLAYER_Base         (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+64)
#define PLAYER_Hook         (@{"PLAYER_Base" LINK File 139}+1)   /* set address of hook function */
#define PLAYER_Name         (@{"PLAYER_Base" LINK File 139}+2)   /* name of player       */
#define PLAYER_Priority     (@{"PLAYER_Base" LINK File 139}+3)   /* priority of player           */
#define PLAYER_Conductor    (@{"PLAYER_Base" LINK File 139}+4)   /* set conductor for player     */
#define PLAYER_Ready        (@{"PLAYER_Base" LINK File 139}+5)   /* the "ready" flag             */
#define PLAYER_AlarmTime    (@{"PLAYER_Base" LINK File 139}+12)  /* alarm time (sets @{"PLAYERF_ALARMSET" LINK File 123}) */
#define PLAYER_Alarm        (@{"PLAYER_Base" LINK File 139}+13)  /* sets/clears @{"PLAYERF_ALARMSET" LINK File 123} flag  */
#define PLAYER_AlarmSigTask (@{"PLAYER_Base" LINK File 139}+6)   /* task to signal for alarm/notify    */
#define PLAYER_AlarmSigBit  (@{"PLAYER_Base" LINK File 139}+8)   /* signal bit for alarm (or -1) */
#define PLAYER_Conducted    (@{"PLAYER_Base" LINK File 139}+7)   /* sets/clears @{"PLAYERF_CONDUCTED" LINK File 125} flag   */
#define PLAYER_Quiet        (@{"PLAYER_Base" LINK File 139}+9)   /* don't process time thru this */
#define PLAYER_UserData     (@{"PLAYER_Base" LINK File 139}+10)
#define PLAYER_ID           (@{"PLAYER_Base" LINK File 139}+11)
#define PLAYER_ExtSync      (@{"PLAYER_Base" LINK File 139}+14)  /* attempt/release to ext sync  */
#define PLAYER_ErrorCode    (@{"PLAYER_Base" LINK File 139}+15)  /* error return value           */


/*****************************************************************************/


/* Method types for messages sent via a Player's hook */
#define PM_TICK     0
#define PM_STATE    1
#define PM_POSITION 2
#define PM_SHUTTLE  3

/* used for @{"PM_TICK" LINK File 161}, @{"PM_POSITION" LINK File 163} and @{"PM_SHUTTLE" LINK File 164} methods */
struct pmTime
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} pmt_Method;        /* @{"PM_TICK" LINK File 161}, @{"PM_POSITION" LINK File 163}, or @{"PM_SHUTTLE" LINK File 164} */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} pmt_Time;
};

/* used for the @{"PM_STATE" LINK File 162} method */
struct pmState
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} pms_Method;        /* @{"PM_STATE" LINK File 162} */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} pms_OldState;
};


/*****************************************************************************/


/* Possible lock types for @{"LockRealTime()" LINK "gg:doc/NDK/Guide/realtime/LockRealTime"} */
#define RT_CONDUCTORS 0   /* conductor list */


/*****************************************************************************/


/* @{"realtime.library" LINK "gg:doc/NDK/Guide/realtime/MAIN"} error codes */
#define RTE_NOMEMORY    801   /* memory allocation failed      */
#define RTE_NOCONDUCTOR 802   /* player needs a conductor      */
#define RTE_NOTIMER     803   /* timer (CIA) allocation failed */
#define RTE_PLAYING     804   /* can't shuttle while playing   */


/*****************************************************************************/


/* @{"OpenLibrary" LINK "gg:doc/NDK/Guide/exec/OpenLibrary"}("@{"realtime.library" LINK "gg:doc/NDK/Guide/realtime/MAIN"}",0) returns a pointer to this structure.
 * All fields are READ-ONLY.
 */
struct RealTimeBase
{
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} rtb_LibNode;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}          rtb_Reserved0[2];

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          rtb_Time;         /* current time                         */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}          rtb_TimeFrac;     /* fixed-point fraction part of time    */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}          rtb_Reserved1;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}           rtb_TickErr;      /* nanosecond error from ideal Tick     */
};                                   /* length to real tick length           */

/* Actual tick length is: 1/@{"TICK_FREQ" LINK File 46} + rtb_TickErr/1e9 */

#define RealTime_TickErr_Min -705
#define RealTime_TickErr_Max  705


/*****************************************************************************/


#endif /* LIBRARIES_REALTIME_H */
@ENDNODE
