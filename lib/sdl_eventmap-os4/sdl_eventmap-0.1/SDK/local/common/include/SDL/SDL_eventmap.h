#ifndef __SDL_EVENTMAP_H__
#define __SDL_EVENTMAP_H__

#include<SDL/SDL.h>
#include<SDL/SDL_rwops.h>
#include<SDL/begin_code.h>

/** \mainpage SDL_eventmap
 *
 * SDL_eventmap is a library to unify many kinds of input into
 * a uniform event system.  Mouse, keyboard, and joystick events are all 
 * completely supported, even keys that SDL cannot identify.
 *
 * It is founded on #SDLH_HashEvent, which  converts an SDL_Event into a 
 * 32-bit hash.  These hashes are then mapped to SDL_UserEvents.  For 
 * instance, a joystick button, a mouse button or a key could all be 
 * mapped to the same SDL_UserEvent without hardcoding any values.
 *
 * SDLH_HashEvent crunches an entire SDL_Event down to 32-bits by 
 * simplifying some information.  For axis motion events, for example, 
 * the hash doesn't contain the exact axis location - just whether it's 
 * positive, negative, or centered.  It does the same for mice.
 *
 * Various levels of filtering are available to ignore  potentially 
 * unimportant events like button-release events, or to filter out
 * extraneous information like key modifiers.  This can be important,
 * if your program doesn't see any difference between enter and
 * alt-enter, moving and click-dragging, etc.
 *
 * An #SDL_EventMap structure acts like a translator, being fed
 * SDL_Events and pumping SDL_UserEvents onto the event queue.
 * You can have several different events mapping to the same
 * SDL_UserEvent code.
 */

#ifdef __cplusplus
extern "C" {
#endif/*__cplusplus*/

/**
 * \defgroup Hash Hashing Routines
 */
/*@{*/

 /*! \brief Filters out keyup events */
#define FILTER_NOKEYUP		0x0001
 /*! \brief Ignores keymod information */
#define FILTER_NOKEYMOD		0x0002
 /*! \brief Filters out joybutton-up events */
#define FILTER_NOJOYBUP		0x0004
 /*! \brief Filters out mousebutton-up events */
#define FILTER_NOMOUSEUP	0x0008
 /*! \brief Filters out hat-centering events */
#define FILTER_NOCENTER         0x0010
 /*! \brief Ignores mousemod information */
#define FILTER_NOMOUSEMOD       0x0020

 /*! \brief Filters out all filterable events */
#define FILTER_ALL 		0x00ff

/*! \brief Opaque structure definition. */
typedef struct SDL_EventMap SDL_EventMap;
/*! \brief Converts an SDL_Event into a 32-bit hash.  */
DECLSPEC Uint32         SDLCALL SDLH_HashEvent(SDL_Event *event, Uint32 flags);
/*! \brief Converts an event hash into a description string.  Not threadsafe.*/
DECLSPEC const char *   SDLCALL SDLH_HashName(Uint32 hash);
/*@}*/

/**
 * \defgroup Mapping Event Mapping Routines
 */
/*@{*/
/*! \brief Creates an SDL_EventMap structure. */
DECLSPEC SDL_EventMap * SDLCALL SDLH_Create();
/*! \brief Frees an SDL_EventMap structure and it's contents. */
DECLSPEC void           SDLCALL SDLH_Free(SDL_EventMap *);
/*! \brief Removes all event associations fron an SDL_EventMap. */
DECLSPEC void           SDLCALL SDLH_Clear(SDL_EventMap *);
/*! \brief Removes specified input association from an SDL_EventMap */
DECLSPEC int            SDLCALL SDLH_RemoveEvent(SDL_EventMap *,Uint32 hash);
/*! \brief Removes specified output association from an SDL_EventMap */
DECLSPEC int            SDLCALL SDLH_RemoveID(SDL_EventMap *, int id);
/*! \brief Adds an event association to an SDL_EventMap */
DECLSPEC int            SDLCALL SDLH_AddHashEvent(SDL_EventMap *, Uint32, int id);
/*! \brief Adds an event association to an SDL_EventMap directly */
DECLSPEC int            SDLCALL SDLH_AddEvent(SDL_EventMap *, SDL_Event *,int, Uint32 flag);
/*! \brief Adds an event to an SDL_EventMap based on input.  Warning, blocks.*/
DECLSPEC Uint32         SDLCALL SDLH_Learn(SDL_EventMap *, int eid, Uint32 flags);
/*! \brief Translates a SDL_Event to SDL_Events specified by the SDL_EventMap*/
DECLSPEC int            SDLCALL SDLH_TranslateEvent(SDL_EventMap *, SDL_Event *, Uint32 flag);
/*! \brief Saves an SDL_EventMap to a SDL_RWops stream */
DECLSPEC int            SDLCALL SDLH_Save(SDL_EventMap *, SDL_RWops *stream);
/*! \brief Loads an SDL_EventMap from a SDL_RWops stream */
DECLSPEC SDL_EventMap * SDLCALL SDLH_Load(SDL_RWops *stream);
/*@}*/

#ifdef __cplusplus
}
#endif/*__cplusplus*/

#include <SDL/close_code.h>

#endif/*__SDL_EVENTMAP_H__*/
