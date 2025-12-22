/* Generate .gg-files:
 * 1. Process these macros
 * 2. Sort lines by offset
 * 3. Delete redundant offsets - convert the rest of them into @offset-commands
 * 4. Delete all whitespace
 * 5. Convert ';' into '\n' and '.' into ' '
 */

#define FD0(offset,type,name)\
offset name;

#define FD1(offset,type,name,a1,r1)\
offset name,r1;

#define FD2(offset,type,name,a1,r1,a2,r2)\
offset name,r1 r2;

#define FD3(offset,type,name,a1,r1,a2,r2,a3,r3)\
offset name,r1 r2 r3;

#define FD4(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4)\
offset name,r1 r2 r3 r4;

#define FD5(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4,a5,r5)\
offset name,r1 r2 r3 r4 r5;

#define FD0F(offset,_flags,type,name)\
offset @flags.+_flags;name;@flags.-_flags;

#define D0 0
#define D1 1
#define D2 2
#define D3 3
#define D4 4
#define D5 5
#define D6 6
#define D7 7
#define A0 8
#define A1 9
#define A2 a
#define A3 b
#define A4 c
#define A5 d
#define A6 e
#define A7 f
#define SP f
