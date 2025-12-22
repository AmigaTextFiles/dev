#drinc:exec/miscellaneous.g
#drinc:exec/memory.g
#drinc:exec/tasks.g
#drinc:exec/ports.g
#drinc:intuition/miscellaneous.g
#drinc:intuition/screen.g
#drinc:intuition/window.g
#drinc:intuition/intuiText.g
#drinc:intuition/image.g
#drinc:intuition/intuiMessage.g
#drinc:intuition/menu.g
#drinc:graphics/gfx.g
#drinc:graphics/rastport.g
#drinc:graphics/gels.g
#drinc:graphics/clip.g

/*
 * Sample Draco program showing simple use of Intuition and Graphics on the
 * Amiga. The parameters below can't really be changed, because of the things
 * that depend on them indirectly, like the initial window position, the
 * size of the image and Bob pictures, etc.
 */

uint
    BIT_PLANES = 2,
    SCREEN_WIDTH = 320,
    SCREEN_HEIGHT = 200;

IntuiText_t
    MODEL1 = IntuiText_t(0, 1, 0x0, 0, 1, nil, nil, nil),
    MODEL2 = IntuiText_t(1, 0, 0x0, 0, 1, nil, nil, nil);

*Screen_t Screen;
*Window_t Window;
*Menu_t MainMenu, AnimationMenu;
IntuiText_t It11, It12, It13, It21, It22, It23, It24, It25,
	    It111, It112, It221, It222,
	    ItA1, ItA2, ItA3;

/*
 * setupMenus -
 *	Create the two menu strips the program uses.
 *	Note that I'm cheating a bit by modifying the constant menu displays
 *	and relying on them all being different (and thus not made into a
 *	common one by the compiler). This commoning is why the IntuiText
 *	structures are global variables - they are all the same, but I need
 *	to put a different text pointer into each one.
 */

proc setupMenus()void:
    *MenuItem_t mi11, mi12, mi13, mi21, mi22, mi23, mi24, mi25,
		mi111, mi112, mi221, mi222,
		miA1, miA2, miA3;
    *Menu_t m1, m2;

    /* first, set up the main menu */

    mi25 := &MenuItem_t(
		nil, 0, 36, 49, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It25 := MODEL1;
    It25.it_IText := "Fill";
    mi25*.mi_ItemFill.miIt := &It25;
    mi24 := &MenuItem_t(
		nil, 0, 27, 49, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It24 := MODEL1;
    It24.it_IText := "Lines";
    mi24*.mi_ItemFill.miIt := &It24;
    mi24*.mi_NextItem := mi25;
    mi23 := &MenuItem_t(
		nil, 0, 18, 49, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It23 := MODEL1;
    It23.it_IText := "Pixels";
    mi23*.mi_ItemFill.miIt := &It23;
    mi23*.mi_NextItem := mi24;
    mi222 := &MenuItem_t(
		nil, 40, 9, 66, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It222 := MODEL1;
    It222.it_IText := "good-bye";
    mi222*.mi_ItemFill.miIt := &It222;
    mi221 := &MenuItem_t(
		nil, 40, 0, 66, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It221 := MODEL1;
    It221.it_IText := "hello";
    mi221*.mi_ItemFill.miIt := &It221;
    mi221*.mi_NextItem := mi222;
    mi22 := &MenuItem_t(
		nil, 0, 9, 49, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It22 := MODEL1;
    It22.it_IText := "Text";
    mi22*.mi_ItemFill.miIt := &It22;
    mi22*.mi_NextItem := mi23;
    mi22*.mi_SubItem := mi221;
    mi21 := &MenuItem_t(
		nil, 0, 0, 49, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It21 := MODEL1;
    It21.it_IText := "Image";
    mi21*.mi_ItemFill.miIt := &It21;
    mi21*.mi_NextItem := mi22;
    m2 := &Menu_t(nil, 64, 0, 50, 10, MENUENABLED, nil, nil, 0, 0, 0, 0);
    m2*.m_MenuName := "Things";
    m2*.m_FirstItem := mi21;
    mi13 := &MenuItem_t(
		nil, 0, 18, 74, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It13 := MODEL1;
    It13.it_IText := "Quit";
    mi13*.mi_ItemFill.miIt := &It13;
    mi12 := &MenuItem_t(
		nil, 0, 9, 74, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It12 := MODEL1;
    It12.it_IText := "Bounce";
    mi12*.mi_ItemFill.miIt := &It12;
    mi12*.mi_NextItem := mi13;
    mi112 := &MenuItem_t(
		nil, 72, 9, 50, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It112 := MODEL1;
    It112.it_IText := "screen";
    mi112*.mi_ItemFill.miIt := &It112;
    mi111 := &MenuItem_t(
		nil, 72, 0, 50, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It111 := MODEL1;
    It111.it_IText := "window";
    mi111*.mi_ItemFill.miIt := &It111;
    mi111*.mi_NextItem := mi112;
    mi11 := &MenuItem_t(
		nil, 0, 0, 74, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    It11 := MODEL1;
    It11.it_IText := "Animation";
    mi11*.mi_ItemFill.miIt := &It11;
    mi11*.mi_NextItem := mi12;
    mi11*.mi_SubItem := mi111;
    m1 := &Menu_t(nil, 0, 0, 58, 10, MENUENABLED, nil, nil, 0, 0, 0, 0);
    m1*.m_MenuName := "Project";
    m1*.m_FirstItem := mi11;
    m1*.m_NextMenu := m2;
    MainMenu := m1;

    /* now, set up the alternate menu used during animation */

    miA3 := &MenuItem_t(
		nil, 0, 18, 50, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    ItA3 := MODEL1;
    ItA3.it_IText := "Quit";
    miA3*.mi_ItemFill.miIt := &ItA3;
    miA2 := &MenuItem_t(
		nil, 0, 9, 50, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    ItA2 := MODEL1;
    ItA2.it_IText := "Slower";
    miA2*.mi_ItemFill.miIt := &ItA2;
    miA2*.mi_NextItem := miA3;
    miA1 := &MenuItem_t(
		nil, 0, 0, 50, 9,
		ITEMTEXT | ITEMENABLED | HIGHCOMP,
		0x0, (nil), (nil), ' ', nil, 0);
    ItA1 := MODEL1;
    ItA1.it_IText := "Faster";
    miA1*.mi_ItemFill.miIt := &ItA1;
    miA1*.mi_NextItem := miA2;
    m1 := &Menu_t(nil, 0, 0, 66, 10, MENUENABLED, nil, nil, 0, 0, 0, 0);
    m1*.m_MenuName := "Controls";
    m1*.m_FirstItem := miA1;
    AnimationMenu := m1;

corp;

/*
 * doAnimation -
 *	Do a little animation, just to show how its done. Waiting for the
 *	top of the frame each cycle is kind of slow, but even slower is the
 *	INTUITICKS signals (supposedly about 10 per second). The proper way
 *	is to set up a timer interrupt which repeats and sends us a signal
 *	every now and then.
 */

proc doAnimation(*RastPort_t rp)void:
    uint BOB_WIDTH = 32, BOB_HEIGHT = 32;
    /* we make these types so we can use constant displays */
    type
	bobMask_t = [BOB_HEIGHT * BOB_WIDTH / 32]ulong,
	bobImage_t = [2] bobMask_t;
    GelsInfo_t gelsInfo;
    VSprite_t headVSprite, tailVSprite, myVSprite;
    Bob_t myBob;
    *bobImage_t bobImage;
    *bobMask_t bobMask;
    *ViewPort_t viewPort;
    *IntuiMessage_t im;
    *MenuItem_t mi;
    ulong class;
    uint which, speed, width, height;
    bool quit, leftToRight, topToBottom, moved, switched;

    /* I hate all these 'pretend's but I don't see an alternative - I don't
       want to add a whole bunch of Amiga specific stuff to the language. */

    bobImage := pretend(AllocMem(sizeof(bobImage_t), MEMF_CHIP), *bobImage_t);
    bobMask := pretend(AllocMem(sizeof(bobMask_t), MEMF_CHIP), *bobMask_t);
    myBob.b_SaveBuffer :=
	pretend(AllocMem(sizeof(bobImage_t), MEMF_CHIP), *uint);
    myVSprite.vs_BorderLine :=
	pretend(AllocMem(BOB_WIDTH / 8, MEMF_CHIP), *uint);
    if bobImage ~= nil and bobMask ~= nil and myBob.b_SaveBuffer ~= nil and
	    myVSprite.vs_BorderLine ~= nil then

	/* I could have used array assignment here, but they insist in the
	   manuals that 'CopyMem' is real fast, so I'll use it (as if it
	   mattered! */

	CopyMem(pretend(&bobImage_t(
	       (0b11111111111111111111111111111111,
		0b01111111111111111111111111111110,
		0b00111111111111111111111111111100,
		0b00011111111111111111111111111000,
		0b00001111111111111111111111110000,
		0b10000111111111111111111111100001,
		0b11000011111111111111111111000011,
		0b11100001111111111111111110000111,
		0b11110000111111111111111100001111,
		0b11111000011111111111111000011111,
		0b11111100001111111111110000111111,
		0b01111110000000000000000001111110,
		0b00111111000000000000000011111100,
		0b00011111100000000000000111111000,
		0b00001111110000000000001111110000,
		0b10000111111000000000011111100001,
		0b11000011111000000000011111000011,
		0b11100001111000000000011110000111,
		0b11110000111000000000011100001111,
		0b11111000011000000000011000011111,
		0b11111100001000000000010000111111,
		0b01111110000111111111100001111110,
		0b00111111000011111111000011111100,
		0b00011111100001111110000111111000,
		0b00001111110000111100001111110000,
		0b10000111111000011000011111100001,
		0b11000011111100000000111111000011,
		0b11100001111110000001111110000111,
		0b11110000111111000011111100001111,
		0b11111000011111100111111000011111,
		0b11111100001111111111110000111111,
		0b01111110000111111111100001111110),

	       (0b01111110000111111111100001111110,
		0b11111100001111111111110000111111,
		0b11111000011111100111111000011111,
		0b11110000111111000011111100001111,
		0b11100001111110000001111110000111,
		0b11000011111100000000111111000011,
		0b10000111111000011000011111100001,
		0b00001111110000111100001111110000,
		0b00011111100001111110000111111000,
		0b00111111000011111111000011111100,
		0b01111110000111111111100001111110,
		0b11111100001000000000010000111111,
		0b11111000011000000000011000011111,
		0b11110000111000000000011100001111,
		0b11100001111000000000011110000111,
		0b11000011111000000000011111000011,
		0b10000111111000000000011111100001,
		0b00001111110000000000001111110000,
		0b00011111100000000000000111111000,
		0b00111111000000000000000011111100,
		0b01111110000000000000000001111110,
		0b11111100001111111111110000111111,
		0b11111000011111111111111000011111,
		0b11110000111111111111111100001111,
		0b11100001111111111111111110000111,
		0b11000011111111111111111111000011,
		0b10000111111111111111111111100001,
		0b00001111111111111111111111110000,
		0b00011111111111111111111111111000,
		0b00111111111111111111111111111100,
		0b01111111111111111111111111111110,
		0b11111111111111111111111111111111)),
		*byte),
	    pretend(bobImage, *byte),
	    sizeof(bobImage_t));

	/* I set up vs_CollMask and vs_BorderLine so I can just call
	   'InitMasks', even though I'm not doing any collision detection,
	   which is what those are for */

	myBob.b_BobVSprite := &myVSprite;
	myBob.b_ImageShadow := pretend(&bobMask*[0], *uint);
	myBob.b_Flags := 0;
	myBob.b_Before := nil;
	myBob.b_After := nil;
	myBob.b_DBuffer := nil;
	myVSprite.vs_VSBob := &myBob;
	myVSprite.vs_Height := BOB_HEIGHT;
	myVSprite.vs_Width := BOB_WIDTH / 16;
	myVSprite.vs_Depth := BIT_PLANES;
	myVSprite.vs_ImageData := pretend(&bobImage*[0][0], *uint);
	myVSprite.vs_CollMask := pretend(&bobMask*[0], *uint);
	myVSprite.vs_PlanePick := 0x3;
	myVSprite.vs_PlaneOnOff := 0x0;
	myVSprite.vs_Flags := SAVEBACK | OVERLAY;
	myVSprite.vs_NextVSprite := nil;
	myVSprite.vs_PrevVSprite := nil;
	myVSprite.vs_Y := 0;
	myVSprite.vs_X := 0;
	InitMasks(&myVSprite);

	viewPort := ViewPortAddress(Window);
	gelsInfo.gi_nextLine := nil;
	gelsInfo.gi_lastColor := nil;
	gelsInfo.gi_collHandler := nil;
	InitGels(&headVSprite, &tailVSprite, &gelsInfo);
	/* Note this absolutely vital assignment. It's not mentioned in the
	   chapter on animation, but is in the one on creating views and
	   viewports */
	rp*.rp_GelsInfo := &gelsInfo;
	AddBob(&myBob, rp);

	leftToRight := true;
	topToBottom := true;
	speed := 1;
	SetMenuStrip(Window, AnimationMenu);
	ModifyIDCMP(Window, MENUPICK | CLOSEWINDOW | INTUITICKS);
	quit := false;
	while not quit do
	    pretend(Wait(1 << Window*.w_UserPort*.mp_SigBit), void);
	    moved := false;
	    while
		im:= pretend(GetMsg(Window*.w_UserPort), *IntuiMessage_t);
		im ~= nil
	    do
		/* Again, as per the manual, we save what we need from the
		   message and reply to it right away, thus freeing up the
		   space it occupied */
		class := im*.im_Class;
		which := im*.im_Code;
		ReplyMsg(pretend(im, *Message_t));
		case class
		incase CLOSEWINDOW:
		    /* Note that here, as well as in the main menu processing,
		       I call ClearMenuStrip and continue with the inner
		       menu event handling loop. This ensures that I won't
		       lose a message which arrives after the quit message
		       but before the system has actually removed the menu */
		    quit := true;
		    ClearMenuStrip(Window);
		incase MENUPICK:
		    while which ~= MENUNULL do
			mi := ItemAddress(AnimationMenu, which);
			case MENUNUM(which)
			incase 0:
			    /* Controls */
			    case ITEMNUM(which)
			    incase 0:
				/* Faster */
				speed := speed * 2;
				/* Sigh; there doesn't seem to be a Layer
				   attached to the screen's RastPort */
				width :=
				    if rp*.rp_Layer = nil then
					SCREEN_WIDTH - BOB_WIDTH
				    else
					rp*.rp_Layer*.l_bounds.r_MaxX -
					rp*.rp_Layer*.l_bounds.r_MinX -
					BOB_WIDTH + 1
				    fi;
				if speed >= width then
				    speed := width - 1;
				fi;
			    incase 1:
				/* Slower */
				speed := speed / 2;
				if speed = 0 then
				    speed := 1;
				fi;
			    incase 2:
				/* Quit */
				quit := true;
				ClearMenuStrip(Window);
			    default:
				/* shouldn't get this */
			    esac;
			default:
			    /* shouldn't get this */
			esac;
			which := mi*.mi_NextSelect;
		    od;
		incase INTUITICKS:
		    /* clock has ticked - move the Bob */
		    if rp*.rp_Layer = nil then
			width := SCREEN_WIDTH - BOB_WIDTH;
			height := SCREEN_HEIGHT - BOB_HEIGHT;
		    else
			width := rp*.rp_Layer*.l_bounds.r_MaxX -
				 rp*.rp_Layer*.l_bounds.r_MinX - BOB_WIDTH + 1;
			height := rp*.rp_Layer*.l_bounds.r_MaxY -
				  rp*.rp_Layer*.l_bounds.r_MinY - BOB_HEIGHT+1;
		    fi;
		    switched := false;
		    if leftToRight then
			myVSprite.vs_X := myVSprite.vs_X + speed;
			if myVSprite.vs_X > width then
			    myVSprite.vs_X := width;
			    leftToRight := false;
			    switched := true;
			fi;
		    else
			if myVSprite.vs_X < speed then
			    myVSprite.vs_X := 0;
			    leftToRight := true;
			    switched := true;
			else
			    myVSprite.vs_X := myVSprite.vs_X - speed;
			fi;
		    fi;
		    if switched then
			if topToBottom then
			    myVSprite.vs_Y := myVSprite.vs_Y + 1;
			    if myVSprite.vs_Y = height then
				topToBottom := false;
			    fi;
			else
			    myVSprite.vs_Y := myVSprite.vs_Y - 1;
			    if myVSprite.vs_Y = 0 then
				topToBottom := true;
			    fi;
			fi;
		    fi;
		    moved := true;
		default:
		    /* shouldn't get this */
		esac;
	    od;
	    /* Following the advice given in the manual, this is separated
	       out so that I don't get behind in message handling */
	    if moved then
		SortGList(rp);
		WaitTOF();
		DrawGList(rp, viewPort);
	    fi;
	od;
	RemBob(&myBob, rp);
	SortGList(rp);
	DrawGList(rp, viewPort);
	ModifyIDCMP(Window, CLOSEWINDOW | MENUPICK);
	SetMenuStrip(Window, MainMenu);
    fi;
    if myVSprite.vs_BorderLine ~= nil then
	FreeMem(pretend(myVSprite.vs_BorderLine, *byte), BOB_WIDTH / 8);
    fi;
    if myBob.b_SaveBuffer ~= nil then
	FreeMem(pretend(myBob.b_SaveBuffer, *byte), sizeof(bobImage_t));
    fi;
    if bobMask ~= nil then
	FreeMem(pretend(bobMask, *byte), sizeof(bobMask_t));
    fi;
    if bobImage ~= nil then
	FreeMem(pretend(bobImage, *byte), sizeof(bobImage_t));
    fi;
corp;

/*
 * doit -
 *	After everything is set up, loop, handling menu selections and any
 *	other IDCMP messages (only CLOSEWINDOW enabled)
 */

proc doit()void:
    uint IMAGE_WIDTH = 32, IMAGE_HEIGHT = 32;
    type squareImage_t = [IMAGE_WIDTH * IMAGE_HEIGHT / 32]ulong;
    IntuiText_t it;
    *Image_t i;
    *IntuiMessage_t im;
    *MenuItem_t mi;
    ulong n;
    ulong class;
    uint which;
    bool quit;

    SetMenuStrip(Window, MainMenu);
    quit := false;
    while not quit do
	pretend(Wait(1 << Window*.w_UserPort*.mp_SigBit), void);
	while
	    im:= pretend(GetMsg(Window*.w_UserPort), *IntuiMessage_t);
	    im ~= nil
	do
	    class := im*.im_Class;
	    which := im*.im_Code;
	    ReplyMsg(pretend(im, *Message_t));
	    case class
	    incase CLOSEWINDOW:
		quit := true;
		ClearMenuStrip(Window);
	    incase MENUPICK:
		while which ~= MENUNULL do
		    mi := ItemAddress(MainMenu, which);
		    case MENUNUM(which)
		    incase 0:
			/* Project */
			case ITEMNUM(which)
			incase 0:
			    /* Animation */
			    case SUBNUM(which)
			    incase 0:
				/* window */
				doAnimation(Window*.w_RPort);
			    incase 1:
				/* screen */
				doAnimation(&Screen*.sc_RastPort);
			    default:
				/* shouldn't get this */
			    esac;
			incase 1:
			    /* Bounce */
			    for n from 1 upto SCREEN_HEIGHT - 10 do
				MoveScreen(Screen, 0, 1);
				WaitTOF();
			    od;
			    for n from 1 upto SCREEN_HEIGHT - 10 do
				MoveScreen(Screen, 0, -1);
				WaitTOF();
			    od;
			incase 2:
			    /* Quit */
			    quit := true;
			    ClearMenuStrip(Window);
			default:
			    /* shouldn't get this */
			esac;
		    incase 1:
			/* Things */
			case ITEMNUM(which)
			incase 0:
			    /* Image */
			    i :=
				&Image_t(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT,
					 BIT_PLANES, nil, 0x2, 0x1, nil);
			    i*.i_ImageData :=
				pretend(AllocMem(sizeof(squareImage_t),
					 MEMF_CHIP), *uint);
			    if i*.i_ImageData ~= nil then
				CopyMem(pretend(&squareImage_t(
					0b10000000000000000000000000000001,
					0b11100000000000000000000000000111,
					0b11111000000000000000000000011111,
					0b11111110000000000000000001111111,
					0b00111111100000000000000111111100,
					0b00001111111000000000011111110000,
					0b00000011111110000001111111000000,
					0b00000000111111100111111100000000,
					0b00000000001111111111110000000000,
					0b00000000000011111111000000000000,
					0b00000000000000111100000000000000,
					0b00000000000000000000000000000000,
					0b00000000000000000000000000000000,
					0b00110011001100110011001100110011,
					0b01100110011001100110011001100110,
					0b11001100110011001100110011001100,
					0b01100110011001100110011001100110,
					0b00110011001100110011001100110011,
					0b00000000000000000000000000000000,
					0b00000000000000000000000000000000,
					0b01111111111111111111111111111110,
					0b00011111111111111111111111111000,
					0b00000111111111111111111111100000,
					0b00000001111111111111111110000000,
					0b00000000011111111111111000000000,
					0b00000000000111111111100000000000,
					0b00000000000001111110000000000000,
					0b00000000000000011000000000000000,
					0b00000000000000000000000000000000,
					0b00000000000000000000000000000000,
					0b11111111111111111111111111111111,
					0b11111111111111111111111111111111),
					*byte),
				    pretend(i*.i_ImageData, *byte),
				    sizeof(squareImage_t));
				DrawImage(Window*.w_RPort, i, 50, 30);
				FreeMem(pretend(i*.i_ImageData, *byte),
					sizeof(squareImage_t));
			    fi;
			incase 1:
			    /* Text */
			    case SUBNUM(which)
			    incase 0:
				/* hello */
				it := MODEL2;
				it.it_IText := "hello";
				PrintIText(Window*.w_RPort, &it, 25, 15);
			    incase 1:
				/* good-bye */
				it := MODEL2;
				it.it_IText := "good-bye";
				PrintIText(Window*.w_RPort, &it, 25, 65);
			    default:
				/* shouldn't get this */
			    esac;
			incase 2:
			    /* Pixels */
			    for n from 0 upto 16 do
				SetAPen(Window*.w_RPort, n % 3 + 1);
				pretend(
				    WritePixel(Window*.w_RPort, n * n, n * 10),
				    void);
			    od;
			    SetAPen(Window*.w_RPort, 1);
			incase 3:
			    /* Lines */
			    for n from 0 upto 18 do
				SetAPen(Window*.w_RPort, n % 3 + 1);
				Move(Window*.w_RPort, 12, 12);
				Draw(Window*.w_RPort, 300, 12 + 10 * n);
			    od;
			    SetAPen(Window*.w_RPort, 1);
			incase 4:
			    /* Fill */
			    SetAPen(Window*.w_RPort, 2);
			    SetBPen(Window*.w_RPort, 3);
			    RectFill(Window*.w_RPort, 20, 100, 300, 180);
			default:
			    /* shouldn't get this */
			esac;
		    default:
			/* shouldn't get this */
		    esac;
		    which := mi*.mi_NextSelect;
		od;
	    default:
		/* shouldn't get this */
	    esac;
	od;
    od;
corp;

proc main()void:
    type
	pointer_t = [22]uint,
	pattern_t = [2]uint;
    *NewScreen_t ns;
    *NewWindow_t nw;
    *uint pointer, pattern;

    /* The C technique of calling a cleanup routine on any failure, and having
       it free everything up via checking global variables, could have been
       used here, but I didn't nest TOO deep did I? (Also, given that Draco
       doesn't initialize global variables to anything, it would have
       required assignments to everything at the beginning.) */

    if OpenIntuitionLibrary(0) ~= nil then
	if OpenExecLibrary(0) ~= nil then
	    if OpenGraphicsLibrary(0) ~= nil then
		ns := &NewScreen_t(
		    0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, BIT_PLANES,
		    0, 1, 0x0, CUSTOMSCREEN, nil, nil, nil, nil);
		ns*.ns_DefaultTitle := "My Test Screen";
		Screen := OpenScreen(ns);
		if Screen ~= nil then
		    nw := &NewWindow_t(
			100, 50, 200, 100, FREEPEN, FREEPEN,
			CLOSEWINDOW | MENUPICK,
			SMART_REFRESH | ACTIVATE | WINDOWSIZING | SIZEBRIGHT |
			    WINDOWDEPTH | WINDOWCLOSE | WINDOWDRAG |
			    NOCAREREFRESH,
			nil, nil, nil, nil, nil, 40, 33, /* room for Bob */
			SCREEN_WIDTH, SCREEN_HEIGHT, CUSTOMSCREEN);
		    nw*.nw_Title := "My Test Window";
		    nw*.nw_Screen := Screen;
		    Window := OpenWindow(nw);
		    if Window ~= nil then
			pointer := pretend(
			    AllocMem(sizeof(pointer_t), MEMF_CHIP), *uint);
			if pointer ~= nil then
			    CopyMem(pretend(&pointer_t(
					0x0000, 0x0000,
					0xc180, 0x4100,
					0x6380, 0xa280,
					0x3700, 0x5500,
					0x1600, 0x2200,
					0x0000, 0x0000,
					0x1600, 0x2200,
					0x2300, 0x5500,
					0x4180, 0xa280,
					0x8080, 0x4100,
					0x0000, 0x0000), *byte),
				    pretend(pointer, *byte),
				    sizeof(pointer_t));
			    SetPointer(Window, pointer, 9, 9, -5, -4);
			    pattern := pretend(
				AllocMem(sizeof(pattern_t), MEMF_CHIP), *uint);
			    if pattern ~= nil then
				CopyMem(pretend(&pattern_t(
					    0xaaaa,
					    0x5555), *byte),
					pretend(pattern, *byte),
					sizeof(pattern_t));
				SetAfPt(Window*.w_RPort, pattern, 1);
				setupMenus();
				doit();
				FreeMem(pretend(pattern, *byte),
					sizeof(pattern_t));
			    fi;
			    FreeMem(pretend(pointer, *byte),
				    sizeof(pointer_t));
			fi;
			CloseWindow(Window);
		    fi;
		    CloseScreen(Screen);
		fi;
		CloseGraphicsLibrary();
	    fi;
	    CloseExecLibrary();
	fi;
	CloseIntuitionLibrary();
    fi;
corp;
