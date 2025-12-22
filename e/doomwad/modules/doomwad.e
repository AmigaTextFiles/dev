/*
** DOOMWAD.M
**
** ©1998 Peter Gordon (the.moosuck@borghome.demon.co.uk)
**
** Use, improve, abuse. The only restriction is you must credit me for
** any usage.
**
*/

OPT MODULE

MODULE 'exec/memory', 'dos/dos'

/* Names of all the "THINGS" */

EXPORT CONST TG_PLAYERSTART1=1,
             TG_PLAYERSTART2=2,
             TG_PLAYERSTART3=3,
             TG_PLAYERSTART4=4,
             TG_DEATHMSTART=11,
             TG_TELEPORTLAND=14,
             TG_PISTOLZOMBIE=$BBC,
             TG_WOLFENSTEINGUY=$54,
             TG_SERGEANT=$9,
             TG_CHAINGUNNER=$41,
             TG_IMP=$BB9,
             TG_DEMON=$BBA,
             TG_SPECTRE=$3A,
             TG_FLYSKULL=$BBE,
             TG_CACODEMON=$BBD,
             TG_GREYBARON=$45,
             TG_HELLBARON=$BBB,
             TG_ARACHNOTRON=$44,
             TG_PAINBLOKE=$47,
             TG_SKELETON=$42,
             TG_MANCUBUS=$43,
             TG_ARCHVILE=$40,
             TG_SPIDERMIND=$7,
             TG_CYBERDEAMON=$10,
             TG_BOSSBRAIN=$58,
             TG_BOSSSHOOTER=$59,
             TG_SPAWNSPOT=$57,
             TG_CHAINSAW=$7D5,
             TG_SHOTGUN=$7D1,
             TG_DOUBLESHOT=$52,
             TG_CHAINGUN=$7D2,
             TG_ROCKETLAUNCHER=$7D3,
             TG_PLASMAGUN=$7D4,
             TG_BFG9000=$7D6,
             TG_AMMOCLIP=$7D7,
             TG_SHELLS=$7D8,
             TG_ROCKET=$7DA,
             TG_CELL=$7FF,
             TG_AMMOBOX=$800,
             TG_SHELLBOX=$801,
             TG_ROCKETBOX=$7FE,
             TG_CELLPACK=$11,
             TG_BACKPACK=$8,
             TG_STIMPACK=$7DB,
             TG_MEDIKIT=$7DC,
             TG_HEALTHPOTION=$7DE,
             TG_ARMOUR=$7DF,
             TG_GREENARMOUR=$7E2,
             TG_BLUEARMOUR=$7E3,
             TG_MEGASPHERE=$53,
             TG_SOULSPHERE=$7DD,
             TG_INVULN=$7E6,
             TG_BESERK=$7E7,
             TG_SUIT=$7E9,
             TG_COMPUMAP=$7EA,
             TG_GOGGLES=$7FD,
             TG_BLUECARD=$5,
             TG_BLUESKULLCARD=$28,
             TG_REDCARD=$D,
             TG_REDSKULLCARD=$26,
             TG_YELLOWCARD=$6,
             TG_YELLOWSKULLCARD=$27,
             TG_BARREL=$7F3,
             TG_CMDRKEEN=$48,
             TG_TECHPILLAR=$30,
             TG_GREENPILLAR=$1E,
             TG_REDPILLAR=$20,
             TG_SGREENPILLAR=$1F,
             TG_HEARTPILLAR=$24,
             TG_SREDPILLAR=$21,
             TG_SKULLPILLAR=$25,
             TG_STALAGMITE=$2F,
             TG_BURNTREE=$2B,
             TG_BIGTREE=$36,
             TG_FLOORLAMP=$7EC,
             TG_TALLLAMP=$55,
             TG_SHORTLAMP=$56,
             TG_CANDLE=$22,
             TG_CANDELABRA=$23,
             TG_TBLUEFSTICK=$2C,
             TG_TGREENFSTICK=$2D,
             TG_TREDFSTICK=$2E,
             TG_SBLUEFSTICK=$37,
             TG_SGREENFSTICK=$38,
             TG_SREDFSTICK=$39,
             TG_BURNINGBARREL=$46,
             TG_EVILEYE=$29,
             TG_FLOATSKULL=$2A,
             TG_HANGTWITCH1=$31,
             TG_HANGTWITCH2=$3F,
             TG_HANGARMS1=$32,
             TG_HANGARMS2=$3B,
             TG_HANGLEGS1=$34,
             TG_HANGLEGS2=$3C,
             TG_HANGPEG1=$33,
             TG_HANGPEG2=$3D,
             TG_HANGLEG1=$35,
             TG_HANGLEG2=$3E,
             TG_HANGGUT1=$49,
             TG_HANGGUT2=$4A,
             TG_HANGTORSO1=$4B,
             TG_HANGTORSO2=$4C,
             TG_HANGTORSO3=$4D,
             TG_HANGTORSO4=$4E,
             TG_IMPALED=$19,
             TG_IMPALETWITCH=$1A,
             TG_SKULLPOLE=$1B,
             TG_SKULLKEBAB=$28,
             TG_SKULLCANDLES=$1D,
             TG_PLAYERSPLAT1=$A,
             TG_PLAYERSPLAT2=$C,
             TG_BLOODPOOL1=$18,
             TG_BLOODPOOL2=$4F,
             TG_BLOODPOOL3=$50,
             TG_BRAINPOOL=$51,
             TG_DEADPLAYER=$F,
             TG_DEADZOMBIE=$12,
             TG_DEADSERGEANT=$13,
             TG_DEADIMP=$14,
             TG_DEADDEMON=$15,
             TG_DEADCACODEMON=$16,
             TG_DEADFLYSKULL=$17

/* Handle for an open .WAD file */
EXPORT OBJECT wadhandle
  dosh,     -> AmigaDOS handle
  iwad,     -> True if wad is an IWAD, False if its a PWAD
  numlumps, -> Number of lumps in the wad
  dirstrt   -> Offset to the start of the directory
ENDOBJECT

/* An entry in the WAD directory */
EXPORT OBJECT dirblock
  offset,   -> Offset to seek to when reading lump
  size,     -> Size of lump
  name[8]:ARRAY OF CHAR -> Name of lump
ENDOBJECT 

/* readthings() decodes the THINGS lump into a big linked list of these */
EXPORT OBJECT thing
  prevthing:PTR TO thing,
  nextthing:PTR TO thing,
  x:INT,
  y:INT,
  angle:INT,
  type:INT,
  options:INT
ENDOBJECT


/* Opens a .WAD file. Returns pointer to wadhandle, or NIL for failure */
EXPORT PROC openwad(name)
  DEF h=0,wh=0:PTR TO wadhandle, tst
  
  -> Allocate memort for wadhandle
  IF(wh:=NewM(SIZEOF wadhandle,MEMF_ANY+MEMF_CLEAR))
  
    -> Open file
    IF(h:=Open(name,OLDFILE))
      
      -> Put DOS handle into wadhandle structure
      wh.dosh:=h
      
      -> Read in first four bytes to check it really is a WAD
      Read(h,{tst},4)
      IF(tst="IWAD")
        -> Its an IWAD
        wh.iwad:=TRUE
      ELSEIF(tst="PWAD")
        -> Its a PWAD
        wh.iwad:=FALSE
      ELSE
        -> Its not a WAD
        Close(wh.dosh)
        h:=0
        Dispose(wh)
        wh:=0
        RETURN 0
      ENDIF
      -> Read the number of lumps
      Read(h,{tst},4)
      -> Convert to motorola and store in numlumps
      wh.numlumps:=motolong(tst)
      -> Read start of WAD directory
      Read(h,{tst},4)
      -> Convert to motorola and store in dirstrt
      wh.dirstrt:=motolong(tst)
    ELSE
      Dispose(wh)
      wh:=0
      RETURN 0
    ENDIF
  ENDIF
ENDPROC wh

-> Closes and open wad
EXPORT PROC closewad(wh:PTR TO wadhandle)
  IF(wh)
    Close(wh.dosh)
    Dispose(wh)
  ENDIF
ENDPROC

-> Frees up a whole thinglist
EXPORT PROC freethings(thinglist:PTR TO thing)
  DEF cthing:PTR TO thing
  WHILE(thinglist>0)
    cthing:=thinglist.nextthing
    Dispose(thinglist)
    thinglist:=cthing
  ENDWHILE
ENDPROC

-> This routine reads the whole THINGS lump from a level into a big linked
-> list
EXPORT PROC readthings(levelname,wh:PTR TO wadhandle)
  DEF c,d,m=0,dirblock:dirblock,thinglist:PTR TO thing,cthing:PTR TO thing
  
  -> Looks for the level you require
  IF(c:=findentry(levelname,wh,dirblock)=0) THEN RETURN 0
  
  -> Scan for a things lump
  WHILE(c<wh.numlumps)
    INC c
    
    -> Get entry from WAD dir
    readentry(c*16,wh,dirblock)
    
    -> Is it the THINGS lump?
    IF(StrCmp(dirblock.name,'THINGS'))
    
      -> Yeah! So seek to the start of the THINGS lump
      Seek(wh.dosh,dirblock.offset,OFFSET_BEGINNING)
      d:=0
      
      -> Allocate a "thing" object
      IF(thinglist:=NewM(SIZEOF thing,MEMF_ANY+MEMF_CLEAR))
      
        -> Point to the first "thing" in the list
        cthing:=thinglist
        WHILE(d<dirblock.size)
        
          -> Read, translate to motorola, and fill in the current
          -> thing object
          Read(wh.dosh,{m}+2,2)
          cthing.x:=motoword(m)
          Read(wh.dosh,{m}+2,2)
          cthing.y:=motoword(m)
          Read(wh.dosh,{m}+2,2)
          cthing.angle:=motoword(m)
          Read(wh.dosh,{m}+2,2)
          cthing.type:=motoword(m)
          Read(wh.dosh,{m}+2,2)
          cthing.options:=motoword(m)
          
          -> Point to next thing
          d:=d+10
          
          -> If we're still in the thing lump...
          IF(d<dirblock.size)
            -> ... allocate another thing object
            IF(m:=NewM(SIZEOF thing,MEMF_ANY+MEMF_CLEAR))

              -> And make the previous thing object point to the current
              -> one, and the current one point to the last one.
              cthing.nextthing:=m
              cthing.nextthing.prevthing:=cthing
              cthing:=m
            ELSE
            
              -> Not enough memory, so free any we've already allocated
              -> and return failure
              freethings(thinglist)
              RETURN 0
            ENDIF
          ENDIF
        ENDWHILE
        RETURN thinglist
      ELSE
        RETURN 0
      ENDIF
    ENDIF
    -> Eek! No things!
    IF(StrCmp(dirblock.name,'MAP',3)) THEN RETURN 0
    IF(StrCmp(dirblock.name,'LINEDEFS')=0) AND (StrCmp(dirblock.name,'SIDEDEFS')=0) AND (StrCmp(dirblock.name,'VERTEXES')=0) AND (StrCmp(dirblock.name,'SEGS')=0) AND (StrCmp(dirblock.name,'SSECTORS')=0) AND (StrCmp(dirblock.name,'NODES')=0) AND (StrCmp(dirblock.name,'SECTORS')=0) AND (StrCmp(dirblock.name,'REJECT')=0) AND (StrCmp(dirblock.name,'BLOCKMAP')=0) THEN RETURN 0
  ENDWHILE
ENDPROC 0

-> Scans the WAD dir for a specific lump
EXPORT PROC findentry(entryname,wh:PTR TO wadhandle,dirblock:PTR TO dirblock)
  DEF c=0
  WHILE(c<wh.numlumps)
    readentry(c*16,wh,dirblock)
    IF(StrCmp(dirblock.name,entryname)) THEN RETURN -1,c
    INC c
  ENDWHILE
ENDPROC 0,0

-> Reads a directory entry into a dirblock structure
EXPORT PROC readentry(offset,wh:PTR TO wadhandle,dirblock:PTR TO dirblock)
  DEF m
  IF(Seek(wh.dosh,(wh.dirstrt+offset),OFFSET_BEGINNING)<>-1)
    Read(wh.dosh,{m},4)
    dirblock.offset:=motolong(m)
    Read(wh.dosh,{m},4)
    dirblock.size:=motolong(m)
    Read(wh.dosh,dirblock+8,8)
  ENDIF
ENDPROC

-> Converts an intel word into a motorola word.
-> It actually would convert a motorola word into an Intel one as well :)
EXPORT PROC motoword(intel:PTR TO INT)
  DEF tmp
  tmp:=Char({intel}+3)
  PutChar({intel}+3,Char({intel}+2))
  PutChar({intel}+2,tmp)
ENDPROC intel

-> Same as motoword() but for longs
EXPORT PROC motolong(intel)
  DEF tmp1,tmp2
  tmp1:=motoword(Int({intel}))
  tmp2:=motoword(Int({intel}+2))
  PutInt({intel},tmp2)
  PutInt({intel}+2,tmp1)
ENDPROC intel
