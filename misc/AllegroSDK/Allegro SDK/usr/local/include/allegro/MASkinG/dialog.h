// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_DIALOG_H
#define			MASKING_DIALOG_H

#include "screenupdate.h"
#include "mouse.h"
#include "widget.h"
#include "tooltip.h"
#include <vector>
#include "maskingdll.h"

namespace MAS {
/**
	Internal helper structure for handling mosue clicks.
	This is used by  the dialog manager to detect
	clicks and especially double clicks. This is done with a finite
	state machine and this struct represents one state of the FSM.
*/
struct MASKING_DLL_DECLSPEC MouseState {
	int doubleClickState;
	int doubleClickDelay;
	int doubleClickTick;
};

/**
	Internal helper structure for moving input focus using the keyboard.
	An object of type MAS_OBJ_LIST represent one element of a list of
	widgets where w is the widget the element belongs to and diff is
	the difference between the widget and the widget that has input focus.
	To move the focus a list of all widgets is constructed and diff values
	are computed with a comparison function, then the list is sorted and
	the focus is offered to the first widget in the list that wants to
	take focus.
*/
struct MASKING_DLL_DECLSPEC MAS_OBJ_LIST {
	int diff;
	MAS::Widget *w;
};

/**
	The dialog manager class.
	Dialogs in MASkinG are nothing but widgets that can contain other widgets.
	You should always have one main dialog to which you can add widgets and
	other dialogs. Normally you should derive your own dialog class from Dialog
	and implement some of the virtual functions that define the apearance and
	behaviour of your dialog. In almost all cases you will need to implement
	the HandleEvent() and MsgInitSkin().

	The most common practice to create dialogs is to define widgets as data
	members of their parent dialog and add them to the dialog in the constructor.
	The widgets may of course also be added and removed dynamically. Once the
	dialog is constructed it can be executed with the Execute() function.

	The dialog class should also be used as a baseclass for all compound
	widgets, that is widgets that are made by combining several other more
	low level widgets.
*/
class MASKING_DLL_DECLSPEC Dialog : public Widget {
	private:
		/**
			ID of the global system timer.
		*/
		static int tickTimerID;
		/**
			True while the dialog is being executed, false otherwise.
		*/
		bool running;

		float frameSkip;
		float frameCounter;

	protected:
		/**
			The global system screen update driver.
		*/
		static ScreenUpdate *driver;
		/**
			The global system mouse object.
		*/
		static Mouse *mouse;
		/**
			The array of the dialog's child widgets.
		*/
		std::vector<Widget *> widgets;
		/**
			The array of the dialog's child widgets that are scheduled for removal and deletion.
		*/
		std::vector<Widget *> deletedWidgets;
		/**
			A pointer to the widget that has input focus.
		*/
		Widget *focusObject;
		Widget *lastFocusObject;
		/**
			A pointer to the widget the mouse is currently on top of.
		*/
		Widget *mouseObject;
		/**
			Holds the current state of the mouse.
		*/
		static MouseState mouseState;
		/**
			True when a joystick button has been pressed. This is used to prevent
			the joystick from being too "responsive".
		*/
		bool joyOn;
		/**
			Set to false to prevent the dialog from being closed with escape. Default is true.
		*/
		bool escapeExits;
		/**
			Set to false to prevent input focuse from being changed with the arrow keys. Default is true.
		*/
		bool arrowKeysMoveFocus;
		/**
			Set to false to turn off moving focus with the tab key. Default is true.
		*/
		bool tabKeyMovesFocus;
		/**
			This variable is set to true when the dialog is about to be closed.
		*/
		bool close;
		/**
			A pointer to the tooltip widget used to display tooltips.
		*/
		Tooltip defaultTooltipObject;
		/**
			The default tooltip object used when the user doesn't set their own.
		*/
		Tooltip *tooltipObject;

	public:
		/**
			Determines what kind of action the dialog manager should perform
			on the active dialog at any time but most notably when the mouse
			is clicked. The action type can be one of the following:
<pre>
         NONE                  - do nothing (usually when the mouse is inside the dialog
         MOVE                  - move the dialog (usually when the mouse is on the caption bar)
         RESIZE_UP_LEFT        - resize the dialog (usually when the mouse is on the
         RESIZE_UP_RIGHT         dialog border; the actual action depend on the exact
         RESIZE_DOWN_LEFT        position on the border)
         RESIZE_DOWN_RIGHT
         RESIZE_UP
         RESIZE_DOWN
         RESIZE_LEFT
         RESIZE_RIGHT
</pre>
		*/
		enum ActionType {
			NONE,
			MOVE,
			RESIZE_UP_LEFT,
			RESIZE_UP_RIGHT,
			RESIZE_DOWN_LEFT,
			RESIZE_DOWN_RIGHT,
			RESIZE_UP,
			RESIZE_DOWN,
			RESIZE_LEFT,
			RESIZE_RIGHT
		};

	protected:
		/**
			The minimum size of the dialog. This is only relevant for dialogs that are not on the top level and can be resized.
		*/
		Size minSize;
		/**
			The currently selected dialog action.
		*/
		ActionType action;
		Point actionOrigin;
		/**
			Returns the action the dialog manager should do on the dialog depending
			on the mouse position. The default implementation returns NONE if the mouse
			is on top of a widget that takes input focus otherwise it returns MOVE.
			The window class for example overloads this function to return MOVE only if
			the mouse is on top of the top bar and appropriate resize actions when it is
			on top of a window border.
		*/
		virtual ActionType GetAction();
		/**
			Switches the current dialog's action to the action passed as the parameter
			of the function and changes the mouse cursor if required. For example if the
			new action is RESIZE_VERTICAL it cahnges the cursor to the vertical resize arrows.
		*/
		void SelectAction(ActionType action);
		/**
			Called whenever the dialog is moved or resized. You should overload this function
			to update the position and size of the dialog's widgets acording to the new size
			of the dialog. For example if you have a window with a panel you should resize the
			panel in this function so that it will always be inside the dialog.
		*/
		virtual void UpdateSize();

	protected:
		/**
			Helper function for redrawing all the widgets in the current dialog that are on
			top of the passed widget. This function needs to be called to prevent dirty widgets
			from drawing themselves over widgets that are on top of them in the z-order. This
			isn't the fastest way, it would be faster if the dirty widget's canvas would be
			clipped so that only the visible parts would be updated but the widgets on top
			might not be rectangular and may have transparent bits in them so it's actually
			easier to just redraw everything. If fromTheTop is true, then all the widgets in
			the dialog are checked to see if they need to be redrawn, otherwise the checking
			starts at the dirtyWidget and goes on from there. This is needed if dirtyWidget
			isn't actually a member of this dialog.
		*/
		void RedrawForeground(MAS::Widget *dirtyWidget, bool fromTheTop=false);
		/**
			Helper function for redrawing everything that is on top of dirtyWidget but is in
			dialogs that are siblings of the passed dialog.
		*/
		void RedrawSiblings(MAS::Dialog *dlg, MAS::Widget *dirtyWidget);
		/**
			Checks if any widget needs to be redrawn.
			Cycles through all the widgets to see if any need to be redrawn and sends MSG_DRAW
			messages to all that do.
		*/
		void CheckForRedraw();
		/**
			Checks if any widget has been moved or resized.
			Like CheckForRedraw() only this function checks if any widget has been resized or
			moved and sends either MSG_RESIZE, MSG_MOVE or MSG_SHAPE.
		*/
		void CheckGeometry();
		/**
			Checks if any widget's skin has changed and send MSG_INITSKIN if it has.
		*/
		void CheckForSkinChange();
		void CheckFocusLock();
		/**
			Handles mouse moves and detects mouse clicks and sends appropriate mouse messages.
		*/
		virtual void HandleMouseInput();
		/**
			Hanldes keyboard and joystick input. It converts joystick button presses to
			matching keyboard presses to simulate joystick input.
		*/
		virtual void HandleKeyboardInput();
		/**
			Checks if a widget in the dialog has the passed keyboard shortcut and sends it
			the MSG_KEY message. It returns true if a widget with the keyboard shortcut is
			found, otherwise it returns false. This function searches for the widget with
			the shortcut recursively in all child dialogs and windows too.
		*/
		virtual bool CheckKeyboardShortcuts(int cAscii, int cScan);
		/**
			Sends keyboard messages corresponding to the passed ASCII code and scan code.
			It returns true if a message was actually sent and false if it wasn't. This
			allows the messages to be passed up and down the dialog hierarchy.
		*/
		virtual bool SendKeyboardMessages(int cAscii, int cScan);
		/**
			Finds the widget the mouse is currently on top of.
		*/
		virtual Widget *FindMouseObject();
		/**
			Moves input focus using a direction variable that was generated with the keyboard.
			The valid values for dir are: 0 (TAB), 1 (SHIFT+TAB), 2 (right), 3 (left), 4 (down)
			and 5 (up).
		*/
		virtual void MoveFocus(int dir);
		/**
			Fills the given list with objects that can potentially be tabbed to.
			This is an internal function for constructing a list of objects that can be tabbed to.
			The objList parameter is passed by reference and is the list that is being constructed,
			cmp is the comparison function that calculates the difference between the current
			widget and the reference widget, w is the reference widget (the one that currently has
			input focus) and c is a counter of widgets that were added to the list. Derived dialogs
			should not overload this function but compound widgets should, but they should leave
			implementation empty. Instead they should implement MsgGotfocus() and MsgLostfocus()
			to make sure the right subwidget is given focus when the compound is tabbed to.
		*/
		virtual void FillObjectList(std::vector<MAS_OBJ_LIST *> &objList, int (*cmp)(const MAS::Widget *, const MAS::Widget *), MAS::Widget *focusObject, int &c);
		/**
			Changes the mouse cursor to the cursor with the index i in the skin's cursor array.
		*/
		virtual void SetMouseCursor(int i);
		/**
			Tests whether the widget w is already in the dialog's widget array or not.
		*/
		bool AlreadyAdded(const Widget &w);

		/**
			Select an update driver according to the settings in the \URL[Settings]{settings.html} class.
		*/
		virtual void SelectDriver();
		/**
			Creates the selected update driver. If the requested driver is DRS and
			the driver doesn't work, the default driver is selected instead. If the
			requested driver is one of the double buffering drivers and it doesn't
			work the next one in line is tried and then the next one and if none
			work, the default one is selected. For example if you want triple
			buffering and it doesn't work, this function will try page flipping
			instead, and if that doesn't work, it will try regular double buffering.
		*/
		Error CreateUpdateDriver(ScreenUpdate *driver);

	protected:
		void MsgStart();
		void MsgEnd();
		void MsgDraw();
		void MsgClick();
		void MsgDClick();
		//void MsgKey();
		//bool MsgChar(int c);
		//bool MsgUChar(int c);
		//bool MsgXChar(int c);
		bool MsgWantfocus();
		void MsgGotfocus();
		void MsgLostfocus();
		void MsgGotmouse();
		void MsgLostmouse();
		void MsgIdle();
		//void MsgRadio(int g);
		void MsgWheel(int z);
		void MsgLPress();
		void MsgMPress();
		void MsgRPress();
		void MsgLRelease();
		void MsgMRelease();
		void MsgRRelease();
		void MsgTimer(int t);
		void MsgTick();
		void MsgMove();
		void MsgResize();
		void MsgShape();
		void MsgMousemove(const Point& d);
		void MsgInitSkin();
		bool MsgWantTab();

	public:
		/**
			The default constructor. Doesn't do much except to initialize
			some varibles. In a derived dialog class you should setup the
			dialog's children widgets and add them to the dialog. You
			shouldn't however do any skin specific initialization (like
			setting the color of some text or something). You should do
			this in the MsgInitSkin() function instead.
		*/
		Dialog();

		/**
			Adds the widget to the dialog if it's not already added.
			Returns true if the widget was actually added, false if it
			already was in the dialog.
		*/
		bool Add(Widget &obj);
		/**
			Removes the widget from the dialog. After removing a widget
			the entire dialog is redrawn. If del is true, the widget is only scheduled
			for for removal and deletion and is actually removed at the first
			chance (i.e. at the	next MSG_TICK). You have to set del to true if
			you create widgets dynamically in your dialog (with new) because
			it is illegal for you to delete a widget in HandleEvent(). You should
			NOT set del to true if you're removing a statically created widget!
		*/
		void Remove(Widget &obj, bool del=false);

		/**
			Broadcasts a message with one optional parameter to all the widgets
			in the dialog. Note that most messages are passed only to widgets
			that are not hidden. There are some expections though: MSG_START,
			MSG_END, MSG_INITSKIN and perhaps some others.
		*/
		void DialogMessage(int msg, int c=0);
		/**
			Changes the skin of the dialog and all its child widgets.
		*/
		void SetSkin(Skin *skin);
		/**
			Returns the drawing canvas of the dialog. The offset parameter is
			the relative starting position of the rectangle you wish to draw to.
			The GetCanvas() function then turns them into absolute screen coordinates
			so you can safely create a subbitmap or something like that. Normally
			you shouldn't need to call this function because the dialog manager
			automatically crates a canvas for widgets that need to be redrawn.
		*/
		BITMAP *GetCanvas(Point &offset);
		/**
			Returns the canvas for widget *obj. Basically this function gets the
			dialog's canvas, makes a subbitmap where the widget is and returns it.
		*/
		BITMAP *GetCanvas(Widget *obj);
		/**
			Returns a pointer to the dialog's screen update driver object. You
			shouldn't need to use this except maybe for reading the name of the
			driver or something like that.
		*/
		ScreenUpdate *GetDriver() const;
		/**
			Returns a pointer to the dialog's mouse object.
		*/
		Mouse *GetMouse() const;
		/**
			Changes the mouse system driver. If you want to modify the appearance
			and/or bahaviour of the mouse in your program, just derive your own
			mouse class from Mouse, create a new instance of it and pass it to
			this function. The mouse driver is deleted when it's not needed anymore
			(i.e. when a new driver is installed or when the program ends) so you
			don't need to worry about deleting it.
		*/
		void SetMouse(Mouse *m);
		/**
			Returns the offset of the dialog relative to it's parent. Note that
			the top level dialog can only be placed at the top left corner of the
			screen.
		*/
		Point GetOffset() const;
		/**
			The main event handler function. The default implementation doesn't
			really do much except for handling a couple of events but you should
			overload it in your derived dialog classes and use it to handle events.
			The parameters are the object that caused the event to be created, the
			event message (the same as the MSG_SOMETHING constants) and two optional
			parameters which have different meanings for different messages but are
			most often unused.

			The most common way to write the event handler is to write a large switch
			statement in which you call functions that correspond to the event. Here's
			a small example:
<pre>
      void MyDialog::HandleEvent(Widget &obj, int msg, int arg1, int arg2) {
         // pass the event up the class hierarchy
         Dialog::HandleEvent(obj, msg, arg1, arg2);

         // handle different messages
         switch (msg) {
            case MSG_ACTIVATE:
               if (obj == button1)         OnButton1();        else
               if (obj == button2)         OnButton2();        else
               if (obj == button3)         OnButton3();
               break;

            case MSG_RPRESS:
               if (obj == desktop)         OnPopupMenu();
               break;

            case MSG_MOUSEMOVE:
               if (obj == desktop)         OnMouseMove(Point(arg1, arg2));
               break;

            case MSG_SCROLL:
               if (object == slider1)      OnChangeVolume(int arg1);
               break;
         };
      }
</pre>
			Note that it is illegal to delete a widget in HandleEvent() or in a function
			called from HandleEven(). If you want to remove and delete a dynamically
			created widget (e.g. in response to MSG_CLOSE), call Remove(obj, true) instead.
		*/
		virtual void HandleEvent(Widget &obj, int msg, int arg1=0, int arg2=0);
		/**
			Returns the root of the dialog hierarchy (the top level dialog).
		*/
		Dialog *Root();
		/**
			Returns the root window of the dialog hierarchy (the top level window) or
			the root dialog if this dialog isn't part of a window.
		*/
		Dialog *RootWindow();
		/**
			Requests the dialog to be closed. It calls MsgClose() to determine
			whether the dialog should really be closed or not. Call this function
			when you want to close the dialog or remove it but don't popup a dialog
			asking the user if they really want to exit. Do that in the MsgClose()
			function instead.
		*/
		virtual void Close();
		/**
			Checks whether the dialog has input focus. A dialog has input focus
			if it's D_HASFOCUS flag is set or if any of it's child widgets has
			input focus.
		*/
		bool HasFocus();
		/**
			Checks whether the dialog has the mouse. A dialog has the mouse
			if it's D_HASMOUSE flag is set or if any of it's child widgets has
			the mouse.
		*/
		/** */bool HasMouse();
		/** */void Hide();
		/** */void Unhide();
		/** */void Enable();
		/** */void Disable();
		/** */void Redraw();
		/**
			These functions do the same thing as the same functions in the Widget base class.
			The only exception is that they also propagate the messages to all dialog's
			child widgets. For example if you ask the dialog to redraw itself it will ask all
			it's widgets to redraw themselves as well.
		*/
		void Redraw(const MAS::Rect &region);
		/**	*/virtual void GiveFocusTo(Widget *w);
		/**	*/virtual void TakeFocusFrom(Widget *w);
		/**
			Functions for moving input focus. GiveFocusTo() tries to give focus to the
			passed widget if it wants it, TakeFocusFrom() takes focus away from the
			widget and MoveFocus() moves the input focus by first taking it away from
			the src object and giving it the dest object.
		*/
		virtual void MoveFocus(Widget *src, Widget *dest);
		/**	*/virtual void GiveMouseTo(Widget *w);
		/**	*/virtual void TakeMouseFrom(Widget *w);
		/**
			Like the corresponding focus functions. Except that these don't handle input
			focus but the fact whether a widget has the mouse or not.
		*/
		virtual void MoveMouse(Widget *src, Widget *dest);
		/**
			Tries to move the input focus to the passed object. This can fail if the object
			you're trying to give focus to is hidden, disables or doesn't want to take focus.
		*/
		void MoveFocusTo(Widget *obj);
		/**
			Returns a pointer to the widget with the input focus.
		*/
		Widget *GetFocusObject() const;
		/**
			Returns a pointer to the widget with the mouse.
		*/
		Widget *GetMouseObject() const;
		/**
			Floats the widget to the top of the dialog. It does so by first removing it from
			the widget array and then adding it back to the end of the array.
		*/
		void BringToTop(Widget &w);
		/**
			Registers a user defined tooltip object. This is then used for displaying tooltip
			help bubbles. Pass NULL to reset the tooltip object to the default implementation.
		*/
		void SetTooltipObject(Tooltip *tooltipObject);

		/**
			The main loop of the dialog manager. This function executes the dialog and returns
			a pointer to the widget that last had input focus (i.e. the widget that caused the
			dialog to close. The optional focus parameter should be a pointer to the widget you
			want to have focus when the dialog starts. Note that the dialog you execute (the
			top level dialog) can't be smaller than the screen and you can't place it in an
			arbitrary position, it has to be in the top left corner of the screen.
		*/
		virtual Widget *Execute(Widget *focus = NULL);
		/**
		*/
		virtual Widget *Popup(Dialog *parent = NULL, int x = MAXINT, int y = MAXINT, Widget *focus = NULL);
		/**
			Pops up a window. Similar to Execute() except that this function pops up the
			dialog at the specified position which means it will remember the background
			of the dialog if it's not popped up from a parent dialog. Note that if you
			want to popup a dialog, it needs a parent so you have to pass "this" if you call
			this function from a dialog's message handler. Pass NULL only when the dialog is
			not popped up from a parent dialog. In this case a dummy parent will be created
			automatically and it will remember the background of the dialog.
		*/
		virtual Widget *Popup(Dialog *parent, const MAS::Point &pos, Widget *focus = NULL);
		/**
			Centres the dialog on the screen.
		*/
		virtual void Centre();
		void Dump();

		friend class MASKING_DLL_DECLSPEC Widget;
};
}

#endif		//MASKING_DIALOG_H
