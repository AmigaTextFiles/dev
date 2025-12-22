Program Lander;
{ ************************************************************************
  **	Lander								**
  ** A sample game using the PCQ windowlib © 1997 THOR-Software inc.	**
  ** Version 0.00 11.07.1997						**
  **									**
  ** This game is by no means complete, it's just a demonstration	**
  ** what's possible with the windowlib and should serve as a reference **
  ** for common techniques for accessing the library.			**
  ** Feel free to complete this example if you like!			**
  ************************************************************************}

{$I "INCLUDE:Utils/windowlib.i"}	{ This is the main include file.
					  All windowlib entries are defined
					  here }
{$I "INCLUDE:Utils/random.i"}		{ A random generator }


{ Next, we define the types for the definition of the sprite shapes. They
  have to be arrays of PCQ type strings, the size of the array beeing the
  height of the sprite. }
TYPE
	LanderArray	=	Array [0..9] of String;	{ The shape of the lander itself }
	FlameArray	=	Array [0..4] of String; { The main engine }
	SteerArray	=	Array [0..2] of String; { The left and right engine }

{ This is the definition of the sprite shapes. Since we're using true hardware
  sprites in this example, the width of the sprites are limited to 16 pixels
  and a maximum of three colors is allowed. The shape itself is encoded in
  "ASCII-Art", each character representing one color:
	space	=	background
	.	=	color 1
	+	=	color 2
	*	=	color 3
  If you're using bobs,i.e. playfield graphics instead of hardware sprites, more
  colors than the four above can be used. The encoding can be found in
  the docs. }
 
CONST
	Lander	:	LanderArray=(	{ the lander itself }
	"      ...       ",
	"     ......     ",
	"    ........    ",
	"   ...+..+...   ",
	"  *..++..++..*  ",
	"   ...+..+...   ",
	"    ........    ",
	"  ..  ***   ..  ",
	" ..  *****   .. ",
	"..            ..");
	 
	{ the main engine. This one takes two shapes since we're going
	  to animate it. This animation is automatically done by the
	  windowlib, no need to care about it. }

	Flame	:	Array[0..1] of FlameArray=((
	"      .*.       ",
	"     .*+*.      ",
	"     .*+*.      ",
	"      ...       ",
	"                "),(
	"      .*.       ",
	"     .*+*.      ",
	"     **+**      ",
	"     .*.*.      ",
	"    .  .  .     "));


	{ left and right engine }
	
	SteerLeft :	Array[0..1] of SteerArray=((
	"             .. ",
	"           ..**.",
	"             .. "),(
	"            ... ",
	"          ..*+*.",
	"            ... "));

	SteerRight :	Array[0..1] of SteerArray=((
	" ..             ",
	".**..           ",
	" ..             "),(
	" ...            ",
	".*+*..          ",
	" ...            "));

{ variable section }
VAR
	x,y			:	Integer;	{ position of the lander }
	xvel,yvel		:	Integer;	{ its velocity }
	g			:	Integer;	{ graviation constant }
	power			:	Integer;	{ acceleration power of the engines }
	powerleft,powerright	:	Integer;
	strength		:	Integer;	{ hull strength of the lander. Crash if we hit the ground faster than that }
	w			:	WindowPtr;	{ the main window }
	s			:	ScreenPtr;	{ the screen }
	lsp			:	SpritePtr;	{ the lander sprite }
	botsp,leftsp,rightsp	:	SpritePtr;	{ left,right and main engine }
	bot1sp,left1sp,right1sp	:	SpritePtr;	{ alternate images, for animation }
	platform		:	Integer;	{ position of the landing platform }
	plheight		:	Integer;	{ height of the platform }
	fuel,lastfuel		:	Integer;	{ current fuel and last fuel, used for easy updateing }
	biguse			:	Integer;	{ fuel consumption of the main engine }
	smalluse		:	Integer;	{ fuel consumption of the left and right engine }

{ A tiny note about the positioning of sprites:
  All positions are relative to the window the sprite resides in, regardless
  if this is a true hardware sprite or a bob.
  The position is given as 32 bit scaled fraction - this sounds horrible, but
  is in fact very easy:
	To get the real screen position of the sprite, shift the sprite 
	position right by 16 bits (divide by 65536), i.e. 
		screenx=spritex SHR 16.

	To set the sprite to a real screen position, shift the screen position
	left by sixteen bits, i.e. spritex=screenx SHL 16.

	Experts might notice that the position is, hence, encoded 
	as following:

	spritex	= ssssssssssssssss ffffffffffffffff
		  screen position  fractional part
		  upper 16 bits	   lower 16 bits

  This scaling is done to allow smooth animation without floating point
  numbers, which are usually slow. }
		

{ This procedure draws the fuel gauge at the top of the main window }
Procedure DrawFuel;
BEGIN
	Color(w,2);		{ select pen two for drawing }
	PBox(w,0,0,319,8);	{ draw the full gauge }
	Position(w,0,7);	{ select the position }
	DrawMode(w,0);		{ select JAM1 for drawing, i.e. the text background is transparent }
	Color(w,1);		{ select pen one for the text }
	DrawText(w,"Fuel :");	{ print the text at the selected position }
	Color(w,0);		{ select pen 0 for the separator bar }
	Plot(w,99,0);		{ draw starting point }
	DrawTo(w,99,8);		{ draw the bar, a vertical line }
	lastfuel:=fuel;		{ remember the last fuel, for easy update }
END;

{ This procedure is called when the fuel has changed and must be updated.
  It does not re-draw the fuel gauge completely, only the part that has
  changed is updated. The variable lastfuel holds the last fuel for this
  purpose. }
Procedure UpdateFuel;
BEGIN
	IF fuel<0 THEN	fuel:=0;	{ don't draw negative fuel }

	IF fuel<>lastfuel THEN BEGIN	{ any change whatsoever? }
		Color(w,1);		{ select pen 1, black }
			{ Update the gauge. Note that the fuel is shifted 
			  right by 16 bits, i.e. is divided by 65536.
			  This is just a useful scaling to avoid floats }
		PBox(w,100+(fuel SHR 16),0,100+(lastfuel SHR 16),8);
		lastfuel:=fuel		{ store the last fuel }
	END
END;

{ Setup the velocities, position and other lander specific constants.
  If you want to add more levels with different settings, that's definitely
  the procedure you've to modify }	
Procedure InitVelocities;
BEGIN
	x:=160 SHL 16;	{ setup x and y position of the lander. Please note }
	y:=8 SHL 16;	{ that the screen positions 160,8 must be shifted }
			{ left by 16 bits to give the sprite position, as }
			{ discussed above }
	xvel:=0;
	yvel:=0;	{ set the velocity to zero }
	g:=1024;	{ graviational constant. Bigger = harder. }
	power:=4096;		{ acceleration by the main engine. }
	powerleft:=2048;	{ left and right engine power }
	powerright:=2048;
	strength:=65536;	{ hull strength. If we land harder than that,
				  we crash! }
	fuel:=219 SHL 16;	{ the fuel }
	biguse:=16384;		{ fuel consumption, for left & right and main engine }
	smalluse:=4096;
END;

{ Draw some stars as background. The color effects are done with the "copper"
  a graphics coprocessor on board. }
Procedure DrawStars;
VAR
	i			:	Integer;
BEGIN
	Color(w,1);		{ select color one for the stars }
	FOR i:=0 TO 39 DO	{ draw 40 stars at random positions }
		Plot(w,RangeRandom(319),RangeRandom(180)+8)
END;

{ Draw the landing plot, i.e the ground. }
Procedure DrawGround;
VAR
	i			:	Integer;
	y			:	Integer;
	dice			:	Integer;
BEGIN
	y:=185-RangeRandom(50);			{ initial height }
	platform:=RangeRandom(319-18);		{ position of the platform }
	Color(w,2);				{ select pen two for the ground }
	{ the nice color effect is again done by the copper, which alters the
	  contents of the color registers "on the fly". No need to take care
	  about this right here. }
		
	FOR i:=0 TO 319 DO BEGIN	{ for all x positions }
		Plot(w,i,189);		{ draw a line from the bottom of }
		DrawTo(w,i,y);		{ the window to the height of the ground }
		dice:=RangeRandom(6);	{ roll a dice to get the new height }
		IF (i>=platform) AND (i<=platform+17) THEN BEGIN
			dice:=3;	{ if we're at the position of the platform }
			plheight:=y	{ do not change the height and remember }
					{ the position for later use }
		END;

		{ depening on the dice roll above, modify the height 
		  by -3 to +3 }

		CASE dice OF
			0:	IF y<183 THEN y:=y+3;
			1:	IF y<184 THEN y:=y+2;
			2:	IF y<185 THEN y:=y+1;
			4:	IF y>99  THEN y:=y-1;
			5:	IF y>98  THEN y:=y-2;
			6:	IF y>97  THEN y:=y-3;
		END;
	END;

	{ The ground is now almost complete. We've to draw the platform
  	  with pen 3 at the position remembered before }

	Color(w,3);			 { select pen three }
	Plot(w,platform,plheight+3);	 { start at the left bottom position }
	DrawTo(w,platform,plheight);	 { up to the ground }
	DrawTo(w,platform+17,plheight);  { and now rightwards }
	DrawTo(w,platform+17,plheight+3);{ and down into the ground again }
	Plot(w,platform+1,plheight+3);	 { just the same story, but }
	DrawTo(w,platform+1,plheight+1); { with a little displacement }
	DrawTo(w,platform+16,plheight+1);{ for a thicker line }
	DrawTo(w,platform+16,plheight+3);

END;

{ This is the main animation loop, everything important happens in here.
  It returns TRUE on a successful landing, or FALSE on a crash. }
Function AnimationLoop : Boolean;
VAR
	pushleft,pushright	:	Boolean;	{ true if joystick is pushed into this direction }
	pushup			:	Boolean;
	boom			:	Boolean;	{ true if we crashed }
	landed			:	Boolean;	{ true on successful landing }
	c1,c2			:	Byte;		{ the colors at the position of the landing gear }
	xw,yw			:	Integer;	{ temporary storage }
BEGIN

	boom:=FALSE;
	landed:=FALSE;		{ neither landed nor crashed }
	ShowSprite(lsp);	{ make the lander visible. }

	{ A tiny remark about all sprite related functions: (Almost) none of
	  them has a direct result on the screen. Calls like ShowSprite() or
	  PlaceSprite() DO NOT have an immediate effect at all, they just
	  alter the current properties of the sprite.
	  To make the changes visible, a call to AnimateSprites() or
	  RedrawSprites() is necessary. This buffering is done because
	  both calls are rather slow, so you should avoid calling them too
	  often. Just set all sprite properties before, and map them to
	  the screen AT ONCE with one big AnimateSprites().

	  The only difference between AnimateSprites() and RedrawSprites()
	  is that the first one does not only redraw the sprites on the
	  screen, but drives the animation engine as well; i.e., it selects
	  the next sprite out of an animation sequence. 
	  If you don't use any animation, both procedures are equivalent. }

	
	REPEAT	{ .. until crash or landing }

		UpdateFuel;		{ redraw the fuel gauge }
		pushup:=StickUp(1);	{ true if the user pushed the stick upwards }
		pushleft:=StickLeft(1);	{ same for left and right }
		pushright:=StickRight(1);

		{ the argument to the joystick calls is the port number of
		  the joystick, 1 beeing the right one at the A2000, i.e. the
		  one which is usually NOT connected to the mouse.
		  You MAY use a joystick in port 0 as well, by providing
		  a zero as argument, but this will make the mouse unuseable.
		  Mouse input can be re-established with a call of
		  FreeJoystick(0), if you need it. }

		IF pushup AND (fuel>=biguse) THEN BEGIN	{ start main engine if fuel is left }
			ShowSprite(botsp);	{ show the main engine }
			yvel:=yvel-power;	{ accelerate upwards }
			fuel:=fuel-biguse;	{ consume fuel }
		END ELSE BEGIN
			HideSprite(botsp);	{ hide it }
			yvel:=yvel+g;		{ fall down }
		END;

		{ left and right engines handled similar }
		IF pushleft AND (fuel>=smalluse) THEN BEGIN
			ShowSprite(rightsp);
			xvel:=xvel-powerleft;
			fuel:=fuel-smalluse;
		END ELSE BEGIN
			HideSprite(rightsp);
		END;

		IF pushright AND (fuel>=smalluse) THEN BEGIN
			ShowSprite(leftsp);
			xvel:=xvel+powerright;
			fuel:=fuel-smalluse;
		END ELSE BEGIN
			HideSprite(leftsp);
		END;

		{ The next lines handle boundary collision of the lander.
		  The animation engine of the OS can handle sprite to sprite
		  collsions, and sprite to boundary collisons, but no
		  sprite to playfield collisions. I've no idea why, this is
		  in fact a design flaw which can't be fixed with the window-
		  lib.
		  We use here the sprite to boundary collisions for 
		  reflections on the boundary of the window.
	
		  The hitmask of the lander was setup in the main program,
		  we can read it here with ReadCollisionMask.
		  The first argument is the sprite, the last a boolean that
		  indicates wether the collision mask should be cleared
		  for the next loop. }

		{ collision with left boundary ? }		
		IF (ReadCollisionMask(lsp,FALSE) AND COLLIDE_LEFT)<>0 THEN BEGIN
			IF xvel<0 THEN
				xvel:=-xvel	{ reflection }
		END;

		{ collision with right boundary ? }
		IF (ReadCollisionMask(lsp,FALSE) AND COLLIDE_RIGHT)<>0 THEN BEGIN
			IF xvel>0 THEN
				xvel:=-xvel	{ reflection as well }
		END;

		{ collision with top of window ? }
		IF (ReadCollisionMask(lsp,FALSE) AND COLLIDE_TOP)<>0 THEN BEGIN
			IF yvel<0 THEN
				yvel:=-yvel;
		END;

		{ collsion with the bottom is a crash }
		IF (ReadCollisionMask(lsp,TRUE) AND COLLIDE_BOTTOM)<>0 THEN BEGIN
			IF yvel>0 THEN
				boom:=TRUE
		END;

		{ update the position by adding the velocity }
		x:=x+xvel;
		y:=y+yvel;

		{ place the lander at the new position }
		PlaceSprite(lsp,x,y);
		{ place the left,right and main engine as well.
		  The proper displacement of the sprites was setup
		  before, in the main program. We may use here the
		  the same position as for the lander.
		  Even though the sprite poisitions are set here, this
		  does not mean that they are visible. This is controlled
		  by ShowSprite & HideSprite }
		PlaceSprite(leftsp,x,y);
		PlaceSprite(rightsp,x,y);
		PlaceSprite(botsp,x,y);


		{ We're now handling collision with the ground. The
		  collision routines of the OS do not handle them, sigh.}


		{ Determinate the screen position from the sprite position }
		xw:=x SHR 16;
		yw:=y SHR 16;

		IF y>0 THEN BEGIN	{ don't allow collision with the fuel gauge }

			c1:=Locate(w,xw+1,yw+9); { get the color at the position of the landing gear }
			c2:=Locate(w,xw+14,yw+9);

			{ don't allow collisions with the stars.
			  -1 is returned if the point is outside of the
			  window. This may happen if the sprite is about to
			  collide with the boundary. We don't handle this as
			  a crash }
			IF (c1=1) or (c1=-1) THEN	c1:=0;
			IF (c2=1) or (c2=-1) THEN	c2:=0;
	
			IF ((c1<>0) OR (c2<>0)) THEN BEGIN { any collision? }
				IF (c1=3) AND (c1=3) THEN BEGIN { with the platform? }
					IF yvel<strength THEN	{ if so, slow enough ? }
						landed:=TRUE	{ yes, so successful landing }
					ELSE	boom:=TRUE	{ if not, crash }
				END ELSE boom:=TRUE		{ same if we collide with anything else }
			END
		END;

		{ the next procedure redraws all the sprites. Note again
		  that (almost) all sprite calls don't work immediately and
		  this one IS needed. 
		  It does also the animation we've setup for realistic engine }
		AnimateSprites(w);	

	UNTIL boom OR landed; {abort on crash or landing}

	AnimationLoop:=landed; {return TRUE if landed properly}
END;

{ This is the main loop of the game. Quite a lot must be done here, as
  for example a score counter, more levels, more "lives", etc... }
	
Procedure MainLoop;
VAR
	success		:	Boolean;
BEGIN
	REPEAT
		HideSprite(lsp);	{ hide all sprites }
		HideSprite(botsp);
		HideSprite(leftsp);
		HideSprite(rightsp);
		AnimateSprites(w);	{ and make the changes visible }
	
		ClearRaster(w,0);	{ clear the window }
		DrawStars;		{ draw background }
		DrawGround;		{ draw ground }
		InitVelocities;		{ initialize lander specific data }
		DrawFuel;		{ draw the fuel gauge }
		success:=AnimationLoop;	{ and start the animation }
	UNTIL NOT success;		{ abort on a crash }
END;

{ This procedure is used to setup the nice color effects on the screen.
  It uses the "Copper" support procedures of the windowlib to change the
  color of some of the pens in the middle of the screen. }

PROCEDURE SetupCopper;
VAR	
	y		:	Integer;
	i		:	Integer;
BEGIN
	SetColor(s,0,0,0,15);	
	{ set background to blue. The colors selected with SetColor are
	  always visible on top of the screen }
			

	y:=19;
	CopperWait(s,0,y);	
	{ wait for line 19 for the next copper operation }

	CopperSetColor(s,1,14,13,12);
	CopperSetColor(s,2,1,2,3);
	CopperSetColor(s,3,0,15,5);
	{ fill pens 1 to 3 with new values }

	{ dim blue to black }
	FOR i:=0 TO 15 DO BEGIN
		CopperSetColor(s,0,0,0,15-i);	{ set pen color }
		y:=y+1;
		CopperWait(s,0,y);		{ wait for the next line }
	END;

	{ dim the stars }
	FOR i:=0 TO 11 DO BEGIN
		CopperSetColor(s,1,12-i,13-i,14-i);	{ next color }
		y:=y+8;				{ wait for the next }
		CopperWait(s,0,y);		{ eight lines }
	END;

	{ dim the ground from dark to light }
	FOR i:=0 TO 8 DO BEGIN
		CopperSetColor(s,2,2+i,3+i,4+i);	{ ground }
		CopperSetColor(s,3,0,15-i,5);		{ platform }
		y:=y+7;
		CopperWait(s,0,y);
	END;

	{ we're done with the copper, display the color effects }
	CopperDone(s);
END;


{ This is now the main program. Initialising starts here }
BEGIN
	{ setup the windowlib. This one is VERY important, nothing works
	  without it! }
	InitGraphics;	
		
	SelfSeed;	{ initialise the random generator }

	{ open a screen for our program. We use a standard LORES screen with
	  four pens. A lot of color effects can be done with the copper, the
	  sprites come with their own colors anyways.
	  LORES is a MUST if you want to use the hardware sprites with 
	  collision detection, due to another bug in the OS routines }
	s:=OpenAScreen(0,0,320,200,2,MON_LORES,"Lander © 1997 THOR-Software.");
        IF s<>NIL THEN BEGIN
		{ unless all other calls, this one might fail! You HAVE to
		  check if we got the screen, no way around it !}
		
		SetupCopper; { display the graphics effects with the copper }
		
		{ open a window on the screen. We use a borderless backdrop window
		  here, the frame around the window is not wanted.
		  Note that we must pass a NIL pointer as window title to make
		  the drag bar of the window invisible as well }
		w:=OpenScreenWindow(s,0,10,320,190,WINFLG_BACKDROP or WINFLG_BORDERLESS or WINFLG_ACTIVATE,NIL);
                IF w<>NIL THEN BEGIN
			{ check if this was successful. THIS CALL MIGHT FAIL! }
		
			IF SetWindowFont(w,"topaz.font",8) THEN BEGIN
				{ set the window font to default. Necessary if
				  the user choose something else.
				  The font will be used by the fuel gauge.
				  Again, this call might fail and returns
				  FALSE in this case }
				

	{ the next calls build the sprite shapes of the lander and the
	  engines. Each engine uses two sprites, only one of them is
	  visible at a time, as done by the animation procedures.
	  This gives a nice "fire" effect.
	  We use also true hardware sprites as they are faster, less
	  flickering and come with their own colors.
	  They are, however, limited to LORES }

				lsp:=OpenSprite(w,@Lander[0],10,SPRITE_HARDWARE);
				botsp:=OpenSprite(w,@Flame[0][0],5,SPRITE_HARDWARE);
				bot1sp:=OpenSprite(w,@Flame[1][0],5,SPRITE_HARDWARE);
				leftsp:=OpenSprite(w,@SteerLeft[0][0],3,SPRITE_HARDWARE);
				left1sp:=OpenSprite(w,@SteerLeft[1][0],3,SPRITE_HARDWARE);
				rightsp:=OpenSprite(w,@SteerRight[0][0],3,SPRITE_HARDWARE);
				right1sp:=OpenSprite(w,@SteerRight[1][0],3,SPRITE_HARDWARE);

	{ please note that we must pass a pointer to the first string of the
	  sprite "ASCII Art" definition. The next parameters are the height and a
	  flags field }
	

	{ Link the engine sprites together. This is all required for the
	  animation, everything else is done by the windowlib.
	  The linked sprites come with their own colors, their own
	  displacement set by ShiftSprite, their own shape but share
	  the position of the sprite they are linked to. }

				LinkSprite(botsp,bot1sp);
				LinkSprite(leftsp,left1sp);
				LinkSprite(rightsp,right1sp);

	{ Start the collision detection of the lander sprite with the border.
	  The first parameter is the "MeMask", used for collisions with other
	  sprites, the second is the "HitMask" which selects which collisions
	  are detected for this sprite }
	
				SetCollisionMasks(lsp,0,COLLIDE_BORDER);
	
	{ Select the colors for the lander sprite }
				SetSpriteColor(lsp,1,10,10,10);
				SetSpriteColor(lsp,2,4,0,8);
				SetSpriteColor(lsp,3,4,4,4);

	{ The colors between the engines will be shared. This has 
	  two advantages: First, we have to setup the colors only for the
	  base sprite, all the colors of all sprites linked to that one will
	  get the same colors. Secondly, it tells the sprite mapping that
	  a hardware sprite using the same colors can be used to display this
	  sprite, allowing more sprites on the display. }	  

				ShareColors(botsp,leftsp);
				ShareColors(botsp,rightsp);

				ShareColors(bot1sp,left1sp);
				ShareColors(bot1sp,right1sp);

	{ select the colors for the engines, base and second animation
	  frame }
				SetSpriteColor(botsp,1,15,0,0);
				SetSpriteColor(botsp,2,15,15,15);
				SetSpriteColor(botsp,3,15,10,0);

				SetSpriteColor(bot1sp,1,10,0,0);
				SetSpriteColor(bot1sp,2,10,10,15);
				SetSpriteColor(bot1sp,3,15,8,0);

	{ select displacements for the engines }
				ShiftSprite(leftsp,-(14 SHL 16),3 SHL 16);
				ShiftSprite(rightsp,14 SHL 16,3 SHL 16);
				ShiftSprite(botsp,0,9 SHL 16);
				ShiftSprite(left1sp,-(14 SHL 16),3 SHL 16);
				ShiftSprite(right1sp,14 SHL 16,3 SHL 16);
				ShiftSprite(bot1sp,0,9 SHL 16);

	{ start the game }
				MainLoop;
	
	{ close the sprites. Just a matter of good style! }

				CloseSprite(lsp);
				CloseSprite(botsp);
				CloseSprite(bot1sp);
				CloseSprite(leftsp);
				CloseSprite(left1sp);
				CloseSprite(rightsp);
				CloseSprite(right1sp)
			END;	
	{ close the window we've used }
			CloseAWindow(w)
		END;

	{ same for the screen }
		CloseAScreen(s)
	END;

	{ THIS ONE IS VERY IMPORTANT! It gives all used resources back to
	  the system. This is necessary, even though we've closed the
	  window, screen and sprites manually. The windowlib allocates
	  quite more stuff implicitly than is visible from the outside. }
	ExitGraphics
END.
