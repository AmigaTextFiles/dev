extern

    /* lex.d */

    next()void,
    whiteSpace()void,
    scan()void,

    /* const.d */

    constStart()*byte,
    constByte(byte b)void,
    constEnd(*byte startPos)*CTENT,
    constBuild(ulong lenSoFar; TYPENUMBER t)ulong,
    makeFloat(*byte pFloat)*CTENT,

    /* error.d */

    printInt(ulong number)void,
    printHex(ulong number)void,
    printSymbol(*SYMBOL symbol)void,
    eHeadHere()void,
    errorThis(ushort errorCode)void,
    errorBack(ushort errorCode)void,
    warning(ushort errorCode)void,
    conCheck(ushort conCode)void,

    /* parseUtils.d */

    getPosConst()ulong,
    getConst8()byte,
    pComma(char terminator)void,
    lCurly()void,
    rSquare()void,
    isStatement()bool,
    isStateEnd()bool,
    isExpression()bool,
    findStateOrExpr()void,
    voidIt()void,
    checkDo()void,
    checkOd()void,
    syntaxCheck(ushort errno)void,
    simpleComma()void,
    rightParen()void,
    leftParen()void,
    checkNumber()void,
    checkArith()void,
    reverseChains()void,

    /* symbol.d */

    findSymbol(*char name)*SYMBOL,
    purgeSymbol(ushort level)void,

    /* misc.d */

    pushDescriptor()void,
    popDescriptor()void,

    /* types.d */

    allocTInfo(ushort amount)void,
    nxtFreTyp()void,
    tInit()void,
    typeSize(TYPENUMBER t)ulong,
    basePtr1(TYPENUMBER t)*TTENTRY,
    basePtr(TYPENUMBER t)*TTENTRY,
    baseKind(TYPENUMBER t)TYPEKIND,
    baseKind1(TYPENUMBER t)TYPEKIND,
    isNumber(TYPENUMBER t)bool,
    isSigned(TYPENUMBER t)bool,
    isSimple(TYPENUMBER t)bool,
    isOp()bool,
    isAddress(TYPENUMBER t)bool,
    getSize(TYPENUMBER t)byte,
    notStatement(TYPENUMBER t)bool,
    chkDup(TYPENUMBER newType)TYPENUMBER,
    tFix(TYPENUMBER t; *byte info; ushort amount)void,
    bCompat(TYPENUMBER oldType)bool,
    assignCompat(TYPENUMBER oldType)void,
    ifCompatible(TYPENUMBER oldType)TYPENUMBER,
    makePtrTo(TYPENUMBER t)TYPENUMBER,

    /* proc.d */

    emitConstants()void,
    addOpPar(*SYMBOL sy)void,
    codeInit()void,
    doReturnValue()void,
    pProc()void,

    /* decl.d */

    pId(IDKIND check)*SYMBOL,
    pType()TYPENUMBER,
    pProcHead()TYPENUMBER,
    pDecls()void,

    /* codeUtil.d */

    hasIndex(*DESCRIPTOR d)bool,
    isPower2(ulong val; *ushort pPower)bool,
    genByte(byte b)void,
    genWord(uint w)void,
    genWordZero()void,
    genLong(ulong l)void,
    reloc(*byte where; ulong what; *RELOC base, current, top)*RELOC,
    relocg(*byte where; ulong what)void,
    relocf(*byte where; ulong what)void,
    relocl(*byte where; ulong what)void,
    relocp(*byte where; *byte what)void,
    unlinkFreeAReg(*REGQUEUE r)void,
    unlinkFreeDReg(*REGQUEUE r)void,
    pushBusyAReg(*REGQUEUE r)void,
    pushBusyDReg(*REGQUEUE r)void,
    getAReg()byte,
    getDReg()byte,
    freeAReg()void,
    freeDReg()void,
    needRegs(ushort aRCount, dRCount)void,
    aActive(ushort reg)bool,
    fixTo(*ushort stackPos)void,
    switchReg(ushort reg; TYPENUMBER typ)void,
    save(*STATE s)void,
    restore(*STATE s; bool undoCode)void,
    forgetRegs()void,
    forgetFreeRegs()void,
    isAvailable()bool,
    A1Busy()bool,
    sizeIt(ushort reg; TYPENUMBER typeNow, typeWant)TYPENUMBER,
    floatRef(uint opCode, reg; *DESCRIPTOR d)void,
    fixSizeReg(TYPENUMBER t)void,
    ifPart(TYPENUMBER oldType; bool noStack)TYPENUMBER,
    condEnd(TYPENUMBER t)void,
    getDim(*ARRAYDIM ar; byte mode; ushort reg)void,
    makeIndir()void,
    constFix()void,
    forceData()void,
    swap()void,
    reverseOps()bool,
    shrinkConsts()void,
    mergeTypes()void,
    modedBinary(uint opCode)void,
    addrCon(bool isPlus; ushort reg; ulong len)void,
    shift(ushort reg; byte size; bool left, tSigned; ushort amount)void,
    multiplyBy(ushort reg; TYPENUMBER typ; ulong val)void,
    floatEntry(int libOffset)void,
    floatBinary(int libOffset)void,

    /* codeOp.d */

    genReloc(VALUEKIND kind; *VALUETYPE val)void,
    peepFlush()void,
    unDoTo(uint pos)void,
    opSingle(uint opCode; byte size, ea)void,
    opRegister(uint opCode; ushort reg; byte ea)void,
    opSpecial(uint opCode)void,
    opMove(uint opCode; byte source, dest)void,
    opQuick(uint opCode; byte data, size, ea)void,
    opModed(uint opCode; ushort reg; byte mode, ea)void,
    opImm(ushort reg; byte data)void,
    opEA(uint opcode; byte ea)void,
    sourceWord(uint w)void,
    sourceLong(ulong l)void,
    destWord(uint w)void,
    destLong(ulong l)void,
    opReloc(*DESCRIPTOR d; bool isSource)void,
    ignoreCheck()void,

    /* branch.d */

    opBranch(byte condition, displacement)void,
    branchTo(byte condition; *byte where)void,
    fixChainTo(uint head; *byte where)void,
    fixChain(uint head)void,
    fixChainImmediate(uint head)void,
    fixRefChainImmediate(uint head)void,
    ifJump(uint doneChain, lastBranch, branchChain)uint,
    moveCodeBack(uint firstPos, amount)void,
    shortenBranches(*BRENTRY brStart)void,
    flushHereChain()void,

    /* codeGen.d */

    getMode(*DESCRIPTOR d; *byte pMode; *ushort pReg; *uint pWord;
	    *bool pFreeA, pFreeD)void,
    tailStuff(*DESCRIPTOR d; bool isSource; byte mode; ushort reg;
	      uint wrd; bool freeA, freeD)void,
    opTail(OPTYPE opType; uint opCode; byte leftMode; ushort leftReg;
	   bool extraAddr, extraData)void,
    condition(bool conditionFlag)uint,
    putAddrInReg()void,
    putInReg()void,
    checkOp(uint op)void,
    opCompat()void,
    externRef(uint opCode; *char name)void,
    genCall1(*char name)void,
    genCall(*char name)void,
    genCall2(*char name1, name2)void,
    genOpCall(*char name2)void,

    /* parseUnit.d */

    pConstruct()void,
    statements()void,

    /* parseIfWhileCall.d */

    pIf()void,
    pWhile()void,
    pCall()void,

    /* parseSub.d */

    pIndSubDot()void,

    /* parseArith.d */

    pPlusMinus()void,

    /* parseBoolAssign.d */

    pAssignment()void,

    /* parseCaseFor.d */

    pCase()void,
    pFor()void,

    /* parseIO.d */

    pOpen()void,
    pCloseIOError()void,
    pReadWrite()void,

    /* system.d */

    readSource(*char sourceBuff; uint bufferSize)uint,
    abort(uint status)void,
    printString(*char st)void,
    printRevString(*char st)void,
    printFileName()void,
    errorHead(uint line, column, errorCode; bool isWarning, isUser)void,
    errorBody(uint errorCode)bool,
    externRefName(*char revName)void,
    externRefUse(uint where)void,
    setChip()void,
    writeProgram(*char thisProc; *uint codeBuffer; uint codeSize;
		 *RELOC globalStart, globalEnd, fileStart, fileEnd,
			programStart, programEnd)void,
    setIncludeFile(*char name)void,
    resetMainFile()void,
    setGlobalSize(ulong globalSize)void,
    fileVarName(*char revName; ulong offset)void,
    setFileSize(ulong fileSize)void,
    enableMath()void,
    insertDataFile(*char fileName; ulong len, offset)void;
