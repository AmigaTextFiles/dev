#define HSIZEBITS  6
#define VSIZEBITS  16-HSIZEBITS
#define HSIZEMASK  $3f	      
#define VSIZEMASK  $3FF       
#define ABC     $80
#define ABNC    $40
#define ANBC    $20
#define ANBNC   $10
#define NABC    $8
#define NABNC   $4
#define NANBC   $2
#define NANBNC  $1
#define A_OR_B 	  ABC|ANBC|NABC | ABNC|ANBNC|NABNC
#define A_OR_C 	  ABC|NABC|ABNC | ANBC|NANBC|ANBNC
#define A_XOR_C    NABC|ABNC   | NANBC|ANBNC
#define A_TO_D 	  ABC|ANBC|ABNC|ANBNC
#define BC0B_DEST  8
#define BC0B_SRCC  9
#define BC0B_SRCB    10
#define BC0B_SRCA  11
#define BC0F_DEST  $100
#define BC0F_SRCC  $200
#define BC0F_SRCB  $400
#define BC0F_SRCA  $800
#define BC1F_DESC    2	     
#define DEST  $100
#define SRCC  $200
#define SRCB  $400
#define SRCA  $800
#define ASHIFTSHIFT   12      
#define BSHIFTSHIFT   12      
#define LINEMODE      $1
#define FILL_OR       $8
#define FILL_XOR      $10
#define FILL_CARRYIN  $4
#define ONEDOT 	     $2      
#define OVFLAG 	     $20
#define SIGNFLAG      $40
#define BLITREVERSE   $2
#define SUD 	     $10
#define SUL 	     $8
#define AUL 	     $4
#define OCTANT8    24
#define OCTANT7    4
#define OCTANT6    12
#define OCTANT5    28
#define OCTANT4    20
#define OCTANT3    8
#define OCTANT2    0
#define OCTANT1    16

OBJECT bltnode
	n:PTR TO bltnode,
	function:PTR TO LONG,
	stat:UBYTE,
	blitsize:WORD,
	beamsync:WORD,
	cleanup:PTR TO LONG

#define CLEANUP  $40
#define CLEANME  CEANUP
