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

#define QREG_PC 13
#define QREG_SR 14
#define QREG_OCT 15

#define QREG_D0 16
#define QREG_D1 17
#define QREG_D2 18
#define QREG_D3 19
#define QREG_D4 20
#define QREG_D5 21
#define QREG_D6 22
#define QREG_D7 23

#define QREG_A0 24
#define QREG_A1 25
#define QREG_A2 26
#define QREG_A3 27
#define QREG_A4 28
#define QREG_A5 29
#define QREG_A6 30
#define QREG_A7 31




