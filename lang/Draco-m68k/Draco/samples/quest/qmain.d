#drinc:util.g
#q.g

/* a data structure we need to keep track of where we've dropped things: */

type
    ContentsList_t = struct {
	*ContentsList_t cl_next;
	long cl_line, cl_column;
	*List_t cl_contents;
    };

/* codes for the types of words in a sentence: */

Id_t
    VERB = 1,
    ARTICLE = 2,
    ADJECTIVE = 3,
    NOUN = 4,
    PREPOSITION = 5,
    PUNCTUATION = 6,
    AUXILLIARY = 7,

/* id's for some words that we need to know: */

    /* verbs: */

    NORTH = 1001,
    SOUTH = 1002,
    EAST = 1003,
    WEST = 1004,
    QUIT = 1005,
    DROP = 1006,
    PUT = 1007,
    GET = 1008,
    PICK = 1009,
    LOOK = 1010,
    LONG = 1011,
    DUMP = 1012,

    /* articles: */

    THE = 2001,

    /* adjectives: */

    /* nouns: */

    SWORD = 4001,
    BOTTLE = 4002,
    KNIFE = 4003,
    PURSE = 4004,
    AMULET = 4005,

    /* prepositions: */

    /* punctuation: */

    PERIOD = 6001,

    /* auxilliaries: */

    DOWN = 7001,
    UP = 7002,
    AROUND = 7003,

    /* some properties and attributes we need: */

    CARRYABLE = 8002;		/* object can be carried */

channel output text TextOut;
long PlayerLine, PlayerColumn, MoveCount;
*List_t CarryList, CarryNext;
*ContentsList_t Contents;
*char Condition;
bool Quit;

/*
 * scenery - simple scenery generator.
 */

proc scenery(long l, c)C2:
    long l1, c1;

    l1 := |l % 30;
    if l1 >= 15 then l1 := l1 - 30 fi;
    c1 := |c % 30;
    if c1 >= 15 then c1 := c1 - 30 fi;
    if l1 * l1 + c1 * c1 <= 16 or l1 = 0 or c1 = 0 then
	C2('~', '~')
    elif l1 * l1 + c1 * c1 <= 25 then
	C2('\#', '\#')
    else
	l := l * 997 + c + 10321;
	l := l * l;
	if l / 32 % 8 = 0 then
	    C2('/', '\\')
	else
	    C2(' ', ' ')
	fi
    fi
corp;

/*
 * findCList - find the contents list for the given location.
 */

proc findCList(long line, column)*ContentsList_t:
    *ContentsList_t cl;

    cl := Contents;
    while cl ~= nil and (cl*.cl_line ~= line or cl*.cl_column ~= column) do
	cl := cl*.cl_next;
    od;
    cl
corp;

/*
 * findContents - return the actual contents of a location.
 */

proc findContents(long line, column)*List_t:
    *ContentsList_t cl;

    cl := findCList(line, column);
    if cl = nil then
	nil
    else
	cl*.cl_contents
    fi
corp;

/*
 * addContents - add a contents list for the given location, if not there.
 */

proc addContents(long line, column)**List_t:
    *ContentsList_t cl;

    cl := findCList(line, column);
    if cl = nil then
	cl := new(ContentsList_t);
	cl*.cl_next := Contents;
	cl*.cl_line := line;
	cl*.cl_column := column;
	cl*.cl_contents := nil;
	Contents := cl;
    fi;
    &cl*.cl_contents
corp;

/*
 * termContents - clean up all the contents stuff.
 */

proc termContents()void:
    *ContentsList_t cl;

    while Contents ~= nil do
	cl := Contents;
	Contents := cl*.cl_next;
	lFree(cl*.cl_contents);
	free(cl);
    od;
corp;

/*
 * lookAround - list the objects at this location.
 */

proc lookAround()bool:
    *List_t il;

    il := findContents(PlayerLine, PlayerColumn);
    if il ~= nil then
	write(TextOut; "Nearby: ");
	while il ~= nil do
	    write(TextOut; psGet(il*.il_this));
	    il := il*.il_next;
	    if il ~= nil then
		write(TextOut; ", ");
	    fi;
	od;
	true
    else
	false
    fi
corp;

/*
 * move - move our character in the given relative direction.
 */

proc move(long lineDelta, columnDelta)void:
    char ch;

    ch := scAt(PlayerLine + lineDelta, PlayerColumn + columnDelta)[0];
    if ch = '\#' or ch = '/' or ch = 'T' then
	write(TextOut; "You can't move there.");
	Condition := "Dazed";
	scUpdate(4);
    else
	PlayerLine := PlayerLine + lineDelta;
	PlayerColumn := PlayerColumn + columnDelta;
	scMove(0, PlayerLine, PlayerColumn);
	MoveCount := MoveCount + 1;
	scUpdate(3);
	if Condition* ~= 'H' then
	    if Condition* = 'D' then
		Condition := "Bruised";
	    else
		Condition := "Healthy";
	    fi;
	    scUpdate(4);
	fi;
	if lookAround() then fi;
    fi;
corp;

/*
 * gramInit - set up our dictionary and grammar.
 */

proc gramInit()void:

    psWord(NORTH, "north", VERB);
    psWord(SOUTH, "south", VERB);
    psWord(EAST, "east", VERB);
    psWord(WEST, "west", VERB);
    psWord(NORTH, "n", VERB);
    psWord(SOUTH, "s", VERB);
    psWord(EAST, "e", VERB);
    psWord(WEST, "w", VERB);
    psWord(QUIT, "quit", VERB);
    psWord(DROP, "drop", VERB);
    psWord(PUT, "put", VERB);
    psWord(GET, "get", VERB);
    psWord(PICK, "pick", VERB);
    psWord(LOOK, "look", VERB);
    psWord(LONG, "long", VERB);
    psWord(DUMP, "dump", VERB);

    psWord(THE, "the", ARTICLE);
    psWord(THE, "a", ARTICLE);
    psWord(THE, "an", ARTICLE);
    psWord(THE, "one", ARTICLE);

    psWord(SWORD, "sword", NOUN);
    psWord(BOTTLE, "bottle", NOUN);
    psWord(KNIFE, "knife", NOUN);
    psWord(PURSE, "purse", NOUN);
    psWord(AMULET, "amulet", NOUN);

    psWord(PERIOD, ".", PUNCTUATION);
    psWord(PERIOD, "!", PUNCTUATION);

    psWord(DOWN, "down", AUXILLIARY);
    psWord(UP, "up", AUXILLIARY);
    psWord(AROUND, "around", AUXILLIARY);

    /* rule #1 - look [around] */

    psgBegin(1);
    psgWord(f_reqId, LOOK);
    psgWord(f_optId, AROUND);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();

    /* rule #2 - drop [ART] N */

    psgBegin(2);
    psgWord(f_reqId, DROP);
    psgWord(f_optType, ARTICLE);
    psgWord(f_reqType, NOUN);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();

    /* rule #3 - put down [ART] N */

    psgBegin(3);
    psgWord(f_reqId, PUT);
    psgWord(f_reqId, DOWN);
    psgWord(f_optType, ARTICLE);
    psgWord(f_reqType, NOUN);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();

    /* rule #4 - put [ART] N down */

    psgBegin(4);
    psgWord(f_reqId, PUT);
    psgWord(f_optType, ARTICLE);
    psgWord(f_reqType, NOUN);
    psgWord(f_reqId, DOWN);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();

    /* rule #5 - get [ART] N */

    psgBegin(5);
    psgWord(f_reqId, GET);
    psgWord(f_optType, ARTICLE);
    psgWord(f_reqType, NOUN);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();

    /* rule #6 - pick up [ART] N */

    psgBegin(6);
    psgWord(f_reqId, PICK);
    psgWord(f_reqId, UP);
    psgWord(f_optType, ARTICLE);
    psgWord(f_reqType, NOUN);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();

    /* rule #7 - pick [ART] N up */

    psgBegin(7);
    psgWord(f_reqId, PICK);
    psgWord(f_optType, ARTICLE);
    psgWord(f_reqType, NOUN);
    psgWord(f_reqId, UP);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();

    /* rule #8 - V */

    psgBegin(8);
    psgWord(f_reqType, VERB);
    psgWord(f_optType, PUNCTUATION);
    psgEnd();
corp;

/*
 * getObjectC2 - return the C2 for the given object:
 */

proc getObjectC2(Id_t id)C2:

    case id
    incase SWORD:
	C2('s', 'w')
    incase BOTTLE:
	C2('b', 'o')
    incase KNIFE:
	C2('k', 'n')
    incase PURSE:
	C2('p', 'u')
    incase AMULET:
	C2('a', 'm')
    default:
	C2('?', '?')
    esac
corp;

/*
 * carryInit - initialize our list of what we are carrying.
 */

proc carryInit()void:

    Contents := nil;
    CarryList := nil;
    lAppend(&CarryList, SWORD);
    lAppend(&CarryList, BOTTLE);
    lAppend(&CarryList, KNIFE);
    lAppend(&CarryList, PURSE);
    lAppend(&CarryList, AMULET);
corp;

/*
 * carryScan - scanner routine for carry list display.
 */

proc carryScan(bool first)*char:
    Id_t id;

    if first then
	CarryNext := CarryList;
    fi;
    if CarryNext = nil then
	nil
    else
	id := CarryNext*.il_this;
	CarryNext := CarryNext*.il_next;
	psGet(id)
    fi
corp;

/*
 * statInit - initialize and set up our status indicators.
 */

proc statInit()void:

    PlayerLine := 0;
    PlayerColumn := 0;
    MoveCount := 0;
    Condition := "Healthy";
    scNumber(1, "Line", 1, 1, 4, &PlayerLine);
    scNumber(2, "Column", 1, 13, 4, &PlayerColumn);
    scNumber(3, "Moves", 2, 1, 3, &MoveCount);
    scString(4, "Condition", 2, 13, 10, &Condition);
    scMult(5, "Carrying", 3, 1, 3, carryScan);
corp;

/*
 * kindName - turn a word type code into a string for _psDump.
 */

proc kindName(Id_t kind)*char:

    case kind
    incase VERB:
	"VERB"
    incase ARTICLE:
	"ARTICLE"
    incase ADJECTIVE:
	"ADJECTIVE"
    incase NOUN:
	"NOUN"
    incase PREPOSITION:
	"PREPOSITION"
    incase PUNCTUATION:
	"PUNCTUATION"
    incase AUXILLIARY:
	"AUXILLIARY"
    default:
	"???"
    esac
corp;

/*
 * verbOnly - process a verb only input command.
 */

proc verbOnly()void:
    extern
	_psDump(channel output text chout;
		proc(Id_t kind)*char kindName)void;
    ulong id;

    id := pspWord(1);
    case id
    incase NORTH:
	move(-1, 0);
	scUpdate(1);
    incase SOUTH:
	move(+1, 0);
	scUpdate(1);
    incase EAST:
	move(0, +1);
	scUpdate(2);
    incase WEST:
	move(0, -1);
	scUpdate(2);
    incase QUIT:
	Quit := true;
    incase LONG:
	write(TextOut;
"This is a very long set of output that the program is told to output when "
"you type in the word 'long'.  This output doesn't have a whole lot of "
"significance or intelligence or meaning or whatever, but what the heck, "
"I just wanted to get something that would make more than one line of "
"output go through the TextOut channel to the screen's text area."
	);
    incase DUMP:
	_psDump(TextOut, kindName);
    default:
	write(TextOut; "You must give an object with verb \"",
		       psGet(id), "\".");
    esac;
corp;

/*
 * drop - drop something.
 */

proc drop(uint pos)void:
    Id_t id;

    id := pspWord(pos);
    if lIn(CarryList, id) then
	/* player is carrying it, so delete it from the carrying list: */
	lDelete(&CarryList, id);
	/* request that the list on the screen be updated: */
	scUpdate(5);
	/* now we add it to the contents list for this location: */
	lAppend(addContents(PlayerLine, PlayerColumn), id);
	/* now we display the object on the map, but re-move the player on
	   top of it so that it is hidden "underneath" the 'me': */
	scNew(id, PlayerLine, PlayerColumn, getObjectC2(id));
	scMove(0, PlayerLine, PlayerColumn);
	write(TextOut; "Dropped.");
    else
	write(TextOut; "You aren't carrying any ", psGet(id), '.');
    fi;
corp;

/*
 * get - get something.
 */

proc get(uint pos)void:
    *ContentsList_t cl;
    Id_t id;

    id := pspWord(pos);
    cl := findCList(PlayerLine, PlayerColumn);
    if lIn(cl*.cl_contents, id) then
	/* the object is here; delete it from that contents, add it to our
	   carrying list, and request an update of the list on screen: */
	lDelete(&cl*.cl_contents, id);
	lAppend(&CarryList, id);
	scUpdate(5);
	scDelete(id);
	/* note: we leave the contents list hanging around, but it may get
	   used again, and anyway, we'll kill it on termination. */
	write(TextOut; "Taken.");
    else
	write(TextOut; "There is no ", psGet(id), " here.");
    fi;
corp;

/*
 * process - process user's commands.
 */

proc process()void:
    [79] char buffer;
    *char p;

    Quit := false;
    while not Quit do
	scRead(&buffer[0]);
	p := &buffer[0];
	while p* = ' ' or p* = '\t' do
	    p := p + 1;
	od;
	if p* ~= '\e' then
	    case psParse(&buffer[0])
	    incase PS_ERROR:
		write(TextOut; "I don't know the word \"", pspBad(), "\".");
	    incase PS_NONE:
		write(TextOut; "I don't understand that sentence.");
	    incase 1:
		if not lookAround() then
		    write(TextOut; "There is nothing here.");
		fi;
	    incase 2:
	    incase 4:
		drop(3);
	    incase 3:
		drop(4);
	    incase 5:
	    incase 7:
		get(3);
	    incase 6:
		get(4);
	    incase 8:
		verbOnly();
	    default:
		write(TextOut; "Can't possibly get this!");
	    esac;
	fi;
    od;
corp;

/*
 * main - main program - the action starts here.
 */

proc main()void:
    *byte dummy;

    /* set up the various library routine sets: */
    scInit();
    psInit(false);
    lInit();
    /* open a text output channel through the screen output routine: */
    open(TextOut, scPut);
    /* pass a scenery generator and empty object list for map: */
    dummy := scNewMap(scenery, nil);
    /* define the initial viewing window for the map area: */
    scWindow(0, 0);
    /* define the input prompt: */
    scPrompt("> ");
    /* go build our dictionary and grammar: */
    gramInit();
    /* go set up our carrying list: */
    carryInit();
    /* go initialize and set up our status indicators: */
    statInit();
    /* set up the 'objects' in the viewing area: */
    scNew(0,  0,  0, C2('m', 'e'));	/* this is 'us', the key character */
    scNew(1, -2, -2, C2('T', '1'));
    scNew(2, -3, -8, C2('T', '2'));
    scNew(3, -1, +3, C2('T', '3'));
    scNew(4, +3, +2, C2('G', '1'));
    scNew(5, +1, -2, C2('G', '2'));
    /* say hello: */
    write(TextOut;
"     Welcome to the test scenario.  Not much will happen here, but there "
"should be enough for you to get an idea of the kinds of things that can go "
"on. So anyway, here goes:"
    );
    /* go process user's commands: */
    process();
    /* all done, go clean up everything: */
    termContents();
    lFree(CarryList);
    lTerm();
    psTerm();
    scTerm();
corp;
