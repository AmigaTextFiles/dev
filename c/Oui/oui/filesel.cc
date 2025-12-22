// $Id: filesel.cc 1.3 1997/07/14 04:21:44 dlorre Exp dlorre $
#include "filesel.h"

void listedevs(void);
BOOL getfile(screen *, STRPTR , STRPTR , STRPTR , STRPTR );
void initlist(void);
void takefile(void);
void freelist(void);
void fileevents(void);
void checkpath(void);
void displayfiles(void);
void devlist(void);
void DoKeys(IntuiMessage *);
void stripspaces(STRPTR );
void bcpl2c(BSTR b, STRPTR d);
BOOL getPath(STRPTR , STRPTR );
void selection(WORD x, WORD y) ;
void DrawIcon(STRPTR name, WORD place) ;
void sinsert(List *list, Node *node) ;

struct fileEntry {
    STRPTR  name ;
    BYTE    type ;
    fileEntry() : type(NULL), name(NULL) {}
};

int fecmp(const void *a, const void *b)
{
fileEntry *fa = (fileEntry *)a ;
fileEntry *fb = (fileEntry *)b ;

    if (fa->type == fb->type) {
        return strcmpi(fa->name, fb->name) ;
    }
    else {
        return fb->type - fa->type ;
    }
}

static fileEntry *fp ;

/* fichier control.c */
LONG DeadKeyConvert(IntuiMessage *, UBYTE *, LONG, KeyMap *);

void filesel::fparent(gadget *g, unsigned long classe, unsigned short code)
{
STRPTR s;

    strcpy(stemp, DRAWER) ;
    s = PathPart(stemp) ;
    *s = '\0' ;
    gdrawer->set(stemp) ;
    DrawIcon(stemp, TOPDBOX) ;
    freelist();
    takefile();
}

void filesel::fdrawer(gadget *g, unsigned long classe, unsigned short code)
{
    strcpy(stemp, DRAWER) ;
    getPath(DRAWER, stemp);
    checkpath();
    gdrawer->set(stemp) ;
    DrawIcon(stemp, TOPDBOX) ;
    freelist();
    takefile();
}

void filesel::fprop(gadget *g, unsigned long classe, unsigned short code)
{
    if (code != topentry) {
        topentry = code ;
        displayfiles() ;
    }
}

void filesel::handlevkey(USHORT code)
{
    if (code == 0x0D) {
        g->selectgadget(7, FALSE) ;
    }
    else if (code == 0x1B) {
        g->selectgadget(9, FALSE) ;
    }
    else
        g->parsegadgets(code) ;
}

void filesel::open(screen *ns)
{
long mw ;
long mc ;
long l ;
long pwidth, pheight ;

    ws = ns ;

    g = new gadgetlist(this, 10) ;
    mw = g->lmax(ok, cancel, parent, NULL) + 20 ;
    mc = g->lmax(file, drawer, comment, NULL) + 20 ;
    l = g->fontheight+4 ;

    g->box(LEFTSEL, TOPSEL+HEIGHTSEL+4, mc, l) ;
    new cstring(g, NULL, drawer, NULL, FALSE, PLACETEXT_IN|NG_HIGHLABEL) ;

    g->box(LEFTSEL+mc, TOPSEL+HEIGHTSEL+4, LEFTBOX + WIDTHBOX - mc - 20, l) ;
    gdrawer = new string(g, WFUNC(&filesel::fdrawer)) ;

    g->box(LEFTSEL, TOPSEL+HEIGHTSEL+4+l, mc, l) ;
    new cstring(g, NULL, file, NULL, FALSE, PLACETEXT_IN|NG_HIGHLABEL) ;

    g->box(LEFTSEL+mc, TOPSEL+HEIGHTSEL+4+l, LEFTBOX + WIDTHBOX - mc - 20, l) ;
    gfile = new string(g, NULL, NULL, sname) ;

    g->box(LEFTSEL, TOPSEL+HEIGHTSEL+4+2*l, mc, l) ;
    new cstring(g, NULL, comment, NULL, FALSE, PLACETEXT_IN|NG_HIGHLABEL) ;

    g->box(LEFTSEL+mc, TOPSEL+HEIGHTSEL+4+2*l, LEFTBOX + WIDTHBOX - mc - 20, l) ;
    if (Saver)
        gcom = new string(g, NULL) ;
    else
        cgcom = new cstring(g, NULL, NULL, NULL, TRUE) ;

    if (ws->scr->ViewPort.Modes & HIRES) {
        pwidth = 18 ;
        pheight = 10 ;
    }
    else {
        pwidth = 13 ;
        pheight = 11 ;
    }

    g->box(pwidth-1, TOPSEL, pwidth-1, TOPSEL+pheight) ;
    gprop = new eprop(g, WFUNC(&filesel::fprop), 0, TOT_DISPLAY, TOT_DISPLAY,
        LORIENT_VERT, RIGHTPROP|HEIGHTPROP) ;

    g->box( ws->scr->WBorLeft+20,
            g->maxh+8,
            mw,
            g->fontheight*3/2) ;

    g->setgpen(ws->xpens[GREEN_PEN]) ;
    new fbutton(g, WFUNC(&filesel::fok), ok, TRUE) ;

    g->left = short((g->maxw+20-mw)/2) ;
    g->setgpen(ws->drawinfo->dri_Pens[TEXTPEN]) ;
    new fbutton(g, WFUNC(&filesel::fparent), parent, FALSE) ;

    g->left = short(g->maxw - mw) ;
    g->setgpen(ws->xpens[RED_PEN]) ;
    new fbutton(g, WFUNC(&filesel::fcancel), cancel, FALSE) ;

    width = short(LEFTBOX + WIDTHBOX+20) ;

    height = short(g->maxh-ws->winbarheight+8) ;

    left = short((ws->width - width - ws->scr->WBorLeft-ws->scr->WBorRight) / 2) ;
    top = short((ws->height - height - ws->winbarheight - ws->scr->WBorBottom) / 2) ;

    window::_open(NULL, BUTTONIDCMP|ARROWIDCMP|SCROLLERIDCMP|
                        IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY|IDCMP_VANILLAKEY|
                        IDCMP_DISKINSERTED|
                        IDCMP_DISKREMOVED|IDCMP_IDCMPUPDATE,
        WA_Flags,   WFLG_DRAGBAR|WFLG_ACTIVATE,
        WA_Title,   title,
        WA_Gadgets, g->glist,
        WA_SizeGadget,  TRUE,
        TAG_END);

    if (initok) {
        recessedbox(LEFTSEL-2, TOPSEL-2, WIDTHSEL+4, HEIGHTSEL+4) ;
        setapen(ws->xpens[GFILL_PEN]) ;
        rectfill(LEFTSEL, TOPSEL, LEFTSEL+WIDTHSEL-1, TOPSEL+HEIGHTSEL-1) ;
        bevelbox(LEFTBOX-2, TOPDBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;
        recessedbox(LEFTBOX-2, TOPFBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;

        g->updategadgets() ;
        if (newregion()) {
            clipok = addregion(LEFTBOX, TOPDBOX, WIDTHBOX, HEIGHTBOX) ;
            clipok &= addregion(LEFTBOX, TOPFBOX, WIDTHBOX, HEIGHTBOX) ;
            clipok &= addregion(LEFTSEL, TOPSEL, WIDTHSEL, HEIGHTSEL) ;
            if (!Saver)
                clipok &= addregion(LEFTSEL, TOPSEL+HEIGHTSEL+34, LEFTBOX+WIDTHBOX-LEFTSEL, 14) ;
        }
    }
}

static filesel frwin(90, 40, 430, 140) ;

BOOL getfile(screen *s, STRPTR name, STRPTR title, STRPTR drawer,
    STRPTR comment)
{
int i ;

    frwin.okflag = FALSE ;

    if (s == NULL) return(FALSE);
    Plain = Italic = *s->scr->Font ;
    Italic.ta_Style |= FSF_ITALIC;

    bloc = (FileInfoBlock *)AllocDosObject(DOS_FIB, NULL) ;
    if (!bloc)
        return FALSE ;

    ParsePatternNoCase("~(#?.info)", pat, MAXLEN) ;
    Saver = short(comment != NULL) ;

    FONTHEIGHT = short(s->scr->Font->ta_YSize) ;
    LEFTSEL = 20 ;
    TOPSEL = TOPDBOX = short(s->winbarheight + 8) ;
    WIDTHSEL = short(s->width / 3) ;
    HEIGHTSEL = short(s->height / 2) ;
    TOT_DISPLAY = short(HEIGHTSEL / FONTHEIGHT) ;
    LEFTBOX = short(LEFTSEL + WIDTHSEL + 30) ;
    TOPDBOX = TOPSEL ;
    HEIGHTBOX = short(HEIGHTSEL / 2 - 10) ;
    TOPFBOX = short(TOPSEL + HEIGHTBOX + 10) ;
    WIDTHBOX = short((HEIGHTBOX*s->xratio) / s->yratio) ;

    listetext = new IntuiText[TOT_DISPLAY] ;
    if (!listetext)
        goto mem1 ;

    fpen = s->drawinfo->dri_Pens[TEXTPEN] ;
    bpen = s->xpens[GFILL_PEN] ;

    for (i=0; i<TOT_DISPLAY; i++) {
        listetext[i].FrontPen = fpen;
        listetext[i].BackPen = bpen;
        listetext[i].DrawMode = JAM2;
        listetext[i].LeftEdge = short(LEFTSEL+4) ;
        listetext[i].TopEdge = short(TOPSEL+i*FONTHEIGHT) ;
        listetext[i].ITextFont = s->scr->Font ;
        listetext[i].IText = new char[MAXLEN];
        if (!listetext[i].IText)
            goto mem2 ;

        listetext[i].IText[0] = '\0' ;
        listetext[i].NextText = (i<(TOT_DISPLAY-1))?&listetext[i+1]:NULL;
    }
    Style = new TextAttr*[TOT_DISPLAY] ;
    if (!Style)
        goto mem3 ;

    strcpy(frwin.sname, name) ;
    strcpy(frwin.title, title) ;
    frwin.open(s) ;
    if (frwin.initok) {
        if (frwin.clipok) {
            frwin.installclip() ;

            Mode = DISPLAY_FILES ;

            indsel = numsel = -1 ;

            getPath(drawer, stemp);
            checkpath();
            gdrawer->set(stemp) ;
            DrawIcon(stemp, TOPDBOX) ;
            DrawIcon(name, TOPFBOX) ;

            takefile();

            frwin.eventloop() ;

            frwin.disposeregion() ;

            freelist();
            stripspaces(FILE);
            strcpy(drawer, DRAWER) ;
            strcpy(name, FILE) ;
            if (Saver)
                strcpy(comment, COMMENT) ;
        }

        frwin.close() ;
    }
    delete Style ;

mem3:
    for (i=0; i<TOT_DISPLAY; i++) {
        if (listetext[i].IText) delete listetext[i].IText ;
    }

mem2:
    delete listetext ;

mem1:
    FreeDosObject(DOS_FIB, bloc) ;
    return (frwin.okflag);
}

void initlist(void)
{
    RepList = new List ;
    NewList(RepList);
    RepList->lh_Type = NT_UNKNOWN;
}

void takefile(void)
{
ExAllData       *EAData ;
ExAllData       *ead ;
ExAllControl    *eac ;
LONG            more ;
int             i ;

    initlist();
    checkpath();
    clef = Lock(DRAWER, ACCESS_READ);

    EAData = new ExAllData[MAXENTRIES] ;

    eac = (ExAllControl *)AllocDosObject(DOS_EXALLCONTROL,NULL);

    nbfics = 0 ;
    eac->eac_Entries = MAXENTRIES ;
    eac->eac_MatchString = pat ;
    eac->eac_MatchFunc = NULL ;
    eac->eac_LastKey = 0;
    do {
        more = ExAll(clef, EAData, sizeof(ExAllData)*MAXENTRIES, ED_TYPE, eac);
        if ((!more) && (IoErr() != ERROR_NO_MORE_ENTRIES)) {
            // ExAll failed abnormally
            break;
        }
        if (eac->eac_Entries == 0) {
            // ExAll failed normally with no entries
            continue;                   // ("more" is *usually* zero)
        }
        ead = EAData;
        do {
            RepNode = new Node ;
            RepNode->ln_Name = new char[strlen(ead->ed_Name)+1] ;
            strcpy(RepNode->ln_Name, ead->ed_Name) ;
            RepNode->ln_Pri = BYTE(ead->ed_Type > 0) ;
            AddTail(RepList, RepNode) ;
            nbfics++;
            ead = ead->ed_Next;
        } while (ead);

    } while (more);

    FreeDosObject(DOS_EXALLCONTROL,eac);
    delete EAData ;

    fp = new fileEntry[nbfics] ;

    RepNode = RepList->lh_Head ;
    for (i=0; i<nbfics; i++) {
        fp[i].name = RepNode->ln_Name ;
        fp[i].type = RepNode->ln_Pri ;
        RepNode = RepNode->ln_Succ ;
    }
    qsort(fp, nbfics, sizeof(fileEntry), &fecmp) ;

    RepNode = RepList->lh_Head ;
    for (i=0 ; i< nbfics; i++) {
        RepNode->ln_Name = fp[i].name ;
        RepNode->ln_Pri = fp[i].type ;
        RepNode = RepNode->ln_Succ ;
    }
    delete [] fp ;

    UnLock(clef);
    topentry = 0 ;
    gprop->set(topentry, -1, nbfics) ;
    displayfiles();
}

void freelist(void)
{
    Garage = NULL;
    for (RepNode = RepList->lh_Head; RepNode->ln_Succ;
         RepNode = RepNode->ln_Succ) {

        if (Garage) {
            Remove((Node *)Garage);
            delete Garage ;
        }

        delete RepNode->ln_Name ;

        Garage = RepNode;
    }

    if (Garage) {
        Remove((Node *)Garage);
        delete Garage ;
    }

    delete RepList ;
}

void filesel::simpleevent(IntuiMessage *message)
{
Gadget *gad ;
WORD mousex, mousey ;
ULONG s, m ;
TagItem *tags ;
long id ;

    code = message->Code;
    gad = (Gadget *)message->IAddress;
    classe = message->Class;
    mousex = message->MouseX ;
    mousey = message->MouseY ;
    s = message->Seconds ;
    m = message->Micros ;

    clickon = FALSE ;

    switch (classe) {
    case IDCMP_MOUSEBUTTONS:
        if (code == SELECTUP) {
            if (mousex > LEFTSEL && mousey > TOPSEL &&
                mousex < (LEFTSEL+WIDTHSEL) &&
                mousey < (TOPSEL+HEIGHTSEL)) {
                if (DoubleClick(declic.s, declic.m, s, m)) {
                    clickon = TRUE ;
                }
                else {
                    declic.s = s ;
                    declic.m = m ;
                }
            }
            selection(mousex, mousey) ;
        }
        break;
    case IDCMP_VANILLAKEY:
        handlevkey(code) ;
        break ;
    case IDCMP_RAWKEY:
        DoKeys(message);
        break;
    case IDCMP_DISKINSERTED:
    case IDCMP_DISKREMOVED:
        if (Mode == DISPLAY_DIRS) devlist() ;
        break ;
    case IDCMP_IDCMPUPDATE:
        tags = (TagItem *)gad ;
        if (FindTagItem(PGA_Top, tags)) {
            code = (unsigned short)GetTagData(PGA_Top, 0, tags) ;
            id = (unsigned short)GetTagData(GA_ID, 0, tags) ;
            g->processgadget(id, classe, code) ;
        }
        break ;
    case IDCMP_GADGETUP:
    case IDCMP_GADGETDOWN:
            g->processgadget(gad->GadgetID, classe, code) ;
        break ;
    case IDCMP_REFRESHWINDOW:
        beginrefresh() ;
        endrefresh(TRUE) ;
        break;
    }
}

void checkpath(void)
{
    clef = NULL;
    clef = Lock(stemp, ACCESS_READ);
    if (!clef) {
        strcpy(stemp, DRAWER) ;
    }
    else
        UnLock(clef);
}

void displayfiles(void)
{
int                 i ;
long                l ;
struct TextExtent   te ;

    RepNode = RepList->lh_Head;
    i=0;
    while (RepNode->ln_Succ && i++<topentry)
        RepNode = RepNode->ln_Succ;

    i = 0;
    while (RepNode->ln_Succ && (i<TOT_DISPLAY)) {
        if (RepNode->ln_Pri)
            Style[i] = &Italic ;
        else
            Style[i] = &Plain ;

        CopyMem(RepNode->ln_Name, listetext[i].IText, strlen(RepNode->ln_Name)+1);
        l = (long)frwin.textfit(listetext[i].IText,
                strlen(listetext[i].IText), &te, NULL, 1,
                 WIDTHSEL, FONTHEIGHT) ;
        listetext[i].IText[l] = '\0' ;
        i++ ;
        RepNode = RepNode->ln_Succ;
    }

    while (i<TOT_DISPLAY) {
        listetext[i++].IText[0] = '\0' ;
    }

    for (i=0 ; i<TOT_DISPLAY; i++) {
        listetext[i].ITextFont = Style[i] ;
        listetext[i].FrontPen =  (unsigned char)(((i+topentry) == numsel)?bpen:fpen) ;
        listetext[i].BackPen =  (unsigned char)(((i+topentry) == numsel)?fpen:bpen) ;
    }
    frwin.setapen(frwin.ws->xpens[GFILL_PEN]) ;
    frwin.rectfill(LEFTSEL, TOPSEL, LEFTSEL+WIDTHSEL-1, TOPSEL+HEIGHTSEL-1) ;
    frwin.printitext(listetext, 0, 0) ;
}

void devlist(void)
{
DosList *dol ;

    dol = LockDosList(LDF_VOLUMES|LDF_ASSIGNS|LDF_READ) ;
    dol = NextDosEntry(dol, LDF_VOLUMES|LDF_ASSIGNS|LDF_READ) ;

    freelist();
    initlist();
    nbfics=0;
    while (dol)
    {
        if ((dol->dol_Type != DLT_DEVICE) || dol->dol_Task) {
            bcpl2c(dol->dol_Name, name);

            RepNode = new Node ;
            RepNode->ln_Name = new char[strlen(name)+1] ;
            strcpy(RepNode->ln_Name,name);
            if (dol->dol_Type == DLT_DIRECTORY)
                RepNode->ln_Pri = 0;
            else
                RepNode->ln_Pri = 1;
            sinsert(RepList, RepNode) ;
            nbfics++;
        }
        dol = NextDosEntry(dol, LDF_VOLUMES|LDF_ASSIGNS|LDF_READ) ;
    }
    UnLockDosList(LDF_VOLUMES|LDF_ASSIGNS|LDF_READ) ;
    topentry = 0 ;
    gprop->set(topentry, -1, nbfics) ;
    displayfiles();
}

void bcpl2c(BSTR b, STRPTR d)
{
STRPTR s = (STRPTR )BADDR(b);
int i ;

    i = 0 ;
    while (i<s[0])
        d[i++] = s[i];
    d[i++]=':'; d[i] = '\0';
}


BOOL getPath(STRPTR command, STRPTR buf)
{
BPTR lock;
BOOL Success = FALSE;

    if (lock = Lock(command, ACCESS_READ)) {
        Success = (short)NameFromLock(lock, buf, 64);
        UnLock(lock);
    }
    return(Success);
}

void stripspaces(STRPTR s)
{
int i,j;
STATIC char cop[MAXLEN];
    strcpy(cop, s);
    i = j = 0;
    while (cop[i] && cop[i] == ' ') i++ ;
    while (cop[i]) s[j++] = cop[i++] ;
    s[j] = '\0';
    while (j && (s[j] == ' ' || s[j] == '\0'))
        j-- ;
    s[j+1] = '\0' ;
}

void DoKeys(IntuiMessage *msg)
{
LONG numchars;
UBYTE buffer[] = "           ";

    numchars = DeadKeyConvert(msg, buffer, 12, 0);
    if (numchars)
    {
        switch (buffer[0]) {
        case 0x9B:
            switch (buffer[1]) {
            case 'A':                   // DOWN ARROW
                topentry-- ;
                numsel-- ;
                if (numsel < 0) numsel = 0 ;
                if (topentry < 0) topentry = 0 ;
                break ;
            case 'B':                   // UP ARROW
                topentry++ ;
                numsel++ ;
                if (numsel >= nbfics) numsel = short(nbfics-1) ;
                if (topentry >= nbfics) topentry = long(nbfics-1) ;
                break ;
            }
            gprop->set(topentry, -1, -1) ;
            displayfiles() ;
            break ;
        case 0x1B:                  // ESC
            frwin.active = FALSE;
            break ;
        case 0x0D:                  // RETURN
            frwin.okflag = TRUE ; frwin.active = FALSE ;
            break ;
        case 0x08:
        case '/':
            frwin.fparent(NULL, 0, 0) ;
            break ;
        }
    }
}


LONG DeadKeyConvert( IntuiMessage           *msg,
                     UBYTE                  *kbuffer,
                     LONG                   kbsize,
                     KeyMap          *kmap)
{
STATIC InputEvent ievent = {NULL, IECLASS_RAWKEY, 0, 0, 0};

    if (msg->Class != IDCMP_RAWKEY)
        return(-2);

    ievent.ie_Code = msg->Code;
    ievent.ie_Qualifier = msg->Qualifier;
    ievent.ie_position.ie_addr = *((APTR*)msg->IAddress);

    return(RawKeyConvert(&ievent, (STRPTR)kbuffer, kbsize, kmap));
}

void listedevs(void)
{
    if (Mode == DISPLAY_FILES) {
        indsel = numsel = -1 ;
        frwin.removeclip() ;
        frwin.recessedbox(LEFTBOX-2, TOPDBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;
        frwin.bevelbox(LEFTBOX-2, TOPFBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;
        frwin.installclip() ;
        Mode = DISPLAY_DIRS;
        devlist();
    }
    else {
        indsel = numsel = -1 ;
        frwin.removeclip() ;
        frwin.bevelbox(LEFTBOX-2, TOPDBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;
        frwin.recessedbox(LEFTBOX-2, TOPFBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;
        frwin.installclip() ;
        Mode = DISPLAY_FILES;
        freelist();
        takefile();
    }
}

void selection(WORD x, WORD y)
{
int ind, num ;
int presel ;

    if (x > LEFTSEL && y > TOPSEL && x < (LEFTSEL+WIDTHSEL) && y < (TOPSEL+HEIGHTSEL)) {
        ind = (y-TOPSEL) / FONTHEIGHT ;
        num = int(ind + topentry) ;
        if (num>=nbfics)
            return ;
        presel = indsel ;
        indsel = short(ind) ;
        numsel = short(num) ;
        if ((Style[indsel] == &Italic) &&
            (Mode == DISPLAY_FILES)) {  // Répertoire sélectionné
            strcpy(DTEMP, DRAWER) ;
            strcpy(stemp, DRAWER) ;
            AddPart(stemp, listetext[indsel].IText, MAXLEN) ;
            stripspaces(stemp) ;
            checkpath();
            gdrawer->set(stemp) ;
            DrawIcon(stemp, TOPDBOX) ;
            freelist();
            takefile();
        }
        else if (Mode == DISPLAY_DIRS) {    // Volume ou Assign sélectionné
            strcpy(stemp, listetext[indsel].IText) ;
            stripspaces(stemp) ;
            getPath(stemp, stemp);
            checkpath();
            gdrawer->set(stemp) ;
            frwin.removeclip() ;
            frwin.bevelbox(LEFTBOX-2, TOPDBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;
            frwin.recessedbox(LEFTBOX-2, TOPFBOX-2, WIDTHBOX+4, HEIGHTBOX+4) ;
            frwin.installclip() ;
            DrawIcon(stemp, TOPDBOX) ;
            Mode = DISPLAY_FILES;
            freelist();
            takefile();
        }
        else {  // Fichier sélectionné
            if (clickon && presel == indsel) {
                frwin.okflag = TRUE ;
                frwin.active = FALSE ;
                return ;
            }
            strcpy(stemp2, listetext[indsel].IText) ;
            stripspaces(stemp2) ;
            gfile->set(stemp2) ;
            strcpy(comstring, DRAWER) ;
            AddPart(comstring, stemp2, MAXLEN) ;
            clef = Lock(comstring, ACCESS_READ) ;
            if (clef) {
                Examine(clef, bloc) ;
                strcpy(comstring, bloc->fib_Comment) ;
                UnLock(clef) ;
            }
            else
                comstring[0] = '\0' ;
            if (Saver) {
                gcom->set(comstring) ;
            }
            else {
                cgcom->set(comstring) ;
            }
            DrawIcon(stemp2, TOPFBOX) ;
        }
        displayfiles() ;
    }
    else if (x > LEFTBOX && x < (LEFTBOX+WIDTHBOX)) {
        if (y>TOPDBOX && y < (TOPDBOX+HEIGHTBOX) && Mode == DISPLAY_FILES) {
            listedevs() ;
        }
        else if (y>TOPFBOX && y < (TOPFBOX+HEIGHTBOX) && Mode == DISPLAY_DIRS) {
            listedevs() ;
        }
    }
}

void DrawIcon(STRPTR name, WORD place)
{
DiskObject *diskobj;
Image *im ;
WORD w, h ;
char fname[80] ;
LONG deftype ;

    frwin.setapen(0) ;
    frwin.rectfill(LEFTBOX, place, LEFTBOX+WIDTHBOX, place+HEIGHTBOX) ;
    if (place == TOPDBOX) {
        frwin.rectfill(LEFTBOX, TOPFBOX, LEFTBOX+WIDTHBOX, TOPFBOX+HEIGHTBOX) ;
        strcpy(fname, name) ;
        indsel = numsel = -1 ;
        deftype = WBDRAWER ;
    }
    else {
        if (name) {
            strcpy(fname, DRAWER) ;
            AddPart(fname, name, MAXLEN) ;
        }
        else {
            fname[0] = '\0' ;
        }
        deftype = WBPROJECT ;
    }
    if ((diskobj=GetDiskObject((UBYTE *)fname)) || (diskobj=GetDefDiskObject(deftype))) {
       im = (Image *)diskobj->do_Gadget.GadgetRender ;
        w = short(MIN(WIDTHBOX, im->Width)) ;
        h = short(MIN(HEIGHTBOX, im->Height)) ;
        im->LeftEdge = short((WIDTHBOX-w) / 2) ;
        im->TopEdge = short((HEIGHTBOX-h) / 2) ;
        im->Depth = 2 ;
        DrawImage(frwin.rp, im, LEFTBOX, place) ;
        FreeDiskObject(diskobj);
    }
}


void sinsert(List *list, Node *node)
{
Node *courant, *pred ;

    if (IsListEmpty(list)) {
        AddHead(list, node) ;
    }
    else {
        courant = list->lh_Head ;
        if ((courant->ln_Pri < node->ln_Pri) ||
            ((courant->ln_Pri == node->ln_Pri) &&
            (stricmp(courant->ln_Name, node->ln_Name) > 0))) {
            AddHead(list, node) ;
        }
        else {
            while (courant->ln_Succ && ((courant->ln_Pri > node->ln_Pri) ||
                ((courant->ln_Pri == node->ln_Pri) && (stricmp(courant->ln_Name, node->ln_Name) < 0)))) {
                pred = courant ;
                courant = courant->ln_Succ ;
            }
            Insert(list, node, pred) ;
        }
    }
}
