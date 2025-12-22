OPT MODULE, EXPORT, PREPROCESS

-> emul/emulregs.e

#define REG_D0 0(R2)
#define REG_D1 4(R2)
#define REG_D2 8(R2)
#define REG_D3 12(R2)
#define REG_D4 16(R2)
#define REG_D5 20(R2)
#define REG_D6 24(R2)
#define REG_D7 28(R2)

#define REG_A0 32(R2)
#define REG_A1 36(R2)
#define REG_A2 40(R2)
#define REG_A3 44(R2)
#define REG_A4 48(R2)
#define REG_A5 52(R2)
#define REG_A6 56(R2)
#define REG_A7 60(R2)

#define REG_PC 64(R2) -> was missing
#define REG_SR 68(R2) -> was missing

#define QREG_PC R13
#define QREG_SR R14

#define QREG_D0 R16
#define QREG_D1 R17
#define QREG_D2 R18
#define QREG_D3 R19
#define QREG_D4 R20
#define QREG_D5 R21
#define QREG_D6 R22
#define QREG_D7 R23

#define QREG_A0 R24
#define QREG_A1 R25
#define QREG_A2 R26
#define QREG_A3 R27
#define QREG_A4 R28
#define QREG_A5 R29
#define QREG_A6 R30
#define QREG_A7 R31




