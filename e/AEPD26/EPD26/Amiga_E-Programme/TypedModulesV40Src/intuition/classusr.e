Short: JRH's useful E modules
Type: dev/e
Author: m88jrh@ecs.ox.ac.uk (Jason R. Hulance)
Uploader: m88jrh@ecs.ox.ac.uk (Jason R. Hulance)

JRH's Useful Modules
====================

These modules are Copyright (C) 1995, Jason R. Hulance.

You are free to use these modules in your programs, whether they are freeware
or commercial.  However, if you want to distribute any of this archive you
must include it all, unmodified, together with this file.

Contents
--------

Various modules:

  ecode.m:
    PROC eCode(func)
    PROC eCodePreserve(func)
    PROC eCodeTask(func)
    PROC eCodeASLHook(func)
    PROC eCodeCxCustom(func)
    PROC eCodeIntHandler(func)
    PROC eCodeIntServer(func)
    PROC eCodeSoftInt(func)
    PROC eCodeDispose(addr)

  split.m:
    PROC argSplit(str=0)


Amiga E does not support Resources (at least, not up to v3.1a, anyway).
These modules rectify this.

  battclock.m:
    DEF battclockbase
    PROC readBattClock()
    PROC resetBattClock()
    PROC writeBattClock(time)

  battmem.m:
    DEF battmembase
    PROC obtainBattSemaphore()
    PROC readBattMem(buffer,offset,length)
    PROC releaseBattSemaphore()
    PROC writeBattMem(buffer,offset,length)

  cia.m:
    PROC ableICR(resource,mask)
    PROC addICRVector(resource,iCRBit,interrupt)
    PROC remICRVector(resource,iCRBit,interrupt)
    PROC setICR(resource,mask)

  disk.m:
    DEF diskbase
    PROC allocUnit(unitNum)
    PROC freeUnit(unitNum)
    PROC getUnit(unitPointer)
    PROC getUnitID(unitNum)
    PROC giveUnit()
    PROC readUnitID(unitNum)

  misc.m:
    DEF miscbase
    PROC allocMiscResource(unitNum,name)
    PROC freeMiscResource(unitNum)

  potgo.m:
    DEF potgobase
    PROC allocPotBits(bits)
    PROC freePotBits(bits)
    PROC writePotgo(word,mask)


Documentation
-------------

The standard documentation on the Resource functions suffices for the
Resource modules.  All the other functions (eCodeXXX and split) r