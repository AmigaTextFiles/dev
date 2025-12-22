#ifndef	WILD_ANIMATION_H
#define WILD_ANIMATION_H

#include <wild/tdcore.h>

/* The WildAction contains the data to do an action, but not the 
// single action's data:
// example: contains the data to rotate the leg to give a kick, 
// but does not contain the time when the action started, the current position:
// these are linked to Alien, wich is doing the action.
*/

struct WildAction
{
 struct	MinNode		act_Node;	/* node to link in Level's list */
 UWORD			act_Sectors;	/* Number of sectors involved */
 UBYTE			act_Flags;
 UBYTE			act_hole00;
 struct MinList		act_Moves;	/* Moves to do to have this action. note (1) */
 struct MinList		act_StopCheck;	/* a list of hooks that check if this is to abort.*/
 struct Hook		act_StopCall;	/* a hook to call when the action if finished */  
}; 

/* note (1)
// The moves here ARE SORTED BY STARTINGPOINT. So, you have to check the move next
// to the last started one, wich is surely the next that will start.
*/

struct WildMove
{
 struct MinNode		mov_Node;
 UBYTE			mov_Flags;
 UBYTE			mov_RunTime;
 UWORD			mov_UseCnt;	/* securty future stuff */
 UWORD			mov_Sector;	/* Sector ID involved in this move */
 ULONG			mov_Starter;	/* This move starts this ticks after the action started */
 ULONG			mov_Duration;	/* All the modifications this move does are completed in this time. */
 struct MinList		mov_StopCheck;	/* a list of hooks that check if the move if to abort.*/ 
 struct WildMoveCommand	*mov_Commands;	/* an array of commands to execute to have the movement.*/
};

struct WildMoveCommand
{
 UBYTE			mcd_Command;	/* command identifier */
 UBYTE			mcd_Target;	/* the target var to set/modify/?? */
 LONG			mcd_Value;	/* the value to set,reach,add,??? */
};

#define		MOVECOMMAND_SET		1	/* set, at start, a var to this value */
#define		MOVECOMMAND_ADD		2	/* add, at start, to a var */
/* to add: command_Hook */ 

/* note: MOVECOMMAND_REACH/GROW had NO SENSE !! If A can GROW, means we have a x^3
in the polynomial expression !! And if V can GROW, this means A !! BLEACH!! */

#define		MOVECOMMAND_END		0	/* that's the end of the commandlist */

/* bits used in target: %00aaprvv
// p = if set, the referring ref is the Parent (only for translations, not for rotations)
// aa= select the A,V,C (acceleration,speed,current) sub-var of the var
// r = if set, the target is the rotation, if 0, is the position.
// vv= X,Y,Z select (if position) or I,J,K (if rotation) to modify
*/

#define		TARGET_X		0
#define		TARGET_Y		1
#define		TARGET_Z		2
#define		TARGET_R		3
#define		TARGET_RX		4
#define		TARGET_RY		5
#define		TARGET_RZ		6

#define		TARGETMASK_XYZR		7

#define		TARGET_SECTORREF	1<<3	/* not supported now, maybe never. (requires differentials math, complex, slow, heavy to code.)*/
#define		TARGET_PARENTREF	0	

#define		TARGET_C		0<<4
#define		TARGET_V		1<<4
#define		TARGET_A		2<<4

#define		TARGETMASK_CVA		3<<4

/* NOTE: change is always PARENT-RELATED. */

/* examples: 	TARGET_SECTORREF|TARGET_V|TARGET_X affects the X speed of translation, referred to sector's ref.
//		TARGET_SECTORREF|TARGET_A|TARGET_I affects the I acceleraion of the rotation of the sector.
*/	

/* That's the struct linker to the alien that tracks what is doing, so the action
// executed, the times,...
*/

struct MovingVar
{
 LONG c,v,a;	
};

struct MovingRef
{
 struct MovingVar	x,y,z,r;
 struct Vek		rv;		/* rotation axis */
 struct Vek		i,j,k;
};

struct WildDoing
{
 struct	MinNode		doi_Node;	/* multiple actions in the future??*/
 struct WildAlien	*doi_Alien;
 ULONG			doi_Started;	/* the tick when this started */
 struct WildAction	*doi_Action;	/* the action to do*/
 struct MinList		doi_Sectors;	/* the DoingSector ones, note(2) */
 struct WildMove	*doi_LastMove;  /* the last started move in the precedent animate() */
};

struct WildDoingSector
{
 struct MinNode		dse_Node;
 struct WildSector	*dse_Sector;
 struct MovingRef	dse_LastMoveShot;
 struct WildMove	*dse_LastInitMove;	/* last move wich has been parsed (of the commands) */
};

/* note (2).
// Here, sectors are SORTED by ID. The IDs are decided basing on the action:
// if you action calls ID 2 a Leg sector, you should put in position 2 a leg
// sector, not a head one. Simple, eh ?
*/

#define		WILD_ANIMATIONBASE	WILD_OTHERSTD+300

#define		WIDA_Alien	WILD_ANIMATIONBASE+1	/* the alien to animate*/
#define		WIDA_Action	WILD_ANIMATIONBASE+2	/* the action to do*/
#define		WIDA_Sectors	WILD_ANIMATIONBASE+3	/* the sectors array*/
#define 	WIDA_StartTime	WILD_ANIMATIONBASE+4	/* if not passed (or passed 0) means Now.*/

#define		WIAN_Arenas	WILD_ANIMATIONBASE+20	/* the arenas to animate (if 0, app's world is fully animated-> any alien is checked. ( a bit slower) */
#define		WIAN_Time	WILD_ANIMATIONBASE+21	/* the tick to be showed (if 0 or no specify, current, WITH NO corrections. (you should use CatchCalc/DisplayTime() to have a correct time.)*/

#endif 
