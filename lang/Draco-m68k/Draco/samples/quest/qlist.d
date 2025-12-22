/*
 * qlist.d - list handling utilities for Quest.
 */

type
    Id_t = ulong,

    IdList_t = struct {
        *IdList_t il_next;
        Id_t il_this;
    },

    PropList_t = struct {
        *PropList_t pl_next;
        Id_t pl_id;
        Id_t pl_property;
    },

    AttrList_t = struct {
        *AttrList_t al_next;
        Id_t al_id;
        Id_t al_attribute;
        Id_t al_value;
    };

Id_t
    ID_NULL = 0;

Id_t NextId;                    /* next available id */
*PropList_t PropList;           /* list of properties */
*AttrList_t AttrList;           /* list of attribute-value pairs */

/*
 * lInit - initialize list processing.
 */

proc lInit()void:

    NextId := ID_NULL;
    PropList := nil;
    AttrList := nil;
corp;

/*
 * lFree - free a list for the user.
 */

proc lFree(*IdList_t il)void:
    *IdList_t ilt;

    while il ~= nil do
        ilt := il;
        il := il*.il_next;
        free(ilt);
    od;
corp;

/*
 * lTerm - clean up after list processing.
 */

proc lTerm()void:
    *PropList_t pl;
    *AttrList_t al;

    while PropList ~= nil do
        pl := PropList;
        PropList := pl*.pl_next;
        free(pl);
    od;
    while AttrList ~= nil do
        al := AttrList;
        AttrList := al*.al_next;
        free(al);
    od;
corp;

/*
 * getId - return the next unique id.
 */

proc getId()Id_t:

    NextId := NextId + 1;
    NextId
corp;

/*
 * lAdd - add an element to the front of a list.
 */

proc lAdd(**IdList_t p; Id_t val)void:
    *IdList_t il;

    il := new(IdList_t);
    il*.il_next := p*;
    il*.il_this := val;
    p* := il;
corp;

/*
 * lAppend - append an element to the end of a list.
 */

proc lAppend(**IdList_t p; Id_t val)void:
    *IdList_t il;

    while p* ~= nil do
        p := &p**.il_next;
    od;
    il := new(IdList_t);
    il*.il_next := nil;
    il*.il_this := val;
    p* := il;
corp;

/*
 * lDelete - delete an element from a list.
 */

proc lDelete(**IdList_t p; Id_t val)void:
    *IdList_t il;

    while p* ~= nil and p**.il_this ~= val do
        p := &p**.il_next;
    od;
    if p* ~= nil then
        il := p*;
        p* := il*.il_next;
        free(il);
    fi;
corp;

/*
 * lGet - get the nth entry on a list.
 */

proc lGet(*IdList_t p; ulong n)Id_t:

    while
        n := n - 1;
        n ~= 0 and p ~= nil
    do
        p := p*.il_next;
    od;
    if p = nil then
        ID_NULL
    else
        p*.il_this
    fi
corp;

/*
 * lIn - say if a value is in a list.
 */

proc lIn(*IdList_t il; Id_t n)bool:

    while il ~= nil and il*.il_this ~= n do
        il := il*.il_next;
    od;
    il ~= nil
corp;

/*
 * _pFind - find the list element for a given id-property pair.
 */

proc _pFind(Id_t id, prop)**PropList_t:
    **PropList_t ppl;

    ppl := &PropList;
    while ppl* ~= nil and (ppl**.pl_id ~= id or ppl**.pl_property ~= prop) do
        ppl := &ppl**.pl_next;
    od;
    ppl
corp;

/*
 * putProp - associate a property with an id.
 */

proc putProp(Id_t id, prop)void:
    *PropList_t pl;

    if _pFind(id, prop)* = nil then
        pl := new(PropList_t);
        pl*.pl_next := PropList;
        pl*.pl_id := id;
        pl*.pl_property := prop;
        PropList := pl;
    fi;
corp;

/*
 * getProp - return 'true' if a property is associated with an id.
 */

proc getProp(Id_t id, prop)bool:

    _pFind(id, prop)* ~= nil
corp;

/*
 * delProp - delete the given property from the given id.
 */

proc delProp(Id_t id, prop)void:
    **PropList_t ppl;
    *PropList_t pl;

    ppl := _pFind(id, prop);
    if ppl* ~= nil then
        pl := ppl*;
        ppl* := pl*.pl_next;
        free(pl);
    fi;
corp;

/*
 * _aFind - find the list element for a given id-attribute pair.
 */

proc _aFind(Id_t id, attr)**AttrList_t:
    **AttrList_t pal;

    pal := &AttrList;
    while pal* ~= nil and (pal**.al_id ~= id or pal**.al_attribute~=attr) do
        pal := &pal**.al_next;
    od;
    pal
corp;

/*
 * putAttr - associate an attribute-value with an id.
 */

proc putAttr(Id_t id, attr, val)void:
    **AttrList_t pal;
    *AttrList_t al;

    pal := _aFind(id, attr);
    if pal* = nil then
        al := new(AttrList_t);
        al*.al_next := AttrList;
        al*.al_id := id;
        al*.al_attribute := attr;
        AttrList := al;
    else
        al := pal*;
    fi;
    al*.al_value := val;
corp;

/*
 * getAttr - return the value of an attribute associated with an id.
 */

proc getAttr(Id_t id, attr)Id_t:
    **AttrList_t pal;

    pal := _aFind(id, attr);
    if pal* = nil then
        ID_NULL
    else
        pal**.al_value
    fi
corp;

/*
 * delAttr - delete the given attribute from the given id.
 */

proc delAttr(Id_t id, attr)void:
    **AttrList_t pal;
    *AttrList_t al;

    pal := _aFind(id, attr);
    if pal* ~= nil then
        al := pal*;
        pal* := al*.al_next;
        free(al);
    fi;
corp;
