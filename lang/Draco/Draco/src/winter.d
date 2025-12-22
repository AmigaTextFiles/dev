#drinc:exec/miscellaneous.g
#drinc:exec/ports.g
#drinc:exec/tasks.g
#drinc:intuition/miscellaneous.g
#drinc:intuition/intuitionbase.g
#drinc:intuition/screen.g
#drinc:intuition/window.g
#drinc:graphics/gfx.g
#drinc:graphics/view.g
#drinc:graphics/rastport.g
#drinc:libraries/dos.g
#drinc:libraries/dosextens.g
#drinc:libraries/layers.g

/*
 * Winter - a small display hack by Chris Gray - October 17, 1987.
 */

uint
    MAX_FLAKES = 200,				/* size of flake array */
    MAX_TRIES = 100,				/* search for empty spot */
    TITLE_HEIGHT = 10,				/* snow below title bars */
    STICK_PERCENT = 5;				/* percent that stick */

ulong HI_PRIORITY = +127;

type Flake_t = struct {
    *Flake_t fl_prev, fl_next;
    uint fl_x, fl_y;
};

uint Seed;					/* for random number gen. */

[MAX_FLAKES] Flake_t Flake;
*Flake_t FreeFlakes, FlakeHead, FlakeTail;

*IntuitionBase_t IntuitionBase; 		/* needed for checking */
*Task_t ThisTask;				/* so we can use SetTaskPri */
ulong IBaseLock;				/* held when 'snow' returns */

/*
 * random - return a random number 0 - passed range.
 */

proc random(uint rang)uint:

    if rang = 0 then
	0
    else
	Seed := Seed * 17137 + 4287;
	Seed := (Seed >> 8) >< (Seed << 8);
	Seed % rang
    fi
corp;

/*
 * initFlakes - intialize the Flake array to be all free flakes.
 */

proc initFlakes()void:
    register uint i;

    for i from 0 upto MAX_FLAKES - 1 do
	Flake[i].fl_next := &Flake[i + 1];
    od;
    Flake[MAX_FLAKES - 1].fl_next := nil;
    FreeFlakes := &Flake[0];
    FlakeHead := nil;
    FlakeTail := nil;
corp;

/*
 * addFlake - make a new flake at the given position.
 */

proc addFlake(uint x, y)void:
    register *Flake_t fl;

    fl := FreeFlakes;
    if fl ~= nil then
	FreeFlakes := fl*.fl_next;
	fl*.fl_x := x;
	fl*.fl_y := y;
	fl*.fl_next := nil;
	fl*.fl_prev := FlakeTail;
	if FlakeTail = nil then
	    FlakeHead := fl;
	else
	    FlakeTail*.fl_next := fl;
	fi;
	FlakeTail := fl;
    fi;
corp;

/*
 * deleteFlake - delete a flake that has died, etc.
 */

proc deleteFlake(register *Flake_t fl)*Flake_t:
    register *Flake_t t;

    t := fl;
    fl := t*.fl_next;
    if fl = nil then
	FlakeTail := t*.fl_prev;
    else
	fl*.fl_prev := t*.fl_prev;
    fi;
    if t*.fl_prev = nil then
	FlakeHead := fl;
    else
	t*.fl_prev*.fl_next := fl;
    fi;
    t*.fl_next := FreeFlakes;
    FreeFlakes := t;
    fl
corp;

/*
 * cloneRastPort - make a copy of a RastPort_t, but one that has all of its
 *	modes, etc. default values.
 */

proc cloneRastPort(*RastPort_t rpOld, rpNew)void:

    rpNew* := rpOld*;
    SetDrMd(rpNew, JAM1);
    SetDrPt(rpNew, 0xffff);
    SetWrMsk(rpNew, 0xff);
corp;

/*
 * snow - everything is fine - make it snow. Return 'true' if we filled up
 *	the window, 'false' if it has gone away on us.
 */

proc snow(*Window_t window; ushort colour)bool:
    RastPort_t rastPort;
    register *Flake_t fl;
    register *Screen_t sc;
    register *Window_t w;
    register uint x, y, newX;
    ulong oldPriority;
    uint width, height, flakeCount, r, newY, oldColour;
    bool first, foundWindow, flakeGone;

    /* we want WHITE snowflakes, but be nice and put it back when done. */

    oldColour := GetRGB4(window*.w_WScreen*.sc_ViewPort.vp_ColorMap, colour);
    SetRGB4(&window*.w_WScreen*.sc_ViewPort, colour, 0xf, 0xf, 0xf);

    flakeCount := 0;
    first := true;

    /* NOTE: we enter this loop with IntuitionBase locked */

    while
	foundWindow := false;
	sc := IntuitionBase*.ib_FirstScreen;
	while sc ~= nil do
	    w := sc*.sc_FirstWindow;
	    while w ~= nil do
		if w = window then
		    foundWindow := true;
		fi;
		w := w*.w_NextWindow;
	    od;
	    sc := sc*.sc_NextScreen;
	od;
	(flakeCount ~= 0 or first) and foundWindow
    do
	first := false;
	cloneRastPort(window*.w_RPort, &rastPort);

	/* The following four lines seem to be about the only way I can be
	   sure the window is still there, but lock it's layer so that the
	   size of it can't be changed while I'm playing with it. Trapping
	   'CloseWindow' calls may not work, since the WorkBench and other
	   internal window handlers (console device?) may not go through
	   the library vector. */

	oldPriority := SetTaskPri(ThisTask, HI_PRIORITY);
	UnlockIBase(IBaseLock);
	LockLayer(0, rastPort.rp_Layer);
	ignore SetTaskPri(ThisTask, oldPriority);

	width := window*.w_Width - 1;
	height := window*.w_Height - 1;

	/* loop through all the flakes currently falling */

	fl := FlakeHead;
	while fl ~= nil do
	    x := fl*.fl_x;
	    y := fl*.fl_y;

	    /* Remember, the window could have shrunk since we last looked at
	       this flake. */

	    if x > width or y >= height then
		fl := deleteFlake(fl);
		flakeCount := flakeCount - 1;
	    else
		newX := x;
		if x = 0 then
		    if random(3) = 0 then
			newX := x + 1;
		    fi;
		elif x = width then
		    if random(3) = 0 then
			newX := x - 1;
		    fi;
		else
		    r := random(4);
		    if r = 0 then
			newX := x - 1;
		    elif r = 1 then
			newX := x + 1;
		    fi;
		fi;
		newY := y + 1;
		flakeGone := false;
		if ReadPixel(&rastPort, newX, newY) ~= 0 then
		    if random(100) < STICK_PERCENT then
			flakeGone := true;
		    elif ReadPixel(&rastPort, x, newY) = 0 then
			newX := x;
		    elif x ~= 0 and ReadPixel(&rastPort, x - 1, newY) = 0 then
			newX := x - 1;		/* bias!!! */
		    elif x ~= width and
			ReadPixel(&rastPort, x + 1, newY) = 0
		    then
			newX := x + 1;
		    else
			flakeGone := true;
		    fi;
		fi;
		if flakeGone then
		    /* nowhere for the flake to go - just leave it here */
		    fl := deleteFlake(fl);
		    flakeCount := flakeCount - 1;
		else
		    /* move the flake */
		    SetAPen(&rastPort, 0);
		    ignore WritePixel(&rastPort, x, y);
		    SetAPen(&rastPort, colour);
		    ignore WritePixel(&rastPort, newX, newY);
		    fl*.fl_x := newX;
		    fl*.fl_y := newY;
		    fl := fl*.fl_next;
		fi;
	    fi;
	od;

	/* make a new flake if we are below our desired count */

	if flakeCount < make(width, ulong) * height / 200 and FreeFlakes ~= nil
	then
	    y := 0;
	    while
		x := random(width - 1) + 1;
		ReadPixel(&rastPort, x, TITLE_HEIGHT) ~= 0 and y ~= MAX_TRIES
	    do
		y := y + 1;
	    od;
	    if y ~= MAX_TRIES then
		SetAPen(&rastPort, colour);
		ignore WritePixel(&rastPort, x, TITLE_HEIGHT);
		addFlake(x, TITLE_HEIGHT);
		flakeCount := flakeCount + 1;
	    fi;
	fi;

	UnlockLayer(rastPort.rp_Layer);
	Delay(1);		/* let others at IntuitionBase */
	IBaseLock := LockIBase(0);

    od;

    /* clean up in case we exited because our window went away */

    fl := FlakeHead;
    while fl ~= nil do
	fl := deleteFlake(fl);
    od;

    if foundWindow then
	/* restore the snowflake colour */
	SetRGB4(&window*.w_WScreen*.sc_ViewPort, colour,
		(oldColour >> 8) & 0xf,
		(oldColour >> 4) & 0xf,
		oldColour & 0xf);
    fi;

    /* note: this return result is valid since we still have IntuitionBase
       locked */

    foundWindow
corp;

/*
 * trySnowing - return 0 if we cannot snow in this window for some reason.
 *		If we can snow, return the pen colour to use for flakes.
 */

proc trySnowing(register *Window_t window)ushort:
    register *RastPort_t rastPort;
    *Layer_t layer;
    *Screen_t screen;
    *BitMap_t bitMap;
    register *ColorMap_t colorMap;
    register uint i, x, count;
    uint depth, whitest;
    ushort colour;

    /* if we changed this testing a bit, we could snow on the WorkBench's
       backdrop instead of inside its windows */

    rastPort := window*.w_RPort;
    if rastPort = nil or window*.w_Flags & BACKDROP ~= 0 then
	0
    else
	bitMap := rastPort*.rp_BitMap;
	layer := rastPort*.rp_Layer;
	if bitMap = nil or layer = nil then
	    0
	else
	    screen := window*.w_WScreen;
	    depth := bitMap*.bm_Depth;
	    if screen = nil or depth = 0 then
		0
	    else
		colorMap := screen*.sc_ViewPort.vp_ColorMap;
		if colorMap = nil then
		    0
		else
		    count := colorMap*.cm_Count;
		    if count <= 1 then
			0
		    else

			/* don't snow using the background colour */

			if count > 1 << depth then
			    count := 1 << depth;
			fi;
			whitest := 1;
			for i from 1 upto count - 1 do
			    x := GetRGB4(colorMap, i);
			    x := (x >> 8) & 0xf + (x >> 4) & 0xf + x & 0xf;
			    if x > whitest then
				whitest := x;
				colour := i;
			    fi;
			od;
			i := 0;
			while
			    x := random(window*.w_Width - 2) + 1;
			    ReadPixel(rastPort, x, TITLE_HEIGHT) ~= 0 and
				i ~= MAX_TRIES
			do
			    i := i + 1;
			od;
			if i = MAX_TRIES then
			    0
			else
			    colour
			fi
		    fi
		fi
	    fi
	fi
    fi
corp;

/*
 * main - open libraries, handle WorkBench, chase windows.
 */

proc main()void:
    *char MESSAGE =
	"Please use 'Run' to run this program in the background.\n";
    uint MESSAGE_LENGTH = 56;
    register *Screen_t screen;
    register *Window_t window;
    *Process_t thisProcess;
    *Message_t wbMessage;
    DateStamp_t ds;
    ushort colour;
    bool foundOne, fromWorkBench, abort;

    if OpenExecLibrary(0) ~= nil then
	IntuitionBase := OpenIntuitionLibrary(0);
	if IntuitionBase ~= nil then
	    if OpenGraphicsLibrary(0) ~= nil then
		if OpenDosLibrary(0) ~= nil then
		    if OpenLayersLibrary(0) ~= nil then
			abort := false;
			ThisTask := FindTask(nil);
			thisProcess := pretend(ThisTask, *Process_t);
			if thisProcess*.pr_CLI = 0 then
			    /* running from WorkBench */
			    fromWorkBench := true;
			    wbMessage := WaitPort(&thisProcess*.pr_MsgPort);
			    wbMessage := GetMsg(&thisProcess*.pr_MsgPort);
			else
			    /* running from CLI */
			    fromWorkBench := false;
			    if IsInteractive(Input()) then
				ignore Write(Output(), MESSAGE,MESSAGE_LENGTH);
				abort := true;
			    fi;
			fi;

			if not abort then
			    DateStamp(&ds);
			    Seed := (ds.ds_Minute >< ds.ds_Tick) | 1;
			    initFlakes();

			    IBaseLock := LockIBase(0);
			    while
				foundOne := false;
				screen := IntuitionBase*.ib_FirstScreen;
				while screen ~= nil do
				    window := screen*.sc_FirstWindow;
				    while window ~= nil do
					colour := trySnowing(window);
					if colour ~= 0 then
					    foundOne := true;
					    if snow(window, colour) then
						window := window*.w_NextWindow;
					    else
						/* rescan at first screen */
						screen := nil;
						window := nil;
					    fi;
					else
					    window := window*.w_NextWindow;
					fi;
				    od;
				    if screen ~= nil then
					screen := screen*.sc_NextScreen;
				    fi;
				od;
				foundOne
			    do
			    od;
			    UnlockIBase(IBaseLock);
			fi;

			if fromWorkBench then

			    /* this is pretty hokey, but this is what the
			       example in the RKM has. There is no matching
			       'Permit' for the 'Forbid'. I will assume that
			       when this task exits, the 'Permit' will
			       magically happen. */

			    Forbid();
			    ReplyMsg(wbMessage);
			fi;

			CloseLayersLibrary();
		    fi;
		    CloseDosLibrary();
		fi;
		CloseGraphicsLibrary();
	    fi;
	    CloseIntuitionLibrary();
	fi;
	CloseExecLibrary();
    fi;
corp;
