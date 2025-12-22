/* Prototypes for functions defined in
io.c  
 */

int  io_AllocParPort(void);

int  io_AllocJoyPort(void);

void  io_FreeParPort(void);

void  io_SetParDirA(int, int );

void  io_SetExtParDirA(int, int );

void  io_SetJoy2DirA(  int ,   int );

void  io_SetJoy1DirA(  int ,   int );

void  io_SetJoy1Dir(  UBYTE );

void  io_SetJoy2Dir(  UBYTE );

void  io_SetParDir(  UBYTE );

void  io_SetExtParDir(  UBYTE );

void  io_WriteJoy1A(  int ,   int );

void  io_WriteJoy2A(  int ,   int );

void  io_WriteExtParA(  int ,   int );

void  io_WriteParA(  int ,   int );

void  io_WritePar(  UBYTE );

void  io_WriteExtPar(  UBYTE );

void  io_WriteJoy1(  UBYTE );

void  io_WriteJoy2(  UBYTE );

int  io_ReadParA(  int );

UBYTE  io_ReadPar(void);

int  io_ReadExtParA(  int );

int  io_ReadJoy2A(  int );

int  io_ReadJoy1A(  int );

void  io_ResetPar(void);

void  io_ResetExtPar(void);

void  io_ResetJoy1(void);

void  io_ResetJoy2(void);

void io_WriteLed(int);

int io_ReadExtJoy2A(int);

UBYTE io_ReadExtJoy2(void);