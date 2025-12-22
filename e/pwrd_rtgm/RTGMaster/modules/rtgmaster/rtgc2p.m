//     $VER: rtgsublibs.i 1.007 (15 Jan 1998)

OBJECT c2p_Info
	ColorDepth:WORD,             //CI_256, CI_128, CI_64, CI_EHB, CI_32..
	CPU:WORD,                    //CI_68060, CI_68040, CI_68030....
	Needs:WORD,                  //CI_Aikiko, CI_MMU, CI_FPU...
	Dirty:BYTE,                  //TRUE/FALSE
	Hack:BYTE,                   //TRUE/FALSE
	PixelSize:ULONG,             //c2p_1x1...
	WidthAlign:WORD,             //Width has to be divisible by <number>
	HeightAlign:WORD,            //Height has to be divisible by <number>
	Misc:WORD,                   //Different stuff...
	AmiCompatible:ULONG,         //Is this compatible to RtgScreenAMI ?
	Description:PTR,             //Pointer to a string
	Initialization:PTR,          //Pointer to Initialization code
	Expunge:PTR,                 //Pointer to Expunge code
	Normal_c2p:PTR,              //Pointer to c2p code
	Normal_c2p_InterL:PTR,       //Pointer to Interleaved c2p
	Scrambled_c2p:PTR,           //Pointer to Scrambled c2p
	Scrambled_c2p_InterL:PTR,    //Pointer to Scrambled Interleaved c2p
	Asynchrone:BYTE              //TRUE/FALSE

// CI_Colordepth
#define CI_256  256
#define CI_128  128
#define CI_64   64
#define CI_EHB  32
#define CI_32   16
#define CI_16   8
#define CI_8    4
#define CI_4    2
#define CI_2    1

// CI_CPU
#define CI_68060  1
#define CI_68040  2
#define CI_68030  4
#define CI_68020  8
#define CI_68060D  16
#define CI_68040D  32
#define CI_68030D  64
#define CI_68020D  128

// CI_Needs
#define CI_68060N  1
#define CI_68040N  2
#define CI_68030N  4
#define CI_Aikiko  8
#define CI_MMU     16
#define CI_FPU     32
#define CI_FAST    64
#define CI_2MB     128

// CI_Misc
#define CI_Smaller  1
#define CI_Fixed    2
#define CI_Destruct  4
#define c2p_1x1  1
#define c2p_1x2  2
#define c2p_2x1  4
#define c2p_2x2  8
#define c2p_4x2  16
#define c2p_2x4  32
#define c2p_4x4  64
#define c2p_Best  128
#define c2p_Fastest  256
#define c2p_Selected  512
#define c2p_1x1D  1024
#define c2p_1x2D  2048
#define c2p_2x1D  4096
#define c2p_2x2D  8192
#define c2p_4x2D  16384
#define c2p_2x4D  32768
#define c2p_4x4D  65536
#define c2p_BestD  131072
#define c2p_FastestD  262144
#define c2p_SelectedD  524288
#define c2p_err_Wrong_C2P  1
#define c2p_err_Wrong_Depth  2
#define c2p_warn_Wrong_Pixelmode  3
#define c2p_err_Wrong_Windowsize  4
#define c2p_warn_divisible  5
#define c2p_err_hardware  6
#define c2p_err_memory  7
#define c2p_err_internal  8
#define c2p_warn_internal  9

