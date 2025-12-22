Program SpriteDemo;

{"Thousands sprites" demo for the windowib. © 1997 THOR-Software.

  This example program displays quite a lot of hardware sprites and
  presents a simple use of the animation engine.}

Procedure WaitTOF;
External;
{$I "include:utils/windowlib.i"}
{$I "include:utils/stringlib.i"}
{$I "include:utils/random.i"}
  
PROCEDURE Demo;

TYPE    
	SpriteArray 	= 	Array[0..8] of String;		{A single sprite shape}
	Anim		=	Array[1..13] of SpritePtr;	{This holds the complete animation as one sprite}

CONST
	{This is the definition of the sprite shapes as ASCII-ART
	 See the windowlib.guide to find out more about the encoding here.}

        Shapes : Array[1..13] of SpriteArray=(
                ("     ...     ",
                 "   ..++...   ",
                 "  .+.+.+.+.  ",
                 "  ++.++..+.  ",
                 "   +.+....   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   .++...+   ",
                 "  ..+.+.+..  ",
                 "  ..++..+..  ",
                 "   .+....+   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   ++...++   ",
                 "  .+.+.+...  ",
                 "  .++..+...  ",
                 "   +....++   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   +...++.   ",
                 "  +.+.+....  ",
                 "  ++..+....  ",
                 "   ....++.   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   ...++..   ",
                 "  .+.+...+.  ",
                 "  +..+...+.  ",
                 "   ...++..   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   ..++..+   ",
                 "  +.+...+..  ",
                 "  ..+...+..  ",
                 "   ..++..+   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   .++..++   ",
                 "  .+...+..+  ",
                 "  .+...+.++  ",
                 "   .++..++   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   ++..++.   ",
                 "  +...+..+.  ",
                 "  +...+.++.  ",
                 "   ++..+++   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   +..++..   ",
                 "  ...+..+.+  ",
                 "  ...+.++.+  ",
                 "   +..+++.   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   ..++..+   ",
                 "  ..+..+.+.  ",
                 "  ..+.++.+.  ",
                 "   ..+++.+   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   .++..++   ",
                 "  .+..+.+.+  ",
                 "  .+.++.++.  ",
                 "   .+++.+.   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   ++..++.   ",
                 "  +..+.+.+.  ",
                 "  +.++.++..  ",
                 "   +++.+..   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "),

                ("     ...     ",
                 "   +..++..   ",
                 "  ..+.+.+.+  ",
                 "  .++.++..+  ",
                 "   ++.+...   ",
                 "     ...     ",
                 "    * * *    ",
                 "    *****    ",
                 "    *****    "));

NumSprites	=	16;	{number of sprites to display. Increase for more!}
                
VAR
        s       :       ScreenPtr;
        w       :       WindowPtr;	{screen and window}
	objects	:	Array[1..NumSprites] of Anim;
        sp      :       Array[1..NumSprites] of SpritePtr;
        i,j     :       Integer;
	x,y	:	Array[1..NumSprites] of Integer;
	xv,yv	:	Array[1..NumSprites] of Integer;
	xm,ym	:	Short;
	r,g,b	:	Array[1..3] of Short;	{colors}
	        
BEGIN
	{open screen and window}
        s:=OpenAScreen(0,0,640,256,2,MON_HIRES,"Sprite example");
        IF s<>NIL THEN BEGIN
                
                w:=OpenScreenWindow(s,0,0,640,256,2+4+8,"Quite a lot of sprites");
                
                IF w<>NIL THEN BEGIN

			FOR j:=1 TO NumSprites DO BEGIN
				{roll dice to get the color}
				FOR i:=1 to 3 DO BEGIN
					r[i]:=RangeRandom(16);
					g[i]:=RangeRandom(16);
					b[i]:=RangeRandom(16);
				END;
				{now build the sprites, one for each animation component}
				FOR i:=1 TO 13 DO BEGIN
					objects[j][i]:=OpenSprite(w,@Shapes[i][0],9,SPRITE_HARDWARE); {we use real sprites here}
					SetSpriteColor(objects[j][i],1,r[1],g[1],b[1]);
					SetSpriteColor(objects[j][i],2,r[2],g[2],b[2]);
					SetSpriteColor(objects[j][i],3,r[3],g[3],b[3]);	{define colors}
					IF i>1 THEN
						LinkSprite(objects[j][1],objects[j][i]);{link it to the base sprite to get an animation}
				END;	
				sp[j]:=objects[j][1];	{we need the base only}
			END;

			{get positions and velocities}	
			FOR i:=1 TO NumSprites DO BEGIN
				x[i]:=RangeRandom(639) SHL 16;
				y[i]:=RangeRandom(229) SHL 16;
				xv[i]:=RangeRandom(2 SHL 8) SHL 8;
				yv[i]:=RangeRandom(2 SHL 8) SHL 8;
			END;

                        RequestStart(w,CLOSEWINDOW_f);
                        REPEAT
				FOR i:=1 To NumSprites DO BEGIN
					PlaceSprite(sp[i],x[i],y[i]);	{set sprite position}
					x[i]:=x[i]+xv[i];		{update position by velocity}
					IF (x[i]<=0) or (x[i]>=(639 SHL 16)) THEN
						xv[i]:=-xv[i];
					y[i]:=y[i]+yv[i];
					IF (y[i]<=0) or (y[i]>=(229 SHL 16)) THEN
						yv[i]:=-yv[i];
				END;
                                AnimateSprites(w);	{display sprites on the screen}
                        UNTIL (NextRequest(w) AND CLOSEWINDOW_f)<>0;
			{until done!}			
        
			{we don't need to close the sprites manually, this is done by the windowlib}
                        CloseAWindow(w);
                END;
                CloseAScreen(s);
        END;
END;

BEGIN
        InitGraphics;
	SelfSeed;
        Demo;
	ExitGraphics;
END.
