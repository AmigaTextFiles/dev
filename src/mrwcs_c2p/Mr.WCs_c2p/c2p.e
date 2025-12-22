/*
** not particularly fast C2P routine
** by Niels Böhm alias Mr.WC
** ©opyright 2000-08-14
** all rights remain reserved
**
** you may use this routine in any way you like,
** you may change it, or use any parts of it,
** as long as you give proper credits
**
** i don't guarantee anything when using this piece of software
** i can't be held responsible for any loss or damage
** cause by this software, whether directly or indirectly
**
** please note that this routine only writes whole longwords,
** that means, you have to pay attention that the end of your
** bitmap can't be exceeded, i.e. you should use either a screen
** width which is a multiple of 32 or an even screen height or
** some pad bytes
**
** btw, this C2P also works on 68000
*/

MODULE 'exec/interrupts',
       'exec/nodes',
       'intuition/screens'

DEF is:is,ticks=0

PROC c2p(chunky,bitmap)
  MOVEM.L A4/A5,-(A7) -> E will complain that we used A4 and A5, but this is
                      -> perfectly save, as long as we put them into a safe
                      -> place and restore them after we're done

  MOVE.L chunky.L,A0
  MOVE.L bitmap.L,A2

  MOVE.W (A2)+,D0   -> here i just determine the size of the screen in pixels
  LSL.W #3,D0       -> (i.e. i use the chunky bitmap to detect the bottom)
  MULU.W (A2),D0    -> and add it to the start address (which i will use as run
  LEA 0(A0,D0.L),A1 -> pointer) in order to later compare the run pointer with
  ADDQ.W #6,A2      -> it and break if it went past the end address

  MOVEM.L (A2),D0-D7  -> the bitplane pointers have to be stored somewhere else
  MOVEM.L D0-D7,-(A7) -> (on the stack) as i am going to increment them lateron

/*
  now for the tricky part - the actual c2p

  At first we have to think about how much data we are supposed to process at
  once. We'll consider the chunky side first:

  The chunky data is just a very long string of bytes, each representing one
  pixel, which we can assume as continuous, if we imagine the ends of each line
  connected to the start of its succeeding line. For matters of speed we only
  want to read longs, thus our piece of data has to be a multiple of 4 bytes or
  4 pixels, respectively.

  On the planar side we assume 8 bitplanes, as we want to see the whole palette
  of 256 colours (adjusting it for fewer bitplanes is easy, as we just need to
  "forget" to write into the "superfluous" bitplanes, however, the algorithm
  remains the same).

  In the bitplanes, the 8 bits of every byte represent one of the bits of 8
  pixels. i.e. here one byte doesn't make up one pixel but rather one eighth of
  8 pixels. Thus the first bytes of all 8 bitplanes do - indivisibly - make up
  8 pixels. Since we only want to use long word memory accesses here, too, we
  need to write 4 bytes to each plane at once, what means, that we have
  4 bytes * 8 bitplanes = 4 * 8 pixels = 32 bytes (which of course is a multiple
  of 4, so we automatically comply to the requirement of the chunky bitmap ;)
*/

_c2p_loop_:
  MOVEM.L (A0)+,D0-D7

-> Okay, here we go, we just read the first 32 bytes of the chunky "string".
-> To understand what will happen in the upcoming process, we visualize the 8
-> longwords the following way:

/* (note that the following 3 lines have a length of 783 characters)

·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------·
|07|06|05|04|03|02|01|00|17|16|15|14|13|12|11|10|27|26|25|24|23|22|21|20|37|36|35|34|33|32|31|30| |47|46|45|44|43|42|41|40|57|56|55|54|53|52|51|50|67|66|65|64|63|62|61|60|77|76|75|74|73|72|71|70| |87|86|85|84|83|82|81|80|97|96|95|94|93|92|91|90|a7|a6|a5|a4|a3|a2|a1|a0|b7|b6|b5|b4|b3|b2|b1|b0| |c7|c6|c5|c4|c3|c2|c1|c0|d7|d6|d5|d4|d3|d2|d1|d0|e7|e6|e5|e4|e3|e2|e1|e0|f7|f6|f5|f4|f3|f2|f1|f0| |g7|g6|g5|g4|g3|g2|g1|g0|h7|h6|h5|h4|h3|h2|h1|h0|i7|i6|i5|i4|i3|i2|i1|i0|j7|j6|j5|j4|j3|j2|j1|j0| |k7|k6|k5|k4|k3|k2|k1|k0|l7|l6|l5|l4|l3|l2|l1|l0|m7|m6|m5|m4|m3|m2|m1|m0|n7|n6|n5|n4|n3|n2|n1|n0| |o7|o6|o5|o4|o3|o2|o1|o0|p7|p6|p5|p4|p3|p2|p1|p0|q7|q6|q5|q4|q3|q2|q1|q0|r7|r6|r5|r4|r3|r2|r1|r0| |s7|s6|s5|s4|s3|s2|s1|s0|t7|t6|t5|t4|t3|t2|t1|t0|u7|u6|u5|u4|u3|u2|u1|u0|v7|v6|v5|v4|v3|v2|v1|v0|
·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------· ·-----------------------------------------------------------------------------------------------·
 ^^
 ||
 |`-- bit number in the _pixel_ (not necessarily in the byte) it belongs to
 `--- pixel number, as there are 32 pixels, i use base-32 (i.e. digits 0-9,a-v)

Now we rearrange our longword registers (only visually) to better represent the
way we are going to write to the target bitplanes:

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
D0 |07|06|05|04|03|02|01|00|17|16|15|14|13|12|11|10|27|26|25|24|23|22|21|20|37|36|35|34|33|32|31|30|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |47|46|45|44|43|42|41|40|57|56|55|54|53|52|51|50|67|66|65|64|63|62|61|60|77|76|75|74|73|72|71|70|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |87|86|85|84|83|82|81|80|97|96|95|94|93|92|91|90|a7|a6|a5|a4|a3|a2|a1|a0|b7|b6|b5|b4|b3|b2|b1|b0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |c7|c6|c5|c4|c3|c2|c1|c0|d7|d6|d5|d4|d3|d2|d1|d0|e7|e6|e5|e4|e3|e2|e1|e0|f7|f6|f5|f4|f3|f2|f1|f0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |g7|g6|g5|g4|g3|g2|g1|g0|h7|h6|h5|h4|h3|h2|h1|h0|i7|i6|i5|i4|i3|i2|i1|i0|j7|j6|j5|j4|j3|j2|j1|j0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D5 |k7|k6|k5|k4|k3|k2|k1|k0|l7|l6|l5|l4|l3|l2|l1|l0|m7|m6|m5|m4|m3|m2|m1|m0|n7|n6|n5|n4|n3|n2|n1|n0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D6 |o7|o6|o5|o4|o3|o2|o1|o0|p7|p6|p5|p4|p3|p2|p1|p0|q7|q6|q5|q4|q3|q2|q1|q0|r7|r6|r5|r4|r3|r2|r1|r0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D7 |s7|s6|s5|s4|s3|s2|s1|s0|t7|t6|t5|t4|t3|t2|t1|t0|u7|u6|u5|u4|u3|u2|u1|u0|v7|v6|v5|v4|v3|v2|v1|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

Naturally the bits are still at the places you'd expect from chunky format, as
the bits won't magically hop around just because we rearrange our visualisation.
So we will immediately start to put an end to this unacceptable state ;)

What we see is, that the bits of the first 8 pixels are spread over the full 32
bit range of the first two registers. But we need them at the very beginning of
all 8 registers, since each register is to correspond to a bitplane. In other
words, we need the first 8 pixels in the leftmost 8x8 block (in which way
doesn't matter for now, as we are just at the beginning of our process ;)
Likewise the next 8 pixels need to get to the second 8x8 block and so on.

This can easily be achieved with the help of two stages. In the first stage we
swap over the low (right) 16-bit words of the first 4 registers with the
corresponding high (left) words of the other 4 registers. After that, we have
all pixels that are to go to the first two 8x8 blocks in the left 16x8 block and
the other pixels that are to go to the last two 8x8 blocks in the right 16x8
block. This is the half of what we wanted - our 1st stage (called Word-Scramble,
although there isn't much scrambled yet, but the code already looks confusing ;)
*/

-> Word-Scramble
  SWAP D4;     SWAP D5;     SWAP D6;     SWAP D7
  EOR.W D0,D4; EOR.W D1,D5; EOR.W D2,D6; EOR.W D3,D7
  EOR.W D4,D0; EOR.W D5,D1; EOR.W D6,D2; EOR.W D7,D3
  EOR.W D0,D4; EOR.W D1,D5; EOR.W D2,D6; EOR.W D3,D7
  SWAP D4;     SWAP D5;     SWAP D6;     SWAP D7

/*

Note that we swapped the words using the little trick:

 a xor b -> b
 b xor a -> a
 a xor b -> b

That will indeed leave us with the former contents of a now in b and vice versa.
We could as well have used MOVE to achieve this in the following way:

 a -> c
 b -> a
 c -> b

This is processed in exactly the same time (at least on 68000, as i only have a
decent processor cycle table for this CPU) but would have required an extra
register as intermediate storage, which in this case wouldn't have been a
problem as we still have some spare address registers, but why waste registers
when this isn't needed?

However, so far our registers look like this:

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
D0 |07|06|05|04|03|02|01|00|17|16|15|14|13|12|11|10|g7|g6|g5|g4|g3|g2|g1|g0|h7|h6|h5|h4|h3|h2|h1|h0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |47|46|45|44|43|42|41|40|57|56|55|54|53|52|51|50|k7|k6|k5|k4|k3|k2|k1|k0|l7|l6|l5|l4|l3|l2|l1|l0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |87|86|85|84|83|82|81|80|97|96|95|94|93|92|91|90|o7|o6|o5|o4|o3|o2|o1|o0|p7|p6|p5|p4|p3|p2|p1|p0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |c7|c6|c5|c4|c3|c2|c1|c0|d7|d6|d5|d4|d3|d2|d1|d0|s7|s6|s5|s4|s3|s2|s1|s0|t7|t6|t5|t4|t3|t2|t1|t0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |27|26|25|24|23|22|21|20|37|36|35|34|33|32|31|30|i7|i6|i5|i4|i3|i2|i1|i0|j7|j6|j5|j4|j3|j2|j1|j0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D5 |67|66|65|64|63|62|61|60|77|76|75|74|73|72|71|70|m7|m6|m5|m4|m3|m2|m1|m0|n7|n6|n5|n4|n3|n2|n1|n0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D6 |a7|a6|a5|a4|a3|a2|a1|a0|b7|b6|b5|b4|b3|b2|b1|b0|q7|q6|q5|q4|q3|q2|q1|q0|r7|r6|r5|r4|r3|r2|r1|r0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D7 |e7|e6|e5|e4|e3|e2|e1|e0|f7|f6|f5|f4|f3|f2|f1|f0|u7|u6|u5|u4|u3|u2|u1|u0|v7|v6|v5|v4|v3|v2|v1|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

Now to complete our first objective, we just need to swap the 2nd and 4th byte
of the 1st, 2nd, 5th and 6th register with the 1st and 3rd byte of the 3rd, 4th,
7th and 8th register, respectively. There are many ways to do this, for example
one could swap the two bytes of one register with the two bytes of the other one
simultaneously by either rotating them into the same word or by masking them
with AND or OR. The latter method would once again require extra scratch
registers and both methods are slower than swapping the bytes singularly
(naturally that refers to the 68000 timing, i don't know if another method is
faster on 68020+). We just need to rotate and swap the bytes we want into place
to perform our operations.
*/

-> Byte-Scramble
  ROR.L #8,D2; ROR.L #8,D3; ROR.L #8,D6; ROR.L #8,D7
  EOR.B D0,D2; EOR.B D1,D3; EOR.B D4,D6; EOR.B D5,D7
  EOR.B D2,D0; EOR.B D3,D1; EOR.B D6,D4; EOR.B D7,D5
  EOR.B D0,D2; EOR.B D1,D3; EOR.B D4,D6; EOR.B D5,D7
  SWAP D0;     SWAP D1;     SWAP D4;     SWAP D5
  SWAP D2;     SWAP D3;     SWAP D6;     SWAP D7
  EOR.B D0,D2; EOR.B D1,D3; EOR.B D4,D6; EOR.B D5,D7
  EOR.B D2,D0; EOR.B D3,D1; EOR.B D6,D4; EOR.B D7,D5
  EOR.B D0,D2; EOR.B D1,D3; EOR.B D4,D6; EOR.B D5,D7
  SWAP D0;     SWAP D1;     SWAP D4;     SWAP D5
  ROR.L #8,D2; ROR.L #8,D3; ROR.L #8,D6; ROR.L #8,D7

/*

Not bad, now each of the 4 8x8 blocks contains exactly the data it should:

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
D0 |07|06|05|04|03|02|01|00|87|86|85|84|83|82|81|80|g7|g6|g5|g4|g3|g2|g1|g0|o7|o6|o5|o4|o3|o2|o1|o0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |47|46|45|44|43|42|41|40|c7|c6|c5|c4|c3|c2|c1|c0|k7|k6|k5|k4|k3|k2|k1|k0|s7|s6|s5|s4|s3|s2|s1|s0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |17|16|15|14|13|12|11|10|97|96|95|94|93|92|91|90|h7|h6|h5|h4|h3|h2|h1|h0|p7|p6|p5|p4|p3|p2|p1|p0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |57|56|55|54|53|52|51|50|d7|d6|d5|d4|d3|d2|d1|d0|l7|l6|l5|l4|l3|l2|l1|l0|t7|t6|t5|t4|t3|t2|t1|t0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |27|26|25|24|23|22|21|20|a7|a6|a5|a4|a3|a2|a1|a0|i7|i6|i5|i4|i3|i2|i1|i0|q7|q6|q5|q4|q3|q2|q1|q0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D5 |67|66|65|64|63|62|61|60|e7|e6|e5|e4|e3|e2|e1|e0|m7|m6|m5|m4|m3|m2|m1|m0|u7|u6|u5|u4|u3|u2|u1|u0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D6 |37|36|35|34|33|32|31|30|b7|b6|b5|b4|b3|b2|b1|b0|j7|j6|j5|j4|j3|j2|j1|j0|r7|r6|r5|r4|r3|r2|r1|r0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D7 |77|76|75|74|73|72|71|70|f7|f6|f5|f4|f3|f2|f1|f0|n7|n6|n5|n4|n3|n2|n1|n0|v7|v6|v5|v4|v3|v2|v1|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

Of course, still in a funny arrangement :)
As you already might have recognized, if we now had the bytes in the correct
vertical order, we could "simply" mirror each block at its main diagonal, then
the job would be finished.

Well, now what? (yes, for a change i ask _you_ ;)
Okay, i'll give you a minute to think (or 2, or 3 ... ;-)
Got it? So, if you answer was something like "Nothing.", "Not a lot.", "Think
differently.", "Look differently.", "You tell me.", ... just go on reading with
the next paragraph. But if you answer was something like "EXchanGe the
register.", little uncle Mr.WC will come to you with his huge ham.......mock and
ask you: "Why? Think again! Can't we access our registers randomly? Does some
arcane power force us to write the third register into the third bitplane?"

Yes, what we'll do is just rearranging our visualisation. Each piece of data
remains in the register it currently is. We'll just look at the lines in a
different order, but we'll always write the register in front of the line which
is held by this one:

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
D0 |07|06|05|04|03|02|01|00|87|86|85|84|83|82|81|80|g7|g6|g5|g4|g3|g2|g1|g0|o7|o6|o5|o4|o3|o2|o1|o0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |17|16|15|14|13|12|11|10|97|96|95|94|93|92|91|90|h7|h6|h5|h4|h3|h2|h1|h0|p7|p6|p5|p4|p3|p2|p1|p0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |27|26|25|24|23|22|21|20|a7|a6|a5|a4|a3|a2|a1|a0|i7|i6|i5|i4|i3|i2|i1|i0|q7|q6|q5|q4|q3|q2|q1|q0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D6 |37|36|35|34|33|32|31|30|b7|b6|b5|b4|b3|b2|b1|b0|j7|j6|j5|j4|j3|j2|j1|j0|r7|r6|r5|r4|r3|r2|r1|r0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |47|46|45|44|43|42|41|40|c7|c6|c5|c4|c3|c2|c1|c0|k7|k6|k5|k4|k3|k2|k1|k0|s7|s6|s5|s4|s3|s2|s1|s0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |57|56|55|54|53|52|51|50|d7|d6|d5|d4|d3|d2|d1|d0|l7|l6|l5|l4|l3|l2|l1|l0|t7|t6|t5|t4|t3|t2|t1|t0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D5 |67|66|65|64|63|62|61|60|e7|e6|e5|e4|e3|e2|e1|e0|m7|m6|m5|m4|m3|m2|m1|m0|u7|u6|u5|u4|u3|u2|u1|u0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D7 |77|76|75|74|73|72|71|70|f7|f6|f5|f4|f3|f2|f1|f0|n7|n6|n5|n4|n3|n2|n1|n0|v7|v6|v5|v4|v3|v2|v1|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

At this point it is possible to restrict our considerations to only one 8x8
block, as the operations we perform on this one are simultaneously performed on
the other ones as well, yielding analogous results.

Okay, now we need to do this mirroring i mentioned above, but we will _not_
exchange each single bit with its counterpart on the other side of the diagonal.
You can easily imagine how inefficiently slow this would be. Fortunately there
is a different method, which is _relatively_ simple and can be done in three
stages with 4 substeps each (3*4 = 12 instead of (8*8-8)/2 = 28 for swapping
single bits).

The key is binary subdivision. As our blocks are areas, subdividing once leaves
us with 4 smaller squares, each 4x4 in size. All bits of the upper right and the
lower left 4x4 square are on the wrong size, what means, that we are able to
simply swap over these two squares. I guess you can already imagine the next two
stages, but we'll first handle this one, in order not to break the interweaving
with the source code.

This time we'll use the masking technique, enabling us to cover all four 8x8
blocks at once. But of course we can't do the operations on many registers
simultaneously, resulting in the previously mentioned substeps.

The idea is to extract only the bits of interest by ANDing them with a bitmask
(naturally, ORing would be possible as well, but this way is not that obvious,
thus we'll stick to the conventional method) and then exchanging them among the
two corresponding registers.

In short (to be done for both counterparts, while one of them was rotated into
position before):
1) load reg into help reg 2) gain bits to exchange by applying bitmask to help
reg 3) xor help reg back into reg to null out extracted bits 4) add/or/xor help
reg into counter reg which was nulled out with counter help reg before

As you can see, we need two spare registers to intermediately hold the bits to
exchange. Unfortunately we can't use address registers for that purpose, as
logical operations aren't possible with them. But we can't scratch on any of the
data registers either, as they are completely filled with required data. The
solution is to make use of the address registers in an indirect manner by using
them as safe places to temporarily swap out two data registers which we don't
need immediately. The caveat of doing so is, that we produce a big mess
concerning which line of our visualisation is held by which register. That means
we have to take great care for always updating our visualisation to correctly
show which registers hold what.

Let's just do it. At first we have to swap out two registers to make them
available as intermediate operands:
*/

-> Save Regs
  MOVE.L D6,A5; MOVE.L D7,A6

/*
That's how the correctly updated visualisation looks like:

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
D0 |07|06|05|04|03|02|01|00|87|86|85|84|83|82|81|80|g7|g6|g5|g4|g3|g2|g1|g0|o7|o6|o5|o4|o3|o2|o1|o0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |17|16|15|14|13|12|11|10|97|96|95|94|93|92|91|90|h7|h6|h5|h4|h3|h2|h1|h0|p7|p6|p5|p4|p3|p2|p1|p0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |27|26|25|24|23|22|21|20|a7|a6|a5|a4|a3|a2|a1|a0|i7|i6|i5|i4|i3|i2|i1|i0|q7|q6|q5|q4|q3|q2|q1|q0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
A5 |37|36|35|34|33|32|31|30|b7|b6|b5|b4|b3|b2|b1|b0|j7|j6|j5|j4|j3|j2|j1|j0|r7|r6|r5|r4|r3|r2|r1|r0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |47|46|45|44|43|42|41|40|c7|c6|c5|c4|c3|c2|c1|c0|k7|k6|k5|k4|k3|k2|k1|k0|s7|s6|s5|s4|s3|s2|s1|s0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |57|56|55|54|53|52|51|50|d7|d6|d5|d4|d3|d2|d1|d0|l7|l6|l5|l4|l3|l2|l1|l0|t7|t6|t5|t4|t3|t2|t1|t0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D5 |67|66|65|64|63|62|61|60|e7|e6|e5|e4|e3|e2|e1|e0|m7|m6|m5|m4|m3|m2|m1|m0|u7|u6|u5|u4|u3|u2|u1|u0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
A6 |77|76|75|74|73|72|71|70|f7|f6|f5|f4|f3|f2|f1|f0|n7|n6|n5|n4|n3|n2|n1|n0|v7|v6|v5|v4|v3|v2|v1|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
*/

-> 4-Bit-Scramble
  ROR.L #4,D1; MOVE.L D0,D6; MOVE.L D1,D7; AND.L #$0F0F0F0F,D6; AND.L #$0F0F0F0F,D7; EOR.L D6,D0; EOR.L D7,D1; OR.L D6,D1; OR.L D7,D0; ROL.L #4,D1
  ROR.L #4,D3; MOVE.L D2,D6; MOVE.L D3,D7; AND.L #$0F0F0F0F,D6; AND.L #$0F0F0F0F,D7; EOR.L D6,D2; EOR.L D7,D3; OR.L D6,D3; OR.L D7,D2; ROL.L #4,D3
  ROR.L #4,D5; MOVE.L D4,D6; MOVE.L D5,D7; AND.L #$0F0F0F0F,D6; AND.L #$0F0F0F0F,D7; EOR.L D6,D4; EOR.L D7,D5; OR.L D6,D5; OR.L D7,D4; ROL.L #4,D5
  EXG D0,A5; EXG D4,A6  -> here we get the previously swapped out registers
                        -> back, since we have to perform the operations on them
                        -> as well, and at the same time we swap out other
                        -> registers, as we permanently need spare registers
  ROR.L #4,D4; MOVE.L D0,D6; MOVE.L D4,D7; AND.L #$0F0F0F0F,D6; AND.L #$0F0F0F0F,D7; EOR.L D6,D0; EOR.L D7,D4; OR.L D6,D4; OR.L D7,D0; ROL.L #4,D4

/*
Here's what that made out of it:

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
A5 |07|06|05|04|47|46|45|44|87|86|85|84|c7|c6|c5|c4|g7|g6|g5|g4|k7|k6|k5|k4|o7|o6|o5|o4|s7|s6|s5|s4|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |17|16|15|14|57|56|55|54|97|96|95|94|d7|d6|d5|d4|h7|h6|h5|h4|l7|l6|l5|l4|p7|p6|p5|p4|t7|t6|t5|t4|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
A6 |27|26|25|24|67|66|65|64|a7|a6|a5|a4|e7|e6|e5|e4|i7|i6|i5|i4|m7|m6|m5|m4|q7|q6|q5|q4|u7|u6|u5|u4|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D0 |37|36|35|34|77|76|75|74|b7|b6|b5|b4|f7|f6|f5|f4|j7|j6|j5|j4|n7|n6|n5|n4|r7|r6|r5|r4|v7|v6|v5|v4|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |03|02|01|00|43|42|41|40|83|82|81|80|c3|c2|c1|c0|g3|g2|g1|g0|k3|k2|k1|k0|o3|o2|o1|o0|s3|s2|s1|s0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |13|12|11|10|53|52|51|50|93|92|91|90|d3|d2|d1|d0|h3|h2|h1|h0|l3|l2|l1|l0|p3|p2|p1|p0|t3|t2|t1|t0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D5 |23|22|21|20|63|62|61|60|a3|a2|a1|a0|e3|e2|e1|e0|i3|i2|i1|i0|m3|m2|m1|m0|q3|q2|q1|q0|u3|u2|u1|u0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |33|32|31|30|73|72|71|70|b3|b2|b1|b0|f3|f2|f1|f0|j3|j2|j1|j0|n3|n2|n1|n0|r3|r2|r1|r0|v3|v2|v1|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

Let's go for the next stage. We just look at each 4x4 square and do the same
with them what we did with the 8x8 block, namely subdivide it into four smaller
blocks (2x2) and swap over two of them. That's exactly the same technique just
with different rotation and masking parameters.
*/

-> 2-Bit-Scramble
  ROR.L #2,D0; MOVE.L D2,D6; MOVE.L D0,D7; AND.L #$33333333,D6; AND.L #$33333333,D7; EOR.L D6,D2; EOR.L D7,D0; OR.L D6,D0; OR.L D7,D2; ROL.L #2,D0
  ROR.L #2,D5; MOVE.L D1,D6; MOVE.L D5,D7; AND.L #$33333333,D6; AND.L #$33333333,D7; EOR.L D6,D1; EOR.L D7,D5; OR.L D6,D5; OR.L D7,D1; ROL.L #2,D5
  ROR.L #2,D4; MOVE.L D3,D6; MOVE.L D4,D7; AND.L #$33333333,D6; AND.L #$33333333,D7; EOR.L D6,D3; EOR.L D7,D4; OR.L D6,D4; OR.L D7,D3; ROL.L #2,D4
  EXG D5,A5; EXG D4,A6
  ROR.L #2,D4; MOVE.L D5,D6; MOVE.L D4,D7; AND.L #$33333333,D6; AND.L #$33333333,D7; EOR.L D6,D5; EOR.L D7,D4; OR.L D6,D4; OR.L D7,D5; ROL.L #2,D4

/*
Fortunately, nothing unexpected happened ;)

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
D5 |07|06|27|26|47|46|67|66|87|86|a7|a6|c7|c6|e7|e6|g7|g6|i7|i6|k7|k6|m7|m6|o7|o6|q7|q6|s7|s6|u7|u6|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |17|16|37|36|57|56|77|76|97|96|b7|b6|d7|d6|f7|f6|h7|h6|j7|j6|l7|l6|n7|n6|p7|p6|r7|r6|t7|t6|v7|v6|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |05|04|25|24|45|44|65|64|85|84|a5|a4|c5|c4|e5|e4|g5|g4|i5|i4|k5|k4|m5|m4|o5|o4|q5|q4|s5|s4|u5|u4|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D0 |15|14|35|34|55|54|75|74|95|94|b5|b4|d5|d4|f5|f4|h5|h4|j5|j4|l5|l4|n5|n4|p5|p4|r5|r4|t5|t4|v5|v4|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |03|02|23|22|43|42|63|62|83|82|a3|a2|c3|c2|e3|e2|g3|g2|i3|i2|k3|k2|m3|m2|o3|o2|q3|q2|s3|s2|u3|u2|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |13|12|33|32|53|52|73|72|93|92|b3|b2|d3|d2|f3|f2|h3|h2|j3|j2|l3|l2|n3|n2|p3|p2|r3|r2|t3|t2|v3|v2|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
A5 |01|00|21|20|41|40|61|60|81|80|a1|a0|c1|c0|e1|e0|g1|g0|i1|i0|k1|k0|m1|m0|o1|o0|q1|q0|s1|s0|u1|u0|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
A6 |11|10|31|30|51|50|71|70|91|90|b1|b0|d1|d0|f1|f0|h1|h0|j1|j0|l1|l0|n1|n0|p1|p0|r1|r0|t1|t0|v1|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

And the final stage is of course as simple as the preceding two. Simply swapping
two (the upper right and the lower left) bits in each 2x2 block.
*/

-> 1-Bit-Scramble
  ROR.L #1,D2; MOVE.L D5,D6; MOVE.L D2,D7; AND.L #$55555555,D6; AND.L #$55555555,D7; EOR.L D6,D5; EOR.L D7,D2; OR.L D6,D2; OR.L D7,D5; ROL.L #1,D2
  ROR.L #1,D0; MOVE.L D4,D6; MOVE.L D0,D7; AND.L #$55555555,D6; AND.L #$55555555,D7; EOR.L D6,D4; EOR.L D7,D0; OR.L D6,D0; OR.L D7,D4; ROL.L #1,D0
  ROR.L #1,D3; MOVE.L D1,D6; MOVE.L D3,D7; AND.L #$55555555,D6; AND.L #$55555555,D7; EOR.L D6,D1; EOR.L D7,D3; OR.L D6,D3; OR.L D7,D1; ROL.L #1,D3
  EXG D5,A5; EXG D0,A6
  ROR.L #1,D0; MOVE.L D5,D6; MOVE.L D0,D7; AND.L #$55555555,D6; AND.L #$55555555,D7; EOR.L D6,D5; EOR.L D7,D0; OR.L D6,D0; OR.L D7,D5; ROL.L #1,D0

/*
Et voilà, here's the astonishing result:

    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   ·-----------------------------------------------------------------------------------------------·
A5 |07|17|27|37|47|57|67|77|87|97|a7|b7|c7|d7|e7|f7|g7|h7|i7|j7|k7|l7|m7|n7|o7|p7|q7|r7|s7|t7|u7|v7|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D2 |06|16|26|36|46|56|66|76|86|96|a6|b6|c6|d6|e6|f6|g6|h6|i6|j6|k6|l6|m6|n6|o6|p6|q6|r6|s6|t6|u6|v6|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D4 |05|15|25|35|45|55|65|75|85|95|a5|b5|c5|d5|e5|f5|g5|h5|i5|j5|k5|l5|m5|n5|o5|p5|q5|r5|s5|t5|u5|v5|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
A6 |04|14|24|34|44|54|64|74|84|94|a4|b4|c4|d4|e4|f4|g4|h4|i4|j4|k4|l4|m4|n4|o4|p4|q4|r4|s4|t4|u4|v4|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D1 |03|13|23|33|43|53|63|73|83|93|a3|b3|c3|d3|e3|f3|g3|h3|i3|j3|k3|l3|m3|n3|o3|p3|q3|r3|s3|t3|u3|v3|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D3 |02|12|22|32|42|52|62|72|82|92|a2|b2|c2|d2|e2|f2|g2|h2|i2|j2|k2|l2|m2|n2|o2|p2|q2|r2|s2|t2|u2|v2|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D5 |01|11|21|31|41|51|61|71|81|91|a1|b1|c1|d1|e1|f1|g1|h1|i1|j1|k1|l1|m1|n1|o1|p1|q1|r1|s1|t1|u1|v1|
   |--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
D0 |00|10|20|30|40|50|60|70|80|90|a0|b0|c0|d0|e0|f0|g0|h0|i0|j0|k0|l0|m0|n0|o0|p0|q0|r0|s0|t0|u0|v0|
   ·-----------------------------------------------------------------------------------------------·
    31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

All bits at the positions we wanted them to be. Now the only thing that's left
to do is writing out the data into the bitmap, which might be done by using
either predecrements or postincrements, as we can always randomly chose, which
register to put. Note that our topmost line represents the most significant
bitplane, i.e. bitplane#7 and not bitplane#0.
*/

  MOVE.L A7,A2
  MOVE.L (A2),A3; MOVE.L D0,(A3)+; MOVE.L A3,(A2)+  -> not only the pointer into
  MOVE.L (A2),A3; MOVE.L D5,(A3)+; MOVE.L A3,(A2)+  -> the plane pointer table,
  MOVE.L (A2),A3; MOVE.L D3,(A3)+; MOVE.L A3,(A2)+  -> but also the bitplane
  MOVE.L (A2),A3; MOVE.L D1,(A3)+; MOVE.L A3,(A2)+  -> pointers need to be
  MOVE.L (A2),A3; MOVE.L A6,(A3)+; MOVE.L A3,(A2)+  -> incremented
  MOVE.L (A2),A3; MOVE.L D4,(A3)+; MOVE.L A3,(A2)+
  MOVE.L (A2),A3; MOVE.L D2,(A3)+; MOVE.L A3,(A2)+
  MOVE.L (A2),A3; MOVE.L A5,(A3)+; MOVE.L A3,(A2)

-> the rest is trivial

  CMPA.L A1,A0
  BCS _c2p_loop_

  LEA $20(A7),A7
  MOVEM.L (A7)+,A4/A5
ENDPROC D0

PROC main() HANDLE
DEF buf1:PTR TO CHAR,buf2:PTR TO CHAR,raster,scr=NIL:PTR TO screen,t=0,x,y

  IF (scr:=OpenS(320,256,8,0,NIL))=NIL THEN Raise("SCR")

  NEW buf1[320*256]
  NEW buf2[320*256]

  FOR y:=0 TO 255
    FOR x:=0 TO 319
      buf1[t]:=x*y
      buf2[t++]:=x*x+(y*y)
    ENDFOR
  ENDFOR

  FOR t:=0 TO 255 DO SetColour(scr,t,t,t,t)

  installvbi()

  REPEAT
    t:=IF t-buf1 THEN buf1 ELSE buf2

    WaitTOF()

    Forbid()
    raster:=time()
    c2p(t,scr.bitmap)
    raster:=time()-raster
    Permit()

-> here, raster line calculation is hardcoded for PAL
    WriteF('\d raster lines (\d ticks + \d lines)\n',raster:=Shr(raster+128,8),raster/313,Mod(raster,313))
  UNTIL Mouse() OR CtrlC()

  removevbi()

EXCEPT DO
  IF scr THEN CloseS(scr)

  IF exception THEN WriteF('ERROR!!!\n')
ENDPROC

PROC time()
  LEA $DFF004,A0
_time_loop_:
  MOVE.L (A0),D2
  NOP
  MOVE.L ticks,D1
  NOP
  MOVE.L (A0),D0
-> i have seen this read-before-and-after-then-check-for-validity trick
-> somewhere in the OS where the time is read out of the cia timers
  CMP.L D2,D0
  BCS.S _time_loop_
  AND.L #$1FFFF,D0
  ADD.L D1,D0
ENDPROC D0
PROC installvbi()
  is::ln.type:=2
  is::ln.pri:=0
  is::ln.name:='Mr.WC\as C2P test interrupt'
  is.data:={ticks}
  is.code:={vbi}
  AddIntServer(5,is)
ENDPROC D0
PROC removevbi() IS RemIntServer(5,is)
vbi:
  ADD.L #$13900,(A1)  -> 313 raster lines, hardcoded for PAL
  MOVEQ #0,D0
  RTS

-> if you see strange comments here at the end, those are the fold data that
-> EE saves along with the source to remember, when loading the file, which
-> procedures were folded

/*EE folds
0
475 40 477 14 478 7 
EE folds*/
