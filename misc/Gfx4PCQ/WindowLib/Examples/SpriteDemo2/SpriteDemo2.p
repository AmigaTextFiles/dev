Program SpriteDemo;
{Another sample program for sprites, © 1997 THOR-Software inc.

 We present bobs this time. They aren't real hardware sprites, but
 animated figures drawn by the blitter.
 They can be as wide as you wish, but share the colors of the screen
 and are usually more flickering.

 We show as well how to read the joystick.
}

Procedure WaitTOF;
External;
{$I "include:utils/windowlib.i"}
{$I "include:utils/stringlib.i"}
  
PROCEDURE Demo;

TYPE    
        SpriteArray     =       Array[0..10] of String;	{contains the shapes}
CONST
	{Definition of the sprite shapes... Just some nonsense, I'm not an
	 artist!}

        Shape1 : SpriteArray    =       (
                "                ..............                 ",
                "        ..........++++++++++............       ",
                "    ........+++++++++++++++++++++++++.......   ",
                " ......+++++++         *            +++++..... ",
                "...++++++             ***             ++++++...",
                "...+++++*******************************+++++...",
                "...++++++             ***             ++++++...",
                " ......+++++++         *           ++++++..... ",
                "    ........+++++++++++++++++++++++++.......   ",
                "        ..........++++++++++............       ",
                "                ..............                 ");

        Shape2 : SpriteArray    =       (
                "                ..............                 ",
                "        ..........++++++++++............       ",
                "    ........+++++++++++++++++++++++++.......   ",
                " ......+++++++******        ********+++++..... ",
                "...++++++           *** ****          ++++++...",
                "...+++++              ***              +++++...",
                "...++++++           *** ****          ++++++...",
                " ......+++++++******        *******++++++..... ",
                "    ........+++++++++++++++++++++++++.......   ",
                "        ..........++++++++++............       ",
                "                ..............                 ");

        Shape3 : SpriteArray    =       (
                "                ..............                 ",
                "        ..........++++++++++............       ",
                "    ........+++++++++++++++++++++++++.......   ",
                " ......+++++++        ****          +++++..... ",
                "...++++++           **    **          ++++++...",
                "...+++++           *        *          +++++...",
                "...++++++           **    **          ++++++...",
                " ......+++++++        ****         ++++++..... ",
                "    ........+++++++++++++++++++++++++.......   ",
                "        ..........++++++++++............       ",
                "                ..............                 ");



VAR
        s       :       ScreenPtr;
        w       :       WindowPtr;	{holds window and screen}
        sp1     :       SpritePtr;
        sp2     :       SpritePtr;
        sp3     :       SpritePtr;	{holds sprites}
        xm,ym   :       Short;
	x,y	:	Short;		{mouse and joystick position}
	mask	:	Integer;	{tmp to store the collision mask}
                
BEGIN
	{open screen & window}
        s:=OpenAScreen(0,0,640,256,2,MON_HIRES or MON_NTSC,"Testscreen");
        IF s<>NIL THEN BEGIN
                
                w:=OpenScreenWindow(s,0,0,640,256,2+4+8,"A Test");
                
                IF w<>NIL THEN BEGIN

			{create the sprites, this time as "bobs", not as true hardware sprites}
                        sp1:=OpenSprite(w,@Shape1[0],11,SPRITE_SAVEBACK or SPRITE_OVERLAY);
                        sp2:=OpenSprite(w,@Shape2[0],11,SPRITE_SAVEBACK or SPRITE_OVERLAY);
                        sp3:=OpenSprite(w,@Shape3[0],11,SPRITE_SAVEBACK or SPRITE_OVERLAY);


			{define priorities. This works only for bobs!
			 Note that the order of this definition is IMPORTANT!
			 See the guide for more!}
			InFrontOf(sp1,sp2);
			InFrontOf(sp2,sp3);

			{Setup memask and hitmask of the sprites. Collect
			 collisions with the first sprite with all others.
			 Read the guide for more information on this.}

			SetCollisionMasks(sp1,2,4+8);
			SetCollisionMasks(sp2,4,2);
			SetCollisionMasks(sp3,8,2);

			{setup the position}
			x:=100;
			y:=100;
                        REPEAT
                                Mouse(w,xm,ym);	{read the mouse}

                                PlaceSprite(sp1,x SHL 16,y SHL 16);
                                PlaceSprite(sp2,xm SHL 16,120 SHL 16);
                                PlaceSprite(sp3,200 SHL 16,ym SHL 16);
				{place the sprites}
	
				AnimateSprites(w);	{and show them}

				mask:=ReadCollisionMask(sp1,TRUE);	{read the collision mask, clear it and print it}
				writeln(mask);

				WaitForStick(1);			{wait until something happens with the joystick}
				{and update the positions}
				If StickUp(1) AND (y>0) THEN y:=y-1;
				If StickDown(1) AND (y<200) THEN y:=y+1;
				If StickLeft(1) AND (x>0) THEN x:=x-1;
				If StickRight(1) AND (x<640) then x:=x+1;
			UNTIL Strig(1);
        
                        CloseAWindow(w);
                END;
                CloseAScreen(s);
        END;
END;

BEGIN
        InitGraphics;
        Demo;
        ExitGraphics;
END.
