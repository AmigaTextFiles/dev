#ifndef _SGEEVENT_H
#define _SGEEVENT_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgeevent.h
 * @brief Low level event handling
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeEvent
 * @brief Low level event handling
 *
 * Event handling for joystick and keyboard events.
 * This is the recommended way to handle user input
 * on the gp2x and other handheld devices.
 *
 * There is another way to handle events. sgeGamestate
 * does provide event handlers which is a more flexible
 * but harder to use system.
 *
 * @{
 */

/**
 * @def SGEEVENT
 * Currently a alias to SDL_Event, may change, use SGEEVENT
 */
#define SGEEVENT SDL_Event

/**
 * @def EVENT_HANDLED
 * Event handler return code if your handler did handle the event
 */
#define EVENT_HANDLED 1

/**
 * @def EVENT_UNHANDLED
 * Event handler return code if your handler did NOT handle the event
 */
#define EVENT_UNHANDLED 0

/**
 * @def MOUSE_LEFT
 * Left mouse button was pressed
 */
#define MOUSE_LEFT SDL_BUTTON_LEFT
/**
 * @def MOUSE_RIGHT
 * Right mouse button was pressed
 */
#define MOUSE_RIGHT SDL_BUTTON_RIGHT
/**
 * @def MOUSE_MIDDLE
 * Middle mouse button was pressed
 */
#define MOUSE_MIDDLE SDL_BUTTON_MIDDLE
/**
 * @def MOUSE_WHEEL_UP
 * Mouse scroll wheel was moved up
 */
#define MOUSE_WHEEL_UP SDL_BUTTON_WHEELUP
/**
 * @def MOUSE_WHEEL_DOWN
 * Mouse scroll wheel was moved down
 */
#define MOUSE_WHEEL_DOWN SDL_BUTTON_WHEELDOWN

/**
 * @def PRESSED
 * A button or key was pressed
 */
#define PRESSED 1

/**
 * @def RELEASED
 * A button or key was released
 */
#define RELEASED 2

/**
 * @struct SGEEVENTSTATEINPUT
 * 
 * Holds the status of a button or key
 */
typedef struct {
	Uint32 held;
	Uint32 pressed;
	Uint32 released;
} SGEEVENTSTATEINPUT;

/**
 * @struct SGEEVENTSTATE
 * 
 * The current state of a game controller/game pad/handheld device
 */
typedef struct {
	SGEEVENTSTATEINPUT up;
	SGEEVENTSTATEINPUT down;
	SGEEVENTSTATEINPUT right;
	SGEEVENTSTATEINPUT left;
	SGEEVENTSTATEINPUT start;
	SGEEVENTSTATEINPUT select;
	SGEEVENTSTATEINPUT fire;
	SGEEVENTSTATEINPUT l1;
	SGEEVENTSTATEINPUT r1;
	SGEEVENTSTATEINPUT a;
	SGEEVENTSTATEINPUT b;
	SGEEVENTSTATEINPUT x;
	SGEEVENTSTATEINPUT y;
	SGEEVENTSTATEINPUT volUp;
	SGEEVENTSTATEINPUT volDown;
} SGEEVENTSTATE;

/**
 * @brief Check if the up button/key is at a certain state
 * @param e The current event
 * @param type PRESSED or RELEASED
 * @return 0 or 1 depending if the button/key is equal to type
 *
 * These function are platform dependant, for example, Up can
 * be the cursor key on a pc, while on a game console its the Up
 * button on the controller.
 *
 * This applies to all sgeKey* functions with the corresponding
 * button/key.
 */
int sgeKeyUp(SDL_Event *e, int type);

/** @see sgeKeyUp */
int sgeKeyDown(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyLeft(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyRight(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyStart(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeySelect(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyFire(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyL1(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyR1(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyA(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyB(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyX(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyY(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyVolUp(SDL_Event *e, int type);
/** @see sgeKeyUp */
int sgeKeyVolDown(SDL_Event *e, int type);

/**
 * @brief Clear the event queue
 */
void sgeClearEvents(void);

/**
 * @brief Update the current state of a game controller
 */
void sgeEventApply(SGEEVENTSTATE *state, SDL_Event *event);

/**
 * @brief Reset all button states of a game controller
 */
void sgeEventResetInputs(SGEEVENTSTATE *state);

// }@

#ifdef __cplusplus
}
#endif

#endif
