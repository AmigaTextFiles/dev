#ifndef _SGEGAMESTATE_H
#define _SGEGAMESTATE_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgegamestate.h
 * @brief Game states and event handlers
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeGameState
 * @brief Game states and event handlers
 *
 * Split your game into single states to switch
 * between.
 *
 * Also provides event callbacks for handling
 * user input.
 *
 * @{
 */

struct _SGEGAMESTATE;

/**
 * @struct SGEGAMESTATEMANAGER
 *
 * The game state manager is the main handler of the game states,
 * you should only have one in your games.
 */
typedef struct {
	/** @privatesection */
	int quit;
	SGEEVENTSTATE event_state;
	struct _SGEGAMESTATE *current;
} SGEGAMESTATEMANAGER;

/**
 * @struct SGEGAMESTATE
 *
 * A collection of data and callback functions of a certain game state.
 * You may want to split your game into several states, for example
 * intro, main menu, options menu, game, ...
 */
typedef struct _SGEGAMESTATE {
	/** @brief A pointer to the current game state manager (only for information, set automatically) */
	SGEGAMESTATEMANAGER *manager;

	/** @brief A pointer to your data */
	void *data;

	/**
	 * @brief A function pointer to the states redraw function
	 * @param state The current state
	 */
	void (*onRedraw)(struct _SGEGAMESTATE *state);

	/**
	 * @brief (optional) A function pointer to the states key down handler
	 * @param state The current state
	 * @param event The current event object
	 * @return EVENT_HANDLED or EVENT_UNHANDLED, depending if the handler did or did not handle the event
	 *
	 * If the handler did not handle the event, the event is passed on to the gamepad event system. @see sgeEvent
	 */
	int (*onKeyDown)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to the states key up handler
	 * @param state The current state
	 * @param event The current event object
	 * @return EVENT_HANDLED or EVENT_UNHANDLED, depending if the handler did or did not handle the event
	 *
	 * If the handler did not handle the event, the event is passed on to the gamepad event system. @see sgeEvent
	 */
	int (*onKeyUp)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to the states joystick button down handler
	 * @param state The current state
	 * @param event The current event object
	 * @return EVENT_HANDLED or EVENT_UNHANDLED, depending if the handler did or did not handle the event
	 *
	 * If the handler did not handle the event, the event is passed on to the gamepad event system. @see sgeEvent
	 */
	int (*onJoystickButtonDown)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to the states joystick button up handler
	 * @param state The current state
	 * @param event The current event object
	 * @return EVENT_HANDLED or EVENT_UNHANDLED, depending if the handler did or did not handle the event
	 *
	 * If the handler did not handle the event, the event is passed on to the gamepad event system. @see sgeEvent
	 */
	int (*onJoystickButtonUp)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to the states joystick move handler
	 * @param state The current state
	 * @param event The current event object
	 */
	void (*onJoystickMove)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to the states mouse button down handler
	 * @param state The current state
	 * @param event The current event object
	 */
	void (*onMouseDown)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to the states mouse button up handler
	 * @param state The current state
	 * @param event The current event object
	 */
	void (*onMouseUp)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to the states mouse move handler
	 * @param state The current state
	 * @param event The current event object
	 */
	void (*onMouseMove)(struct _SGEGAMESTATE *state, SGEEVENT *event);

	/**
	 * @brief (optional) A function pointer to a state change handler
	 * @param state The current state
	 * @param event The current event object
	 * @return 1 or 0, 1 = state changed worked, 0 = state change failed (must be handled by the state changing function)
	 */
	int (*onStateChange)(struct _SGEGAMESTATE *state, struct _SGEGAMESTATE* previous);
} SGEGAMESTATE;

/**
 * @brief Create a new state manager
 */
SGEGAMESTATEMANAGER* sgeGameStateManagerNew(void);

/**
 * @brief Change to a new state
 * @param manager The game state manager
 * @param next_state The SGEGAMESTATE to switch to
 */
int sgeGameStateManagerChange(SGEGAMESTATEMANAGER *manager, SGEGAMESTATE *next_state);

/**
 * @brief Run the game with the current states, redrawing at certain frames per second
 * @param manager The game state manager
 * @param fps The frames per seconds the game should run
 */
void sgeGameStateManagerRun(SGEGAMESTATEMANAGER* manager, int fps);

/**
 * @brief Quit the game state manager
 */
void sgeGameStateManagerQuit(SGEGAMESTATEMANAGER* manager);

/**
 * @brief Create new game state.
 *
 * The sge game state struct is given to all function callbacks
 * to enable them to call the manager and get its data.
 *
 * It needs at least a onRedraw function, the rest of the callbacks
 * are optional.
 */
SGEGAMESTATE* sgeGameStateNew(void);

// }@

#ifdef __cplusplus
}
#endif

#endif
