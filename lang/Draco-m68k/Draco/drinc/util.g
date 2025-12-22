type

„/*resultfromthestringcomparisonroutine:*/

„COMPARISON=enum{
ˆEQUAL,
ˆLESS,
ˆGREATER
„};

„/*errorcodesreturnedby'IOerror':*/

„ushort
ˆCH_OK=0,/*noerror*/

ˆCH_EOF=1,/*readpastend-of-fileindicator*/
ˆCH_CLOSED=2,Š/*useafterclose*/

ˆCH_NONEXIS=3,‰/*filedoesn'texist*/
ˆCH_DISKFULL=4,ˆ/*diskisfull;writefailed*/
ˆCH_BADSEEK=5,‰/*badseekcall*/

ˆCH_MISSING=6,‰/*nodataonline*/
ˆCH_BADCHAR=7,‰/*badcharacterforinputconversion*/
ˆCH_OVERFLOW=8,ˆ/*overflowonnumericconversion*/
ˆCH_UNDERFLOW=9,‡/*underflowonfloatingpointinput*/

ˆCH_BADREAD=10;ˆ/*thesystemreadcallfailed!*/

/*resultfromLineReadwhenwegetendoffile:*/

ulongLINE_EOF=0xffffffff;

extern

„CharsLen(*charcharsPtr)ulong,
„CharsEqual(*charcharsPtr1,charsPtr2)bool,
„CharsCopy(*chardest,source)void,
„CharsCmp(*charcharsPtr1,charsPtr2)COMPARISON,
„CharsConcat(*chardest,source)void,
„CharsCopyN(*chardest,source;ulongn)void,
„CharsIndex(*charsubject,object)long,

„exit(longstatus)void,

„ConvTime(ulongseconds;*charbuffer)void,
„GetCurrentTime()ulong,

„GetPar()*char,
„RescanPars()void,

„FileCreate(*charfileName)bool,
„FileDestroy(*charfileName)boid,
„FileRename(*charoldName,newName)bool,

„RawRead(channelinputbinarychan;arbptrbuffer;ulongcount)ulong,
„RawWrite(channeloutputbinarychan;arbptrbuffer;ulongcount)ulong,
„LineRead(channelinputtextchan;*charbuffer;ulongcount)ulong,
„LineWrite(channeloutputtextchan;*charbuffer;ulongcount)ulong,
„RandomOut(channeloutputbinarychan)void,
„ReOpen(channelinputbinarych1;channeloutputbinarych2)void,
„SeekIn(channelinputbinarychan;ulongposition)bool,
„SeekOut(channeloutputbinarychan;ulongposition)bool,
„TextAppend(channeloutputtextchan)bool,
„LineFlush()void,
„GetIn(channelinputbinarychan)ulong,
„GetOut(channeloutputbinarychan)ulong,
„GetInMax(channelinputbinarychan)ulong,
„GetOutMax(channeloutputbinarychan)ulong,
„FlushOut(channeloutputbinarychan)void,

„Malloc(ulonglength)arbptr,
„Mfree(arbptrregion;ulonglength)void,
„MerrorSet(boolnewFlag)void,
„MerrorGet()bool,

„BlockCopy(arbptrdest,source;ulongcount)void,
„BlockFill(arbptrdest;ulongcount;bytevalu)void,
„BlockCopyB(arbptrdest,source;ulongcount)void;
