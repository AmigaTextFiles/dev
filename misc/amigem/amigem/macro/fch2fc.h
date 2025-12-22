/* Generate .fc-files:
 * 1. Process these macros
 * 2. Delete all whitespace
 * 3. Convert ';' into '\n' and '.' into ' '
 */

#define FC0(_offset,type,name,r0)\
@offset._offset;@basereg.r0;name;

#define FC1(_offset,type,name,r0,a1,r1)\
@offset._offset;@basereg.r0;name,r1;

#define FC2(_offset,type,name,r0,a1,r1,a2,r2)\
@offset._offset;@basereg.r0;name,r1 r2;

#define FC3(_offset,type,name,r0,a1,r1,a2,r2,a3,r3)\
@offset._offset;@basereg.r0;name,r1 r2 r3;

#define FC4(_offset,type,name,r0,a1,r1,a2,r2,a3,r3,a4,r4)\
@offset._offset;@basereg.r0;name,r1 r2 r3 r4;

#define FC5(_offset,type,name,r0,a1,r1,a2,r2,a3,r3,a4,r4,a5,r5)\
@offset._offset;@basereg.r0;name,r1 r2 r3 r4 r5;

#define FC1F(_offset,_flags,type,name,r0,a1,r1)\
@offset._offset;@basereg.r0;@flags.+_flags;name,r1;@flags.-_flags;

#define FC2F(_offset,_flags,type,name,r0,a1,r1,a2,r2)\
@offset._offset;@basereg.r0;@flags.+_flags;name,r1 r2;@flags.-_flags;

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
