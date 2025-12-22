#drinc:util.g

/*
 * QPARSE.DRC - parsing routines for Quest.
 */

extern
    _scAbort(*char message)void,
    scPut(char ch)void;

type
    Id_t = ulong,

    DictEntry_t = struct {
	*DictEntry_t d_next;
	*char d_text;
	Id_t d_id;
	Id_t d_type;
    },

    FormType_t = enum {f_reqId, f_reqType, f_optId, f_optType, f_multiple},

    FormList_t = struct {
	*FormList_t f_next;
	FormType_t f_kind;
	Id_t f_data;
    },

    Grammar_t = struct {
	*Grammar_t g_next;
	*FormList_t g_sentence;
	Id_t g_id;
    },

    WordList_t = struct {
	*WordList_t wl_next;
	uint wl_position;
	Id_t wl_type;
	Id_t wl_id;
    };

Id_t
    PS_NONE = 0,
    PS_ERROR = 0xffffffff;

*DictEntry_t Dictionary;
*Grammar_t Grammar;
**FormList_t WordPtr;

*WordList_t InputSentence;
*Grammar_t MatchedSentence;
*char UnknownWord;
*WordList_t PrefixList;
uint ScanPos;
ushort ScanCount;
bool PrefixEnabled;

/*
 * psInit - initialize the parser.
 */

proc psInit(bool prefixEnabled)void:

    PrefixEnabled := prefixEnabled;
    Dictionary := nil;
    Grammar := nil;
    InputSentence := nil;
    UnknownWord := nil;
    PrefixList := nil;
    ScanPos := 0;
corp;

/*
 * _psClean - cleanup the leftovers of a previous sentence.
 */

proc _psClean()void:
    *WordList_t w;

    while InputSentence ~= nil do
	w := InputSentence;
	InputSentence := InputSentence*.wl_next;
	free(w);
    od;
    if UnknownWord ~= nil then
	Mfree(pretend(UnknownWord, *byte), CharsLen(UnknownWord) + 1);
	UnknownWord := nil;
    fi;
    while PrefixList ~= nil do
	w := PrefixList;
	PrefixList := PrefixList*.wl_next;
	free(w);
    od;
corp;

/*
 * psTerm - clean up after parser operation.
 */

proc psTerm()void:
    *DictEntry_t d;
    *Grammar_t g;
    *FormList_t f, ft;

    _psClean();
    while Grammar ~= nil do
	g := Grammar;
	f := g*.g_sentence;
	while f ~= nil do
	    ft := f;
	    f := f*.f_next;
	    free(ft);
	od;
	Grammar := g*.g_next;
	free(g);
    od;
    while Dictionary ~= nil do
	d := Dictionary;
	Dictionary := d*.d_next;
	free(d);
    od;
corp;

/*
 * psWord - add a word to the dictionary.
 */

proc psWord(Id_t id; *char txt; Id_t typ)void:
    *DictEntry_t d;

    d := new(DictEntry_t);
    d*.d_next := Dictionary;
    d*.d_text := txt;
    d*.d_id := id;
    d*.d_type := typ;
    Dictionary := d;
corp;

/*
 * psDel - delete a word from the dictionary.
 */

proc psDel(Id_t id)void:
    **DictEntry_t pd;
    *DictEntry_t d;

    pd := &Dictionary;
    while pd* ~= nil and pd**.d_id ~= id do
	pd := &pd**.d_next;
    od;
    if pd* ~= nil then
	d := pd*;
	pd* := d*.d_next;
	free(d);
    fi;
corp;

/*
 * psgBegin - set up to start a new sentence in the grammar.
 */

proc psgBegin(Id_t id)void:
    **Grammar_t pg;
    *Grammar_t g;

    pg := &Grammar;
    while pg* ~= nil do
	pg := &pg**.g_next;
    od;
    g := new(Grammar_t);
    g*.g_next := nil;
    g*.g_id := id;
    WordPtr := &g*.g_sentence;
    pg* := g;
corp;

/*
 * psgWord - add a word to the current grammar sentence.
 */

proc psgWord(FormType_t kind; Id_t data)void:
    *FormList_t w;

    w := new(FormList_t);
    w*.f_kind := kind;
    w*.f_data := data;
    WordPtr* := w;
    WordPtr := &w*.f_next;
corp;

/*
 * psgEnd - end of the current grammar sentence.
 */

proc psgEnd()void:

    WordPtr* := nil;
corp;

/*
 * psgDel - delete a rule from the grammar.
 */

proc psgDel(Id_t id)void:
    **Grammar_t pg;
    *Grammar_t g;
    *FormList_t f, temp;

    pg := &Grammar;
    while pg* ~= nil and pg**.g_id ~= id do
	pg := &pg**.g_next;
    od;
    if pg* ~= nil then
	g := pg*;
	pg* := g*.g_next;
	f := g*.g_sentence;
	free(g);
	while f ~= nil do
	    temp := f;
	    f := f*.f_next;
	    free(temp);
	od;
    fi;
corp;

/*
 * CAP - capitalize a letter.
 */

proc CAP(char ch)char:

    if ch >= 'a' and ch <= 'z' then
	ch - 32
    else
	ch
    fi
corp;

/*
 * psFind - look a word up in the dictionary.
 */

proc psFind(*char wrd)Id_t:
    *DictEntry_t d;
    *char p1, p2;

    d := Dictionary;
    while
	if d = nil then
	    false
	else
	    p1 := wrd;
	    p2 := d*.d_text;
	    while p1* ~= '\e' and CAP(p1*) = CAP(p2*) do
		p1 := p1 + 1;
		p2 := p2 + 1;
	    od;
	    CAP(p1*) ~= CAP(p2*)
	fi
    do
	d := d*.d_next;
    od;
    if d = nil then
	PS_NONE
    else
	d*.d_id
    fi
corp;

/*
 * _psLookup - return the DictEntry_t for the indicated word.
 */

proc _psLookup(Id_t id)*DictEntry_t:
    *DictEntry_t d;

    d := Dictionary;
    while
	if d = nil then
	    _scAbort("psLookup: can't find id.");
	fi;
	d*.d_id ~= id
    do
	d := d*.d_next;
    od;
    d
corp;

/*
 * psType - find the type of the word with the given id.
 */

proc psType(Id_t id)Id_t:

    _psLookup(id)*.d_type
corp;

/*
 * psGet - return the text of the word with the given id.
 */

proc psGet(Id_t id)*char:

    _psLookup(id)*.d_text
corp;

/*
 * _delimChar - say if a character is a delimiter character.
 */

proc _delimChar(char ch)bool:

    not (ch >= 'A' and ch <= 'Z' or ch >= 'a' and ch <= 'z' or
	 ch >= '0' and ch <= '9')
corp;

/*
 * psParse - parse an input sentence.
 */

proc psParse(*char sentence)Id_t:
    **WordList_t wp;
    *FormList_t f;
    *WordList_t w;
    *char wordStart;
    Id_t data, position;
    char ch;
    bool bad;

    /* first, free the previous input sentence list: */

    _psClean();

    /* turn the input sentence into a list of words: */

    ScanPos := 0;
    wp := &InputSentence;
    bad := false;
    while
	while sentence* = ' ' do
	    sentence := sentence + 1;
	od;
	not bad and sentence* ~= '\e'
    do
	if PrefixEnabled and sentence* = ':' and PrefixList = nil then
	    /* first part was a prefix: */
	    wp* := nil;
	    PrefixList := InputSentence;
	    wp := &InputSentence;
	    sentence := sentence + 1;
	else
	    wordStart := sentence;
	    sentence := sentence + 1;
	    while not _delimChar(sentence*) do
		sentence := sentence + 1;
	    od;
	    ch := sentence*;
	    sentence* := '\e';
	    w := new(WordList_t);
	    w*.wl_id := psFind(wordStart);
	    if w*.wl_id = PS_NONE then
		UnknownWord := pretend(Malloc(CharsLen(wordStart)+1), *char);
		CharsCopy(UnknownWord, wordStart);
		bad := true;
	    else
		w*.wl_type := psType(w*.wl_id);
	    fi;
	    wp* := w;
	    wp := &w*.wl_next;
	    sentence* := ch;
	fi;
    od;
    wp* := nil;

    /* if an unknown word was found, don't go any further: */

    if bad then
	PS_ERROR
    else

	/* check the forms in the grammar for a matching sentence form: */

	MatchedSentence := Grammar;
	while
	    if MatchedSentence = nil then
		bad := true;
		false
	    else
		f := MatchedSentence*.g_sentence;
		w := InputSentence;
		bad := false;
		position := 1;
		while not bad and f ~= nil do
		    data := f*.f_data;
		    case f*.f_kind
		    incase f_reqId:
			if w ~= nil and data = w*.wl_id then
			    w*.wl_position := position;
			    f := f*.f_next;
			    w := w*.wl_next;
			else
			    bad := true;
			fi;
		    incase f_reqType:
			if w ~= nil and data = w*.wl_type then
			    w*.wl_position := position;
			    f := f*.f_next;
			    w := w*.wl_next;
			else
			    bad := true;
			fi;
		    incase f_optId:
			if w ~= nil and data = w*.wl_id then
			    w*.wl_position := position;
			    w := w*.wl_next;
			fi;
			f := f*.f_next;
		    incase f_optType:
			if w ~= nil and data = w*.wl_type then
			    w*.wl_position := position;
			    w := w*.wl_next;
			fi;
			f := f*.f_next;
		    incase f_multiple:
			while w ~= nil and data = w*.wl_type do
			    w*.wl_position := position;
			    w := w*.wl_next;
			od;
			f := f*.f_next;
		    esac;
		    position := position + 1;
		od;
		if w ~= nil then
		    bad := true;
		fi;
		bad
	    fi
	do
	    MatchedSentence := MatchedSentence*.g_next;
	od;
	if bad then
	    PS_NONE
	else
	    MatchedSentence*.g_id
	fi
    fi
corp;

/*
 * pspBad - return the unknown word (if any).
 */

proc pspBad()*char:

    UnknownWord
corp;

/*
 * pspWord - return the (first or any) word which fits the indicated position
 *	     in the matched sentence form.
 */

proc pspWord(uint pos)Id_t:
    *WordList_t w;
    ushort i;

    if pos ~= ScanPos then
	ScanPos := pos;
	ScanCount := 0;
    fi;
    w := InputSentence;
    while w ~= nil and w*.wl_position < pos do
	w := w*.wl_next;
    od;
    i := ScanCount;
    ScanCount := ScanCount + 1;
    while w ~= nil and i ~= 0 do
	i := i - 1;
	w := w*.wl_next;
    od;
    if w = nil or w*.wl_position ~= pos then
	PS_NONE
    else
	w*.wl_id
    fi
corp;

/*
 * pspPref - return words in the prefix list.
 */

proc pspPref()Id_t:
    *WordList_t p;
    Id_t id;

    if PrefixList = nil then
	PS_NONE
    else
	p := PrefixList;
	PrefixList := PrefixList*.wl_next;
	id := p*.wl_id;
	free(p);
	id
    fi
corp;

/*
 * _psDump - externally callable routine to dump the dictionary and grammar.
 */

proc _psDump(channel output text chout; proc(Id_t kind)*char kindName)void:
    *DictEntry_t d;
    *Grammar_t g;
    *FormList_t f;

    writeln(chout; "Words in dictionary:");
    d := Dictionary;
    while d ~= nil do
	writeln(chout; "    ", kindName(d*.d_type), ", id ", d*.d_id, ": ",
		d*.d_text);
	d := d*.d_next;
    od;
    writeln(chout; "The grammar is:");
    g := Grammar;
    while g ~= nil do
	write(chout; "    rule ", g*.g_id, ": ");
	f := g*.g_sentence;
	while f ~= nil do
	    case f*.f_kind
	    incase f_reqId:
		write(chout; psGet(f*.f_data));
	    incase f_reqType:
		write(chout; kindName(f*.f_data));
	    incase f_optId:
		write(chout; '[', psGet(f*.f_data), ']');
	    incase f_optType:
		write(chout; '[', kindName(f*.f_data), ']');
	    incase f_multiple:
		write(chout; kindName(f*.f_data), '*');
	    esac;
	    f := f*.f_next;
	    if f ~= nil then
		write(chout; ' ');
	    fi;
	od;
	writeln(chout;);
	g := g*.g_next;
    od;
corp;
