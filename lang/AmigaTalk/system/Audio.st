" ----------------------------------------------------------------------- "
" Audio Class implements control of the audio.device only, NOT any custom "
" hardware you might have.                                                "
""
"  WARNING:  You should know what you're doing to the Amiga OS before     "
"            messing with this Class, or any other System Class!          "
""
"  NOTE(S):  Methods marked 'BOOLEAN' return true on success, false on    "
"            failure. "
" ----------------------------------------------------------------------- "
 
Class Audio :Device ! private1 private2 private3 aChannel !
[
   initialize: portName channels: chBytes flags: flags priority: newPriority 
      
      " newPriority is in the range: -128 to 127.
      *
      * flags pertinent to the user are: 
      *    ADIOF_SYNCCYCLE = 32 & ADIOF_NOWAIT = 64.
      * 
      * chbytes is a ByteArray that is only 4 bytes long.  #[ 3 5 10 12 ] 
      * It is encoded as follows for each byte:
      *
      *    Channel 3 Channel 2 Channel 1 Channel 0 Allocation 
      *      RIGHT     LEFT      LEFT      RIGHT      MASK
      *
      *        0         0         1         1        0x03    Stereo
      *        0         1         0         1        0x05    Stereo
      *        1         0         1         0        0x0A    Stereo
      *        1         1         0         0        0x0C    Stereo
      *
      *        0         0         0         1        0x01    MonAural
      *        0         0         1         0        0x02    MonAural
      *        0         1         0         0        0x04    MonAural
      *        1         0         0         0        0x08    MonAural
      *  
      * UNCOMMON USAGE:
      *
      *        0         0         0         0        0x00    NO CHANNELS
      *        0         1         1         0        0x06    Both Left Ch.
      *        0         1         1         1        0x07    Three Channels
      *        1         0         0         1        0x09    Both Right Ch.
      *        1         0         1         1        0x0B    Three Channels
      *        1         1         0         1        0x0D    Three Channels
      *        1         1         1         0        0x0E    Three Channels
      *        1         1         1         1        0x0F    ALL Channels
      "

      private1 <- <primitive 220 1>.

      private2 <- <primitive 220 3 private1 portName flags newPriority chBytes>.
      
      (self openChannel: chBytes priority: newPriority)
        ifFalse: [self error: 'Could NOT open Audio channel(s)!']
|
   openChannel: chByteArray priority: pri ! rval !     " BOOLEAN "

      rval     <- <primitive 220 21 private1 pri chByteArray>.

      aChannel <- self myChannel.

      ^ rval
|
   myChannel

      ^ <primitive 220 27 private1>
|
   volume: volumeLevel                                 " BOOLEAN "

      ^ <primitive 220 14 private1 volumeLevel>     
|
   period: newPeriod                                   " BOOLEAN "

      " The frequency of the sound you wish to play is 
      * dependent on the period & the length of the sound
      * data.  The frequency is determined by dividing the
      * VideoClockFreq by the product of the period & data 
      * length.  
      *
      * Example:  f = 3579545 / (256 * period) for NTSC
      *           f = 4436618 / (256 * period) for PAL
      * 
      *           where 256 is the length of the data.
      "      
      ^ <primitive 220 13 private1 newPeriod>     
|
   waitCycle                                           " BOOLEAN " 

      ^ <primitive 220 16 private1 aChannel>
|
   read

      ^ <primitive 220 17 private1 aChannel>
|
   setData: aByteArray

      private3 <- <primitive 220 26 private1 aByteArray>
|
   playAt: volume for: duration                        " BOOLEAN "

      " if the duration is zero, the channel will play 
      * continuously, until you abort it (stop method).
      * the number of cycles is dependent on the duration &
      * the frequency (determined by the period & data length).
      *
      *   Example: numCycles = (frequency * duration) / 1000
      *
      * See the 'period:' method for frequency calculation. 
      "
      ^ <primitive 220 15 private1 volume duration aChannel>
|
   start                                               " BOOLEAN "

      ^ <primitive 220 12 private1>
|
   stop                                                " BOOLEAN "

      ^ <primitive 220 11 private1>
|
   reset                                               " BOOLEAN "

      ^ <primitive 220 10 private1>
|
   changePriority: newPriority                         " BOOLEAN "

      ^ <primitive 220 6 private1 newPriority>
|
   flush                                               " BOOLEAN "

      ^ <primitive 220 9 private1>
|
   clear                                               " BOOLEAN "

      ^ <primitive 220 24 private1>
|
   update                                              " BOOLEAN "

      ^ <primitive 220 25 private1>
|
   finish                                              " BOOLEAN "

      ^ <primitive 220 8 private1>
|
   lock                                                " BOOLEAN "

      ^ <primitive 220 7 private1>
|
   read: audioFileName size: size                      " BOOLEAN "

      ^ <primitive 220 18 private1 audioFileName size>
|
   write: audioFileName size: size                     " BOOLEAN "

      ^ <primitive 220 19 private1 audioFileName size>
|
   freeChannel

      " Tell the system you are done with an Audio Channel: "
      <primitive 220 20 private1 private2 aChannel>
|
   disposeData

      <primitive 220 2 private3>.

      <primitive 250 5 0 private3>.

      ^ nil
|
   dispose

      <primitive 220 0 private1 private2>.

      self disposeData.

      <primitive 220 5 private1>.

      <primitive 250 5 0 private1>. " One-way ticket to death!! "

      ^ nil
|
   audioKey

      ^ <primitive 220 22 private1> " NOT really needed at this time. "
]
