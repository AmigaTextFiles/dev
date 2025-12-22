#include "NativeCodeGenerator.h"
#include "CompilerTypes.h"

#define JUMP_TO_BRANCH	1

static bool CheckFunc;
static bool CheckCase;


static const int CPU_REG_A = 256;
static const int CPU_REG_X = 257;
static const int CPU_REG_Y = 258;
static const int CPU_REG_C = 259;
static const int CPU_REG_Z = 260;

static const int NUM_REGS = 261;

static const uint32 LIVE_CPU_REG_A = 0x00000001;
static const uint32 LIVE_CPU_REG_X = 0x00000002;
static const uint32 LIVE_CPU_REG_Y = 0x00000004;
static const uint32 LIVE_CPU_REG_C = 0x00000008;
static const uint32 LIVE_CPU_REG_Z = 0x00000010;
static const uint32 LIVE_MEM	   = 0x00000020;

static const uint32 LIVE_ALL	   = 0x000000ff;

static int GlobalValueNumber = 0;

NativeRegisterData::NativeRegisterData(void)
	: mMode(NRDM_UNKNOWN), mValue(GlobalValueNumber++), mMask(0)
{

}

void NativeRegisterData::Reset(void)
{
	mMode = NRDM_UNKNOWN;
	mValue = GlobalValueNumber++;
}

void NativeRegisterData::ResetMask(void)
{
	mMask = 0;
}

bool NativeRegisterData::SameData(const NativeCodeInstruction& ins) const
{
	if (ins.mMode == ASMIM_ZERO_PAGE)
		return mMode == NRDM_ZERO_PAGE && mValue == ins.mAddress;
	else if (ins.mMode == ASMIM_ABSOLUTE)
		return mMode == NRDM_ABSOLUTE && mValue == ins.mAddress && mLinkerObject == ins.mLinkerObject && mFlags == ins.mFlags;
	else if (ins.mMode == ASMIM_ABSOLUTE_X)
		return mMode == NRDM_ABSOLUTE_X && mValue == ins.mAddress && mLinkerObject == ins.mLinkerObject && mFlags == ins.mFlags;
	else if (ins.mMode == ASMIM_ABSOLUTE_Y)
		return mMode == NRDM_ABSOLUTE_Y && mValue == ins.mAddress && mLinkerObject == ins.mLinkerObject && mFlags == ins.mFlags;
	else if (ins.mMode == ASMIM_INDIRECT_Y)
		return mMode == NRDM_INDIRECT_Y && mValue == ins.mAddress;
	else
		return false;
}

bool NativeRegisterData::SameData(const NativeRegisterData& d) const
{
	if (mMode != d.mMode)
		return false;

	switch (mMode)
	{
	case NRDM_UNKNOWN:
	case NRDM_IMMEDIATE:
	case NRDM_ZERO_PAGE:
		return mValue == d.mValue;
	case NRDM_IMMEDIATE_ADDRESS:
	case NRDM_ABSOLUTE:
		return mValue == d.mValue && mLinkerObject == d.mLinkerObject && mFlags == d.mFlags;
	default:
		return false;
	}
}

void NativeRegisterDataSet::Reset(void)
{
	for (int i = 0; i < NUM_REGS; i++)
		mRegs[i].Reset();
}

void NativeRegisterDataSet::ResetMask(void)
{
	for (int i = 0; i < NUM_REGS; i++)
		mRegs[i].ResetMask();
}



void NativeRegisterDataSet::ResetWorkRegs(void)
{
	ResetZeroPage(BC_REG_WORK_Y);
	ResetZeroPage(BC_REG_ADDR + 0);
	ResetZeroPage(BC_REG_ADDR + 1);

	for (int i = 0; i < 4; i++)
		ResetZeroPage(BC_REG_ACCU + i);
	for (int i = 0; i < 8; i++)
		ResetZeroPage(BC_REG_WORK + i);
}

void NativeRegisterDataSet::ResetWorkMasks(void)
{
	mRegs[BC_REG_WORK_Y].ResetMask();
	mRegs[BC_REG_ADDR + 0].ResetMask();
	mRegs[BC_REG_ADDR + 1].ResetMask();

	for (int i = 0; i < 4; i++)
		mRegs[BC_REG_ACCU + i].ResetMask();
	for (int i = 0; i < 8; i++)
		mRegs[BC_REG_WORK + i].ResetMask();
}


void NativeRegisterDataSet::ResetZeroPage(int addr)
{
	mRegs[addr].Reset();
	for (int i = 0; i < NUM_REGS; i++)
	{
		if (mRegs[i].mMode == NRDM_ZERO_PAGE && mRegs[i].mValue == addr)
			mRegs[i].Reset();
		else if (mRegs[i].mMode == NRDM_INDIRECT_Y && (mRegs[i].mValue == addr || mRegs[i].mValue + 1 == addr))
			mRegs[i].Reset();
	}
}

int NativeRegisterDataSet::FindAbsolute(LinkerObject* linkerObject, int addr)
{
	for (int i = 0; i < 256; i++)
	{
		if (mRegs[i].mMode == NRDM_ABSOLUTE	&& mRegs[i].mLinkerObject == linkerObject && mRegs[i].mValue == addr)
			return i;
	}

	return -1;
}

void NativeRegisterDataSet::ResetAbsolute(LinkerObject* linkerObject, int addr)
{
	for (int i = 0; i < NUM_REGS; i++)
	{
		if ((mRegs[i].mMode == NRDM_ABSOLUTE || mRegs[i].mMode == NRDM_ABSOLUTE_X || mRegs[i].mMode == NRDM_ABSOLUTE_Y)
			&& mRegs[i].mLinkerObject == linkerObject && mRegs[i].mValue == addr)
			mRegs[i].Reset();
		else if (mRegs[i].mMode == NRDM_INDIRECT_Y)
			mRegs[i].Reset();
	}
}

void NativeRegisterDataSet::ResetX(void)
{
	for (int i = 0; i < NUM_REGS; i++)
	{
		if (mRegs[i].mMode == NRDM_ABSOLUTE_X)
			mRegs[i].Reset();
	}
}

void NativeRegisterDataSet::ResetY(void)
{
	for (int i = 0; i < NUM_REGS; i++)
	{
		if (mRegs[i].mMode == NRDM_ABSOLUTE_Y || mRegs[i].mMode == NRDM_INDIRECT_Y )
			mRegs[i].Reset();
	}
}

void NativeRegisterDataSet::ResetIndirect(int reg)
{
	for (int i = 0; i < NUM_REGS; i++)
	{
		if (mRegs[i].mMode == NRDM_ABSOLUTE ||
			mRegs[i].mMode == NRDM_ABSOLUTE_X ||
			mRegs[i].mMode == NRDM_ABSOLUTE_Y)
		{
			if (reg != BC_REG_STACK || !mRegs[i].mLinkerObject)
				mRegs[i].Reset();
		}
		else if (mRegs[i].mMode == NRDM_INDIRECT_Y )
		{
			mRegs[i].Reset();
		}
	}
}


void NativeRegisterDataSet::IntersectMask(const NativeRegisterDataSet& set)
{
	for (int i = 0; i < NUM_REGS; i++)
	{
		mRegs[i].mMask &= set.mRegs[i].mMask & ~(mRegs[i].mValue ^ set.mRegs[i].mValue);
	}
}


void NativeRegisterDataSet::Intersect(const NativeRegisterDataSet& set)
{

	for (int i = 0; i < NUM_REGS; i++)
	{
		if (mRegs[i].mMode == NRDM_UNKNOWN)
		{
			if (set.mRegs[i].mMode != NRDM_UNKNOWN || mRegs[i].mValue != set.mRegs[i].mValue)
				mRegs[i].Reset();
		}
		else if (mRegs[i].mMode == NRDM_IMMEDIATE)
		{
			if (set.mRegs[i].mMode != NRDM_IMMEDIATE || mRegs[i].mValue != set.mRegs[i].mValue)
				mRegs[i].Reset();
		}
		else if (mRegs[i].mMode == NRDM_IMMEDIATE_ADDRESS)
		{
			if (set.mRegs[i].mMode != NRDM_IMMEDIATE_ADDRESS || mRegs[i].mValue != set.mRegs[i].mValue || mRegs[i].mLinkerObject != set.mRegs[i].mLinkerObject || mRegs[i].mFlags != set.mRegs[i].mFlags)
				mRegs[i].Reset();
		}
	}

	bool	changed;
	do
	{
		changed = false;

		for (int i = 0; i < NUM_REGS; i++)
		{
			if (mRegs[i].mMode == NRDM_ZERO_PAGE)
			{
				if (set.mRegs[i].mMode != NRDM_ZERO_PAGE || mRegs[i].mValue != set.mRegs[i].mValue)
				{
					mRegs[i].Reset();
					changed = true;
				}
#if 0
				else if (mRegs[mRegs[i].mValue].mValue != set.mRegs[set.mRegs[i].mValue].mValue)
				{
					mRegs[i].Reset();
					changed = true;
				}
#endif
			}
			else if (mRegs[i].mMode == NRDM_ABSOLUTE)
			{
				if (set.mRegs[i].mMode != NRDM_ABSOLUTE || mRegs[i].mValue != set.mRegs[i].mValue || mRegs[i].mLinkerObject != set.mRegs[i].mLinkerObject)
				{
					mRegs[i].Reset();
					changed = true;
				}
			}
			else if (mRegs[i].mMode == NRDM_INDIRECT_Y)
			{
				if (set.mRegs[i].mMode != NRDM_INDIRECT_Y || mRegs[i].mValue != set.mRegs[i].mValue || !mRegs[CPU_REG_Y].SameData(set.mRegs[CPU_REG_Y]))
				{
					mRegs[i].Reset();
					changed = true;
				}
				else
				{
					int reg = mRegs[i].mValue;
					if (!mRegs[reg].SameData(set.mRegs[reg]) || !mRegs[reg + 1].SameData(set.mRegs[reg + 1]))
					{
						mRegs[i].Reset();
						changed = true;
					}
				}
			}
			else if (mRegs[i].mMode == NRDM_ABSOLUTE_X || mRegs[i].mMode == NRDM_ABSOLUTE_Y)
			{
				mRegs[i].Reset();
				changed = true;
			}
		}

	} while (changed);
}

ValueNumberingData::ValueNumberingData(void)
{
	mIndex = GlobalValueNumber++;
	mOffset = 0;
}

void ValueNumberingData::Reset(void)
{
	mIndex = GlobalValueNumber++;
	mOffset = 0;
}

bool ValueNumberingData::SameBase(const  ValueNumberingData& d) const
{
	return mIndex == d.mIndex;
}

void ValueNumberingDataSet::Reset(void)
{
	for (int i = 0; i < 261; i++)
		mRegs[i].Reset();
}

void ValueNumberingDataSet::ResetWorkRegs(void)
{
	mRegs[BC_REG_WORK_Y].Reset();
	mRegs[BC_REG_ADDR].Reset();
	mRegs[BC_REG_ADDR + 1].Reset();

	for (int i = 0; i < 4; i++)
		mRegs[BC_REG_ACCU + i].Reset();
	for (int i = 0; i < 8; i++)
		mRegs[BC_REG_WORK + i].Reset();
}

void ValueNumberingDataSet::ResetCall(const NativeCodeInstruction& ins)
{
	mRegs[CPU_REG_C].Reset();
	mRegs[CPU_REG_Z].Reset();
	mRegs[CPU_REG_A].Reset();
	mRegs[CPU_REG_X].Reset();
	mRegs[CPU_REG_Y].Reset();

	ResetWorkRegs();

	if (!(ins.mFlags & NCIF_RUNTIME) || (ins.mFlags & NCIF_FEXEC))
	{
		if (ins.mLinkerObject && ins.mLinkerObject->mProc)
		{
			if (!(ins.mFlags & NCIF_FEXEC) && (ins.mLinkerObject->mFlags & LOBJF_ZEROPAGESET))
			{
				for (int i = 0; i < 256; i++)
					if (ins.mLinkerObject->mZeroPageSet[i])
						mRegs[i].Reset();
				return;
			}

			for (int i = BC_REG_TMP; i < BC_REG_TMP + ins.mLinkerObject->mProc->mCallerSavedTemps; i++)
				mRegs[i].Reset();
		}
		else
		{
			for (int i = BC_REG_TMP; i < BC_REG_TMP_SAVED; i++)
				mRegs[i].Reset();
		}

		for (int i = BC_REG_FPARAMS; i < BC_REG_FPARAMS_END; i++)
			mRegs[i].Reset();
	}

}


void ValueNumberingDataSet::Intersect(const ValueNumberingDataSet& set)
{
	for (int i = 0; i < 261; i++)
	{
		if (mRegs[i].mIndex != set.mRegs[i].mIndex || mRegs[i].mOffset != set.mRegs[i].mOffset)
			mRegs[i].Reset();
	}
}



NativeCodeInstruction::NativeCodeInstruction(void)
	: mIns(nullptr), mType(ASMIT_INV), mMode(ASMIM_IMPLIED), mAddress(0), mLinkerObject(nullptr), mFlags(NCIF_LOWER | NCIF_UPPER), mParam(0), mLive(LIVE_ALL)
{}

NativeCodeInstruction::NativeCodeInstruction(const InterInstruction* ins, AsmInsType type, AsmInsMode mode, int64 address, LinkerObject* linkerObject, uint32 flags, int param)
	: mIns(ins), mType(type), mMode(mode), mAddress(int(address)), mLinkerObject(linkerObject), mFlags(flags), mParam(param), mLive(LIVE_ALL)
{
	if (mode == ASMIM_IMMEDIATE_ADDRESS)
	{
		assert((mFlags & (NCIF_LOWER | NCIF_UPPER)) != (NCIF_LOWER | NCIF_UPPER));
		assert(HasAsmInstructionMode(mType, ASMIM_IMMEDIATE));
	}
	if (mode == ASMIM_IMMEDIATE)
	{
		assert(address >= 0 && address < 256);
	}
	if (mode == ASMIM_ZERO_PAGE)
	{
		assert(address >= 2 && address < 256);
	}
}

NativeCodeInstruction::NativeCodeInstruction(const InterInstruction* ins, AsmInsType type, const NativeCodeInstruction& addr)
	: mIns(ins), mType(type), mMode(addr.mMode), mAddress(addr.mAddress), mLinkerObject(addr.mLinkerObject), mFlags(addr.mFlags), mParam(addr.mParam), mLive(LIVE_ALL)
{
}


bool NativeCodeInstruction::IsUsedResultInstructions(NumberSet& requiredTemps)
{
	bool	used = false;

	mLive = 0;
	if (requiredTemps[CPU_REG_A])
		mLive |= LIVE_CPU_REG_A;
	if (requiredTemps[CPU_REG_X])
		mLive |= LIVE_CPU_REG_X;
	if (requiredTemps[CPU_REG_Y])
		mLive |= LIVE_CPU_REG_Y;
	if (requiredTemps[CPU_REG_Z])
		mLive |= LIVE_CPU_REG_Z;
	if (requiredTemps[CPU_REG_C])
		mLive |= LIVE_CPU_REG_C;
	if (mMode == ASMIM_ZERO_PAGE && requiredTemps[mAddress])
		mLive |= LIVE_MEM;
	if (mMode == ASMIM_INDIRECT_Y && (requiredTemps[mAddress] || requiredTemps[mAddress + 1]))
		mLive |= LIVE_MEM;

	if (mType == ASMIT_JSR)
	{
		requiredTemps -= CPU_REG_C;
		requiredTemps -= CPU_REG_Z;
		requiredTemps -= CPU_REG_A;
		requiredTemps -= CPU_REG_X;
		requiredTemps -= CPU_REG_Y;

		if (mFlags & NCIF_USE_CPU_REG_A)
			requiredTemps += CPU_REG_A;
		if (mFlags & NCIF_USE_CPU_REG_X)
			requiredTemps += CPU_REG_X;
		if (mFlags & NCIF_USE_CPU_REG_Y)
			requiredTemps += CPU_REG_Y;

		if (mFlags & NCIF_RUNTIME)
		{
			for (int i = 0; i < 4; i++)
			{
				requiredTemps += BC_REG_ACCU + i;
				requiredTemps += BC_REG_WORK + i;
			}

			if (mFlags & NCIF_USE_ZP_32_X)
			{
				for (int i = 0; i < 4; i++)
					requiredTemps += mParam + i;
			}

			if (mFlags & NCIF_FEXEC)
			{
				requiredTemps += BC_REG_LOCALS;
				requiredTemps += BC_REG_LOCALS + 1;
				for(int i= BC_REG_FPARAMS; i< BC_REG_FPARAMS_END; i++)
					requiredTemps += i;
			}
		}
		else
		{
			for (int i = 0; i < 4; i++)
			{
				requiredTemps -= BC_REG_ACCU + i;
				requiredTemps -= BC_REG_WORK + i;
			}

			if (mFlags & NICF_USE_WORKREGS)
			{
				for (int i = 0; i < 10; i++)
					requiredTemps += BC_REG_WORK + i;
			}

			requiredTemps += BC_REG_LOCALS;
			requiredTemps += BC_REG_LOCALS + 1;
			if (mLinkerObject)
			{
				for (int i = 0; i < mLinkerObject->mNumTemporaries; i++)
				{
					for (int j = 0; j < mLinkerObject->mTempSizes[i]; j++)
						requiredTemps += mLinkerObject->mTemporaries[i] + j;
				}
			}
		}

		return true;
	}

	if (mType == ASMIT_RTS)
	{
#if 1
		if (mFlags & NCIF_USE_CPU_REG_A)
			requiredTemps += CPU_REG_A;

		if (mFlags & NCIF_LOWER)
		{
			requiredTemps += BC_REG_ACCU;
			if (mFlags & NCIF_UPPER)
			{
				requiredTemps += BC_REG_ACCU + 1;

				if (mFlags & NCIF_LONG)
				{
					requiredTemps += BC_REG_ACCU + 2;
					requiredTemps += BC_REG_ACCU + 3;
				}
			}
		}
#endif
#if 0
		for (int i = 0; i < 4; i++)
		{
			requiredTemps += BC_REG_ACCU + i;
		}
#endif

		requiredTemps += BC_REG_STACK;
		requiredTemps += BC_REG_STACK + 1;
		requiredTemps += BC_REG_LOCALS;
		requiredTemps += BC_REG_LOCALS + 1;

		return true;
	}

	if (mType == ASMIT_BYTE)
		return true;

	// check side effects

	switch (mType)
	{
	case ASMIT_STA:
	case ASMIT_STX:
	case ASMIT_STY:
	case ASMIT_INC:
	case ASMIT_DEC:
	case ASMIT_ASL:
	case ASMIT_LSR:
	case ASMIT_ROL:
	case ASMIT_ROR:
		if (mMode != ASMIM_IMPLIED && mMode != ASMIM_ZERO_PAGE)
			used = true;
		break;
	case ASMIT_JSR:
	case ASMIT_JMP:
	case ASMIT_BEQ:
	case ASMIT_BNE:
	case ASMIT_BPL:
	case ASMIT_BMI:
	case ASMIT_BCC:
	case ASMIT_BCS:
		used = true;
		break;
	}

	if (requiredTemps[CPU_REG_C])
	{
		switch (mType)
		{
		case ASMIT_CLC:
		case ASMIT_SEC:
		case ASMIT_ADC:
		case ASMIT_SBC:
		case ASMIT_ROL:
		case ASMIT_ROR:
		case ASMIT_CMP:
		case ASMIT_ASL:
		case ASMIT_LSR:
		case ASMIT_CPX:
		case ASMIT_CPY:
			used = true;
			break;
		}
	}

	if (requiredTemps[CPU_REG_Z])
	{
		switch (mType)
		{
		case ASMIT_ADC:
		case ASMIT_SBC:
		case ASMIT_ROL:
		case ASMIT_ROR:
		case ASMIT_INC:
		case ASMIT_DEC:
		case ASMIT_CMP:
		case ASMIT_CPX:
		case ASMIT_CPY:
		case ASMIT_ASL:
		case ASMIT_LSR:
		case ASMIT_ORA:
		case ASMIT_EOR:
		case ASMIT_AND:
		case ASMIT_LDA:
		case ASMIT_LDX:
		case ASMIT_LDY:
		case ASMIT_BIT:
		case ASMIT_INX:
		case ASMIT_DEX:
		case ASMIT_INY:
		case ASMIT_DEY:
		case ASMIT_TYA:
		case ASMIT_TXA:
		case ASMIT_TAY:
		case ASMIT_TAX:
			used = true;
			break;
		}
	}

	if (requiredTemps[CPU_REG_A])
	{
		switch (mType)
		{
		case ASMIT_ROL:
		case ASMIT_ROR:
		case ASMIT_ASL:
		case ASMIT_LSR:
			if (mMode == ASMIM_IMPLIED)
				used = true;
			break;
		case ASMIT_ADC:
		case ASMIT_SBC:
		case ASMIT_ORA:
		case ASMIT_EOR:
		case ASMIT_AND:
		case ASMIT_LDA:
		case ASMIT_TXA:
		case ASMIT_TYA:
			used = true;
			break;
		}
	}

	if (requiredTemps[CPU_REG_X])
	{
		switch (mType)
		{
		case ASMIT_LDX:
		case ASMIT_INX:
		case ASMIT_DEX:
		case ASMIT_TAX:
			used = true;
			break;
		}
	}

	if (requiredTemps[CPU_REG_Y])
	{
		switch (mType)
		{
		case ASMIT_LDY:
		case ASMIT_INY:
		case ASMIT_DEY:
		case ASMIT_TAY:
			used = true;
			break;
		}
	}

	if (mMode == ASMIM_ZERO_PAGE)
	{
		switch (mType)
		{
		case ASMIT_ROL:
		case ASMIT_ROR:
		case ASMIT_ASL:
		case ASMIT_LSR:
		case ASMIT_INC:
		case ASMIT_DEC:
		case ASMIT_STA:
		case ASMIT_STX:
		case ASMIT_STY:
			if (requiredTemps[mAddress])
				used = true;
			break;
		}
	}

	if (used)
	{
		switch (mMode)
		{
		case ASMIM_ZERO_PAGE_X:
		case ASMIM_INDIRECT_X:
		case ASMIM_ABSOLUTE_X:
			requiredTemps += CPU_REG_X;
			break;

		case ASMIM_ZERO_PAGE_Y:
		case ASMIM_ABSOLUTE_Y:
			requiredTemps += CPU_REG_Y;
			break;

		case ASMIM_INDIRECT_Y:
			requiredTemps += CPU_REG_Y;
			requiredTemps += mAddress;
			requiredTemps += mAddress + 1;
			break;
		}

		// check carry flags

		switch (mType)
		{
		case ASMIT_ADC:
		case ASMIT_SBC:
		case ASMIT_ROL:
		case ASMIT_ROR:
			requiredTemps += CPU_REG_C;
			break;
		case ASMIT_CMP:
		case ASMIT_ASL:
		case ASMIT_LSR:
		case ASMIT_CPX:
		case ASMIT_CPY:
		case ASMIT_CLC:
		case ASMIT_SEC:
			requiredTemps -= CPU_REG_C;
			break;
		case ASMIT_BCC:
		case ASMIT_BCS:
			requiredTemps += CPU_REG_C;
			break;
		case ASMIT_BEQ:
		case ASMIT_BNE:
		case ASMIT_BPL:
		case ASMIT_BMI:
			requiredTemps += CPU_REG_Z;
			break;
		}

		// check zero flags

		switch (mType)
		{
		case ASMIT_ADC:
		case ASMIT_SBC:
		case ASMIT_ROL:
		case ASMIT_ROR:
		case ASMIT_CMP:
		case ASMIT_CPX:
		case ASMIT_CPY:
		case ASMIT_ASL:
		case ASMIT_LSR:
		case ASMIT_INC:
		case ASMIT_DEC:
		case ASMIT_ORA:
		case ASMIT_EOR:
		case ASMIT_AND:
		case ASMIT_LDA:
		case ASMIT_LDX:
		case ASMIT_LDY:
		case ASMIT_BIT:
		case ASMIT_TAY:
		case ASMIT_TYA:
		case ASMIT_TAX:
		case ASMIT_TXA:
		case ASMIT_INX:
		case ASMIT_DEX:
		case ASMIT_INY:
		case ASMIT_DEY:
			requiredTemps -= CPU_REG_Z;
			break;
		}

		// check CPU register

		switch (mType)
		{
		case ASMIT_ROL:
		case ASMIT_ROR:
		case ASMIT_ASL:
		case ASMIT_LSR:
			if (mMode == ASMIM_IMPLIED)
				requiredTemps += CPU_REG_A;
			break;

		case ASMIT_LDA:
			requiredTemps -= CPU_REG_A;
			break;

		case ASMIT_ADC:
		case ASMIT_SBC:
		case ASMIT_ORA:
		case ASMIT_EOR:
		case ASMIT_AND:
			requiredTemps += CPU_REG_A;
			break;
		case ASMIT_LDX:
			requiredTemps -= CPU_REG_X;
			break;
		case ASMIT_INX:
		case ASMIT_DEX:
			requiredTemps += CPU_REG_X;
			break;
		case ASMIT_LDY:
			requiredTemps -= CPU_REG_Y;
			break;
		case ASMIT_INY:
		case ASMIT_DEY:
			requiredTemps += CPU_REG_Y;
			break;

		case ASMIT_CMP:
		case ASMIT_STA:
			requiredTemps += CPU_REG_A;
			break;
		case ASMIT_CPX:
		case ASMIT_STX:
			requiredTemps += CPU_REG_X;
			break;
		case ASMIT_CPY:
		case ASMIT_STY:
			requiredTemps += CPU_REG_Y;
			break;

		case ASMIT_TXA:
			requiredTemps += CPU_REG_X;
			requiredTemps -= CPU_REG_A;
			break;
		case ASMIT_TYA:
			requiredTemps += CPU_REG_Y;
			requiredTemps -= CPU_REG_A;
			break;
		case ASMIT_TAX:
			requiredTemps += CPU_REG_A;
			requiredTemps -= CPU_REG_X;
			break;
		case ASMIT_TAY:
			requiredTemps += CPU_REG_A;
			requiredTemps -= CPU_REG_Y;
			break;
		}

		if (mMode == ASMIM_ZERO_PAGE)
		{
			switch (mType)
			{
			case ASMIT_STA:
			case ASMIT_STX:
			case ASMIT_STY:
				requiredTemps -= mAddress;
				break;
			default:
				requiredTemps += mAddress;
			}
		}

		return true;
	}

	return false;
}

bool NativeCodeInstruction::LoadsAccu(void) const
{
	return mType == ASMIT_LDA || mType == ASMIT_TXA || mType == ASMIT_TYA || mType == ASMIT_JSR;
}

bool NativeCodeInstruction::ChangesAccuAndFlag(void) const
{
	if (mType == ASMIT_LDA || mType == ASMIT_TXA || mType == ASMIT_TYA ||
		mType == ASMIT_ORA || mType == ASMIT_AND || mType == ASMIT_EOR ||
		mType == ASMIT_SBC || mType == ASMIT_ADC)
		return true;
	else if (mType == ASMIT_LSR || mType == ASMIT_ASL || mType == ASMIT_ROR || mType == ASMIT_ROL)
		return mMode == ASMIM_IMPLIED;
	else
		return false;
}

uint32 NativeCodeInstruction::NeedsLive(void) const
{
	uint32 live = mLive;
	if (mMode == ASMIM_ABSOLUTE_Y || mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_ZERO_PAGE_Y)
		live |= LIVE_CPU_REG_Y;
	if (mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_INDIRECT_X || mMode == ASMIM_ZERO_PAGE_X)
		live |= LIVE_CPU_REG_X;

	if (mType == ASMIT_TYA || mType == ASMIT_STY || mType == ASMIT_CPY || mType == ASMIT_INY || mType == ASMIT_DEY)
		live |= LIVE_CPU_REG_Y;
	if (mType == ASMIT_TXA || mType == ASMIT_STX || mType == ASMIT_CPX || mType == ASMIT_INX || mType == ASMIT_DEX)
		live |= LIVE_CPU_REG_X;

	if (mMode == ASMIM_IMPLIED && (mType == ASMIT_TAX || mType == ASMIT_TAY ||
		mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR))
		live |= LIVE_CPU_REG_A;

	if (mType == ASMIT_STA ||
		mType == ASMIT_ORA || mType == ASMIT_AND || mType == ASMIT_EOR ||
		mType == ASMIT_SBC || mType == ASMIT_ADC || mType == ASMIT_CMP)
		live |= LIVE_CPU_REG_A;

	if (mType == ASMIT_ADC || mType == ASMIT_SBC || mType == ASMIT_ROL || mType == ASMIT_ROR)
		live |= LIVE_CPU_REG_C;

	return live;
}

bool NativeCodeInstruction::RequiresYReg(void) const
{
	if (mMode == ASMIM_ABSOLUTE_Y || mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_ZERO_PAGE_Y)
		return true;
	if (mType == ASMIT_TYA || mType == ASMIT_STY || mType == ASMIT_CPY || mType == ASMIT_INY || mType == ASMIT_DEY)
		return true;

	return false;
}

bool NativeCodeInstruction::RequiresXReg(void) const
{
	if (mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_INDIRECT_X || mMode == ASMIM_ZERO_PAGE_X)
		return true;
	if (mType == ASMIT_TXA || mType == ASMIT_STX || mType == ASMIT_CPX || mType == ASMIT_INX || mType == ASMIT_DEX)
		return true;

	return false;
}


bool NativeCodeInstruction::ReplaceYRegWithXReg(void)
{
	bool	changed = false;

	switch (mType)
	{
	case ASMIT_LDY:
		mType = ASMIT_LDX;
		changed = true;
		break;
	case ASMIT_STY:
		mType = ASMIT_STX;
		changed = true;
		break;
	case ASMIT_CPY:
		mType = ASMIT_CPX;
		changed = true;
		break;
	case ASMIT_TYA:
		mType = ASMIT_TXA;
		changed = true;
		break;
	case ASMIT_TAY:
		mType = ASMIT_TAX;
		changed = true;
		break;
	case ASMIT_INY:
		mType = ASMIT_INX;
		changed = true;
		break;
	case ASMIT_DEY:
		mType = ASMIT_DEX;
		changed = true;
		break;
	}


	if (mMode == ASMIM_ABSOLUTE_Y)
	{
		assert(HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_X));
		mMode = ASMIM_ABSOLUTE_X;
		changed = true;
	}

	if (mLive & LIVE_CPU_REG_Y)
		mLive |= LIVE_CPU_REG_X;

	return changed;
}

bool NativeCodeInstruction::CanSwapXYReg(void)
{
	if (mMode == ASMIM_INDIRECT_X || mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_ZERO_PAGE_X || mMode == ASMIM_ZERO_PAGE_Y)
		return false;
	else if (mMode == ASMIM_ABSOLUTE_X)
		return HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_Y);
	else if (mMode == ASMIM_ABSOLUTE_Y)
		return HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_X);
	else
		return true;
}

bool NativeCodeInstruction::SwapXYReg(void)
{
	bool	changed = false;

	switch (mType)
	{
	case ASMIT_LDX:
		mType = ASMIT_LDY;
		changed = true;
		break;
	case ASMIT_STX:
		mType = ASMIT_STY;
		changed = true;
		break;
	case ASMIT_CPX:
		mType = ASMIT_CPY;
		changed = true;
		break;
	case ASMIT_TXA:
		mType = ASMIT_TYA;
		changed = true;
		break;
	case ASMIT_TAX:
		mType = ASMIT_TAY;
		changed = true;
		break;
	case ASMIT_INX:
		mType = ASMIT_INY;
		changed = true;
		break;
	case ASMIT_DEX:
		mType = ASMIT_DEY;
		changed = true;
		break;
	case ASMIT_LDY:
		mType = ASMIT_LDX;
		changed = true;
		break;
	case ASMIT_STY:
		mType = ASMIT_STX;
		changed = true;
		break;
	case ASMIT_CPY:
		mType = ASMIT_CPX;
		changed = true;
		break;
	case ASMIT_TYA:
		mType = ASMIT_TXA;
		changed = true;
		break;
	case ASMIT_TAY:
		mType = ASMIT_TAX;
		changed = true;
		break;
	case ASMIT_INY:
		mType = ASMIT_INX;
		changed = true;
		break;
	case ASMIT_DEY:
		mType = ASMIT_DEX;
		changed = true;
		break;
	}

	if (mMode == ASMIM_ABSOLUTE_X)
	{
		assert(HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_Y));
		mMode = ASMIM_ABSOLUTE_Y;
		changed = true;
	}
	else if (mMode == ASMIM_ABSOLUTE_Y)
	{
		assert(HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_X));
		mMode = ASMIM_ABSOLUTE_X;
		changed = true;
	}
	
	uint32	live = mLive;
	mLive &= ~(LIVE_CPU_REG_X | LIVE_CPU_REG_Y);
	if (live & LIVE_CPU_REG_X)
		mLive |= LIVE_CPU_REG_Y;
	if (live & LIVE_CPU_REG_Y)
		mLive |= LIVE_CPU_REG_X;

	return changed;

}

static void UpdateCollisionSet(NumberSet& liveTemps, NumberSet* collisionSets, int temp)
{
	int i;

	if (temp >= 0 && !liveTemps[temp])
	{
		for (i = 0; i < liveTemps.Size(); i++)
		{
			if (liveTemps[i])
			{
				collisionSets[i] += temp;
				collisionSets[temp] += i;
			}
		}

		liveTemps += temp;
	}
}

void NativeCodeInstruction::BuildCollisionTable(NumberSet& liveTemps, NumberSet* collisionSets)
{
	if (mMode == ASMIM_ZERO_PAGE)
	{
		if (ChangesAddress())
			liveTemps -= mAddress;
		if (UsesAddress())
			UpdateCollisionSet(liveTemps, collisionSets, mAddress);		
	}
	if (mMode == ASMIM_INDIRECT_Y)
	{
		UpdateCollisionSet(liveTemps, collisionSets, mAddress);
		UpdateCollisionSet(liveTemps, collisionSets, mAddress + 1);
	}
	if (mType == ASMIT_JSR)
	{
		for(int i= BC_REG_ACCU; i< BC_REG_ACCU + 4; i++)
			UpdateCollisionSet(liveTemps, collisionSets, i);
		for (int i = BC_REG_WORK; i < BC_REG_WORK + 4; i++)
			UpdateCollisionSet(liveTemps, collisionSets, i);

		if (mFlags & NCIF_RUNTIME)
		{

			if (mFlags & NCIF_USE_ZP_32_X)
			{
				for (int i = mParam; i < mParam + 4; i++)
					UpdateCollisionSet(liveTemps, collisionSets, i);
			}

			if (mFlags & NCIF_FEXEC)
			{
				for (int i = BC_REG_FPARAMS; i < BC_REG_FPARAMS_END; i++)
					UpdateCollisionSet(liveTemps, collisionSets, i);
			}
		}
		else
		{
			for (int i = BC_REG_FPARAMS; i < BC_REG_FPARAMS_END; i++)
				UpdateCollisionSet(liveTemps, collisionSets, i);

			if (mLinkerObject && mLinkerObject->mProc)
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP + mLinkerObject->mProc->mCallerSavedTemps; i++)
					UpdateCollisionSet(liveTemps, collisionSets, i);
			}
			else
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP_SAVED; i++)
					UpdateCollisionSet(liveTemps, collisionSets, i);
			}
		}
	}
}


bool NativeCodeInstruction::ReplaceXRegWithYReg(void)
{
	bool	changed = false;

	switch (mType)
	{
	case ASMIT_LDX:
		mType = ASMIT_LDY;
		changed = true;
		break;
	case ASMIT_STX:
		mType = ASMIT_STY;
		changed = true;
		break;
	case ASMIT_CPX:
		mType = ASMIT_CPY;
		changed = true;
		break;
	case ASMIT_TXA:
		mType = ASMIT_TYA;
		changed = true;
		break;
	case ASMIT_TAX:
		mType = ASMIT_TAY;
		changed = true;
		break;
	case ASMIT_INX:
		mType = ASMIT_INY;
		changed = true;
		break;
	case ASMIT_DEX:
		mType = ASMIT_DEY;
		changed = true;
		break;
	}

	if (mMode == ASMIM_ABSOLUTE_X)
	{
		assert(HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_Y));
		mMode = ASMIM_ABSOLUTE_Y;
		changed = true;
	}

	if (mLive & LIVE_CPU_REG_X)
		mLive |= LIVE_CPU_REG_Y;

	return changed;
}

bool NativeCodeInstruction::ChangesYReg(void) const
{
	return mType == ASMIT_TAY || mType == ASMIT_LDY || mType == ASMIT_INY || mType == ASMIT_DEY || mType == ASMIT_JSR;
}

bool NativeCodeInstruction::ChangesXReg(void) const
{
	return mType == ASMIT_TAX || mType == ASMIT_LDX || mType == ASMIT_INX || mType == ASMIT_DEX || mType == ASMIT_JSR;
}

bool NativeCodeInstruction::ReferencesCarry(void) const
{
	return ChangesCarry() || RequiresCarry();
}

bool NativeCodeInstruction::ReferencesAccu(void) const
{
	return ChangesAccu() || RequiresAccu();
}

bool NativeCodeInstruction::ReferencesYReg(void) const	
{
	return ChangesYReg() || RequiresYReg();
}

bool NativeCodeInstruction::ReferencesXReg(void) const
{
	return ChangesXReg() || RequiresXReg();
}

bool NativeCodeInstruction::ReferencesZeroPage(int address) const
{
	return UsesZeroPage(address) || ChangesZeroPage(address);
}

bool NativeCodeInstruction::ChangesZeroPage(int address) const
{
	if (mMode == ASMIM_ZERO_PAGE && mAddress == address)
		return mType == ASMIT_INC || mType == ASMIT_DEC || mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR || mType == ASMIT_STA || mType == ASMIT_STX || mType == ASMIT_STY;
	else if (mType == ASMIT_JSR)
	{
		if (address >= BC_REG_ACCU && address < BC_REG_ACCU + 4)
			return true;
		if (address >= BC_REG_WORK && address < BC_REG_WORK + 8)
			return true;
		if (address >= BC_REG_ADDR && address < BC_REG_ADDR + 4)
			return true;

		if (!(mFlags & NCIF_RUNTIME) || (mFlags & NCIF_FEXEC))
		{
			if (mLinkerObject && mLinkerObject->mProc)
			{
				if (!(mFlags & NCIF_FEXEC) && (mLinkerObject->mFlags & LOBJF_ZEROPAGESET))
					return mLinkerObject->mZeroPageSet[address];
				if (address >= BC_REG_TMP && address < BC_REG_TMP + mLinkerObject->mProc->mCallerSavedTemps)
					return true;
			}
			else
			{
				if (address >= BC_REG_TMP && address < BC_REG_TMP_SAVED)
					return true;
			}

			if (address >= BC_REG_FPARAMS && address < BC_REG_FPARAMS_END)
				return true;
		}

		return false;
	}
	else
		return false;
}

bool NativeCodeInstruction::UsesZeroPage(int address) const
{
	if (mMode == ASMIM_ZERO_PAGE && mAddress == address)
		return true;
	else if (mMode == ASMIM_INDIRECT_Y && (mAddress == address || mAddress + 1 == address))
		return true;
	else if (mType == ASMIT_JSR)
	{
		if (mFlags & NCIF_RUNTIME)
		{
			if (address >= BC_REG_ACCU && address < BC_REG_ACCU + 4)
				return true;

			if (address >= BC_REG_WORK && address < BC_REG_WORK + 8)
				return true;

			if (mFlags & NCIF_USE_ZP_32_X)
			{
				if (address >= mParam && address < mParam + 4)
					return true;
			}

			if (mFlags & NCIF_FEXEC)
			{
				if (address >= BC_REG_FPARAMS && address < BC_REG_FPARAMS_END)
					return true;
			}
		}
		else
		{
			if (mFlags & NICF_USE_WORKREGS)
			{
				if (address >= BC_REG_WORK && address < BC_REG_WORK + 10)
					return true;
			}

			if (address >= BC_REG_FPARAMS && address < BC_REG_FPARAMS_END)
				return true;

			if (mLinkerObject)
			{
				for (int i = 0; i < mLinkerObject->mNumTemporaries; i++)
				{
					if (address >= mLinkerObject->mTemporaries[i] && address < mLinkerObject->mTemporaries[i] + mLinkerObject->mTempSizes[i])
						return true;
				}
			}
		}

		return false;
	}
	else if (mType == ASMIT_RTS)
	{
		if (mFlags & NCIF_LOWER)
		{
			if (address == BC_REG_ACCU + 0)
				return true;

			if (mFlags & NCIF_UPPER)
			{
				if (address == BC_REG_ACCU + 1)
					return true;

				if (mFlags & NCIF_LONG)
				{
					if (address == BC_REG_ACCU + 2 || address == BC_REG_ACCU + 3)
						return true;
				}
			}
		}

		return false;
	}
	else
		return false;
}


bool NativeCodeInstruction::ChangesGlobalMemory(void) const
{
	if (mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_ABSOLUTE || mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y)
		return mType == ASMIT_INC || mType == ASMIT_DEC || mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR || mType == ASMIT_STA || mType == ASMIT_STX || mType == ASMIT_STY || mType == ASMIT_JSR;
	else
		return false;
}

bool NativeCodeInstruction::RequiresCarry(void) const
{
	return
		mType == ASMIT_ADC || mType == ASMIT_SBC ||
		mType == ASMIT_ROL || mType == ASMIT_ROR;
}

bool NativeCodeInstruction::ChangesZFlag(void) const
{
	return 
		mType == ASMIT_ADC || mType == ASMIT_SBC ||
		mType == ASMIT_LSR || mType == ASMIT_ASL || mType == ASMIT_ROL || mType == ASMIT_ROR ||
		mType == ASMIT_INC || mType == ASMIT_DEC ||
		mType == ASMIT_INY || mType == ASMIT_DEY ||
		mType == ASMIT_INX || mType == ASMIT_DEX ||
		mType == ASMIT_TAX || mType == ASMIT_TAY || mType == ASMIT_TXA || mType == ASMIT_TYA ||
		mType == ASMIT_CMP || mType == ASMIT_CPX || mType == ASMIT_CPY ||
		mType == ASMIT_LDA || mType == ASMIT_LDX || mType == ASMIT_LDY ||
		mType == ASMIT_AND || mType == ASMIT_ORA || mType == ASMIT_EOR ||
		mType == ASMIT_JSR;
}

bool NativeCodeInstruction::ChangesCarry(void) const
{
	return
		mType == ASMIT_CLC || mType == ASMIT_SEC ||
		mType == ASMIT_ADC || mType == ASMIT_SBC ||
		mType == ASMIT_LSR || mType == ASMIT_ASL || mType == ASMIT_ROL || mType == ASMIT_ROR ||
		mType == ASMIT_CMP || mType == ASMIT_CPX || mType == ASMIT_CPY ||
		mType == ASMIT_JSR;
}

bool NativeCodeInstruction::RequiresAccu(void) const
{
	if (mMode == ASMIM_IMPLIED)
	{
		return
			mType == ASMIT_TAX || mType == ASMIT_TAY ||
			mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR;
	}
	else
	{
		return
			mType == ASMIT_STA ||
			mType == ASMIT_ORA || mType == ASMIT_AND || mType == ASMIT_EOR ||
			mType == ASMIT_SBC || mType == ASMIT_ADC || mType == ASMIT_CMP;
	}
}

bool NativeCodeInstruction::UsesAccu(void) const
{
	if (ChangesAccu())
		return true;

	return mType == ASMIT_STA || mType == ASMIT_CMP || mType == ASMIT_TAX || mType == ASMIT_TAY;
}

bool NativeCodeInstruction::ChangesAccu(void) const
{
	if (mMode == ASMIM_IMPLIED)
	{
		return
			mType == ASMIT_TXA || mType == ASMIT_TYA ||
			mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR;
	}
	else
	{
		return
			mType == ASMIT_JSR ||
			mType == ASMIT_LDA || 
			mType == ASMIT_ORA || mType == ASMIT_AND || mType == ASMIT_EOR ||
			mType == ASMIT_SBC || mType == ASMIT_ADC;
	}
}



bool NativeCodeInstruction::UsesAddress(void) const
{
	if (mMode != ASMIM_IMPLIED)
	{
		return
			mType == ASMIT_INC || mType == ASMIT_DEC || mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR ||
			mType == ASMIT_LDA || mType == ASMIT_LDX || mType == ASMIT_LDY ||
			mType == ASMIT_CMP || mType == ASMIT_CPX || mType == ASMIT_CPY ||
			mType == ASMIT_ADC || mType == ASMIT_SBC || mType == ASMIT_AND || mType == ASMIT_ORA || mType == ASMIT_EOR;
	}
	else
		return false;
}

bool NativeCodeInstruction::ChangesAddress(void) const
{
	if (mMode != ASMIM_IMPLIED)
		return mType == ASMIT_INC || mType == ASMIT_DEC || mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR || mType == ASMIT_STA || mType == ASMIT_STX || mType == ASMIT_STY;
	else
		return false;
}

bool NativeCodeInstruction::IsSimpleJSR(void) const
{
	return mType == ASMIT_JSR && mMode == ASMIM_ABSOLUTE && !(mLinkerObject && (mLinkerObject->mFlags & LOBJF_INLINE));
}

bool NativeCodeInstruction::IsShift(void) const
{
	return mType == ASMIT_ASL || mType == ASMIT_LSR || mType == ASMIT_ROL || mType == ASMIT_ROR;
}

bool NativeCodeInstruction::IsShiftOrInc(void) const
{
	return mType == ASMIT_INC || mType == ASMIT_DEC || mType == ASMIT_ASL || mType == ASMIT_LSR;// || mType == ASMIT_ROL || mType == ASMIT_ROR;
}


bool NativeCodeInstruction::IsCommutative(void) const
{
	return mType == ASMIT_ADC || mType == ASMIT_AND || mType == ASMIT_ORA || mType == ASMIT_EOR;
}


bool NativeCodeInstruction::IsSame(const NativeCodeInstruction& ins) const
{
	if (mType == ins.mType && mMode == ins.mMode && mParam == ins.mParam)
	{
		switch (mMode)
		{
		case ASMIM_IMPLIED:
			return true;
		case ASMIM_IMMEDIATE:
		case ASMIM_ZERO_PAGE:
		case ASMIM_ZERO_PAGE_X:
		case ASMIM_ZERO_PAGE_Y:
		case ASMIM_INDIRECT_X:
		case ASMIM_INDIRECT_Y:
			return ins.mAddress == mAddress;
		case ASMIM_IMMEDIATE_ADDRESS:
			return (ins.mLinkerObject == mLinkerObject && ins.mAddress == mAddress && ins.mFlags == mFlags);
		case ASMIM_ABSOLUTE:
		case ASMIM_ABSOLUTE_X:
		case ASMIM_ABSOLUTE_Y:
			return (ins.mLinkerObject == mLinkerObject && ins.mAddress == mAddress);
		default:
			return false;
		}
	}
	else
		return false;
}

bool NativeCodeInstruction::IsSameLS(const NativeCodeInstruction& ins) const
{
	if ((mType == ins.mType || mType == ASMIT_STA && ins.mType == ASMIT_LDA) && mMode == ins.mMode && mParam == ins.mParam)
	{
		switch (mMode)
		{
		case ASMIM_IMPLIED:
			return true;
		case ASMIM_IMMEDIATE:
		case ASMIM_ZERO_PAGE:
		case ASMIM_ZERO_PAGE_X:
		case ASMIM_ZERO_PAGE_Y:
		case ASMIM_INDIRECT_X:
		case ASMIM_INDIRECT_Y:
			return ins.mAddress == mAddress;
		case ASMIM_IMMEDIATE_ADDRESS:
			return (ins.mLinkerObject == mLinkerObject && ins.mAddress == mAddress && ins.mFlags == mFlags);
		case ASMIM_ABSOLUTE:
		case ASMIM_ABSOLUTE_X:
		case ASMIM_ABSOLUTE_Y:
			return (ins.mLinkerObject == mLinkerObject && ins.mAddress == mAddress);
		default:
			return false;
		}
	}
	else
		return false;
}

bool NativeCodeInstruction::MayBeMovedBefore(const NativeCodeInstruction& ins)
{
	if ((ChangesAddress() || ins.ChangesAddress()) && MayBeSameAddress(ins))
		return false;
	if (RequiresXReg() && ins.ChangesXReg() || ins.RequiresXReg() && ChangesXReg())
		return false;
	if (RequiresYReg() && ins.ChangesYReg() || ins.RequiresYReg() && ChangesYReg())
		return false;
	if (RequiresAccu() && ins.ChangesAccu() || ins.RequiresAccu() && ChangesAccu())
		return false;
	if (RequiresCarry() && ins.ChangesCarry() || ins.RequiresCarry() && ChangesCarry())
		return false;

	if ((ins.mLive & LIVE_CPU_REG_Z) && ChangesZFlag())
		return false;

	return true;
}

bool NativeCodeInstruction::MayBeSameAddress(const NativeCodeInstruction& ins, bool sameXY) const
{
	if (ins.mMode == ASMIM_ZERO_PAGE)
	{
		if (mMode == ASMIM_ZERO_PAGE)
			return mAddress == ins.mAddress;
		else
			return false;
	}
	else if (ins.mMode == ASMIM_ZERO_PAGE_X || ins.mMode == ASMIM_ZERO_PAGE_Y)
	{
		return mMode == ASMIM_ZERO_PAGE || mMode == ASMIM_INDIRECT_X || mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_ZERO_PAGE_X || mMode == ASMIM_ZERO_PAGE_Y;
	}
	else if (ins.mMode == ASMIM_ABSOLUTE)
	{
		if (mMode == ASMIM_ABSOLUTE)
			return mLinkerObject == ins.mLinkerObject && mAddress == ins.mAddress;
		else if (mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y)
			return mLinkerObject == ins.mLinkerObject && mAddress <= ins.mAddress && mAddress + 256 > ins.mAddress;
		else
			return mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_INDIRECT_X;
	}
	else if (ins.mMode == ASMIM_ABSOLUTE_X || ins.mMode == ASMIM_ABSOLUTE_Y)
	{
		if (mMode == ASMIM_ABSOLUTE || mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y)
		{
			if (mLinkerObject != ins.mLinkerObject)
				return false;
			else if (mAddress >= ins.mAddress + 256 || ins.mAddress >= mAddress + 256)
				return false;
			else if (mMode == ASMIM_ABSOLUTE && ins.mAddress > mAddress)
				return false;
			else
				return mMode != ins.mMode || !sameXY || mAddress == ins.mAddress;
		}
		else
			return mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_INDIRECT_X;
	}
	else if (ins.mMode == ASMIM_INDIRECT_Y || ins.mMode == ASMIM_INDIRECT_X)
		return mMode == ASMIM_ABSOLUTE || mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y || mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_INDIRECT_X;
	else
		return false;
}

bool NativeCodeInstruction::MayBeChangedOnAddress(const NativeCodeInstruction& ins, bool sameXY) const
{
	if (mMode == ASMIM_IMMEDIATE || mMode == ASMIM_IMMEDIATE_ADDRESS)
		return false;

	if (ins.mType == ASMIT_JSR)
	{
		if (mMode == ASMIM_ZERO_PAGE)
			return ins.ChangesZeroPage(mAddress);
		else if (mMode == ASMIM_IMPLIED || mMode == ASMIM_IMMEDIATE || mMode == ASMIM_IMMEDIATE_ADDRESS)
			return false;
		else
			return true;
	}

	if (!ins.ChangesAddress())
		return false;

	if (ins.mMode == ASMIM_ZERO_PAGE)
	{
		if (mMode == ASMIM_ZERO_PAGE)
			return mAddress == ins.mAddress;
		else if (mMode == ASMIM_INDIRECT_X || mMode == ASMIM_INDIRECT_Y)
			return mAddress == ins.mAddress || mAddress + 1 == ins.mAddress;
		else
			return mMode == ASMIM_ZERO_PAGE_X || mMode == ASMIM_ZERO_PAGE_Y;
	}
	else if (ins.mMode == ASMIM_ZERO_PAGE_X || ins.mMode == ASMIM_ZERO_PAGE_Y)
	{
		return mMode == ASMIM_ZERO_PAGE || mMode == ASMIM_INDIRECT_X || mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_ZERO_PAGE_X || mMode == ASMIM_ZERO_PAGE_Y;
	}
	else if (ins.mMode == ASMIM_ABSOLUTE)
	{
		if (mMode == ASMIM_ABSOLUTE)
			return mLinkerObject == ins.mLinkerObject && mAddress == ins.mAddress;
		else if (mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y)
			return mLinkerObject == ins.mLinkerObject;
		else if (mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_INDIRECT_X)
			return mAddress != BC_REG_STACK;
		else
			return false;
	}
	else if (ins.mMode == ASMIM_ABSOLUTE_X || ins.mMode == ASMIM_ABSOLUTE_Y)
	{
		if (mMode == ASMIM_ABSOLUTE || mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y)
		{
			if (mLinkerObject != ins.mLinkerObject)
				return false;
			else
				return mMode != ins.mMode || !sameXY || mAddress == ins.mAddress;
		}
		else if (mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_INDIRECT_X)
			return mAddress != BC_REG_STACK;
		else
			return false;
	}
	else if (ins.mMode == ASMIM_INDIRECT_Y || ins.mMode == ASMIM_INDIRECT_X)
	{
		if (mMode == ASMIM_ABSOLUTE || mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y)
			return ins.mAddress != BC_REG_STACK;
		else
			return mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_INDIRECT_X;
	}
	else
		return false;
}

bool NativeCodeInstruction::UsesMemoryOf(const NativeCodeInstruction& ins) const
{
	if (ins.mMode == ASMIM_ZERO_PAGE)
		return UsesZeroPage(ins.mAddress);
	else if (UsesAddress())
	{
		if (ins.mMode == ASMIM_ABSOLUTE && mMode == ASMIM_ABSOLUTE)
			return mLinkerObject == ins.mLinkerObject && mAddress == ins.mAddress;
		else if (
			(ins.mMode == ASMIM_ABSOLUTE || ins.mMode == ASMIM_ABSOLUTE_X || ins.mMode == ASMIM_ABSOLUTE_Y) &&
			(mMode == ASMIM_ABSOLUTE || mMode == ASMIM_ABSOLUTE_X || mMode == ASMIM_ABSOLUTE_Y))
			return mLinkerObject == ins.mLinkerObject;
		else if (ins.mMode == ASMIM_INDIRECT_Y || mMode == ASMIM_INDIRECT_Y)
			return true;
		else
			return false;
	}
	else
		return false;
		
}


bool NativeCodeInstruction::SameEffectiveAddress(const NativeCodeInstruction& ins) const
{
	if (mMode != ins.mMode)
		return false;

	switch (mMode)
	{
	case ASMIM_ZERO_PAGE:
	case ASMIM_ZERO_PAGE_X:
	case ASMIM_ZERO_PAGE_Y:
	case ASMIM_INDIRECT_X:
	case ASMIM_INDIRECT_Y:
	case ASMIM_IMMEDIATE:
		return ins.mAddress == mAddress;
	case ASMIM_ABSOLUTE:
	case ASMIM_ABSOLUTE_X:
	case ASMIM_ABSOLUTE_Y:
		return (ins.mLinkerObject == mLinkerObject && ins.mAddress == mAddress);
	default:
		return false;
	}
}

bool NativeCodeInstruction::ApplySimulation(const NativeRegisterDataSet& data)
{
	switch (mType)
	{
	case ASMIT_LDA:
	case ASMIT_LDX:
	case ASMIT_LDY:
	case ASMIT_CMP:
	case ASMIT_CPX:
	case ASMIT_CPY:
	case ASMIT_ADC:
	case ASMIT_SBC:
	case ASMIT_AND:
	case ASMIT_ORA:
	case ASMIT_EOR:
		if (mMode == ASMIM_ZERO_PAGE && data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
		{
			mMode = ASMIM_IMMEDIATE;
			mAddress = data.mRegs[mAddress].mValue;
			return true;
		}
		else if (mMode == ASMIM_ZERO_PAGE && data.mRegs[mAddress].mMode == NRDM_IMMEDIATE_ADDRESS)
		{
			mMode = ASMIM_IMMEDIATE_ADDRESS;
			mLinkerObject = data.mRegs[mAddress].mLinkerObject;
			mFlags = data.mRegs[mAddress].mFlags;
			mAddress = data.mRegs[mAddress].mValue;
			assert((mFlags & (NCIF_LOWER | NCIF_UPPER)) != (NCIF_LOWER | NCIF_UPPER));
			return true;
		}
		break;
	}

	if (mMode == ASMIM_INDIRECT_Y && data.mRegs[mAddress].mMode == NRDM_IMMEDIATE && data.mRegs[mAddress + 1].mMode == NRDM_IMMEDIATE)
	{
		mMode = ASMIM_ABSOLUTE_Y;
		mAddress = data.mRegs[mAddress].mValue + 256 * data.mRegs[mAddress + 1].mValue;
		mLinkerObject = nullptr;
	}
	else if (mMode == ASMIM_INDIRECT_Y && data.mRegs[mAddress].mMode == NRDM_IMMEDIATE_ADDRESS && data.mRegs[mAddress + 1].mMode == NRDM_IMMEDIATE_ADDRESS && data.mRegs[mAddress].mLinkerObject == data.mRegs[mAddress + 1].mLinkerObject)
	{
		mMode = ASMIM_ABSOLUTE_Y;
		mLinkerObject = data.mRegs[mAddress].mLinkerObject;
		mAddress = data.mRegs[mAddress].mValue;
	}

	return false;
}

void NativeCodeInstruction::Simulate(NativeRegisterDataSet& data)
{
	int	reg = -1;
	if (mMode == ASMIM_ZERO_PAGE)
		reg = mAddress;
	else if (mMode == ASMIM_IMPLIED)
		reg = CPU_REG_A;

	switch (mType)
	{
	case ASMIT_JSR:
		data.mRegs[CPU_REG_C].Reset();
		data.mRegs[CPU_REG_Z].Reset();
		data.mRegs[CPU_REG_A].Reset();
		data.mRegs[CPU_REG_X].Reset();
		data.mRegs[CPU_REG_Y].Reset();

		data.ResetWorkRegs();

		if (mFlags & NCIF_FEXEC)
		{
			for (int i = BC_REG_TMP; i < BC_REG_TMP_SAVED; i++)
				data.mRegs[i].Reset();
		}
		else if (!(mFlags & NCIF_RUNTIME))
		{
			if (mLinkerObject && mLinkerObject->mProc)
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP + mLinkerObject->mProc->mCallerSavedTemps; i++)
					data.mRegs[i].Reset();
			}
			else
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP_SAVED; i++)
					data.mRegs[i].Reset();
			}
		}
		break;

	case ASMIT_ROL:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue << 1) | data.mRegs[CPU_REG_C].mValue;
				data.mRegs[CPU_REG_C].mValue = t >= 256;
				data.mRegs[reg].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_ROR:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue >> 1) | (data.mRegs[CPU_REG_C].mValue << 7);
				data.mRegs[CPU_REG_C].mValue = data.mRegs[reg].mValue & 1;
				data.mRegs[reg].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_ASL:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue << 1);
				data.mRegs[CPU_REG_C].mValue = t >= 256;
				data.mRegs[reg].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_LSR:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue >> 1);
				data.mRegs[CPU_REG_C].mValue = data.mRegs[reg].mValue & 1;
				data.mRegs[reg].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_INC:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[reg].mValue = (data.mRegs[reg].mValue + 1) & 255;
				data.mRegs[CPU_REG_Z].mValue = data.mRegs[reg].mValue;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
			data.mRegs[CPU_REG_Z].Reset();
		break;

	case ASMIT_DEC:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[reg].mValue = (data.mRegs[reg].mValue + 1) & 255;
				data.mRegs[CPU_REG_Z].mValue = data.mRegs[reg].mValue;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
			data.mRegs[CPU_REG_Z].Reset();
		break;

	case ASMIT_ADC:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
			{
				int	t = data.mRegs[reg].mValue + data.mRegs[CPU_REG_A].mValue + data.mRegs[CPU_REG_C].mValue;
				data.mRegs[CPU_REG_C].mValue = t >= 256;
				data.mRegs[CPU_REG_A].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_SBC:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue ^ 0xff) + data.mRegs[CPU_REG_A].mValue + data.mRegs[CPU_REG_C].mValue;
				data.mRegs[CPU_REG_C].mValue = t >= 256;
				data.mRegs[CPU_REG_A].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_AND:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				int	t = data.mRegs[reg].mValue & data.mRegs[CPU_REG_A].mValue;
				data.mRegs[CPU_REG_A].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else if ((data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[reg].mValue == 0) || (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == 0))
			{
				data.mRegs[CPU_REG_A].mValue = 0;
				data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = 0;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_ORA:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				int	t = data.mRegs[reg].mValue | data.mRegs[CPU_REG_A].mValue;
				data.mRegs[CPU_REG_A].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else if ((data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[reg].mValue == 0xff) || (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == 0xff))
			{
				data.mRegs[CPU_REG_A].mValue = 0xff;
				data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = 0xff;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_EOR:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				int	t = data.mRegs[reg].mValue | data.mRegs[CPU_REG_A].mValue;
				data.mRegs[CPU_REG_A].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_INX:
		if (data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_X].mValue = (data.mRegs[CPU_REG_X].mValue + 1) & 255;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_X].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_DEX:
		if (data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_X].mValue = (data.mRegs[CPU_REG_X].mValue - 1) & 255;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_X].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_INY:
		if (data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Y].mValue = (data.mRegs[CPU_REG_Y].mValue + 1) & 255;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_Y].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_DEY:
		if (data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Y].mValue = (data.mRegs[CPU_REG_Y].mValue - 1) & 255;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_Y].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_TXA:
		if (data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_A].mValue = data.mRegs[CPU_REG_X].mValue;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_X].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_TYA:
		if (data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_A].mValue = data.mRegs[CPU_REG_Y].mValue;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_Y].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_TAX:
		if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_X].mValue = data.mRegs[CPU_REG_A].mValue;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_A].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_X].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_TAY:
		if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Y].mValue = data.mRegs[CPU_REG_A].mValue;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_A].mValue;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_Y].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_CMP:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue ^ 0xff) + data.mRegs[CPU_REG_A].mValue + 1;
				data.mRegs[CPU_REG_C].mValue = t >= 256;
				data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else if (mMode == ASMIM_IMMEDIATE && mAddress == 0)
		{
			data.mRegs[CPU_REG_C].mValue = 1;
			data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].Reset();
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_CPX:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue ^ 0xff) + data.mRegs[CPU_REG_X].mValue + 1;
				data.mRegs[CPU_REG_C].mValue = t >= 256;
				data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else if (mMode == ASMIM_IMMEDIATE && mAddress == 0)
		{
			data.mRegs[CPU_REG_C].mValue = 1;
			data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].Reset();
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_CPY:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
			{
				int	t = (data.mRegs[reg].mValue ^ 0xff) + data.mRegs[CPU_REG_Y].mValue + 1;
				data.mRegs[CPU_REG_C].mValue = t >= 256;
				data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = t & 255;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else if (mMode == ASMIM_IMMEDIATE && mAddress == 0)
		{
			data.mRegs[CPU_REG_C].mValue = 1;
			data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].Reset();
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_LDA:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE)
			{
				int	t = data.mRegs[reg].mValue;
				data.mRegs[CPU_REG_A].mValue = t;
				data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = t;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_A].mValue = mAddress;
			data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = mAddress;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else if (mMode == ASMIM_IMMEDIATE_ADDRESS)
		{
			data.mRegs[CPU_REG_A].mValue = mAddress;
			data.mRegs[CPU_REG_A].mLinkerObject = mLinkerObject;
			data.mRegs[CPU_REG_A].mFlags = mFlags;
			data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE_ADDRESS;
			data.mRegs[CPU_REG_Z].Reset();
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_LDX:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE)
			{
				int	t = data.mRegs[reg].mValue;
				data.mRegs[CPU_REG_X].mValue = t;
				data.mRegs[CPU_REG_X].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = t;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_X].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_X].mValue = mAddress;
			data.mRegs[CPU_REG_X].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = mAddress;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_X].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_LDY:
		if (reg >= 0)
		{
			if (data.mRegs[reg].mMode == NRDM_IMMEDIATE)
			{
				int	t = data.mRegs[reg].mValue;
				data.mRegs[CPU_REG_Y].mValue = t;
				data.mRegs[CPU_REG_Y].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = t;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[CPU_REG_Y].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Y].mValue = mAddress;
			data.mRegs[CPU_REG_Y].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = mAddress;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
		}
		else
		{
			data.mRegs[CPU_REG_Y].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_STA:
		if (reg >= 0)
		{
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE || data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE_ADDRESS)
			{
				data.mRegs[reg] = data.mRegs[CPU_REG_A];
			}
			else
			{
				data.mRegs[reg].Reset();
			}
		}
		break;

	case ASMIT_STX:
		if (reg >= 0)
		{
			if (data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[reg].mValue = data.mRegs[CPU_REG_X].mValue;
				data.mRegs[reg].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
			}
		}
		break;

	case ASMIT_STY:
		if (reg >= 0)
		{
			if (data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[reg].mValue = data.mRegs[CPU_REG_Y].mValue;
				data.mRegs[reg].mMode = NRDM_IMMEDIATE;
			}
			else
			{
				data.mRegs[reg].Reset();
			}
		}
		break;
	}
}

bool NativeCodeInstruction::BitFieldForwarding(NativeRegisterDataSet& data, AsmInsType& carryop)
{
	bool	changed = false;

	int		iaddr = -1;
	
	if (mMode == ASMIM_IMPLIED)
		iaddr = CPU_REG_A;
	else if (mMode == ASMIM_ZERO_PAGE)
		iaddr = mAddress;

	switch (mType)
	{
	case ASMIT_JSR:
		data.mRegs[CPU_REG_C].ResetMask();
		data.mRegs[CPU_REG_Z].ResetMask();
		data.mRegs[CPU_REG_A].ResetMask();
		data.mRegs[CPU_REG_X].ResetMask();
		data.mRegs[CPU_REG_Y].ResetMask();

		data.ResetWorkMasks();

		if (!(mFlags & NCIF_RUNTIME) || (mFlags & NCIF_FEXEC))
		{
			if (mLinkerObject && mLinkerObject->mProc)
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP + mLinkerObject->mProc->mCallerSavedTemps; i++)
					data.mRegs[i].ResetMask();
			}
			else
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP_SAVED; i++)
					data.mRegs[i].ResetMask();
			}

			for (int i = BC_REG_FPARAMS; i < BC_REG_FPARAMS_END; i++)
				data.mRegs[i].ResetMask();
		}
		break;
	case ASMIT_CLC:
		data.mRegs[CPU_REG_C].mMask = 1;
		data.mRegs[CPU_REG_C].mValue = 0;
		break;
	case ASMIT_SEC:
		data.mRegs[CPU_REG_C].mMask = 1;
		data.mRegs[CPU_REG_C].mValue = 1;
		break;

	case ASMIT_CMP:
	case ASMIT_CPX:
	case ASMIT_CPY:
		data.mRegs[CPU_REG_C].mMask = 0;
		break;

	case ASMIT_ADC:
		if (mMode == ASMIM_IMMEDIATE && data.mRegs[CPU_REG_C].mMask == 1 && data.mRegs[CPU_REG_C].mValue == 0)
		{
			if ((mAddress & ~data.mRegs[CPU_REG_A].mMask) == 0 && (mAddress & data.mRegs[CPU_REG_A].mValue) == 0)
			{
				mType = ASMIT_ORA;
				data.mRegs[CPU_REG_A].mValue |= mAddress;
				changed = true;
			}
			else if (mAddress == 1 && (data.mRegs[CPU_REG_A].mMask & 3) == 3 && (data.mRegs[CPU_REG_A].mValue & 3) == 1)
			{
				mType = ASMIT_EOR;
				mAddress = 3;
				data.mRegs[CPU_REG_A].mValue ^= 3;
				changed = true;
			}
			else
			{
				data.mRegs[CPU_REG_C].mMask = 0;
				data.mRegs[CPU_REG_A].mMask = 0;
			}
		}
		else if (mMode == ASMIM_IMMEDIATE && mAddress == 0)
		{
			int zeros = data.mRegs[CPU_REG_A].mMask & ~data.mRegs[CPU_REG_A].mValue;

			int fzero = 0x01;
			while (fzero < 0x100 && (fzero & zeros) == 0)
				fzero <<= 1;

			fzero |= (fzero - 1);

			data.mRegs[CPU_REG_A].mMask &= ~fzero;

			if (fzero >= 0x100)
				data.mRegs[CPU_REG_C].mMask = 0;
			else
			{
				data.mRegs[CPU_REG_C].mMask = 1;
				data.mRegs[CPU_REG_C].mValue = 0;
			}
		}
		else
		{
			data.mRegs[CPU_REG_C].mMask = 0;
			data.mRegs[CPU_REG_A].mMask = 0;
		}

		break;
	case ASMIT_SBC:
		data.mRegs[CPU_REG_C].mMask = 0;
		data.mRegs[CPU_REG_A].mMask = 0;
		break;

	case ASMIT_LDA:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			data.mRegs[CPU_REG_A].mMask = data.mRegs[mAddress].mMask;
			data.mRegs[CPU_REG_A].mValue = data.mRegs[mAddress].mValue;

			if (data.mRegs[CPU_REG_A].mMask == 0xff)
			{
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_A].mMask = 0xff;
			data.mRegs[CPU_REG_A].mValue = mAddress & 0xff;
		}
		else
			data.mRegs[CPU_REG_A].mMask = 0;
		break;
	case ASMIT_STA:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			data.mRegs[mAddress].mMask = data.mRegs[CPU_REG_A].mMask;
			data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_A].mValue;
		}
		break;

	case ASMIT_LDX:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			data.mRegs[CPU_REG_X].mMask = data.mRegs[mAddress].mMask;
			data.mRegs[CPU_REG_X].mValue = data.mRegs[mAddress].mValue;

			if (data.mRegs[CPU_REG_X].mMask == 0xff)
			{
				mType = ASMIT_LDX;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_X].mValue;
				changed = true;
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_X].mMask = 0xff;
			data.mRegs[CPU_REG_X].mValue = mAddress & 0xff;
		}
		else
			data.mRegs[CPU_REG_X].mMask = 0;
		break;
	case ASMIT_STX:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			data.mRegs[mAddress].mMask = data.mRegs[CPU_REG_X].mMask;
			data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_X].mValue;
		}
		break;

	case ASMIT_LDY:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			data.mRegs[CPU_REG_Y].mMask = data.mRegs[mAddress].mMask;
			data.mRegs[CPU_REG_Y].mValue = data.mRegs[mAddress].mValue;

			if (data.mRegs[CPU_REG_Y].mMask == 0xff)
			{
				mType = ASMIT_LDY;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_Y].mValue;
				changed = true;
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Y].mMask = 0xff;
			data.mRegs[CPU_REG_Y].mValue = mAddress & 0xff;
		}
		else
			data.mRegs[CPU_REG_Y].mMask = 0;
		break;
	case ASMIT_STY:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			data.mRegs[mAddress].mMask = data.mRegs[CPU_REG_Y].mMask;
			data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_Y].mValue;
		}
		break;

	case ASMIT_AND:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			int	zeros =
				(data.mRegs[mAddress].mMask & ~data.mRegs[mAddress].mValue) |
				(data.mRegs[CPU_REG_A].mMask & ~data.mRegs[CPU_REG_A].mValue);

			int	ones =
				(data.mRegs[mAddress].mMask & data.mRegs[mAddress].mValue) &
				(data.mRegs[CPU_REG_A].mMask & data.mRegs[CPU_REG_A].mValue);

			data.mRegs[CPU_REG_A].mMask = (ones | zeros) & 0xff;
			data.mRegs[CPU_REG_A].mValue = ones & 0xff;

			if (data.mRegs[CPU_REG_A].mMask == 0xff)
			{
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			if (mAddress != 0xff && ((data.mRegs[CPU_REG_A].mMask & ~data.mRegs[CPU_REG_A].mValue) | mAddress) == 0xff)
			{
				mAddress = 0xff;
				changed = true;
			}

			int	zeros =	~mAddress |	(data.mRegs[CPU_REG_A].mMask & ~data.mRegs[CPU_REG_A].mValue);

			int	ones = mAddress & (data.mRegs[CPU_REG_A].mMask & data.mRegs[CPU_REG_A].mValue);
			
			data.mRegs[CPU_REG_A].mMask = (ones | zeros) & 0xff;
			data.mRegs[CPU_REG_A].mValue = ones & 0xff;

			if (data.mRegs[CPU_REG_A].mMask == 0xff)
			{
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else
			data.mRegs[CPU_REG_A].mMask &= ~data.mRegs[CPU_REG_A].mValue;
		break;

	case ASMIT_ORA:
		if (mMode == ASMIM_ZERO_PAGE)
		{
			int	ones =
				(data.mRegs[mAddress].mMask & data.mRegs[mAddress].mValue) |
				(data.mRegs[CPU_REG_A].mMask & data.mRegs[CPU_REG_A].mValue);

			int	zeros =
				(data.mRegs[mAddress].mMask & ~data.mRegs[mAddress].mValue) &
				(data.mRegs[CPU_REG_A].mMask & ~data.mRegs[CPU_REG_A].mValue);

			data.mRegs[CPU_REG_A].mMask = (ones | zeros) & 0xff;
			data.mRegs[CPU_REG_A].mValue = ones & 0xff;

			if (data.mRegs[CPU_REG_A].mMask == 0xff)
			{
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else if (mMode == ASMIM_IMMEDIATE)
		{
			if (mAddress != 0x00 && (~(data.mRegs[CPU_REG_A].mMask & data.mRegs[CPU_REG_A].mValue) & mAddress) == 0x00)
			{
				mAddress = 0x00;
				changed = true;
			}

			int	ones = mAddress | (data.mRegs[CPU_REG_A].mMask & data.mRegs[CPU_REG_A].mValue);

			int	zeros = ~ mAddress & (data.mRegs[CPU_REG_A].mMask & ~data.mRegs[CPU_REG_A].mValue);

			data.mRegs[CPU_REG_A].mMask = (ones | zeros) & 0xff;
			data.mRegs[CPU_REG_A].mValue = ones & 0xff;

			if (data.mRegs[CPU_REG_A].mMask == 0xff)
			{
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else
			data.mRegs[CPU_REG_A].mMask &= data.mRegs[CPU_REG_A].mValue;
		break;

	case ASMIT_EOR:
		data.mRegs[CPU_REG_A].mMask = 0;
		break;

	case ASMIT_TAX:
		data.mRegs[CPU_REG_X].mMask = data.mRegs[CPU_REG_A].mMask;
		data.mRegs[CPU_REG_X].mValue = data.mRegs[CPU_REG_A].mValue;
		break;
	case ASMIT_TAY:
		data.mRegs[CPU_REG_Y].mMask = data.mRegs[CPU_REG_A].mMask;
		data.mRegs[CPU_REG_Y].mValue = data.mRegs[CPU_REG_A].mValue;
		break;

	case ASMIT_TXA:
		data.mRegs[CPU_REG_A].mMask = data.mRegs[CPU_REG_X].mMask;
		data.mRegs[CPU_REG_A].mValue = data.mRegs[CPU_REG_X].mValue;
		break;

	case ASMIT_TYA:
		data.mRegs[CPU_REG_A].mMask = data.mRegs[CPU_REG_Y].mMask;
		data.mRegs[CPU_REG_A].mValue = data.mRegs[CPU_REG_Y].mValue;
		break;

	case ASMIT_INX:
	case ASMIT_DEX:
		data.mRegs[CPU_REG_X].mMask = 0;
		break;

	case ASMIT_INY:
	case ASMIT_DEY:
		data.mRegs[CPU_REG_Y].mMask = 0;
		break;

	case ASMIT_INC:
	case ASMIT_DEC:
		if (mMode == ASMIM_ZERO_PAGE)
			data.mRegs[mAddress].mMask = 0;
		break;

	case ASMIT_ASL:
		if (iaddr >= 0)
		{
			int	mask = data.mRegs[iaddr].mMask, value = data.mRegs[iaddr].mValue;

			data.mRegs[iaddr].mMask = ((mask << 1) & 0xff) | 0x01;
			data.mRegs[iaddr].mValue = ((value << 1) & 0xff);
			
			if (mask & 0x80)
			{
				data.mRegs[CPU_REG_C].mMask = 1;
				data.mRegs[CPU_REG_C].mValue = value >> 7;
			}
			else
				data.mRegs[CPU_REG_C].mMask = 0;

			if (mMode == ASMIM_IMPLIED && data.mRegs[CPU_REG_A].mMask == 0xff && data.mRegs[CPU_REG_C].mMask)
			{
				carryop = data.mRegs[CPU_REG_C].mValue ? ASMIT_SEC : ASMIT_CLC;
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else
			data.mRegs[CPU_REG_C].mMask = 0;
		break;

	case ASMIT_LSR:
		if (iaddr >= 0)
		{
			int	mask = data.mRegs[iaddr].mMask, value = data.mRegs[iaddr].mValue;

			if (mask == 0xff && value == 0x00)
			{
				mType = ASMIT_CLC;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_C].mMask = 1;
				data.mRegs[CPU_REG_C].mValue = 0;

				changed = true;
			}
			else
			{
				data.mRegs[iaddr].mMask = ((mask >> 1) & 0xff) | 0x80;
				data.mRegs[iaddr].mValue = ((value >> 1) & 0x7f);

				if (mask & 0x01)
				{
					data.mRegs[CPU_REG_C].mMask = 1;
					data.mRegs[CPU_REG_C].mValue = value & 1;
				}
				else
					data.mRegs[CPU_REG_C].mMask = 0;

				if (mMode == ASMIM_IMPLIED && data.mRegs[CPU_REG_A].mMask == 0xff && data.mRegs[CPU_REG_C].mMask)
				{
					carryop = data.mRegs[CPU_REG_C].mValue ? ASMIT_SEC : ASMIT_CLC;
					mType = ASMIT_LDA;
					mMode = ASMIM_IMMEDIATE;
					mAddress = data.mRegs[CPU_REG_A].mValue;
					changed = true;
				}
			}
		}
		else
			data.mRegs[CPU_REG_C].mMask = 0;
		break;

	case ASMIT_ROL:
		if (iaddr >= 0)
		{
			int	mask = data.mRegs[iaddr].mMask, value = data.mRegs[iaddr].mValue;

			data.mRegs[iaddr].mMask = (mask << 1) & 0xff;
			data.mRegs[iaddr].mValue = (value << 1) & 0xff;

			if (data.mRegs[CPU_REG_C].mMask & 1)
			{
				data.mRegs[iaddr].mMask |= 1;
				data.mRegs[iaddr].mValue |= data.mRegs[CPU_REG_C].mValue & 1;
			}

			if (mask & 0x80)
			{
				data.mRegs[CPU_REG_C].mMask = 1;
				data.mRegs[CPU_REG_C].mValue = value >> 7;
			}
			else
				data.mRegs[CPU_REG_C].mMask = 0;

			if (mMode == ASMIM_IMPLIED && data.mRegs[CPU_REG_A].mMask == 0xff && data.mRegs[CPU_REG_C].mMask)
			{
				carryop = data.mRegs[CPU_REG_C].mValue ? ASMIT_SEC : ASMIT_CLC;
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else
			data.mRegs[CPU_REG_C].mMask = 0;
		break;

	case ASMIT_ROR:
		if (iaddr >= 0)
		{
			int	mask = data.mRegs[iaddr].mMask, value = data.mRegs[iaddr].mValue;

			data.mRegs[iaddr].mMask = (mask >> 1) & 0x7f;
			data.mRegs[iaddr].mValue = (value >> 1) & 0x7f;

			if (data.mRegs[CPU_REG_C].mMask & 1)
			{
				data.mRegs[iaddr].mMask |= 0x80;
				data.mRegs[iaddr].mValue |= (data.mRegs[CPU_REG_C].mValue << 7) & 0x80;
			}

			if (mask & 0x01)
			{
				data.mRegs[CPU_REG_C].mMask = 1;
				data.mRegs[CPU_REG_C].mValue = value & 1;
			}
			else
				data.mRegs[CPU_REG_C].mMask = 0;

			if (mMode == ASMIM_IMPLIED && data.mRegs[CPU_REG_A].mMask == 0xff && data.mRegs[CPU_REG_C].mMask)
			{
				carryop = data.mRegs[CPU_REG_C].mValue ? ASMIT_SEC : ASMIT_CLC;
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
		}
		else
			data.mRegs[CPU_REG_C].mMask = 0;
		break;
	}

#if _DEBUG
	for (int i = 0; i < NUM_REGS; i++)
	{
		assert(!(data.mRegs[i].mMask & 0xff00));
	}
#endif

	return changed;
}

bool NativeCodeInstruction::ValueForwarding(NativeRegisterDataSet& data, AsmInsType& carryop, bool initial, bool final, int fastCallBase)
{
	bool	changed = false;

	carryop = ASMIT_NOP;

	mFlags &= ~NCIF_YZERO;

	if ((data.mRegs[CPU_REG_Y].mMode & NRDM_IMMEDIATE) && (data.mRegs[CPU_REG_Y].mValue == 0))
		mFlags |= NCIF_YZERO;

	if (mType == ASMIT_JSR)
	{
		data.mRegs[CPU_REG_C].Reset();
		data.mRegs[CPU_REG_Z].Reset();
		data.mRegs[CPU_REG_A].Reset();
		data.mRegs[CPU_REG_X].Reset();
		data.mRegs[CPU_REG_Y].Reset();

		data.ResetIndirect(0);

		data.ResetWorkRegs();

		if (!(mFlags & NCIF_RUNTIME) || (mFlags & NCIF_FEXEC))
		{
			if (mLinkerObject && mLinkerObject->mProc)
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP + mLinkerObject->mProc->mCallerSavedTemps; i++)
					data.ResetZeroPage(i);
			}
			else
			{
				for (int i = BC_REG_TMP; i < BC_REG_TMP_SAVED; i++)
					data.ResetZeroPage(i);
			}

			if (mLinkerObject && (mLinkerObject->mFlags & LOBJF_ZEROPAGESET))
			{
				for (int i = BC_REG_FPARAMS; i < BC_REG_FPARAMS + fastCallBase; i++)
					if (mLinkerObject->mZeroPageSet[i])
						data.ResetZeroPage(i);
			}
			else
			{
				for (int i = BC_REG_FPARAMS; i < BC_REG_FPARAMS + fastCallBase; i++)
					data.ResetZeroPage(i);
			}
		}

		return false;
	}

	if (data.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_C].mValue == 0)
	{
		switch (mType)
		{
		case ASMIT_ROL:
			mType = ASMIT_ASL;
			changed = true;
			break;
		case ASMIT_ROR:
			mType = ASMIT_LSR;
			changed = true;
			break;
		}
	}

	switch (mType)
	{
	case ASMIT_CLC:
		data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
		data.mRegs[CPU_REG_C].mValue = 0;
		break;
	case ASMIT_SEC:
		data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
		data.mRegs[CPU_REG_C].mValue = 1;
		break;

	case ASMIT_ROL:
	case ASMIT_ROR:
		if (mMode == ASMIM_IMPLIED)
			data.mRegs[CPU_REG_A].Reset();
		data.mRegs[CPU_REG_C].Reset();
		data.mRegs[CPU_REG_Z].Reset();
		break;

	case ASMIT_ASL:
	case ASMIT_LSR:
		if (mMode == ASMIM_IMPLIED)
		{
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == 0 && !(mLive & LIVE_CPU_REG_Z))
			{
				mType = ASMIT_CLC;				
				data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_C].mValue = 0;
				changed = true;
			}
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_C].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_INC:
	case ASMIT_DEC:
		data.mRegs[CPU_REG_Z].Reset();
		break;

	case ASMIT_LDA:
		if (mMode == ASMIM_IMMEDIATE)
		{
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == mAddress && !(mLive & LIVE_CPU_REG_Z))
			{
				mType = ASMIT_NOP;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			else
			{
				data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_A].mValue = mAddress;
			}

			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = mAddress;
		}
		else if (mMode == ASMIM_IMMEDIATE_ADDRESS)
		{
			data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE_ADDRESS;
			data.mRegs[CPU_REG_A].mValue = mAddress;
			data.mRegs[CPU_REG_A].mLinkerObject = mLinkerObject;
			data.mRegs[CPU_REG_A].mFlags = mFlags;
			data.mRegs[CPU_REG_Z].Reset();
		}
		else
		{
			if (mMode != ASMIM_ZERO_PAGE && mMode != ASMIM_ABSOLUTE && mMode != ASMIM_INDIRECT_Y && mMode != ASMIM_ABSOLUTE_X && mMode != ASMIM_ABSOLUTE_Y)
				data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_STA:
		if (mMode == ASMIM_ZERO_PAGE && data.mRegs[CPU_REG_A].mMode == NRDM_ZERO_PAGE && mAddress == data.mRegs[CPU_REG_A].mValue)
		{
			mType = ASMIT_NOP;
			mMode = ASMIM_IMPLIED;
			changed = true;
		}
		break;
	case ASMIT_STX:
		if (mMode == ASMIM_ZERO_PAGE && data.mRegs[CPU_REG_X].mMode == NRDM_ZERO_PAGE && mAddress == data.mRegs[CPU_REG_X].mValue)
		{
			mType = ASMIT_NOP;
			mMode = ASMIM_IMPLIED;
			changed = true;
		}
		break;
	case ASMIT_STY:
		if (mMode == ASMIM_ZERO_PAGE && data.mRegs[CPU_REG_Y].mMode == NRDM_ZERO_PAGE && mAddress == data.mRegs[CPU_REG_Y].mValue)
		{
			mType = ASMIT_NOP;
			mMode = ASMIM_IMPLIED;
			changed = true;
		}
		break;

	case ASMIT_ADC:
		if (data.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
		{
			if (mMode == ASMIM_IMMEDIATE && mAddress == 0 && data.mRegs[CPU_REG_C].mValue == 0)
			{
				mType = ASMIT_ORA;
				changed = true;
			}
			else if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == 0 && data.mRegs[CPU_REG_C].mValue == 0)
			{
				mType = ASMIT_LDA;
				changed = true;
			}
			else if (mMode == ASMIM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				int	t = mAddress + data.mRegs[CPU_REG_A].mValue + data.mRegs[CPU_REG_C].mValue;

				mType = ASMIT_LDA;
				mAddress = t & 0xff;

				int c = t >= 256;

				if (c && !data.mRegs[CPU_REG_C].mValue)
					carryop = ASMIT_SEC;
				else if (!c && data.mRegs[CPU_REG_C].mValue)
					carryop = ASMIT_CLC;

				changed = true;
			}
		}

		data.mRegs[CPU_REG_A].Reset();
		data.mRegs[CPU_REG_C].Reset();
		data.mRegs[CPU_REG_Z].Reset();
		break;

	case ASMIT_SBC:
		if (data.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
		{
			if (mMode == ASMIM_IMMEDIATE && mAddress == 0 && data.mRegs[CPU_REG_C].mValue == 1)
			{
				mType = ASMIT_ORA;
				changed = true;
			}
			else if (mMode == ASMIM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				int	t = (mAddress ^ 0xff) + data.mRegs[CPU_REG_A].mValue + data.mRegs[CPU_REG_C].mValue;

				mType = ASMIT_LDA;
				mAddress = t & 0xff;

				int c = t >= 256;

				if (c && !data.mRegs[CPU_REG_C].mValue)
					carryop = ASMIT_SEC;
				else if (!c && data.mRegs[CPU_REG_C].mValue)
					carryop = ASMIT_CLC;

				changed = true;
			}
			else if (mMode == ASMIM_IMMEDIATE_ADDRESS && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE_ADDRESS && mLinkerObject == data.mRegs[CPU_REG_A].mLinkerObject)
			{
				int	t;
				if (mFlags & NCIF_LOWER)
					t = (mAddress ^ 0xffff) + data.mRegs[CPU_REG_A].mValue + data.mRegs[CPU_REG_C].mValue;
				else
					t = ((mAddress ^ 0xffff) >> 8) + data.mRegs[CPU_REG_A].mValue + data.mRegs[CPU_REG_C].mValue;

				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = t & 0xff;

				int c = t >= 256;

				if (c && !data.mRegs[CPU_REG_C].mValue)
					carryop = ASMIT_SEC;
				else if (!c && data.mRegs[CPU_REG_C].mValue)
					carryop = ASMIT_CLC;

				changed = true;
			}
		}

		data.mRegs[CPU_REG_A].Reset();
		data.mRegs[CPU_REG_C].Reset();
		data.mRegs[CPU_REG_Z].Reset();
		break;
	case ASMIT_CMP:
		if (mMode == ASMIM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_A].mValue - mAddress;
			data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_C].mValue = data.mRegs[CPU_REG_A].mValue >= mAddress;
		}
		else if (mMode == ASMIM_IMMEDIATE && mAddress == 0)
		{
			data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_C].mValue = 1;			
			data.mRegs[CPU_REG_Z].Reset();
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_CPX:
		if (mMode == ASMIM_IMMEDIATE && data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_X].mValue - mAddress;
			data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_C].mValue = data.mRegs[CPU_REG_X].mValue >= mAddress;
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_CPY:
		if (mMode == ASMIM_IMMEDIATE && data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
		{
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_Y].mValue - mAddress;
			data.mRegs[CPU_REG_C].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_C].mValue = data.mRegs[CPU_REG_Y].mValue >= mAddress;
		}
		else
		{
			data.mRegs[CPU_REG_C].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;

	case ASMIT_ORA:
	case ASMIT_EOR:
	case ASMIT_AND:
		if (mMode == ASMIM_IMMEDIATE && data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
		{
			if (mType == ASMIT_ORA)
				mAddress |= data.mRegs[CPU_REG_A].mValue;
			else if (mType == ASMIT_AND)
				mAddress &= data.mRegs[CPU_REG_A].mValue;
			else if (mType == ASMIT_EOR)
				mAddress ^= data.mRegs[CPU_REG_A].mValue;
			mType = ASMIT_LDA;
			data.mRegs[CPU_REG_A].mValue = mAddress;
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = mAddress;
			changed = true;
		}
		else if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == 0)
		{
			if (mType == ASMIT_ORA || mType == ASMIT_EOR)
			{
				mType = ASMIT_LDA;
				data.mRegs[CPU_REG_A].Reset();
				data.mRegs[CPU_REG_Z].Reset();
			}
			else
			{
				mType = ASMIT_LDA;
				mMode = ASMIM_IMMEDIATE;
				mAddress = 0;

				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = 0;
			}
			changed = true;
		}
		else if (mMode == ASMIM_IMMEDIATE && mType == ASMIT_ORA && mAddress != 0x00)
		{
			data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
			data.mRegs[CPU_REG_Z].mValue = 1;
			data.mRegs[CPU_REG_A].Reset();
		}
		else if (mMode == ASMIM_IMMEDIATE && ((mAddress == 0 && (mType == ASMIT_ORA || mType == ASMIT_EOR)) || (mAddress == 0xff && mType == ASMIT_AND)))
		{
			data.mRegs[CPU_REG_Z].Reset();
		}
		else
		{
			data.mRegs[CPU_REG_A].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_LDX:
		data.ResetX();
		if (mMode == ASMIM_IMMEDIATE)
		{
			if (data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_X].mValue == mAddress && !(mLive & LIVE_CPU_REG_Z))
			{
				mType = ASMIT_NOP;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			else
			{
				data.mRegs[CPU_REG_X].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_X].mValue = mAddress;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = mAddress;
			}
		}
		else
		{
			if (mMode != ASMIM_ZERO_PAGE && mMode != ASMIM_ABSOLUTE && mMode != ASMIM_ABSOLUTE_Y)
				data.mRegs[CPU_REG_X].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_INX:
	case ASMIT_DEX:
		data.ResetX();
		data.mRegs[CPU_REG_X].Reset();
		data.mRegs[CPU_REG_Z].Reset();
		break;
	case ASMIT_LDY:
		data.ResetY();
		if (mMode == ASMIM_IMMEDIATE)
		{
			if (data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_Y].mValue == mAddress && !(mLive & LIVE_CPU_REG_Z))
			{
				mType = ASMIT_NOP;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			else
			{
				data.mRegs[CPU_REG_Y].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Y].mValue = mAddress;
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = mAddress;
			}
		}
		else
		{
			if (mMode != ASMIM_ZERO_PAGE && mMode != ASMIM_ABSOLUTE && mMode != ASMIM_ABSOLUTE_X)
				data.mRegs[CPU_REG_Y].Reset();
			data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_INY:
	case ASMIT_DEY:
		data.ResetY();
		data.mRegs[CPU_REG_Y].Reset();
		data.mRegs[CPU_REG_Z].Reset();
		break;

	case ASMIT_TXA:
		if (data.mRegs[CPU_REG_A].SameData(data.mRegs[CPU_REG_X]) && !(mLive & LIVE_CPU_REG_Z))
		{
			mType = ASMIT_NOP;
			mMode = ASMIM_IMPLIED;
			changed = true;
		}
		else
		{
			data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_X];
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_A].mValue;
			}
			else
				data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_TYA:
		if (data.mRegs[CPU_REG_A].SameData(data.mRegs[CPU_REG_Y]) && !(mLive & LIVE_CPU_REG_Z))
		{
			mType = ASMIT_NOP;
			mMode = ASMIM_IMPLIED;
			changed = true;
		}
		else
		{
			data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_Y];
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_A].mValue;
			}
			else
				data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_TAX:
		if (data.mRegs[CPU_REG_X].SameData(data.mRegs[CPU_REG_A]) && !(mLive & LIVE_CPU_REG_Z))
		{
			mType = ASMIT_NOP;
			mMode = ASMIM_IMPLIED;
			changed = true;
		}
		else
		{
			data.ResetX();
			data.mRegs[CPU_REG_X] = data.mRegs[CPU_REG_A];
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_A].mValue;
			}
			else
				data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	case ASMIT_TAY:
		if (data.mRegs[CPU_REG_Y].SameData(data.mRegs[CPU_REG_A]) && !(mLive & LIVE_CPU_REG_Z))
		{
			mType = ASMIT_NOP;
			mMode = ASMIM_IMPLIED;
			changed = true;
		}
		else
		{
			data.ResetY();
			data.mRegs[CPU_REG_Y] = data.mRegs[CPU_REG_A];
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[CPU_REG_Z].mMode = NRDM_IMMEDIATE;
				data.mRegs[CPU_REG_Z].mValue = data.mRegs[CPU_REG_A].mValue;
			}
			else
				data.mRegs[CPU_REG_Z].Reset();
		}
		break;
	}

#if 1
	if (mMode == ASMIM_ABSOLUTE_X && data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
	{
		mMode = ASMIM_ABSOLUTE;
		mAddress += data.mRegs[CPU_REG_X].mValue;
		changed = true;
	}
	else if (mMode == ASMIM_ABSOLUTE_Y && data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
	{
		mMode = ASMIM_ABSOLUTE;
		mAddress += data.mRegs[CPU_REG_Y].mValue;
		changed = true;
	}
#endif

#if 1
	if (mMode == ASMIM_ABSOLUTE_X && data.mRegs[CPU_REG_X].SameData(data.mRegs[CPU_REG_Y]) && HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_Y) && !(mFlags & NICT_INDEXFLIPPED))
	{
		mFlags |= NICT_INDEXFLIPPED;
		mMode = ASMIM_ABSOLUTE_Y;
		changed = true;
	}
	else if (final && mMode == ASMIM_ABSOLUTE_Y && data.mRegs[CPU_REG_X].SameData(data.mRegs[CPU_REG_Y]) && HasAsmInstructionMode(mType, ASMIM_ABSOLUTE_X) && !(mFlags & NICT_INDEXFLIPPED))
	{
		mFlags |= NICT_INDEXFLIPPED;
		mMode = ASMIM_ABSOLUTE_X;
		changed = true;
	}
#endif

#if 1
	if (mMode == ASMIM_ABSOLUTE && final && !(mFlags & NCIF_VOLATILE) && !ChangesAddress() && HasAsmInstructionMode(mType, ASMIM_ZERO_PAGE))
	{
		int i = data.FindAbsolute(mLinkerObject, mAddress);
		if (i >= 0)
		{
			mMode = ASMIM_ZERO_PAGE;
			mAddress = i;
			mLinkerObject = nullptr;
			changed = true;
		}
	}
#endif

	if (mMode == ASMIM_ZERO_PAGE)
	{
		switch (mType)
		{
		case ASMIT_LDA:
			if (data.mRegs[CPU_REG_A].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_A].mValue == mAddress)
			{
				if (mLive & LIVE_CPU_REG_Z)
				{
					mType = ASMIT_ORA;
					mMode = ASMIM_IMMEDIATE;
					mAddress = 0;
				}
				else
				{
					mType = ASMIT_NOP;
					mMode = ASMIM_IMPLIED;
				}
				changed = true;
			}
			else if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[CPU_REG_A] = data.mRegs[mAddress];
				mAddress = data.mRegs[CPU_REG_A].mValue;
				mMode = ASMIM_IMMEDIATE;
				changed = true;
			}
			else if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE_ADDRESS)
			{
				data.mRegs[CPU_REG_A] = data.mRegs[mAddress];
				mAddress = data.mRegs[CPU_REG_A].mValue;
				mLinkerObject = data.mRegs[CPU_REG_A].mLinkerObject;
				mFlags = (mFlags & ~(NCIF_LOWER | NCIF_UPPER)) | (data.mRegs[CPU_REG_A].mFlags & (NCIF_LOWER | NCIF_UPPER));
				mMode = ASMIM_IMMEDIATE_ADDRESS;
				changed = true;
			}
			else if (data.mRegs[mAddress].SameData(data.mRegs[CPU_REG_A]))
			{
				if (mLive & LIVE_CPU_REG_Z)
				{
					mType = ASMIT_ORA;
					mMode = ASMIM_IMMEDIATE;
					mAddress = 0;
				}
				else
				{
					mType = ASMIT_NOP;
					mMode = ASMIM_IMPLIED;
				}
				changed = true;
			}
			else if (data.mRegs[mAddress].mMode == NRDM_ZERO_PAGE)
			{
				data.mRegs[CPU_REG_A] = data.mRegs[mAddress];
				mAddress = data.mRegs[CPU_REG_A].mValue;
				changed = true;
			}
#if 1
			else if (data.mRegs[CPU_REG_X].SameData(*this))
			{
				mType = ASMIT_TXA;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_X];
				changed = true;
			}
			else if (data.mRegs[CPU_REG_Y].SameData(*this))
			{
				mType = ASMIT_TYA;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_Y];
				changed = true;
			}
#else
			else if (data.mRegs[CPU_REG_X].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_X].mValue == mAddress)
			{
				mType = ASMIT_TXA;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_X];
				changed = true;
			}
			else if (data.mRegs[CPU_REG_Y].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_Y].mValue == mAddress)
			{	
				mType = ASMIT_TYA;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_Y];
				changed = true;
			}
#endif
			else
			{
				data.mRegs[CPU_REG_A].Reset();
				if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
				{
					data.mRegs[CPU_REG_A].mMode = NRDM_IMMEDIATE;
					data.mRegs[CPU_REG_A].mValue = data.mRegs[mAddress].mValue;
				}
				else if (initial && mAddress == BC_REG_WORK_Y)
				{
					data.mRegs[CPU_REG_A].Reset();
				}
				else
				{
					data.mRegs[CPU_REG_A].mMode = NRDM_ZERO_PAGE;
					data.mRegs[CPU_REG_A].mValue = mAddress;
				}
			}
			break;

		case ASMIT_LDX:
			if (data.mRegs[CPU_REG_X].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_X].mValue == mAddress)
			{
				mType = ASMIT_NOP;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			else if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[CPU_REG_X] = data.mRegs[mAddress];
				mAddress = data.mRegs[CPU_REG_X].mValue;
				mMode = ASMIM_IMMEDIATE;
				changed = true;
			}
			else if (data.mRegs[CPU_REG_A].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_A].mValue == mAddress)
			{
				mType = ASMIT_TAX;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_X] = data.mRegs[CPU_REG_A];
				changed = true;
			}
			else if (data.mRegs[mAddress].SameData(data.mRegs[CPU_REG_A]))
			{
				mType = ASMIT_TAX;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_X] = data.mRegs[CPU_REG_A];
				changed = true;
			}
#if 1
			else if (data.mRegs[mAddress].mMode == NRDM_ZERO_PAGE)
			{
				data.mRegs[CPU_REG_X] = data.mRegs[mAddress];
				mAddress = data.mRegs[CPU_REG_X].mValue;
				changed = true;
			}
#endif
			else
			{
				data.mRegs[CPU_REG_X].Reset();
				if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
				{
					data.mRegs[CPU_REG_X].mMode = NRDM_IMMEDIATE;
					data.mRegs[CPU_REG_X].mValue = data.mRegs[mAddress].mValue;
				}
				else
				{
					data.mRegs[CPU_REG_X].mMode = NRDM_ZERO_PAGE;
					data.mRegs[CPU_REG_X].mValue = mAddress;
				}
			}
			break;

		case ASMIT_LDY:
			if (data.mRegs[CPU_REG_Y].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_Y].mValue == mAddress)
			{
				mType = ASMIT_NOP;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			else if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[CPU_REG_Y] = data.mRegs[mAddress];
				mAddress = data.mRegs[CPU_REG_Y].mValue;
				mMode = ASMIM_IMMEDIATE;
				changed = true;
			}
			else if (final && data.mRegs[CPU_REG_A].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_A].mValue == mAddress)
			{
				mType = ASMIT_TAY;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_Y] = data.mRegs[CPU_REG_A];
				changed = true;
			}
			else if (final && data.mRegs[mAddress].SameData(data.mRegs[CPU_REG_A]))
			{
				mType = ASMIT_TAY;
				mMode = ASMIM_IMPLIED;
				data.mRegs[CPU_REG_Y] = data.mRegs[CPU_REG_A];
				changed = true;
			}
#if 1
			else if (data.mRegs[mAddress].mMode == NRDM_ZERO_PAGE)
			{
				data.mRegs[CPU_REG_Y] = data.mRegs[mAddress];
				mAddress = data.mRegs[CPU_REG_Y].mValue;
				changed = true;
			}
#endif
			else
			{
				data.mRegs[CPU_REG_Y].Reset();
				if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
				{
					data.mRegs[CPU_REG_Y].mMode = NRDM_IMMEDIATE;
					data.mRegs[CPU_REG_Y].mValue = data.mRegs[mAddress].mValue;
				}
				else
				{
					data.mRegs[CPU_REG_Y].mMode = NRDM_ZERO_PAGE;
					data.mRegs[CPU_REG_Y].mValue = mAddress;
				}
			}
			break;

		case ASMIT_ADC:
		case ASMIT_SBC:
		case ASMIT_AND:
		case ASMIT_ORA:
		case ASMIT_EOR:
		case ASMIT_CMP:
		case ASMIT_CPX:
		case ASMIT_CPY:
			if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE)
			{
				mAddress = data.mRegs[mAddress].mValue;
				mMode = ASMIM_IMMEDIATE;
				changed = true;
			}
			else if (data.mRegs[mAddress].mMode == NRDM_ZERO_PAGE)
			{
				mAddress = data.mRegs[mAddress].mValue;
				changed = true;
			}
			else if (data.mRegs[mAddress].mMode == NRDM_ABSOLUTE && !final)
			{
				mMode = ASMIM_ABSOLUTE;
				mLinkerObject = data.mRegs[mAddress].mLinkerObject;
				mAddress = data.mRegs[mAddress].mValue;
				changed = true;
			}
			break;

		case ASMIT_STA:
			if (data.mRegs[mAddress].SameData(data.mRegs[CPU_REG_A]) || data.mRegs[CPU_REG_A].mMode == NRDM_ZERO_PAGE && data.mRegs[CPU_REG_A].mValue == mAddress)
			{
				mType = ASMIT_NOP;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			else
			{
				data.ResetZeroPage(mAddress);
				if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE || data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE_ADDRESS)
				{
					data.mRegs[mAddress] = data.mRegs[CPU_REG_A];
				}
				else if (data.mRegs[CPU_REG_A].mMode == NRDM_ZERO_PAGE)
				{
#if 1
					if (data.mRegs[data.mRegs[CPU_REG_A].mValue].mMode == NRDM_UNKNOWN &&
						(mAddress >= BC_REG_FPARAMS && mAddress < BC_REG_FPARAMS_END) &&
						!(data.mRegs[CPU_REG_A].mValue >= BC_REG_FPARAMS && data.mRegs[CPU_REG_A].mValue < BC_REG_FPARAMS_END))
					{
						data.mRegs[data.mRegs[CPU_REG_A].mValue].mMode = NRDM_ZERO_PAGE;
						data.mRegs[data.mRegs[CPU_REG_A].mValue].mValue = mAddress;
						data.mRegs[mAddress].Reset();
					}
					else
#endif	
					{
						data.mRegs[mAddress].mMode = NRDM_ZERO_PAGE;
						data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_A].mValue;
					}

				}
				else if (data.mRegs[CPU_REG_A].mMode == NRDM_ABSOLUTE)
				{
					data.mRegs[mAddress] = data.mRegs[CPU_REG_A];
				}
				else
				{
					data.mRegs[CPU_REG_A].mMode = NRDM_ZERO_PAGE;
					data.mRegs[CPU_REG_A].mValue = mAddress;
				}
			}
			break;
		case ASMIT_STX:
			data.ResetZeroPage(mAddress);
			if (data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[mAddress].mMode = NRDM_IMMEDIATE;
				data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_X].mValue;
			}
			else if (data.mRegs[CPU_REG_X].mMode == NRDM_ZERO_PAGE)
			{
				data.mRegs[mAddress].mMode = NRDM_ZERO_PAGE;
				data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_X].mValue;
			}
			else if (data.mRegs[CPU_REG_X].mMode == NRDM_ABSOLUTE)
			{
				data.mRegs[mAddress] = data.mRegs[CPU_REG_X];
			}
			else
			{
				data.mRegs[CPU_REG_X].mMode = NRDM_ZERO_PAGE;
				data.mRegs[CPU_REG_X].mValue = mAddress;
			}
			break;
		case ASMIT_STY:
			data.ResetZeroPage(mAddress);
			if (data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE)
			{
				data.mRegs[mAddress].mMode = NRDM_IMMEDIATE;
				data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_Y].mValue;
			}
			else if (data.mRegs[CPU_REG_Y].mMode == NRDM_ZERO_PAGE)
			{
				data.mRegs[mAddress].mMode = NRDM_ZERO_PAGE;
				data.mRegs[mAddress].mValue = data.mRegs[CPU_REG_Y].mValue;
			}
			else if (data.mRegs[CPU_REG_Y].mMode == NRDM_ABSOLUTE)
			{
				data.mRegs[mAddress] = data.mRegs[CPU_REG_Y];
			}
			else
			{
				data.mRegs[CPU_REG_Y].mMode = NRDM_ZERO_PAGE;
				data.mRegs[CPU_REG_Y].mValue = mAddress;
			}
			break;
		case ASMIT_INC:
		case ASMIT_DEC:
		case ASMIT_ASL:
		case ASMIT_LSR:
		case ASMIT_ROL:
		case ASMIT_ROR:
			data.ResetZeroPage(mAddress);			
			break;
		}
	}
	else if (final && mMode == ASMIM_IMMEDIATE)
	{
#if 1
		switch (mType)
		{
		case ASMIT_LDA:
			if (data.mRegs[CPU_REG_Y].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_Y].mValue == mAddress)
			{
				data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_Y];
				mType = ASMIT_TYA;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			else if (data.mRegs[CPU_REG_X].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_X].mValue == mAddress)
			{
				data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_X];
				mType = ASMIT_TXA;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			break;
		case ASMIT_LDX:
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == mAddress)
			{
				data.mRegs[CPU_REG_X] = data.mRegs[CPU_REG_A];
				mType = ASMIT_TAX;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			break;
		case ASMIT_LDY:
			if (data.mRegs[CPU_REG_A].mMode == NRDM_IMMEDIATE && data.mRegs[CPU_REG_A].mValue == mAddress)
			{
				data.mRegs[CPU_REG_Y] = data.mRegs[CPU_REG_A];
				mType = ASMIT_TAY;
				mMode = ASMIM_IMPLIED;
				changed = true;
			}
			break;
		}
#endif
	}
	else if (mMode == ASMIM_INDIRECT_Y)
	{
		if (data.mRegs[mAddress].mMode == NRDM_ZERO_PAGE && data.mRegs[mAddress + 1].mMode == NRDM_ZERO_PAGE && data.mRegs[mAddress].mValue + 1 == data.mRegs[mAddress + 1].mValue)
		{
			mFlags |= NICT_ZPFLIPPED;
			mAddress = data.mRegs[mAddress].mValue;
			if (mType == ASMIT_LDA)
				data.mRegs[CPU_REG_A].Reset();
		}
		else if (data.mRegs[mAddress].mMode == NRDM_IMMEDIATE_ADDRESS && data.mRegs[mAddress + 1].mMode == NRDM_IMMEDIATE_ADDRESS && data.mRegs[mAddress].mLinkerObject == data.mRegs[mAddress + 1].mLinkerObject)
		{
			mMode = ASMIM_ABSOLUTE_Y;
			mLinkerObject = data.mRegs[mAddress].mLinkerObject;
			mAddress = data.mRegs[mAddress + 1].mValue;
			if (mType == ASMIT_LDA)
				data.mRegs[CPU_REG_A].Reset();
		}
		else if (mType == ASMIT_LDA)
		{
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_A].mMode == NRDM_INDIRECT_Y && data.mRegs[CPU_REG_A].mValue == mAddress)
				{
					if (mLive & LIVE_CPU_REG_Z)
					{
						mType = ASMIT_ORA;
						mMode = ASMIM_IMMEDIATE;
						mAddress = 0;
					}
					else
					{
						mType = ASMIT_NOP;
						mMode = ASMIM_IMPLIED;
					}
					changed = true;
				}
				else if (data.mRegs[CPU_REG_X].SameData(*this))
				{
					mType = ASMIT_TXA;
					mMode = ASMIM_IMPLIED;
					data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_X];
					changed = true;
				}
				else if (data.mRegs[CPU_REG_Y].SameData(*this))
				{
					mType = ASMIT_TYA;
					mMode = ASMIM_IMPLIED;
					data.mRegs[CPU_REG_A] = data.mRegs[CPU_REG_Y];
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_A].mMode = NRDM_INDIRECT_Y;
					data.mRegs[CPU_REG_A].mValue = mAddress;
					data.mRegs[CPU_REG_A].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_A].Reset();
		}

		if (ChangesAddress())
			data.ResetIndirect(mAddress);
	}
	else if (mMode == ASMIM_ABSOLUTE_X)
	{
		if (mType == ASMIT_LDA)
		{
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_A].mMode == NRDM_ABSOLUTE_X && data.mRegs[CPU_REG_A].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_A].mValue == mAddress)
				{
					if (mLive & LIVE_CPU_REG_Z)
					{
						mType = ASMIT_ORA;
						mMode = ASMIM_IMMEDIATE;
						mAddress = 0;
					}
					else
					{
						mType = ASMIT_NOP;
						mMode = ASMIM_IMPLIED;
					}
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_A].mMode = NRDM_ABSOLUTE_X;
					data.mRegs[CPU_REG_A].mLinkerObject = mLinkerObject;
					data.mRegs[CPU_REG_A].mValue = mAddress;
					data.mRegs[CPU_REG_A].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_A].Reset();
		}
		else if (mType == ASMIT_LDY)
		{
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_Y].mMode == NRDM_ABSOLUTE_X && data.mRegs[CPU_REG_Y].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_Y].mValue == mAddress && !(mLive & LIVE_CPU_REG_Z))
				{
					mType = ASMIT_NOP;
					mMode = ASMIM_IMPLIED;
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_Y].mMode = NRDM_ABSOLUTE_X;
					data.mRegs[CPU_REG_Y].mLinkerObject = mLinkerObject;
					data.mRegs[CPU_REG_Y].mValue = mAddress;
					data.mRegs[CPU_REG_Y].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_Y].Reset();
		}

		if (ChangesAddress())
			data.ResetIndirect(mAddress);
	}
	else if (mMode == ASMIM_ABSOLUTE_Y)
	{
		if (mType == ASMIT_LDA)
		{
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_A].mMode == NRDM_ABSOLUTE_Y && data.mRegs[CPU_REG_A].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_A].mValue == mAddress)
				{
					if (mLive & LIVE_CPU_REG_Z)
					{
						mType = ASMIT_ORA;
						mMode = ASMIM_IMMEDIATE;
						mAddress = 0;
					}
					else
					{
						mType = ASMIT_NOP;
						mMode = ASMIM_IMPLIED;
					}
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_A].mMode = NRDM_ABSOLUTE_Y;
					data.mRegs[CPU_REG_A].mLinkerObject = mLinkerObject;
					data.mRegs[CPU_REG_A].mValue = mAddress;
					data.mRegs[CPU_REG_A].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_A].Reset();
		}
		else if (mType == ASMIT_LDX)
		{
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_X].mMode == NRDM_ABSOLUTE_Y && data.mRegs[CPU_REG_X].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_X].mValue == mAddress && !(mLive & LIVE_CPU_REG_Z))
				{
					mType = ASMIT_NOP;
					mMode = ASMIM_IMPLIED;
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_X].mMode = NRDM_ABSOLUTE_Y;
					data.mRegs[CPU_REG_X].mLinkerObject = mLinkerObject;
					data.mRegs[CPU_REG_X].mValue = mAddress;
					data.mRegs[CPU_REG_X].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_X].Reset();
		}

		if (ChangesAddress())
			data.ResetIndirect(mAddress);
	}
	else if (mMode == ASMIM_ABSOLUTE)
	{
		switch (mType)
		{
		case ASMIT_LDA:
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_A].mMode == NRDM_ABSOLUTE && data.mRegs[CPU_REG_A].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_A].mValue == mAddress)
				{
					if (mLive & LIVE_CPU_REG_Z)
					{
						mType = ASMIT_ORA;
						mMode = ASMIM_IMMEDIATE;
						mAddress = 0;
					}
					else
					{
						mType = ASMIT_NOP;
						mMode = ASMIM_IMPLIED;
					}
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_A].mMode = NRDM_ABSOLUTE;
					data.mRegs[CPU_REG_A].mLinkerObject = mLinkerObject;
					data.mRegs[CPU_REG_A].mValue = mAddress;
					data.mRegs[CPU_REG_A].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_A].Reset();
			break;
		case ASMIT_LDY:
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_Y].mMode == NRDM_ABSOLUTE && data.mRegs[CPU_REG_Y].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_Y].mValue == mAddress)
				{
					if (!(mLive & LIVE_CPU_REG_Z))
					{
						mType = ASMIT_NOP;
						mMode = ASMIM_IMPLIED;
					}
					changed = true;
				}
				else if (final && data.mRegs[CPU_REG_A].mMode == NRDM_ABSOLUTE && data.mRegs[CPU_REG_A].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_A].mValue == mAddress)
				{
					mType = ASMIT_TAY;
					mMode = ASMIM_IMPLIED;

					data.mRegs[CPU_REG_Y] = data.mRegs[CPU_REG_A];
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_Y].mMode = NRDM_ABSOLUTE;
					data.mRegs[CPU_REG_Y].mLinkerObject = mLinkerObject;
					data.mRegs[CPU_REG_Y].mValue = mAddress;
					data.mRegs[CPU_REG_Y].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_Y].Reset();
			break;
		case ASMIT_LDX:
			if (!(mFlags & NCIF_VOLATILE))
			{
				if (data.mRegs[CPU_REG_X].mMode == NRDM_ABSOLUTE && data.mRegs[CPU_REG_X].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_X].mValue == mAddress)
				{
					if (!(mLive & LIVE_CPU_REG_Z))
					{
						mType = ASMIT_NOP;
						mMode = ASMIM_IMPLIED;
					}
					changed = true;
				}
				else if (final && data.mRegs[CPU_REG_A].mMode == NRDM_ABSOLUTE && data.mRegs[CPU_REG_A].mLinkerObject == mLinkerObject && data.mRegs[CPU_REG_A].mValue == mAddress)
				{
					mType = ASMIT_TAX;
					mMode = ASMIM_IMPLIED;

					data.mRegs[CPU_REG_X] = data.mRegs[CPU_REG_A];
					changed = true;
				}
				else
				{
					data.mRegs[CPU_REG_X].mMode = NRDM_ABSOLUTE;
					data.mRegs[CPU_REG_X].mLinkerObject = mLinkerObject;
					data.mRegs[CPU_REG_X].mValue = mAddress;
					data.mRegs[CPU_REG_X].mFlags = mFlags;
				}
			}
			else
				data.mRegs[CPU_REG_X].Reset();
			break;
		default:
			if (ChangesAddress())
				data.ResetAbsolute(mLinkerObject, mAddress);
		}
	}

	return changed;
}

void NativeCodeInstruction::FilterRegUsage(NumberSet& requiredTemps, NumberSet& providedTemps)
{
	// check runtime calls

	if (mType == ASMIT_JSR)
	{
#if 1
		if (mFlags & NCIF_USE_CPU_REG_A)
		{
			if (!providedTemps[CPU_REG_A])
				requiredTemps += CPU_REG_A;
		}
		if (mFlags & NCIF_USE_CPU_REG_X)
		{
			if (!providedTemps[CPU_REG_X])
				requiredTemps += CPU_REG_X;
		}
		if (mFlags & NCIF_USE_CPU_REG_Y)
		{
			if (!providedTemps[CPU_REG_Y])
				requiredTemps += CPU_REG_Y;
		}

		if (mFlags & NCIF_RUNTIME)
		{
			for (int i = 0; i < 4; i++)
			{
				if (!providedTemps[BC_REG_ACCU + i])
					requiredTemps += BC_REG_ACCU + i;
				if (!providedTemps[BC_REG_WORK + i])
					requiredTemps += BC_REG_WORK + i;
			}
			if (mFlags & NCIF_USE_ZP_32_X)
			{
				for (int i = 0; i < 4; i++)
				{
					if (!providedTemps[mParam + i])
						requiredTemps += mParam + i;
				}
			}

			if (mFlags & NCIF_FEXEC)
			{
				for (int i = BC_REG_FPARAMS; i < BC_REG_FPARAMS_END; i++)
					if (!providedTemps[i])
						requiredTemps += i;
			}
		}
		else if (mFlags & NICF_USE_WORKREGS)
		{
			for (int i = 0; i < 10; i++)
				if (!providedTemps[BC_REG_WORK + i])
					requiredTemps += BC_REG_WORK + i;
		}
		else
		{
			if (mLinkerObject)
			{
				for (int i = 0; i < mLinkerObject->mNumTemporaries; i++)
				{
					for (int j = 0; j < mLinkerObject->mTempSizes[i]; j++)
					{
						if (!providedTemps[mLinkerObject->mTemporaries[i] + j])
							requiredTemps += mLinkerObject->mTemporaries[i] + j;
					}
				}
			}
		}
#endif
		providedTemps += BC_REG_ADDR + 0;
		providedTemps += BC_REG_ADDR + 1;

		for (int i = 0; i < 4; i++)
			providedTemps += BC_REG_ACCU + i;
		for (int i = 0; i < 8; i++)
			providedTemps += BC_REG_WORK + i;

		providedTemps += CPU_REG_A;
		providedTemps += CPU_REG_X;
		providedTemps += CPU_REG_Y;
		providedTemps += CPU_REG_C;
		providedTemps += CPU_REG_Z;
		return;
	}

	if (mType == ASMIT_RTS)
	{
#if 1
		if (mFlags & NCIF_USE_CPU_REG_A)
		{
			if (!providedTemps[CPU_REG_A])
				requiredTemps += CPU_REG_A;
		}

		if (mFlags & NCIF_LOWER)
		{
			if (!providedTemps[BC_REG_ACCU + 0]) requiredTemps += BC_REG_ACCU + 0;

			if (mFlags & NCIF_UPPER)
			{
				if (!providedTemps[BC_REG_ACCU + 1]) requiredTemps += BC_REG_ACCU + 1;

				if (mFlags & NCIF_LONG)
				{
					if (!providedTemps[BC_REG_ACCU + 2]) requiredTemps += BC_REG_ACCU + 2;
					if (!providedTemps[BC_REG_ACCU + 3]) requiredTemps += BC_REG_ACCU + 3;
				}
			}
		}
#endif
#if 0
		for (int i = 0; i < 4; i++)
		{
			if (!providedTemps[BC_REG_ACCU + i])
				requiredTemps += BC_REG_ACCU + i;
		}
#endif
		if (!providedTemps[BC_REG_STACK])
			requiredTemps += BC_REG_STACK;
		if (!providedTemps[BC_REG_STACK + 1])
			requiredTemps += BC_REG_STACK + 1;
		if (!providedTemps[BC_REG_LOCALS])
			requiredTemps += BC_REG_LOCALS;
		if (!providedTemps[BC_REG_LOCALS + 1])
			requiredTemps += BC_REG_LOCALS + 1;

		return;
	}

	// check index

	switch (mMode)
	{
	case ASMIM_ZERO_PAGE_X:
	case ASMIM_INDIRECT_X:
	case ASMIM_ABSOLUTE_X:
		if (!providedTemps[CPU_REG_X])
			requiredTemps += CPU_REG_X;
		break;

	case ASMIM_ZERO_PAGE_Y:
	case ASMIM_ABSOLUTE_Y:
		if (!providedTemps[CPU_REG_Y])
			requiredTemps += CPU_REG_Y;
		break;

	case ASMIM_INDIRECT_Y:
		if (!providedTemps[CPU_REG_Y])
			requiredTemps += CPU_REG_Y;
		if (!providedTemps[mAddress])
			requiredTemps += mAddress;
		if (!providedTemps[mAddress + 1])
			requiredTemps += mAddress + 1;
		break;
	}

	// check carry flags

	switch (mType)
	{
	case ASMIT_ADC:
	case ASMIT_SBC:
	case ASMIT_ROL:
	case ASMIT_ROR:
		if (!providedTemps[CPU_REG_C])
			requiredTemps += CPU_REG_C;
		providedTemps += CPU_REG_C;
		break;
	case ASMIT_CMP:
	case ASMIT_ASL:
	case ASMIT_LSR:
	case ASMIT_CPX:
	case ASMIT_CPY:
	case ASMIT_CLC:
	case ASMIT_SEC:
		providedTemps += CPU_REG_C;
		break;
	case ASMIT_BCC:
	case ASMIT_BCS:
		if (!providedTemps[CPU_REG_C])
			requiredTemps += CPU_REG_C;
		break;
	case ASMIT_BEQ:
	case ASMIT_BNE:
	case ASMIT_BPL:
	case ASMIT_BMI:
		if (!providedTemps[CPU_REG_Z])
			requiredTemps += CPU_REG_Z;
		break;
	}

	// check zero flag

	switch (mType)
	{
	case ASMIT_ADC:
	case ASMIT_SBC:
	case ASMIT_ROL:
	case ASMIT_ROR:
	case ASMIT_INC:
	case ASMIT_DEC:
	case ASMIT_CMP:
	case ASMIT_CPX:
	case ASMIT_CPY:
	case ASMIT_ASL:
	case ASMIT_LSR:
	case ASMIT_ORA:
	case ASMIT_EOR:
	case ASMIT_AND:
	case ASMIT_LDA:
	case ASMIT_LDX:
	case ASMIT_LDY:
	case ASMIT_BIT:
	case ASMIT_TAX:
	case ASMIT_TXA:
	case ASMIT_TAY:
	case ASMIT_TYA:
		providedTemps += CPU_REG_Z;
		break;
	}

	// check CPU register

	switch (mType)
	{
	case ASMIT_ROL:
	case ASMIT_ROR:
	case ASMIT_ASL:
	case ASMIT_LSR:
		if (mMode == ASMIM_IMPLIED)
		{
			if (!providedTemps[CPU_REG_A])
				requiredTemps += CPU_REG_A;
			providedTemps += CPU_REG_A;
		}
		break;

	case ASMIT_LDA:
		providedTemps += CPU_REG_A;
		break;

	case ASMIT_CMP:
	case ASMIT_STA:
		if (!providedTemps[CPU_REG_A])
			requiredTemps += CPU_REG_A;
		break;
	case ASMIT_CPX:
	case ASMIT_STX:
		if (!providedTemps[CPU_REG_X])
			requiredTemps += CPU_REG_X;
		break;
	case ASMIT_CPY:
	case ASMIT_STY:
		if (!providedTemps[CPU_REG_Y])
			requiredTemps += CPU_REG_Y;
		break;

	case ASMIT_ADC:
	case ASMIT_SBC:
	case ASMIT_ORA:
	case ASMIT_EOR:
	case ASMIT_AND:
		if (!providedTemps[CPU_REG_A])
			requiredTemps += CPU_REG_A;
		providedTemps += CPU_REG_A;
		break;
	case ASMIT_LDX:
		providedTemps += CPU_REG_X;
		break;
	case ASMIT_INX:
	case ASMIT_DEX:
		if (!providedTemps[CPU_REG_X])
			requiredTemps += CPU_REG_X;
		providedTemps += CPU_REG_X;
		break;
	case ASMIT_LDY:
		providedTemps += CPU_REG_Y;
		break;
	case ASMIT_INY:
	case ASMIT_DEY:
		if (!providedTemps[CPU_REG_Y])
			requiredTemps += CPU_REG_Y;
		providedTemps += CPU_REG_Y;
		break;

	case ASMIT_TAX:
		if (!providedTemps[CPU_REG_A])
			requiredTemps += CPU_REG_A;
		providedTemps += CPU_REG_X;
		break;
	case ASMIT_TAY:
		if (!providedTemps[CPU_REG_A])
			requiredTemps += CPU_REG_A;
		providedTemps += CPU_REG_Y;
		break;
	case ASMIT_TXA:
		if (!providedTemps[CPU_REG_X])
			requiredTemps += CPU_REG_X;
		providedTemps += CPU_REG_A;
		break;
	case ASMIT_TYA:
		if (!providedTemps[CPU_REG_Y])
			requiredTemps += CPU_REG_Y;
		providedTemps += CPU_REG_A;
		break;
	}

	if (mMode == ASMIM_ZERO_PAGE)
	{
		switch (mType)
		{
		case ASMIT_STA:
		case ASMIT_STX:
		case ASMIT_STY:
			providedTemps += mAddress;
			break;
		case ASMIT_ROL:
		case ASMIT_ROR:
		case ASMIT_ASL:
		case ASMIT_LSR:
		case ASMIT_INC:
		case ASMIT_DEC:
			if (!providedTemps[mAddress])
				requiredTemps += mAddress;
			providedTemps += mAddress;
			break;
		default:
			if (!providedTemps[mAddress])
				requiredTemps += mAddress;
		}
	}
}

void NativeCodeInstruction::CopyMode(const NativeCodeInstruction& ins)
{
	mMode = ins.mMode;
	mAddress = ins.mAddress;
	mLinkerObject = ins.mLinkerObject;
	mFlags = (mFlags & ~(NCIF_LOWER | NCIF_UPPER)) | (ins.mFlags & (NCIF_LOWER | NCIF_UPPER | NCIF_VOLATILE));
}

void NativeCodeInstruction::Assemble(NativeCodeBasicBlock* block)
{
	bool	weak = true;

	if (mIns)
	{
		if (ChangesAddress() && (mMode != ASMIM_ZERO_PAGE || mLinkerObject))
			weak = false;
		else if (mType == ASMIT_JSR && !(mFlags & NCIF_RUNTIME))
			weak = false;
		block->PutLocation(mIns->mLocation, weak);
	}

	if (mType == ASMIT_BYTE)
		block->PutByte(mAddress);
	else if (mType == ASMIT_JSR && mLinkerObject && (mLinkerObject->mFlags & LOBJF_INLINE))
	{
		int	pos = block->mCode.Size();
		int size = mLinkerObject->mSize;

		// skip RTS on embedding
		if (mLinkerObject->mData[size - 1] == 0x60)
			size--;

		for (int i = 0; i < size; i++)
			block->PutByte(mLinkerObject->mData[i]);
		for (int i = 0; i < mLinkerObject->mReferences.Size(); i++)
		{
			LinkerReference	rl = *(mLinkerObject->mReferences[i]);
			if (rl.mFlags & LREF_TEMPORARY)
			{
				block->mCode[pos + rl.mOffset] += mLinkerObject->mTemporaries[rl.mRefOffset];
			}
			else
			{
				rl.mOffset += pos;
				if (rl.mRefObject == rl.mObject)
				{
					rl.mRefObject = nullptr;
					rl.mRefOffset += pos;
					rl.mFlags |= LREF_INBLOCK;
				}

				block->mRelocations.Push(rl);
			}
		}
	}
	else
	{
		if (mType == ASMIT_JSR && (mFlags & NCIF_USE_ZP_32_X))
		{
			block->PutOpcode(AsmInsOpcodes[ASMIT_LDX][ASMIM_IMMEDIATE]);
			block->PutByte(mParam);
		}

		AsmInsMode	mode = mMode;

		if (mode == ASMIM_ABSOLUTE && !mLinkerObject && mAddress < 256 && HasAsmInstructionMode(mType, ASMIM_ZERO_PAGE))
			mode = ASMIM_ZERO_PAGE;
		else if (mode == ASMIM_ABSOLUTE_X && !mLinkerObject && mAddress < 256 && HasAsmInstructionMode(mType, ASMIM_ZERO_PAGE_X))
			mode = ASMIM_ZERO_PAGE_X;
		else if (mode == ASMIM_ABSOLUTE_Y && !mLinkerObject && mAddress < 256 && HasAsmInstructionMode(mType, ASMIM_ZERO_PAGE_Y))
			mode = ASMIM_ZERO_PAGE_Y;
		else if (mode == ASMIM_ABSOLUTE && mLinkerObject && (mLinkerObject->mFlags & LOBJF_ZEROPAGE) && HasAsmInstructionMode(mType, ASMIM_ZERO_PAGE))
			mode = ASMIM_ZERO_PAGE;
		else if (mode == ASMIM_ABSOLUTE_X && mLinkerObject && (mLinkerObject->mFlags & LOBJF_ZEROPAGE) && HasAsmInstructionMode(mType, ASMIM_ZERO_PAGE_X))
			mode = ASMIM_ZERO_PAGE_X;
		else if (mode == ASMIM_ABSOLUTE_Y && mLinkerObject && (mLinkerObject->mFlags & LOBJF_ZEROPAGE) && HasAsmInstructionMode(mType, ASMIM_ZERO_PAGE_Y))
			mode = ASMIM_ZERO_PAGE_Y;

		if (mode == ASMIM_IMMEDIATE_ADDRESS)
		{
			assert((mFlags & (NCIF_LOWER | NCIF_UPPER)) != (NCIF_LOWER | NCIF_UPPER));
			assert(HasAsmInstructionMode(mType, ASMIM_IMMEDIATE));
			block->PutOpcode(AsmInsOpcodes[mType][ASMIM_IMMEDIATE]);
		}
		else
		{
			assert(HasAsmInstructionMode(mType, mode));
			block->PutOpcode(AsmInsOpcodes[mType][mode]);
		}
		
		switch (mode)
		{
		case ASMIM_IMPLIED:
			break;
		case ASMIM_ZERO_PAGE:
		case ASMIM_ZERO_PAGE_X:
		case ASMIM_ZERO_PAGE_Y:
		case ASMIM_INDIRECT_X:
		case ASMIM_INDIRECT_Y:
			if (mLinkerObject)
			{
				LinkerReference		rl;
				rl.mOffset = block->mCode.Size();

				rl.mRefObject = mLinkerObject;
				rl.mRefOffset = mAddress;
				rl.mFlags = LREF_LOWBYTE;

				block->mRelocations.Push(rl);
				block->PutByte(0);
			}
			else
			{
				if (mAddress == 0)
					block->mProc->mGenerator->mErrors->Error(mIns->mLocation, EWARN_NULL_POINTER_DEREFERENCED, "nullptr dereferenced");
				block->PutByte(uint8(mAddress));
			}
			break;
		case ASMIM_IMMEDIATE:
			block->PutByte(uint8(mAddress));
			break;
		case ASMIM_IMMEDIATE_ADDRESS:
			if (mLinkerObject)
			{
				LinkerReference		rl;
				rl.mOffset = block->mCode.Size();
				rl.mFlags = 0;
				if (mFlags & NCIF_LOWER)
					rl.mFlags |= LREF_LOWBYTE;
				if (mFlags & NCIF_UPPER)
					rl.mFlags |= LREF_HIGHBYTE;
				rl.mRefObject = mLinkerObject;

				rl.mRefObject = mLinkerObject;
				rl.mRefOffset = mAddress;

				if (mLinkerObject)
					mLinkerObject->mFlags |= LOBJF_NO_CROSS;

				block->mRelocations.Push(rl);
				block->PutByte(0);
			}
			else
			{
				block->PutByte(uint8(mAddress));
			}
			break;
		case ASMIM_ABSOLUTE:
		case ASMIM_INDIRECT:
		case ASMIM_ABSOLUTE_X:
		case ASMIM_ABSOLUTE_Y:
			if (mLinkerObject)
			{
				int	w = 0;

				LinkerReference		rl;
				rl.mOffset = block->mCode.Size();

				rl.mRefObject = mLinkerObject;
				if (mFlags & NCIF_LOWER)
				{
					rl.mFlags = LREF_LOWBYTE | LREF_HIGHBYTE;
					rl.mRefOffset = mAddress;
				}
				else
				{
					rl.mFlags = LREF_HIGHBYTE;
					rl.mOffset++;
					rl.mRefOffset = mAddress & 0xff00;

					w = mAddress & 0xff;
				}

				if (mode != ASMIM_ABSOLUTE)
					mLinkerObject->mFlags |= LOBJF_NO_CROSS;

				block->mRelocations.Push(rl);
				block->PutWord(w);
			}
			else
			{
				if (mAddress == 0)
					block->mProc->mGenerator->mErrors->Error(mIns->mLocation, EWARN_NULL_POINTER_DEREFERENCED, "nullptr dereferenced");
				block->PutWord(uint16(mAddress));
			}
			break;
		case ASMIM_RELATIVE:
			block->PutByte(uint8(mAddress));
			break;
		}
	}

	if (mIns)
		block->PutLocation(mIns->mLocation, weak);
}

void NativeCodeBasicBlock::PutLocation(const Location& location, bool weak)
{
	int sz = mCodeLocations.Size();
	if (sz > 0 && 
		(weak ||
		 (mCodeLocations[sz - 1].mLocation.mFileName == location.mFileName &&
		 mCodeLocations[sz - 1].mLocation.mLine == location.mLine)))
	{
		mCodeLocations[sz - 1].mEnd = this->mCode.Size();
		if (mCodeLocations[sz - 1].mWeak)
			mCodeLocations[sz - 1].mWeak = weak;
	}
	else if (sz > 0 && mCodeLocations[sz - 1].mWeak)
	{
		mCodeLocations[sz - 1].mLocation = location;
		mCodeLocations[sz - 1].mEnd = this->mCode.Size();
		mCodeLocations[sz - 1].mWeak = weak;
	}
	else
	{
		CodeLocation	loc;
		loc.mLocation = location;
		loc.mStart = loc.mEnd = this->mCode.Size();
		loc.mWeak = weak;
		mCodeLocations.Push(loc);
	}
}

void NativeCodeBasicBlock::PutOpcode(short opcode)
{
	assert(opcode >= 0 && opcode < 256);
	this->mCode.Push(uint8(opcode));
}

void NativeCodeBasicBlock::PutByte(uint8 code)
{
	this->mCode.Push(code);
}

void NativeCodeBasicBlock::PutWord(uint16 code)
{
	this->mCode.Push((uint8)(code & 0xff));
	this->mCode.Push((uint8)(code >> 8));
}

static AsmInsType InvertBranchCondition(AsmInsType code)
{
	switch (code)
	{
	case ASMIT_BEQ: return ASMIT_BNE;
	case ASMIT_BNE: return ASMIT_BEQ;
	case ASMIT_BPL: return ASMIT_BMI;
	case ASMIT_BMI: return ASMIT_BPL;
	case ASMIT_BCS: return ASMIT_BCC;
	case ASMIT_BCC: return ASMIT_BCS;
	default:
		return code;
	}
}

static AsmInsType TransposeBranchCondition(AsmInsType code)
{
	switch (code)
	{
	case ASMIT_BEQ: return ASMIT_BEQ;
	case ASMIT_BNE: return ASMIT_BNE;
	case ASMIT_BPL: return ASMIT_BMI;
	case ASMIT_BMI: return ASMIT_BPL;
	case ASMIT_BCS: return ASMIT_BCC;
	case ASMIT_BCC: return ASMIT_BCS;
	default:
		return code;
	}
}


int NativeCodeBasicBlock::PutJump(NativeCodeProcedure* proc, NativeCodeBasicBlock* target, int offset)
{
	if (target->mIns.Size() == 1 && target->mIns[0].mType == ASMIT_RTS)
	{
		if (mIns.Size() > 0 && mIns.Last().IsSimpleJSR())
		{
			this->mCode[this->mCode.Size() - 3] = 0x4c;
			return 0;
		}
		else
		{
			PutByte(0x60);
			return 1;
		}
	}
#if JUMP_TO_BRANCH
	else if (offset >= -126 && offset <= 129)
	{
		if (mNDataSet.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
		{
			if (mNDataSet.mRegs[CPU_REG_C].mValue)
				PutOpcode(AsmInsOpcodes[ASMIT_BCS][ASMIM_RELATIVE]);
			else
				PutOpcode(AsmInsOpcodes[ASMIT_BCC][ASMIM_RELATIVE]);

			PutByte(offset - 2);
			return 2;
		}
		else if (mNDataSet.mRegs[CPU_REG_Z].mMode == NRDM_IMMEDIATE)
		{
			if (mNDataSet.mRegs[CPU_REG_Z].mValue)
				PutOpcode(AsmInsOpcodes[ASMIT_BNE][ASMIM_RELATIVE]);
			else
				PutOpcode(AsmInsOpcodes[ASMIT_BEQ][ASMIM_RELATIVE]);

			PutByte(offset - 2);
			return 2;
		}
	}
#endif
	PutByte(0x4c);

	LinkerReference		rl;
	rl.mObject = nullptr;
	rl.mOffset = mCode.Size();
	rl.mFlags = LREF_LOWBYTE | LREF_HIGHBYTE;
	rl.mRefObject = nullptr;
	rl.mRefOffset = target->mOffset;
	mRelocations.Push(rl);

	PutWord(0);
	return 3;
}

int NativeCodeBasicBlock::BranchByteSize(NativeCodeBasicBlock* target, int from, int to)
{
	if (to - from >= -126 && to - from <= 129)
		return 2;
	else
	{
		if (target->mIns.Size() == 1 && target->mIns[0].mType == ASMIT_RTS)
			return 3;
		return 5;
	}
}

int NativeCodeBasicBlock::JumpByteSize(NativeCodeBasicBlock* target, int offset)
{
	if (target->mIns.Size() == 1 && target->mIns[0].mType == ASMIT_RTS)
	{
		if (mIns.Size() > 0 && mIns.Last().IsSimpleJSR())
			return 0;
		else
			return 1;
	}
#if JUMP_TO_BRANCH
	else if (offset >= -126 && offset <= 129)
	{
		if (mNDataSet.mRegs[CPU_REG_C].mMode == NRDM_IMMEDIATE)
			return 2;
		else if (mNDataSet.mRegs[CPU_REG_Z].mMode == NRDM_IMMEDIATE)
			return 2;
		else
			return 3;
	}
#endif
	else
		return 3;
}


int NativeCodeBasicBlock::PutBranch(NativeCodeProcedure* proc, NativeCodeBasicBlock* target, AsmInsType code, int offset)
{
	if (offset >= -126 && offset <= 129)
	{
		PutOpcode(AsmInsOpcodes[code][ASMIM_RELATIVE]);
		PutByte(offset - 2);
		return 2;
	}
	else
	{
		PutOpcode(AsmInsOpcodes[InvertBranchCondition(code)][ASMIM_RELATIVE]);

		if (target->mIns.Size() == 1 && target->mIns[0].mType == ASMIT_RTS)
		{
			PutByte(1);
			PutByte(0x60);
			return 3;
		}
		else
		{
			PutByte(3);
			PutByte(0x4c);

			LinkerReference		rl;
			rl.mObject = nullptr;
			rl.mOffset = mCode.Size();
			rl.mFlags = LREF_LOWBYTE | LREF_HIGHBYTE;
			rl.mRefObject = nullptr;
			rl.mRefOffset = mOffset + mCode.Size() + offset - 3;
			mRelocations.Push(rl);

			PutWord(0);
			return 5;
		}
	}
}

void NativeCodeBasicBlock::LoadConstantToReg(InterCodeProcedure * proc, const InterInstruction * ins, InterType type, int reg)
{
	if (type == IT_FLOAT)
	{
		union { float f; unsigned int v; } cc;
		cc.f = float(ins->mConst.mFloatConst);

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
	}
	else if (type == IT_POINTER)
	{
		if (ins->mConst.mMemory == IM_GLOBAL)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mConst.mIntConst, ins->mConst.mLinkerObject, NCIF_LOWER));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mConst.mIntConst, ins->mConst.mLinkerObject, NCIF_UPPER));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		}
		else if (ins->mConst.mMemory == IM_ABSOLUTE)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mConst.mIntConst & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mConst.mIntConst >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		}
		else if (ins->mConst.mMemory == IM_FPARAM || ins->mConst.mMemory == IM_FFRAME)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, BC_REG_FPARAMS + ins->mConst.mVarIndex + ins->mConst.mIntConst));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		}
		else if (ins->mConst.mMemory == IM_FRAME)
		{
			int	index = ins->mConst.mVarIndex + int(ins->mConst.mIntConst) + 2;

			mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_STACK));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_STACK + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (index >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		}
		else if (ins->mConst.mMemory == IM_LOCAL || ins->mConst.mMemory == IM_PARAM)
		{
			int	index = int(ins->mConst.mIntConst);
			int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
			if (ins->mConst.mMemory == IM_LOCAL)
				index += proc->mLocalVars[ins->mConst.mVarIndex]->mOffset;
			else
				index += ins->mConst.mVarIndex + proc->mLocalSize + 2;
			index += mFrameOffset;
			CheckFrameIndex(ins, areg, index, 2);

			if (index != 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, areg));
			if (index != 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, areg + 1));
			if (index != 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (index >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		}
		else if (ins->mConst.mMemory == IM_PROCEDURE)
		{
			NativeCodeInstruction	lins(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mConst.mLinkerObject, NCIF_LOWER);
			NativeCodeInstruction	hins(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mConst.mLinkerObject, NCIF_UPPER);

			mIns.Push(lins);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
			mIns.Push(hins);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		}
	}
	else if (type == IT_INT32)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mConst.mIntConst & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mConst.mIntConst >> 8) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mConst.mIntConst >> 16) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mConst.mIntConst >> 24) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mConst.mIntConst & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
		if (InterTypeSize[ins->mDst.mType] > 1)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mConst.mIntConst >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		}
	}

}

void NativeCodeBasicBlock::LoadConstant(InterCodeProcedure* proc, const InterInstruction * ins)
{
	LoadConstantToReg(proc, ins, ins->mDst.mType, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]);
}

void NativeCodeBasicBlock::CheckFrameIndex(const InterInstruction* ins, int& reg, int& index, int size, int treg)
{
	if (index < 0 || index + size > 256)
	{
		if (treg == 0)
			treg = BC_REG_ADDR;
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (index >> 8) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
		index = 0;
		reg = treg;
	}
}

void NativeCodeBasicBlock::StoreValue(InterCodeProcedure* proc, const InterInstruction * ins)
{
	uint32	flags = NCIF_LOWER | NCIF_UPPER;
	if (ins->mVolatile)
		flags |= NCIF_VOLATILE;

	if (ins->mSrc[0].mType == IT_FLOAT)
	{
		int stride = ins->mSrc[1].mStride;

		if (ins->mSrc[1].mTemp < 0)
		{
			if (ins->mSrc[0].mTemp < 0)
			{
				union { float f; unsigned int v; } cc;
				cc.f = float(ins->mSrc[0].mFloatConst);

				if (ins->mSrc[1].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, ins->mSrc[1].mLinkerObject, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, nullptr, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 3));
				}
				else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
				{
					int	index = int(ins->mSrc[1].mIntConst);
					int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (ins->mSrc[1].mMemory == IM_LOCAL)
						index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
					else
						index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(ins, reg, index, 4);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
				}
				else if (ins->mSrc[1].mMemory == IM_FRAME)
				{
					int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y,BC_REG_STACK));
				}
			}
			else
			{
				int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp];

				if (ins->mSrc[0].mFinal && CheckPredAccuStore(sreg))
				{
					// cull previous store from accu to temp using direcrt forwarding from accu
					mIns.SetSize(mIns.Size() - 8);
					sreg = BC_REG_ACCU;
				}

				if (ins->mSrc[1].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, ins->mSrc[1].mLinkerObject, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, nullptr, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 3));
				}
				else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
				{
					int	index = int(ins->mSrc[1].mIntConst);
					int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (ins->mSrc[1].mMemory == IM_LOCAL)
						index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
					else
						index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(ins, reg, index, 4);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
				}
				else if (ins->mSrc[1].mMemory == IM_FRAME)
				{
					int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
				}
			}
		}
		else
		{
			if (ins->mSrc[0].mTemp < 0)
			{
				if (ins->mSrc[1].mMemory == IM_INDIRECT)
				{
					union { float f; unsigned int v; } cc;
					cc.f = float(ins->mSrc[0].mFloatConst);

					int	reg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
					int index = int(ins->mSrc[1].mIntConst);
					int stride = ins->mSrc[1].mStride;

					if (stride * 4 <= 256)
					{
						CheckFrameIndex(ins, reg, index, stride * 4);

						for (int i = 0; i < 4; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> (8 * i)) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						}
					}
					else
					{
						for (int i = 0; i < 4; i++)
						{
							CheckFrameIndex(ins, reg, index, 1);

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> (8 * i)) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));

							index += stride;
						}
					}
				}
			}
			else
			{
				if (ins->mSrc[1].mMemory == IM_INDIRECT)
				{
					int	reg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
					int index = int(ins->mSrc[1].mIntConst);
					int stride = ins->mSrc[1].mStride;

					if (stride * 4 <= 256)
					{
						CheckFrameIndex(ins, reg, index, stride * 4);

						for (int i = 0; i < 4; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + i));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						}
					}
					else
					{
						for (int i = 0; i < 4; i++)
						{
							CheckFrameIndex(ins, reg, index, 1);

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + i));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));

							index += stride;
						}
					}
				}
			}
		}
	}
	else if (ins->mSrc[0].mType == IT_POINTER)
	{
		int stride = ins->mSrc[1].mStride;

		if (ins->mSrc[1].mTemp < 0)
		{
			if (ins->mSrc[0].mTemp < 0)
			{
				if (ins->mSrc[1].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, ins->mSrc[1].mLinkerObject, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, nullptr, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 1));
				}
				else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
				{
					int	index = int(ins->mSrc[1].mIntConst);
					int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (ins->mSrc[1].mMemory == IM_LOCAL)
						index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
					else
						index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(ins, reg, index, 2);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
				}
				else if (ins->mSrc[1].mMemory == IM_FRAME)
				{
					int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
				}
			}
			else
			{
				if (ins->mSrc[1].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, ins->mSrc[1].mLinkerObject, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, nullptr, flags));
				}
				else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 1));
				}
				else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
				{
					int	index = int(ins->mSrc[1].mIntConst);
					int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (ins->mSrc[1].mMemory == IM_LOCAL)
						index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
					else
						index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(ins, reg, index, 2);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
				}
				else if (ins->mSrc[1].mMemory == IM_FRAME)
				{
					int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
				}
			}
		}
		else
		{
			if (ins->mSrc[0].mTemp < 0)
			{
				if (ins->mSrc[1].mMemory == IM_INDIRECT)
				{
					int	reg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
					int index = int(ins->mSrc[1].mIntConst);
					int stride = ins->mSrc[1].mStride;

					if (2 * stride <= 256)
					{
						CheckFrameIndex(ins, reg, index, 2 * stride);

						for (int i = 0; i < 2; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> (8 * i)) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						}
					}
					else
					{
						for (int i = 0; i < 2; i++)
						{
							CheckFrameIndex(ins, reg, index, 1);

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> (8 * i)) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));

							index += stride;
						}
					}
				}
			}
			else
			{
				if (ins->mSrc[1].mMemory == IM_INDIRECT)
				{
					int	reg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
					int index = int(ins->mSrc[1].mIntConst);
					int stride = ins->mSrc[1].mStride;

					if (2 * stride <= 256)
					{
						CheckFrameIndex(ins, reg, index, 2 * stride);

						for (int i = 0; i < 2; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + i));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						}
					}
					else
					{
						for (int i = 0; i < 2; i++)
						{
							CheckFrameIndex(ins, reg, index, 1);

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + i));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));

							index += stride;
						}
					}
				}
			}
		}
	}
	else
	{
		if (ins->mSrc[1].mTemp < 0)
		{
			if (ins->mSrc[0].mTemp < 0)
			{
				if (InterTypeSize[ins->mSrc[0].mType] == 1)
				{
					if (ins->mSrc[1].mMemory == IM_GLOBAL)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
					}
					else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
					{
						int	index = int(ins->mSrc[1].mIntConst);
						int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
						if (ins->mSrc[1].mMemory == IM_LOCAL)
							index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
						else
							index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
						index += mFrameOffset;
						CheckFrameIndex(ins, reg, index, 1);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					}
					else if (ins->mSrc[1].mMemory == IM_FRAME)
					{
						int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					}
				}
				else if (InterTypeSize[ins->mSrc[0].mType] == 2)
				{
					int stride = ins->mSrc[1].mStride;

					if (ins->mSrc[1].mMemory == IM_GLOBAL)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, ins->mSrc[1].mLinkerObject, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, nullptr, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + stride));
					}
					else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
					{
						int	index = int(ins->mSrc[1].mIntConst);
						int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
						if (ins->mSrc[1].mMemory == IM_LOCAL)
							index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
						else
							index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
						index += mFrameOffset;
						CheckFrameIndex(ins, reg, index, 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					}
					else if (ins->mSrc[1].mMemory == IM_FRAME)
					{
						int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					}
				}
				else if (InterTypeSize[ins->mSrc[0].mType] == 4)
				{
					int stride = ins->mSrc[1].mStride;

					if (ins->mSrc[1].mMemory == IM_GLOBAL)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 16) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 24) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, ins->mSrc[1].mLinkerObject, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 16) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 24) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, nullptr, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 1 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 16) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 24) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 3 * stride));
					}
					else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
					{
						int	index = int(ins->mSrc[1].mIntConst);
						int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
						if (ins->mSrc[1].mMemory == IM_LOCAL)
							index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
						else
							index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
						index += mFrameOffset;
						CheckFrameIndex(ins, reg, index, 4);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 16) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 24) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					}
					else if (ins->mSrc[1].mMemory == IM_FRAME)
					{
						int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 16) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 24) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					}
				}
			}
			else
			{
				if (InterTypeSize[ins->mSrc[0].mType] == 1)
				{
					if (ins->mSrc[1].mMemory == IM_GLOBAL)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
					}
					else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
					{
						int	index = int(ins->mSrc[1].mIntConst);
						int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
						if (ins->mSrc[1].mMemory == IM_LOCAL)
							index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
						else
							index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
						index += mFrameOffset;
						CheckFrameIndex(ins, reg, index, 1);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					}
					else if (ins->mSrc[1].mMemory == IM_FRAME)
					{
						int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					}
				}
				else if (InterTypeSize[ins->mSrc[0].mType] == 2)
				{
					int stride = ins->mSrc[1].mStride;

					if (ins->mSrc[1].mMemory == IM_GLOBAL)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, ins->mSrc[1].mLinkerObject, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + stride, nullptr, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + stride));
					}
					else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
					{
						int	index = int(ins->mSrc[1].mIntConst);
						int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;

						if (ins->mSrc[1].mMemory == IM_LOCAL)
							index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
						else
							index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
						index += mFrameOffset;
						CheckFrameIndex(ins, reg, index, 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					}
					else if (ins->mSrc[1].mMemory == IM_FRAME)
					{
						int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					}
				}
				else if (InterTypeSize[ins->mSrc[0].mType] == 4)
				{
					int stride = ins->mSrc[1].mStride;

					if (ins->mSrc[1].mMemory == IM_GLOBAL)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, ins->mSrc[1].mLinkerObject, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, ins->mSrc[1].mLinkerObject, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 1 * stride, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 2 * stride, nullptr, flags));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + 3 * stride, nullptr, flags));
					}
					else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 1 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 3 * stride));
					}
					else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
					{
						int	index = int(ins->mSrc[1].mIntConst);
						int	reg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;

						if (ins->mSrc[1].mMemory == IM_LOCAL)
							index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
						else
							index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
						index += mFrameOffset;
						CheckFrameIndex(ins, reg, index, 4);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
					}
					else if (ins->mSrc[1].mMemory == IM_FRAME)
					{
						int	index = int(ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst + 2);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3 * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
					}
				}
			}
		}
		else
		{
			if (ins->mSrc[0].mTemp < 0)
			{
				if (ins->mSrc[1].mMemory == IM_INDIRECT)
				{
					int	reg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
					int index = int(ins->mSrc[1].mIntConst);
					int stride = ins->mSrc[1].mStride;
					int size = InterTypeSize[ins->mSrc[0].mType];

					if (stride * size <= 256)
					{
						CheckFrameIndex(ins, reg, index, stride * size);

						for (int i = 0; i < size; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> (8 * i)) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						}
					}
					else
					{
						for (int i = 0; i < size; i++)
						{
							CheckFrameIndex(ins, reg, index, 1);

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> (8 * i)) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));

							index += stride;
						}
					}
				}
			}
			else
			{
				if (ins->mSrc[1].mMemory == IM_INDIRECT)
				{
					int	reg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
					int index = int(ins->mSrc[1].mIntConst);
					int stride = ins->mSrc[1].mStride;
					int size = InterTypeSize[ins->mSrc[0].mType];

					if (stride * size <= 256)
					{
						CheckFrameIndex(ins, reg, index, stride * size);

						for (int i = 0; i < size; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + i));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));
						}
					}
					else
					{
						for (int i = 0; i < size; i++)
						{
							CheckFrameIndex(ins, reg, index, 1);

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + i));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, reg));

							index += stride;
						}
					}
				}
			}
		}
	}

}

void NativeCodeBasicBlock::LoadByteIndexedValue(InterCodeProcedure* proc, const InterInstruction* iins, const InterInstruction* rins)
{
	mIns.Push(NativeCodeInstruction(rins, ASMIT_LDY, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[iins->mSrc[0].mTemp]));

	uint32	flags = NCIF_LOWER | NCIF_UPPER;
	if (rins->mVolatile)
		flags |= NCIF_VOLATILE;

	for (int i = 0; i < InterTypeSize[rins->mDst.mType]; i++)
	{
		if (i != 0)
			mIns.Push(NativeCodeInstruction(rins, ASMIT_INY, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[iins->mSrc[1].mTemp], nullptr, flags));
		if (rins->mDst.mTemp == iins->mSrc[1].mTemp)
			mIns.Push(NativeCodeInstruction(rins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + i));
		else
			mIns.Push(NativeCodeInstruction(rins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rins->mDst.mTemp] + i));
	}

	if (rins->mDst.mTemp == iins->mSrc[1].mTemp)
	{
		for (int i = 0; i < InterTypeSize[rins->mDst.mType]; i++)
		{
			mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + i));
			mIns.Push(NativeCodeInstruction(rins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rins->mDst.mTemp] + i));
		}
	}
}

void NativeCodeBasicBlock::StoreByteIndexedValue(InterCodeProcedure* proc, const InterInstruction* iins, const InterInstruction* wins)
{
	mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[iins->mSrc[0].mTemp]));

	uint32	flags = NCIF_LOWER | NCIF_UPPER;
	if (wins->mVolatile)
		flags |= NCIF_VOLATILE;

	for (int i = 0; i < InterTypeSize[wins->mSrc[0].mType]; i++)
	{
		if (i != 0)
			mIns.Push(NativeCodeInstruction(wins, ASMIT_INY, ASMIM_IMPLIED));
		if (wins->mSrc[0].mTemp < 0)
			mIns.Push(NativeCodeInstruction(wins, ASMIT_LDA, ASMIM_IMMEDIATE, (wins->mSrc[0].mIntConst >> (8 * i)) & 0xff));
		else
			mIns.Push(NativeCodeInstruction(wins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[wins->mSrc[0].mTemp] + i));
		mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[iins->mSrc[1].mTemp], nullptr, flags));
	}
}


void NativeCodeBasicBlock::LoadStoreIndirectValue(InterCodeProcedure* proc, const InterInstruction* rins, const InterInstruction* wins)
{
	int size = InterTypeSize[wins->mSrc[0].mType];

	AsmInsMode	rmode = ASMIM_INDIRECT_Y;
	int	rindex = int(rins->mSrc[0].mIntConst);
	int rareg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
	LinkerObject* rlobject = nullptr;
	int rstride = rins->mSrc[0].mStride;

	uint32	rflags = NCIF_LOWER | NCIF_UPPER;
	if (rins->mVolatile)
		rflags |= NCIF_VOLATILE;

	switch (rins->mSrc[0].mMemory)
	{
	case IM_PARAM:
		rindex += rins->mSrc[0].mVarIndex + proc->mLocalSize + 2 + mFrameOffset;
		break;
	case IM_LOCAL:
		rindex += proc->mLocalVars[rins->mSrc[0].mVarIndex]->mOffset + mFrameOffset;
		break;
	case IM_PROCEDURE:
	case IM_GLOBAL:
		rmode = ASMIM_ABSOLUTE;
		rlobject = rins->mSrc[0].mLinkerObject;
		rindex = int(rins->mSrc[0].mIntConst);
		break;
	case IM_FRAME:
		rindex = int(rins->mSrc[0].mVarIndex + rins->mSrc[0].mIntConst + 2);
		rareg = BC_REG_STACK;
		break;
	case IM_INDIRECT:
		rareg = BC_REG_TMP + proc->mTempOffset[rins->mSrc[0].mTemp];
		break;
	case IM_ABSOLUTE:
		rmode = ASMIM_ABSOLUTE;
		rindex = int(rins->mSrc[0].mIntConst);
		break;
	case IM_FPARAM:
	case IM_FFRAME:
		rmode = ASMIM_ZERO_PAGE;
		rareg = int(BC_REG_FPARAMS + rins->mSrc[0].mVarIndex + rins->mSrc[0].mIntConst);
		break;
	}

	AsmInsMode	wmode = ASMIM_INDIRECT_Y;
	int	windex = int(wins->mSrc[1].mIntConst);
	int wareg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
	LinkerObject* wlobject = nullptr;
	int wstride = wins->mSrc[1].mStride;

	uint32	wflags = NCIF_LOWER | NCIF_UPPER;
	if (wins->mVolatile)
		wflags |= NCIF_VOLATILE;

	switch (wins->mSrc[1].mMemory)
	{
	case IM_PARAM:
		windex += wins->mSrc[1].mVarIndex + proc->mLocalSize + 2 + mFrameOffset;
		break;
	case IM_LOCAL:
		windex += proc->mLocalVars[wins->mSrc[1].mVarIndex]->mOffset + mFrameOffset;
		break;
	case IM_PROCEDURE:
	case IM_GLOBAL:
		wmode = ASMIM_ABSOLUTE;
		wlobject = wins->mSrc[1].mLinkerObject;
		windex = int(wins->mSrc[1].mIntConst);
		break;
	case IM_FRAME:
		windex = int(wins->mSrc[1].mVarIndex + wins->mSrc[1].mIntConst + 2);
		wareg = BC_REG_STACK;
		break;
	case IM_INDIRECT:
		wareg = BC_REG_TMP + proc->mTempOffset[wins->mSrc[1].mTemp];
		break;
	case IM_ABSOLUTE:
		wmode = ASMIM_ABSOLUTE;
		windex = int(wins->mSrc[1].mIntConst);
		break;
	case IM_FPARAM:
	case IM_FFRAME:
		wmode = ASMIM_ZERO_PAGE;
		wareg = BC_REG_FPARAMS + wins->mSrc[1].mVarIndex + int(wins->mSrc[1].mIntConst);
		break;
	}

	for (int i = 0; i < size; i++)
	{
		if (rmode == ASMIM_INDIRECT_Y)
			CheckFrameIndex(rins, rareg, rindex, 1, BC_REG_ADDR);
		if (wmode == ASMIM_INDIRECT_Y)
			CheckFrameIndex(wins, wareg, windex, 1, BC_REG_ACCU);

		if (rmode == ASMIM_INDIRECT_Y)
		{
			mIns.Push(NativeCodeInstruction(rins, ASMIT_LDY, ASMIM_IMMEDIATE, rindex));
			mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_INDIRECT_Y, rareg, nullptr, rflags));
		}
		else if (rmode == ASMIM_ZERO_PAGE)
			mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_ZERO_PAGE, rareg + i));
		else
			mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_ABSOLUTE, rindex, rlobject, rflags));

		if (wmode == ASMIM_INDIRECT_Y)
		{
			mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_IMMEDIATE, windex));
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_INDIRECT_Y, wareg, nullptr, wflags));
		}
		else if (wmode == ASMIM_ZERO_PAGE)
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ZERO_PAGE, wareg + i));
		else
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ABSOLUTE, windex, wlobject, wflags));

		rindex += rstride;
		windex += wstride;
	}
}

void NativeCodeBasicBlock::LoadStoreValue(InterCodeProcedure* proc, const InterInstruction * rins, const InterInstruction * wins)
{
	uint32	rflags = NCIF_LOWER | NCIF_UPPER;
	if (rins->mVolatile)
		rflags |= NCIF_VOLATILE;

	uint32	wflags = NCIF_LOWER | NCIF_UPPER;
	if (wins->mVolatile)
		wflags |= NCIF_VOLATILE;


	if (rins->mDst.mType == IT_FLOAT)
	{

	}
	else if (rins->mDst.mType == IT_POINTER)
	{

	}
	else
	{

		if (InterTypeSize[wins->mSrc[0].mType] == 1)
		{
			if (rins->mSrc[0].mTemp < 0)
			{
				if (rins->mSrc[0].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_ABSOLUTE, rins->mSrc[0].mIntConst, rins->mSrc[0].mLinkerObject, rflags));
				}
				else if (rins->mSrc[0].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_ABSOLUTE, rins->mSrc[0].mIntConst, nullptr, rflags));
				}
				else if (rins->mSrc[0].mMemory == IM_FPARAM)
				{
					mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + rins->mSrc[0].mVarIndex + rins->mSrc[0].mIntConst));
				}
				else if (rins->mSrc[0].mMemory == IM_LOCAL || rins->mSrc[0].mMemory == IM_PARAM)
				{
					int	index = int(rins->mSrc[0].mIntConst);
					int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (rins->mSrc[0].mMemory == IM_LOCAL)
						index += proc->mLocalVars[rins->mSrc[0].mVarIndex]->mOffset;
					else
						index += rins->mSrc[0].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(rins, areg, index, 1);

					mIns.Push(NativeCodeInstruction(rins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				}
			}
			else
			{
				if (rins->mSrc[0].mMemory == IM_INDIRECT)
				{
					int	areg = BC_REG_TMP + proc->mTempOffset[rins->mSrc[0].mTemp];
					int index = int(rins->mSrc[0].mIntConst);

					CheckFrameIndex(rins, areg, index, 1);

					mIns.Push(NativeCodeInstruction(rins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				}
			}

			if (wins->mSrc[1].mTemp < 0)
			{
				if (wins->mSrc[1].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ABSOLUTE, wins->mSrc[1].mIntConst, wins->mSrc[1].mLinkerObject, wflags));
				}
				else if (wins->mSrc[1].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ABSOLUTE, wins->mSrc[1].mIntConst, nullptr, wflags));
				}
				else if (wins->mSrc[1].mMemory == IM_FPARAM || wins->mSrc[1].mMemory == IM_FFRAME)
				{
					mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + wins->mSrc[1].mVarIndex + wins->mSrc[1].mIntConst));
				}
				else if (wins->mSrc[1].mMemory == IM_LOCAL || wins->mSrc[1].mMemory == IM_PARAM)
				{
					int	index = int(wins->mSrc[1].mIntConst);
					int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (wins->mSrc[1].mMemory == IM_LOCAL)
						index += proc->mLocalVars[wins->mSrc[1].mVarIndex]->mOffset;
					else
						index += wins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(wins, areg, index, 1);

					mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_INDIRECT_Y, areg));
				}
				else if (wins->mSrc[1].mMemory == IM_FRAME)
				{
					int	index = wins->mSrc[1].mVarIndex + int(wins->mSrc[1].mIntConst) + 2;

					mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_STACK));
				}
			}
			else
			{
				if (wins->mSrc[1].mMemory == IM_INDIRECT)
				{
					int	areg = BC_REG_TMP + proc->mTempOffset[wins->mSrc[1].mTemp];
					int index = int(wins->mSrc[1].mIntConst);

					CheckFrameIndex(wins, areg, index, 1);

					mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_INDIRECT_Y, areg));
				}
			}
		}
	}
}

bool NativeCodeBasicBlock::LoadLoadOpStoreIndirectValue(InterCodeProcedure* proc, const InterInstruction* rins1, const InterInstruction* rins0, const InterInstruction* oins, const InterInstruction* wins)
{
	if (rins1->mSrc[0].mMemory == IM_INDIRECT && rins0->mSrc[0].mMemory == IM_INDIRECT && wins->mSrc[1].mMemory == IM_INDIRECT)
	{
		int size = InterTypeSize[wins->mSrc[0].mType];

		if (wins->mSrc[0].mFinal) 
		{
			if (wins->mSrc[0].mTemp == rins1->mSrc[0].mTemp || wins->mSrc[0].mTemp == rins0->mSrc[0].mTemp)
				return false;
		}

		switch (oins->mOperator)
		{
		case IA_ADD:
			mIns.Push(NativeCodeInstruction(oins, ASMIT_CLC));
			break;
		default:
			return false;
		}

		for (int i = 0; i < size; i++)
		{
			if (rins1->mSrc[0].mIntConst == wins->mSrc[1].mIntConst && rins0->mSrc[0].mIntConst != wins->mSrc[1].mIntConst)
			{
				mIns.Push(NativeCodeInstruction(rins0, ASMIT_LDY, ASMIM_IMMEDIATE, rins0->mSrc[0].mIntConst + i));
				mIns.Push(NativeCodeInstruction(rins0, ASMIT_LDA, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[rins0->mSrc[0].mTemp]));

				mIns.Push(NativeCodeInstruction(rins1, ASMIT_LDY, ASMIM_IMMEDIATE, rins1->mSrc[0].mIntConst + i));
				mIns.Push(NativeCodeInstruction(oins, ASMIT_ADC, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[rins1->mSrc[0].mTemp]));
			}
			else
			{
				mIns.Push(NativeCodeInstruction(rins1, ASMIT_LDY, ASMIM_IMMEDIATE, rins1->mSrc[0].mIntConst + i));
				mIns.Push(NativeCodeInstruction(rins1, ASMIT_LDA, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[rins1->mSrc[0].mTemp]));

				mIns.Push(NativeCodeInstruction(rins0, ASMIT_LDY, ASMIM_IMMEDIATE, rins0->mSrc[0].mIntConst + i));
				mIns.Push(NativeCodeInstruction(oins, ASMIT_ADC, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[rins0->mSrc[0].mTemp]));
			}

			mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_IMMEDIATE, wins->mSrc[1].mIntConst + i));
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[wins->mSrc[1].mTemp]));

			if (!wins->mSrc[0].mFinal)
				mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[wins->mSrc[0].mTemp] + i));
		}

		return true;
	}
	else
		return false;
}

bool NativeCodeBasicBlock::LoadUnopStoreIndirectValue(InterCodeProcedure* proc, const InterInstruction* rins, const InterInstruction* oins, const InterInstruction* wins)
{
	int size = InterTypeSize[wins->mSrc[0].mType];

	AsmInsMode  ram = ASMIM_INDIRECT_Y, wam = ASMIM_INDIRECT_Y;
	bool		sfinal = wins->mSrc[0].mFinal;
	int			imm;
	AsmInsType	at;

	switch (oins->mOperator)
	{
	case IA_NEG:
		mIns.Push(NativeCodeInstruction(oins, ASMIT_SEC));
		imm = 0x00;
		at = ASMIT_SBC;
		break;
	case IA_NOT:
		imm = 0xff;
		at = ASMIT_EOR;
		break;
	default:
		return false;
	}

	int	rindex = int(rins->mSrc[0].mIntConst);
	int rareg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;

	switch (rins->mSrc[0].mMemory)
	{
	case IM_INDIRECT:
		rareg = BC_REG_TMP + proc->mTempOffset[rins->mSrc[0].mTemp];
		break;
	case IM_LOCAL:
		rindex += proc->mLocalVars[rins->mSrc[0].mVarIndex]->mOffset + mFrameOffset;
		break;
	case IM_PARAM:
		rindex += rins->mSrc[0].mVarIndex + proc->mLocalSize + 2 + mFrameOffset;
		break;
	case IM_FPARAM:
	case IM_FFRAME:
		ram = ASMIM_ZERO_PAGE;
		rareg = BC_REG_FPARAMS + rins->mSrc[0].mVarIndex + int(rins->mSrc[0].mIntConst);
		break;
	default:
		return false;
	}

	int	windex = int(wins->mSrc[1].mIntConst);
	int wareg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;

	switch (wins->mSrc[1].mMemory)
	{
	case IM_INDIRECT:
		wareg = BC_REG_TMP + proc->mTempOffset[wins->mSrc[1].mTemp];
		break;
	case IM_LOCAL:
		windex += proc->mLocalVars[wins->mSrc[1].mVarIndex]->mOffset + mFrameOffset;
		break;
	case IM_PARAM:
		windex += wins->mSrc[1].mVarIndex + proc->mLocalSize + 2 + mFrameOffset;
		break;
	case IM_FPARAM:
	case IM_FFRAME:
		wam = ASMIM_ZERO_PAGE;
		wareg = BC_REG_FPARAMS + +wins->mSrc[1].mVarIndex + int(wins->mSrc[1].mIntConst);
		break;
	default:
		return false;
	}

	uint32	rflags = NCIF_LOWER | NCIF_UPPER;
	if (rins->mVolatile)
		rflags |= NCIF_VOLATILE;

	uint32	wflags = NCIF_LOWER | NCIF_UPPER;
	if (wins->mVolatile)
		wflags |= NCIF_VOLATILE;

	if (ram == ASMIM_INDIRECT_Y)
		CheckFrameIndex(rins, rareg, rindex, size, BC_REG_ADDR);
	if (wam == ASMIM_INDIRECT_Y)
		CheckFrameIndex(wins, wareg, windex, size, BC_REG_ACCU);


	for (int i = 0; i < size; i++)
	{
		mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_IMMEDIATE, imm));

		if (ram == ASMIM_INDIRECT_Y)
		{
			mIns.Push(NativeCodeInstruction(rins, ASMIT_LDY, ASMIM_IMMEDIATE, rindex + i));
			mIns.Push(NativeCodeInstruction(oins, at, ram, rareg));
		}
		else
			mIns.Push(NativeCodeInstruction(oins, at, ram, rareg + i));

		if (!sfinal)
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[wins->mSrc[0].mTemp] + i));

		if (wam == ASMIM_INDIRECT_Y)
		{
			if (ram != ASMIM_INDIRECT_Y || rindex != windex)
				mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_IMMEDIATE, windex + i));
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, wam, wareg));
		}
		else
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, wam, wareg + i));
	}

	return true;

}

bool NativeCodeBasicBlock::LoadOpStoreIndirectValue(InterCodeProcedure* proc, const InterInstruction* rins, const InterInstruction* oins, int oindex, const InterInstruction* wins)
{
	int size = InterTypeSize[wins->mSrc[0].mType];

	AsmInsType	at = ASMIT_ADC, an = ASMIT_ADC;
	AsmInsMode  am = oins->mSrc[oindex].mTemp < 0 ? ASMIM_IMMEDIATE : ASMIM_ZERO_PAGE, ram = ASMIM_INDIRECT_Y, wam = ASMIM_INDIRECT_Y;
	bool		reverse = false, sfinal = wins->mSrc[0].mFinal;

	switch (oins->mOperator)
	{
	case IA_ADD:
		at = an = ASMIT_ADC;
		break;
	case IA_SUB:
		at = an = ASMIT_SBC;
		if (oindex == 1)
			reverse = true;
		break;
	case IA_AND:
		at = an = ASMIT_AND;
		break;
	case IA_OR:
		at = an = ASMIT_ORA;
		break;
	case IA_XOR:
		at = an = ASMIT_EOR;
		break;
	case IA_SHL:
		if (oindex == 0 && oins->mSrc[oindex].mTemp < 0 && oins->mSrc[oindex].mIntConst == 1)
		{
			at = ASMIT_ASL;
			an = ASMIT_ROL;
			am = ASMIM_IMPLIED;
		}
		else
			return false;
		break;
	default:
		return false;
	}

	int	rindex = int(rins->mSrc[0].mIntConst);
	int rareg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
	int rstride = rins->mSrc[0].mStride;

	switch (rins->mSrc[0].mMemory)
	{
	case IM_INDIRECT:
		rareg = BC_REG_TMP + proc->mTempOffset[rins->mSrc[0].mTemp];
		break;
	case IM_LOCAL:
		rindex += proc->mLocalVars[rins->mSrc[0].mVarIndex]->mOffset + mFrameOffset;
		break;
	case IM_PARAM:
		rindex += rins->mSrc[0].mVarIndex + proc->mLocalSize + 2 + mFrameOffset;
		break;
	case IM_FPARAM:
	case IM_FFRAME:
		ram = ASMIM_ZERO_PAGE;
		rareg = BC_REG_FPARAMS + rins->mSrc[0].mVarIndex + int(rins->mSrc[0].mIntConst);
		break;
	default:
		return false;
	}

	int	windex = int(wins->mSrc[1].mIntConst);
	int wareg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
	int wstride = wins->mSrc[1].mStride;

	switch (wins->mSrc[1].mMemory)
	{
	case IM_INDIRECT:
		wareg = BC_REG_TMP + proc->mTempOffset[wins->mSrc[1].mTemp];
		break;
	case IM_LOCAL:
		windex += proc->mLocalVars[wins->mSrc[1].mVarIndex]->mOffset + mFrameOffset;
		break;
	case IM_PARAM:
		windex += wins->mSrc[1].mVarIndex + proc->mLocalSize + 2 + mFrameOffset;
		break;
	case IM_FPARAM:
	case IM_FFRAME:
		wam = ASMIM_ZERO_PAGE;
		wareg = BC_REG_FPARAMS + +wins->mSrc[1].mVarIndex + int(wins->mSrc[1].mIntConst);
		break;
	default:
		return false;
	}

	if (rstride * size >= 256 || wstride * size >= 256)
		return false;

	uint32	rflags = NCIF_LOWER | NCIF_UPPER;
	if (rins->mVolatile)
		rflags |= NCIF_VOLATILE;

	uint32	wflags = NCIF_LOWER | NCIF_UPPER;
	if (wins->mVolatile)
		wflags |= NCIF_VOLATILE;

	if (ram == ASMIM_INDIRECT_Y && wam == ASMIM_INDIRECT_Y && rareg == wareg && rindex == windex)
	{
		CheckFrameIndex(rins, rareg, rindex, size, BC_REG_ADDR);
		windex = rindex;
		wareg = rareg;
	}
	else
	{
		if (ram == ASMIM_INDIRECT_Y)
			CheckFrameIndex(rins, rareg, rindex, size, BC_REG_ADDR);
		if (wam == ASMIM_INDIRECT_Y)
			CheckFrameIndex(wins, wareg, windex, size, BC_REG_ACCU);
	}

	switch (oins->mOperator)
	{
	case IA_ADD:
		mIns.Push(NativeCodeInstruction(oins, ASMIT_CLC));
		break;
	case IA_SUB:
		mIns.Push(NativeCodeInstruction(oins, ASMIT_SEC));
		break;
	}

	for (int i = 0; i < size; i++)
	{
		if (reverse)
		{
			if (am == ASMIM_IMPLIED)
				mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_IMPLIED));
			else if (am == ASMIM_IMMEDIATE)
				mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_IMMEDIATE, (oins->mSrc[oindex].mIntConst >> (8 * i)) & 0xff));
			else
				mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[oins->mSrc[oindex].mTemp] + i));

			if (ram == ASMIM_INDIRECT_Y)
			{
				mIns.Push(NativeCodeInstruction(oins, ASMIT_LDY, ASMIM_IMMEDIATE, rindex + i * rstride));
				mIns.Push(NativeCodeInstruction(oins, at, ram, rareg));
			}
			else
				mIns.Push(NativeCodeInstruction(oins, at, ram, rareg + i));
		}
		else
		{
			if (ram == ASMIM_INDIRECT_Y)
			{
				mIns.Push(NativeCodeInstruction(rins, ASMIT_LDY, ASMIM_IMMEDIATE, rindex + i * rstride));
				mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ram, rareg));
			}
			else
				mIns.Push(NativeCodeInstruction(rins, ASMIT_LDA, ram, rareg + i));

			if (am == ASMIM_IMPLIED)
				mIns.Push(NativeCodeInstruction(oins, at, ASMIM_IMPLIED));
			else if (am == ASMIM_IMMEDIATE)
				mIns.Push(NativeCodeInstruction(oins, at, ASMIM_IMMEDIATE, (oins->mSrc[oindex].mIntConst >> (8 * i)) & 0xff));
			else
				mIns.Push(NativeCodeInstruction(oins, at, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[oins->mSrc[oindex].mTemp] + i));
		}

		if (!sfinal)
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[wins->mSrc[0].mTemp] + i));

		at = an;
		if (wam == ASMIM_INDIRECT_Y)
		{
			if (ram != ASMIM_INDIRECT_Y || rindex != windex)
				mIns.Push(NativeCodeInstruction(wins, ASMIT_LDY, ASMIM_IMMEDIATE, windex + i * wstride));
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, wam, wareg));
		}
		else
			mIns.Push(NativeCodeInstruction(wins, ASMIT_STA, wam, wareg + i));
	}

	return true;
}

void NativeCodeBasicBlock::LoadValueToReg(InterCodeProcedure* proc, const InterInstruction * ins, int reg, const NativeCodeInstruction* ainsl, const NativeCodeInstruction* ainsh)
{
	uint32	flags = NCIF_LOWER | NCIF_UPPER;
	if (ins->mVolatile)
		flags |= NCIF_VOLATILE;

	if (ins->mDst.mType == IT_FLOAT)
	{
		int stride = ins->mSrc[0].mStride;

		if (ins->mSrc[0].mTemp < 0)
		{
			if (ins->mSrc[0].mMemory == IM_GLOBAL)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 1 * stride, ins->mSrc[0].mLinkerObject, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 2 * stride, ins->mSrc[0].mLinkerObject, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 3 * stride, ins->mSrc[0].mLinkerObject, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
			}
			else if (ins->mSrc[0].mMemory == IM_ABSOLUTE)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, nullptr, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 1 * stride, nullptr, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 2 * stride, nullptr, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 3 * stride, nullptr, flags));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
			}
			else if (ins->mSrc[0].mMemory == IM_FPARAM)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
			}
			else if (ins->mSrc[0].mMemory == IM_LOCAL || ins->mSrc[0].mMemory == IM_PARAM)
			{
				int	index = int(ins->mSrc[0].mIntConst);
				int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
				if (ins->mSrc[0].mMemory == IM_LOCAL)
					index += proc->mLocalVars[ins->mSrc[0].mVarIndex]->mOffset;
				else
					index += ins->mSrc[0].mVarIndex + proc->mLocalSize + 2;
				index += mFrameOffset;
				CheckFrameIndex(ins, areg, index, 4);

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
			}
		}
		else
		{
			if (ins->mSrc[0].mMemory == IM_INDIRECT)
			{
				int	areg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp];
				int index = int(ins->mSrc[0].mIntConst);
				int stride = ins->mSrc[0].mStride;

				if (stride * 4 <= 256)
				{
					CheckFrameIndex(ins, areg, index, stride * 4);

					for (int i = 0; i < 4; i++)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + i));
					}
				}
				else
				{
					for (int i = 0; i < 4; i++)
					{
						CheckFrameIndex(ins, areg, index, 1);

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + i));

						index += stride;
					}
				}
			}
		}
	}
	else if (ins->mDst.mType == IT_POINTER)
	{
		int stride = ins->mSrc[0].mStride;

		if (ins->mSrc[0].mTemp < 0)
		{
			if (ins->mSrc[0].mMemory == IM_GLOBAL)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, flags));
				if (ainsl)
				{
					if (ainsl->mType == ASMIT_ADC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
					else if (ainsl->mType == ASMIT_SBC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(*ainsl);
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + stride, ins->mSrc[0].mLinkerObject, flags));
				if (ainsh) mIns.Push(*ainsh);
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
			}
			else if (ins->mSrc[0].mMemory == IM_ABSOLUTE)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, nullptr, flags));
				if (ainsl)
				{
					if (ainsl->mType == ASMIT_ADC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
					else if (ainsl->mType == ASMIT_SBC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(*ainsl);
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + stride, nullptr, flags));
				if (ainsh) mIns.Push(*ainsh);
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
			}
			else if (ins->mSrc[0].mMemory == IM_FPARAM)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst));
				if (ainsl)
				{
					if (ainsl->mType == ASMIT_ADC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
					else if (ainsl->mType == ASMIT_SBC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(*ainsl);
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + stride));
				if (ainsh) mIns.Push(*ainsh);
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
			}
			else if (ins->mSrc[0].mMemory == IM_LOCAL || ins->mSrc[0].mMemory == IM_PARAM)
			{
				int	index = int(ins->mSrc[0].mIntConst);
				int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
				if (ins->mSrc[0].mMemory == IM_LOCAL)
					index += proc->mLocalVars[ins->mSrc[0].mVarIndex]->mOffset;
				else
					index += ins->mSrc[0].mVarIndex + proc->mLocalSize + 2;
				index += mFrameOffset;
				CheckFrameIndex(ins, areg, index, 2);

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				if (ainsl)
				{
					if (ainsl->mType == ASMIT_ADC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
					else if (ainsl->mType == ASMIT_SBC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(*ainsl);
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + stride));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				if (ainsh) mIns.Push(*ainsh);
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
			}
		}
		else
		{
			if (ins->mSrc[0].mMemory == IM_INDIRECT)
			{
				int	areg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp];
				int index = int(ins->mSrc[0].mIntConst);

				CheckFrameIndex(ins, areg, index, 2);

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				if (ainsl)
				{
					if (ainsl->mType == ASMIT_ADC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
					else if (ainsl->mType == ASMIT_SBC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(*ainsl);
				}
				if (reg == areg)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK_Y));
				else
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + stride));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				if (ainsh) mIns.Push(*ainsh);
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				if (reg == areg)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_WORK_Y));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
				}
			}
		}
	}
	else
	{
		if (ins->mSrc[0].mTemp < 0)
		{
			if (InterTypeSize[ins->mDst.mType] == 1)
			{
				if (ins->mSrc[0].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, flags));
				}
				else if (ins->mSrc[0].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, nullptr, flags));
				}
				else if (ins->mSrc[0].mMemory == IM_FPARAM)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst));
				}
				else if (ins->mSrc[0].mMemory == IM_LOCAL || ins->mSrc[0].mMemory == IM_PARAM)
				{
					int	index = int(ins->mSrc[0].mIntConst);
					int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (ins->mSrc[0].mMemory == IM_LOCAL)
						index += proc->mLocalVars[ins->mSrc[0].mVarIndex]->mOffset;
					else
						index += ins->mSrc[0].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(ins, areg, index, 1);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
				}

				if (ainsl)
				{
					if (ainsl->mType == ASMIT_ADC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
					else if (ainsl->mType == ASMIT_SBC)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(*ainsl);
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));

				if (InterTypeSize[ins->mDst.mType] > 1)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					if (ainsh) mIns.Push(*ainsh);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				}
			}
			else if (InterTypeSize[ins->mDst.mType] == 2)
			{
				int stride = ins->mSrc[0].mStride;

				if (ins->mSrc[0].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, flags));
					if (ainsl)
					{
						if (ainsl->mType == ASMIT_ADC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
						else if (ainsl->mType == ASMIT_SBC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
						mIns.Push(*ainsl);
					}
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 1 * stride, ins->mSrc[0].mLinkerObject, flags));
					if (ainsh) mIns.Push(*ainsh);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				}
				else if (ins->mSrc[0].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, nullptr, flags));
					if (ainsl)
					{
						if (ainsl->mType == ASMIT_ADC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
						else if (ainsl->mType == ASMIT_SBC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
						mIns.Push(*ainsl);
					}
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 1 * stride, nullptr, flags));
					if (ainsh) mIns.Push(*ainsh);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				}
				else if (ins->mSrc[0].mMemory == IM_FPARAM)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst));
					if (ainsl)
					{
						if (ainsl->mType == ASMIT_ADC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
						else if (ainsl->mType == ASMIT_SBC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
						mIns.Push(*ainsl);
					}
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + 1 * stride));
					if (ainsh) mIns.Push(*ainsh);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				}
				else if (ins->mSrc[0].mMemory == IM_LOCAL || ins->mSrc[0].mMemory == IM_PARAM)
				{
					int	index = int(ins->mSrc[0].mIntConst);
					int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (ins->mSrc[0].mMemory == IM_LOCAL)
						index += proc->mLocalVars[ins->mSrc[0].mVarIndex]->mOffset;
					else
						index += ins->mSrc[0].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(ins, areg, index, 2);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
					if (ainsl)
					{
						if (ainsl->mType == ASMIT_ADC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
						else if (ainsl->mType == ASMIT_SBC)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
						mIns.Push(*ainsl);
					}
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1 * stride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
					if (ainsh) mIns.Push(*ainsh);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
				}
			}
			else if (InterTypeSize[ins->mDst.mType] == 4)
			{
				int stride = ins->mSrc[0].mStride;

				if (ins->mSrc[0].mMemory == IM_GLOBAL)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 1 * stride, ins->mSrc[0].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 2 * stride, ins->mSrc[0].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 3 * stride, ins->mSrc[0].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
				}
				else if (ins->mSrc[0].mMemory == IM_ABSOLUTE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 1 * stride, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 2 * stride, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + 3 * stride, nullptr, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
				}
				else if (ins->mSrc[0].mMemory == IM_FPARAM)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + 1 * stride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + 2 * stride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst + 3 * stride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
				}
				else if (ins->mSrc[0].mMemory == IM_LOCAL || ins->mSrc[0].mMemory == IM_PARAM)
				{
					int	index = int(ins->mSrc[0].mIntConst);
					int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
					if (ins->mSrc[0].mMemory == IM_LOCAL)
						index += proc->mLocalVars[ins->mSrc[0].mVarIndex]->mOffset;
					else
						index += ins->mSrc[0].mVarIndex + proc->mLocalSize + 2;
					index += mFrameOffset;
					CheckFrameIndex(ins, areg, index, 4);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 1 * stride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 2 * stride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + 3 * stride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 3));
				}
			}
		}
		else
		{
			if (ins->mSrc[0].mMemory == IM_INDIRECT)
			{
				int		areg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp];
				int		index = int(ins->mSrc[0].mIntConst);
				int		stride = ins->mSrc[0].mStride;
				int		size = InterTypeSize[ins->mDst.mType];
				bool	accu = false;

				if (size * stride <= 256)
				{
					CheckFrameIndex(ins, areg, index, size * stride);

					accu = reg == areg;

					for (int i = 0; i < size; i++)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * stride));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg, nullptr, flags));

						if (i == 0)
						{
							if (ainsl)
							{
								if (ainsl->mType == ASMIT_ADC)
									mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
								else if (ainsl->mType == ASMIT_SBC)
									mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
								mIns.Push(*ainsl);
							}
						}
						else if (ainsh)
							mIns.Push(*ainsh);

						if (accu)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + i));
						else
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + i));
					}
				}
				else
				{
					assert(ainsl == nullptr && ainsh == nullptr);

					for (int i = 0; i < size; i++)
					{
						CheckFrameIndex(ins, areg, index, i * stride);
						if (reg == areg)
							accu = true;

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, areg, nullptr, flags));

						if (accu)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + i));
						else
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + i));

						index += stride;
					}
				}

				if (accu)
				{
					for (int i = 0; i < size; i++)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + i));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + i));
					}
				}
			}
		}
	}
}

void NativeCodeBasicBlock::LoadValue(InterCodeProcedure* proc, const InterInstruction * ins)
{
	LoadValueToReg(proc, ins, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp], nullptr, nullptr);
}

NativeCodeBasicBlock * NativeCodeBasicBlock::CopyValue(InterCodeProcedure* proc, const InterInstruction * ins, NativeCodeProcedure* nproc)
{
	int	size = ins->mConst.mOperandSize;
	int	msize = 4, dstride = ins->mSrc[1].mStride, sstride = ins->mSrc[0].mStride;

	uint32	flags = NCIF_LOWER | NCIF_UPPER;
	if (ins->mVolatile)
		flags |= NCIF_VOLATILE;

	if (sstride > 1 || dstride > 1)
		msize = 32;
	else if (nproc->mInterProc->mCompilerOptions & COPT_OPTIMIZE_AUTO_UNROLL)
		msize = 8;
	else if (nproc->mInterProc->mCompilerOptions & COPT_OPTIMIZE_CODE_SIZE)
		msize = 2;
#if 1
	if (ins->mSrc[0].mTemp < 0 && ins->mSrc[1].mTemp < 0)
	{
		if (ins->mSrc[0].mMemory == IM_GLOBAL && (ins->mSrc[1].mMemory == IM_FRAME || ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM) && size < 256 && dstride == 1 && sstride == 1)
		{
			int areg = BC_REG_STACK;

			int	index = int(ins->mSrc[1].mIntConst);
			if (ins->mSrc[1].mMemory == IM_FRAME)
				index += ins->mSrc[1].mVarIndex + 2;
			else
			{
				if (!mNoFrame)
					areg = BC_REG_LOCALS;

				if (ins->mSrc[1].mMemory == IM_LOCAL)
					index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
				else
					index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
				index += mFrameOffset;
			}
			CheckFrameIndex(ins, areg, index, size, BC_REG_ADDR);

			if (size <= msize)
			{
				for (int i = 0; i < size; i++)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index + i * dstride));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + i * sstride, ins->mSrc[0].mLinkerObject, flags));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, areg, nullptr, flags));
				}

				return this;
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, index));
				this->Close(ins, lblock, nullptr, ASMIT_JMP);
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst - index, ins->mSrc[0].mLinkerObject, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, areg, nullptr, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_INY, ASMIM_IMPLIED));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CPY, ASMIM_IMMEDIATE, (index + size) & 255));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				return eblock;
			}
		}
		else if ((ins->mSrc[0].mMemory == IM_GLOBAL || ins->mSrc[0].mMemory == IM_ABSOLUTE) && (ins->mSrc[1].mMemory == IM_GLOBAL || ins->mSrc[1].mMemory == IM_ABSOLUTE))
		{	
			NativeCodeBasicBlock* block = this;

			int	offset = 0;
			if (size >= 256)
			{
				block = nproc->AllocateBlock();

				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();

				
				if (size > 256)
				{
					if (size < 512 && !(size & 1))
					{
						int	step = size >> 1;

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, step));
						this->Close(ins, lblock, nullptr, ASMIT_JMP);
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst - 1, ins->mSrc[0].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst - 1, ins->mSrc[1].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst + step - 1, ins->mSrc[0].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst + step - 1, ins->mSrc[1].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEY, ASMIM_IMPLIED));
						lblock->Close(ins, lblock, block, ASMIT_BNE);

						return block;
					}
					else if (size < 1024 && !(size & 3))
					{
						int	step = size >> 2;

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, step));
						this->Close(ins, lblock, nullptr, ASMIT_JMP);
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst - 1, ins->mSrc[0].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst - 1, ins->mSrc[1].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst + step - 1, ins->mSrc[0].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst + step - 1, ins->mSrc[1].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst + 2 * step - 1, ins->mSrc[0].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst + 2 * step - 1, ins->mSrc[1].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst + 3 * step - 1, ins->mSrc[0].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst + 3 * step - 1, ins->mSrc[1].mLinkerObject, flags));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEY, ASMIM_IMPLIED));
						lblock->Close(ins, lblock, block, ASMIT_BNE);

						return block;
					}
				}

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, 0));
				this->Close(ins, lblock, nullptr, ASMIT_JMP);
				while (offset + 255 < size)
				{
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst + offset, ins->mSrc[0].mLinkerObject, flags));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst + offset, ins->mSrc[1].mLinkerObject, flags));
					offset += 256;
				}
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_INY, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, block, ASMIT_BNE);

				size &= 255;
			}

			if (size <= msize)
			{
				for (int i = 0; i < size; i++)
				{
					block->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst + offset + i * sstride, ins->mSrc[0].mLinkerObject, flags));
					block->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE, ins->mSrc[1].mIntConst + offset + i * dstride, ins->mSrc[1].mLinkerObject, flags));
				}
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				block->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, size));
				block->Close(ins, lblock, nullptr, ASMIT_JMP);
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, ins->mSrc[0].mIntConst + offset - 1, ins->mSrc[0].mLinkerObject, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ABSOLUTE_Y, ins->mSrc[1].mIntConst + offset - 1, ins->mSrc[1].mLinkerObject, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEY, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				block = eblock;
			}

			return block;
		}
	}
#endif

	int	sreg, dreg;


	if (ins->mSrc[0].mTemp < 0)
	{
		if (ins->mSrc[0].mMemory == IM_GLOBAL)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, NCIF_LOWER));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, NCIF_UPPER));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			sreg = BC_REG_ACCU;
		}
		else if (ins->mSrc[0].mMemory == IM_ABSOLUTE)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			sreg = BC_REG_ACCU;
		}
		else if (ins->mSrc[0].mMemory == IM_FPARAM)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, BC_REG_FPARAMS + ins->mSrc[0].mVarIndex + ins->mSrc[0].mIntConst));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			sreg = BC_REG_ACCU;
		}
		else if (ins->mSrc[0].mMemory == IM_LOCAL || ins->mSrc[0].mMemory == IM_PARAM)
		{
			int	index = int(ins->mSrc[0].mIntConst);
			sreg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
			if (ins->mSrc[0].mMemory == IM_LOCAL)
				index += proc->mLocalVars[ins->mSrc[0].mVarIndex]->mOffset;
			else
				index += ins->mSrc[0].mVarIndex + proc->mLocalSize + 2;
			index += mFrameOffset;
			CheckFrameIndex(ins, sreg, index, 256, BC_REG_ACCU);
		}
	}
	else if (ins->mSrc[0].mIntConst != 0)
	{
		int	index = int(ins->mSrc[0].mIntConst);
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (index >> 8) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		sreg = BC_REG_ACCU;
	}
	else
	{
		sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp];
	}
	
	if (ins->mSrc[1].mTemp < 0)
	{
		if (ins->mSrc[1].mMemory == IM_GLOBAL)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, NCIF_LOWER));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, NCIF_UPPER));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 1));
			dreg = BC_REG_ADDR;
		}
		else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 1));
			dreg = BC_REG_ADDR;
		}
		else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 1));
			dreg = BC_REG_ADDR;
		}
		else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
		{
			int	index = int(ins->mSrc[1].mIntConst);
			dreg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
			if (ins->mSrc[1].mMemory == IM_LOCAL)
				index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
			else
				index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
			index += mFrameOffset;
			CheckFrameIndex(ins, dreg, index, 256, BC_REG_ADDR);
		}
		else if (ins->mSrc[1].mMemory == IM_FRAME)
		{
			int	index = ins->mSrc[1].mVarIndex + int(ins->mSrc[1].mIntConst) + 2;

			mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_STACK));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_STACK + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (index >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 1));
			dreg = BC_REG_ADDR;
		}
	}
	else if (ins->mSrc[1].mIntConst != 0)
	{
		int	index = int(ins->mSrc[1].mIntConst);
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (index >> 8) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 1));
		dreg = BC_REG_ADDR;
	}
	else
	{
		dreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
	}

	if (size <= msize)
	{
		for (int i = 0; i < size; i++)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, i * sstride));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, sreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, i* dstride));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, dreg));
		}

		return this;
	}
	else
	{
		NativeCodeBasicBlock* block = this;

		if (size >= 256)
		{
			block = nproc->AllocateBlock();

			if (sreg != BC_REG_ACCU && !ins->mSrc[0].mFinal)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				sreg = BC_REG_ACCU;
			}
			if (dreg != BC_REG_ADDR && !ins->mSrc[1].mFinal)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ADDR + 1));
				dreg = BC_REG_ADDR;
			}

			NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
			NativeCodeBasicBlock* lblock2 = nproc->AllocateBlock();

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, 0));
			if (size >= 512)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_IMMEDIATE, size >> 8));
			this->Close(ins, lblock, nullptr, ASMIT_JMP);
			lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, sreg, nullptr, flags));
			lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, dreg, nullptr, flags));
			lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_INY, ASMIM_IMPLIED));
			lblock->Close(ins, lblock, lblock2, ASMIT_BNE);
			lblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_INC, ASMIM_ZERO_PAGE, sreg + 1));
			lblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_INC, ASMIM_ZERO_PAGE, dreg + 1));
			if (size >= 512)
			{
				lblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
				lblock2->Close(ins, lblock, block, ASMIT_BNE);
			}
			else
				lblock2->Close(ins, block, nullptr, ASMIT_JMP);

			size &= 0xff;
		}

		if (size > 0)
		{
			NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
			NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

			if (size < 128)
			{
				block->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, size - 1));
				block->Close(ins, lblock, nullptr, ASMIT_JMP);
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, sreg, nullptr, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, dreg, nullptr, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEY, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BPL);
			}
			else if (size <= 256)
			{
				block->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, size - 1));
				block->Close(ins, lblock, nullptr, ASMIT_JMP);
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, sreg, nullptr, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, dreg, nullptr, flags));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEY, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);
				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, sreg, nullptr, flags));
				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, dreg, nullptr, flags));
			}

			block = eblock;
		}

		return block;
	}
}

void NativeCodeBasicBlock::CallMalloc(InterCodeProcedure* proc, const InterInstruction* ins, NativeCodeProcedure* nproc)
{
	if (ins->mSrc[0].mTemp < 0)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
	}

	NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("malloc")));
	mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));

	if (ins->mDst.mTemp >= 0)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
	}
}

void NativeCodeBasicBlock::CallFree(InterCodeProcedure* proc, const InterInstruction* ins, NativeCodeProcedure* nproc)
{
	if (ins->mSrc[0].mTemp < 0)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
	}

	NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("free")));
	mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
}


NativeCodeBasicBlock* NativeCodeBasicBlock::StrcpyValue(InterCodeProcedure* proc, const InterInstruction* ins, NativeCodeProcedure* nproc)
{
	int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], dreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];

	NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
	NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

	mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, 0xff));
	this->Close(ins, lblock, nullptr, ASMIT_JMP);
	lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_INY, ASMIM_IMPLIED));
	lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, sreg));
	lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_INDIRECT_Y, dreg));
	lblock->Close(ins, lblock, eblock, ASMIT_BNE);

	return eblock;
}

bool NativeCodeBasicBlock::CheckPredAccuStore(int reg)
{
	if (mIns.Size() < 8)
		return false;

	int	p = mIns.Size() - 8;

	for (int i = 0; i < 4; i++)
	{
		if (mIns[p + 0].mType != ASMIT_LDA || mIns[p + 0].mMode != ASMIM_ZERO_PAGE || mIns[p + 0].mAddress != BC_REG_ACCU + i)
			return false;
		if (mIns[p + 1].mType != ASMIT_STA || mIns[p + 1].mMode != ASMIM_ZERO_PAGE || mIns[p + 1].mAddress != reg + i)
			return false;

		p += 2;
	}

	return true;
}

void NativeCodeBasicBlock::ShiftRegisterRight(const InterInstruction* ins, int reg, int shift)
{
	if (shift == 0)
	{
	}
	else if (shift == 1)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, reg));
	}
	else if (shift == 15)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 0));
	}
	else if (shift == 14)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 3));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
	}
	else if (shift >= 8)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
		for (int i = 8; i < shift; i++)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
	}
	else if (shift >= 5)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, reg));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		for (int i = shift; i < 8; i++)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0xff >> shift));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, reg + 1));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
		for (int i = 1; i < shift; i++)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, reg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
	}
}

void NativeCodeBasicBlock::ShiftRegisterLeft(InterCodeProcedure* proc, const InterInstruction* ins, int reg, int shift)
{
	if (shift == 0)
	{

	}
	else if (shift == 1)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, reg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, reg + 1));
	}
	else if (shift >= 8)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		for (int i = 8; i < shift; i++)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
	}
	else if (shift >= 5)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
		for (int i = shift; i < 8; i++)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, reg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, (0xff << shift) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
		for (int i = 0; i < shift; i++)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
	}
}

void NativeCodeBasicBlock::ShiftRegisterLeftFromByte(InterCodeProcedure* proc, const InterInstruction* ins, int reg, int shift, int max)
{
	if (shift == 0)
	{

	}
	else if (shift >= 8)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		for (int i = 8; i < shift; i++)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
	}
	else if (shift == 1)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		if (max >= 128)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
	}
	else if (shift >= 5 && shift < 8 && (max << shift) >= 512)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
		for (int i = shift; i < 7; i++)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, (0xff << shift) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TXA));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, (0xff >> (8 - shift)) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
	}
	else if (shift == 4 && max >= 128)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TXA, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0xf0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		while (shift > 0 && max < 256)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			shift--;
			max *= 2;
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		if (max > 255)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		while (shift > 0)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, reg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
			shift--;
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg + 1));
	}
}

void NativeCodeBasicBlock::ShiftRegisterLeftByte(InterCodeProcedure* proc, const InterInstruction* ins, int reg, int shift)
{
	if (shift == 0)
	{

	}
	else if (shift == 1)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, reg));
	}
	else if (shift >= 6)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
		for (int i = shift; i < 8; i++)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, (0xff << shift) & 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg));
		for (int i = 0; i < shift; i++)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, reg));
	}
}

int NativeCodeBasicBlock::ShortSignedDivide(InterCodeProcedure* proc, NativeCodeProcedure* nproc, const InterInstruction* ins, const InterInstruction* sins, int mul)
{
	int	dreg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];
	int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];

	if (sins)
	{
		LoadValueToReg(proc, sins, dreg, nullptr, nullptr);
		sreg = dreg;
	}

	if (mul == 2)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
	}
	else if (mul == 4)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x03));


		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, sreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0));

		// Two signed shifts
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, dreg + 0));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, dreg + 0));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
	}
	else if (mul == 8)
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x07));


		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, sreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0));

		// Three signed shifts
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, dreg + 0));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, dreg + 0));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, dreg + 0));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x10));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_IMMEDIATE, 0x10));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
	}

	return dreg;
}

int NativeCodeBasicBlock::ShortMultiply(InterCodeProcedure* proc, NativeCodeProcedure* nproc, const InterInstruction * ins, const InterInstruction* sins, int index, int mul)
{
	mul &= 0xffff;

	if (ins->mSrc[index].IsUByte() && ins->mSrc[index].mRange.mMaxValue == 1 && mul > 4 && mul < 256)
	{	
		int	dreg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];
		int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[index].mTemp];

		if (sins)
		{
			LoadValueToReg(proc, sins, dreg, nullptr, nullptr);
			sreg = dreg;
		}

		if (mul == 128)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, sreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, mul));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg));
		}
	
		return dreg;
	}

#if 1
	if (mul >= 0xfffc)
	{
		int	dreg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];
		int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[index].mTemp];

		if (sins)
		{
			LoadValueToReg(proc, sins, dreg, nullptr, nullptr);
			sreg = dreg;
		}

		int	wreg = BC_REG_ACCU;
		if (sreg != dreg)
			wreg = dreg;

		switch (mul)
		{
		case 0xffff: // -1
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, sreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, sreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			break;
		case 0xfffe: // -2
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, sreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, sreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			break;
		case 0xfffd: // -3
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 1));

			mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, wreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			break;
		case 0xfffc: // -4
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, sreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, sreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			break;
		}

		return dreg;
	}
#endif

	int	lshift = 0, lmul = mul;
	while (!(lmul & 1))
	{
		lmul >>= 1;
		lshift++;
	}

	if (mul > 1 && ((lshift & 7) > 3 || lmul != 1) && ins->mSrc[index].IsUByte() && ins->mSrc[index].mRange.mMaxValue < 16)
	{
		int	dreg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];

		if (sins)
		{
			LoadValueToReg(proc, sins, dreg, nullptr, nullptr);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_ZERO_PAGE, dreg));
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[index].mTemp]));
		}

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_MUL, mul, int(ins->mSrc[index].mRange.mMaxValue) + 1, false)));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg));
		if (ins->mDst.IsUByte())
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_MUL, mul, int(ins->mSrc[index].mRange.mMaxValue) + 1, true)));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}

		return dreg;
	}
	
	if (lmul == 1 && !sins && ins->mSrc[index].mTemp == ins->mDst.mTemp)
	{
		// shift in place

		int	dreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[index].mTemp];

		if (ins->mDst.IsUByte())
		{
			ShiftRegisterLeftByte(proc, ins, dreg, lshift);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		else if (ins->mSrc[index].IsUByte())
			ShiftRegisterLeftFromByte(proc, ins, dreg, lshift, int(ins->mSrc[index].mRange.mMaxValue));
		else
			ShiftRegisterLeft(proc, ins, dreg, lshift);
		return dreg;
	}

	int	dreg = BC_REG_ACCU;

	if (sins)
		LoadValueToReg(proc, sins, BC_REG_ACCU, nullptr, nullptr);
	else if (ins->mSrc[index].mTemp == ins->mDst.mTemp)
		dreg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];
	else
	{
		int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[index].mTemp];
		dreg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
	}

	int	wreg = BC_REG_ACCU;
	if (dreg == BC_REG_ACCU)
		wreg = BC_REG_WORK + 4;

	switch (lmul)
	{
#if 1
	case 1:
		if (ins->mDst.IsUByte())
		{
			ShiftRegisterLeftByte(proc, ins, dreg, lshift);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		else if (ins->mSrc[index].IsUByte())
			ShiftRegisterLeftFromByte(proc, ins, dreg, lshift, int(ins->mSrc[index].mRange.mMaxValue));
		else
			ShiftRegisterLeft(proc, ins, dreg, lshift);
		return dreg;
	case 3:
		if (ins->mSrc[index].IsUByte() && ins->mSrc[index].mRange.mMaxValue <= 85)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		if (ins->mDst.IsUByte())
		{
			ShiftRegisterLeftByte(proc, ins, dreg, lshift);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		else
			ShiftRegisterLeft(proc, ins, dreg, lshift);
		return dreg;
	case 5:
		if (ins->mSrc[index].IsUByte() && ins->mSrc[index].mRange.mMaxValue <= 51)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));

			if (ins->mDst.IsUByte())
			{
				ShiftRegisterLeftByte(proc, ins, dreg, lshift);
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			}
			else
				ShiftRegisterLeftFromByte(proc, ins, dreg, lshift, int(ins->mSrc[index].mRange.mMaxValue) * 5);
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));

			if (ins->mDst.IsUByte())
			{
				ShiftRegisterLeftByte(proc, ins, dreg, lshift);
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			}
			else
				ShiftRegisterLeft(proc, ins, dreg, lshift);
		}
		return dreg;
	case 7:
		if (ins->mSrc[index].IsUByte() && ins->mSrc[index].mRange.mMaxValue < 64)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		}
		else if (ins->mSrc[index].IsUByte() && ins->mSrc[index].mRange.mMaxValue < 128)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, wreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, wreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, wreg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		}

		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, dreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		if (ins->mDst.IsUByte())
		{
			ShiftRegisterLeftByte(proc, ins, dreg, lshift);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		else
			ShiftRegisterLeft(proc, ins, dreg, lshift);
		return dreg;
	case 9:
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		if (ins->mDst.IsUByte())
		{
			ShiftRegisterLeftByte(proc, ins, dreg, lshift);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		}
		else
			ShiftRegisterLeft(proc, ins, dreg, lshift);
		return dreg;
#if 1
	case 25:
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TAY, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TXA, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TYA, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_TXA, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, wreg + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, dreg + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
		ShiftRegisterLeft(proc, ins, dreg, lshift);
		return dreg;
#endif
#endif
	default:
		if (mul & 0xff00)
		{
			if (ins->mSrc[index].IsUByte())
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg));

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_IMMEDIATE, mul & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_IMMEDIATE, mul >> 8));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));

				NativeCodeGenerator::Runtime& rt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mul16by8")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, rt.mOffset, rt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_USE_CPU_REG_A));
			}
			else
			{
				if (dreg != BC_REG_ACCU)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				}

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, mul & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, mul >> 8));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));

				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mul16")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
			}
		}
		else
		{
			if (dreg != BC_REG_ACCU)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			}

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, mul));
//			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));

			NativeCodeGenerator::Runtime& rt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mul16by8")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, rt.mOffset, rt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_USE_CPU_REG_A));
		}

		return BC_REG_WORK + 2;
	}
}

static bool IsPowerOf2(unsigned n)
{
	return (n & (n - 1)) == 0;
}

static int Binlog(unsigned n)
{
	int	k = -1;

	while (n)
	{
		n >>= 1;
		k++;
	}

	return k;
}
void NativeCodeBasicBlock::AddAsrSignedByte(InterCodeProcedure* proc, const InterInstruction* ains, const InterInstruction* sins)
{
	mIns.Push(NativeCodeInstruction(ains, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ains->mSrc[1].mTemp]));

	for (int i = 0; i < sins->mSrc[0].mIntConst; i++)
	{
		mIns.Push(NativeCodeInstruction(sins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
		mIns.Push(NativeCodeInstruction(sins, ASMIT_ROR));
	}
	mIns.Push(NativeCodeInstruction(sins, ASMIT_ADC, ASMIM_IMMEDIATE, 0x00));
	mIns.Push(NativeCodeInstruction(sins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[sins->mDst.mTemp]));

	mIns.Push(NativeCodeInstruction(sins, ASMIT_ASL, ASMIM_IMPLIED));
	mIns.Push(NativeCodeInstruction(sins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
	mIns.Push(NativeCodeInstruction(sins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
	mIns.Push(NativeCodeInstruction(sins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
	mIns.Push(NativeCodeInstruction(sins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[sins->mDst.mTemp] + 1));

}

NativeCodeBasicBlock* NativeCodeBasicBlock::BinaryOperator(InterCodeProcedure* proc, NativeCodeProcedure* nproc, const InterInstruction * ins, const InterInstruction * sins1, const InterInstruction * sins0)
{
	int	treg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];

	if (ins->mDst.mType == IT_FLOAT)
	{
		int		sop0 = 0, sop1 = 1;
		bool	flipop = false;
		bool	changedSign = false;

		if (ins->mOperator == IA_ADD || ins->mOperator == IA_MUL || ins->mOperator == IA_SUB)
		{
			if (!sins0 && ins->mSrc[sop0].mTemp >= 0 && CheckPredAccuStore(BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop0].mTemp]))
			{
				flipop = true;
				sop0 = 1; sop1 = 0;
				const InterInstruction* sins = sins0; sins0 = sins1; sins1 = sins;
			}
			else if (!sins1 && !sins0 && ins->mSrc[sop0].mTemp < 0 && ins->mSrc[sop1].mTemp >= 0 && !CheckPredAccuStore(BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop1].mTemp]))
			{
				flipop = true;
				sop0 = 1; sop1 = 0;
				const InterInstruction* sins = sins0; sins0 = sins1; sins1 = sins;
			}
		}

		int	sreg0 = ins->mSrc[sop0].mTemp < 0 ? -1 : BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop0].mTemp];

		if (ins->mSrc[sop1].mTemp < 0)
		{
			union { float f; unsigned int v; } cc;

			if (ins->mOperator == IA_SUB && flipop)
			{
				changedSign = true;
				cc.f = float(-ins->mSrc[sop1].mFloatConst);
			}
			else
				cc.f = float(ins->mSrc[sop1].mFloatConst);

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
		}
		else if (sins1)
		{
			LoadValueToReg(proc, sins1, BC_REG_ACCU, nullptr, nullptr);
		}
		else if (CheckPredAccuStore(BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop1].mTemp]))
		{
			if (ins->mSrc[sop1].mFinal)
			{
				// cull previous store from accu to temp using direcrt forwarding
				mIns.SetSize(mIns.Size() - 8);
			}
			if (sreg0 == BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop1].mTemp])
				sreg0 = BC_REG_ACCU;
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop1].mTemp] + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop1].mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop1].mTemp] + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[sop1].mTemp] + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
		}

		if (ins->mSrc[sop0].mTemp < 0)
		{
			union { float f; unsigned int v; } cc;

			if (ins->mOperator == IA_SUB && !flipop)
			{
				changedSign = true;
				cc.f = float(-ins->mSrc[sop0].mFloatConst);
			}
			else
				cc.f = float(ins->mSrc[sop0].mFloatConst);

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));

			NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("fsplitt")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
		}
		else if (sins0)
		{
			LoadValueToReg(proc, sins0, BC_REG_WORK, nullptr, nullptr);
			NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("fsplitt")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
		}
		else
		{
			NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("fsplitx")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_USE_ZP_32_X, sreg0));
#if 0
			mIns.Push(NativeCodeInstruction(ASMIT_LDA, ASMIM_ZERO_PAGE, sreg0 + 0));
			mIns.Push(NativeCodeInstruction(ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
			mIns.Push(NativeCodeInstruction(ASMIT_LDA, ASMIM_ZERO_PAGE, sreg0 + 1));
			mIns.Push(NativeCodeInstruction(ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
			mIns.Push(NativeCodeInstruction(ASMIT_LDA, ASMIM_ZERO_PAGE, sreg0 + 2));
			mIns.Push(NativeCodeInstruction(ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 2));
			mIns.Push(NativeCodeInstruction(ASMIT_LDA, ASMIM_ZERO_PAGE, sreg0 + 3));
			mIns.Push(NativeCodeInstruction(ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));
#endif
		}


		switch (ins->mOperator)
		{
		case IA_ADD:
		{
			NativeCodeGenerator::Runtime& art(nproc->mGenerator->ResolveRuntime(Ident::Unique("faddsub")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, art.mOffset, art.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
		}	break;
		case IA_SUB:
		{
			if (!changedSign)
			{
				if (flipop)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));
				}
			}

			NativeCodeGenerator::Runtime& art(nproc->mGenerator->ResolveRuntime(Ident::Unique("faddsub")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, art.mOffset, art.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
		}	break;
		case IA_MUL:
		{
			NativeCodeGenerator::Runtime& art(nproc->mGenerator->ResolveRuntime(Ident::Unique("fmul")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, art.mOffset, art.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
		}	break;
		case IA_DIVS:
		case IA_DIVU:
		{
			NativeCodeGenerator::Runtime& art(nproc->mGenerator->ResolveRuntime(Ident::Unique("fdiv")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, art.mOffset, art.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
		}	break;
		}

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
	}
	else if (ins->mDst.mType == IT_INT32)
	{
		switch (ins->mOperator)
		{
		case IA_ADD:
		case IA_SUB:
		case IA_OR:
		case IA_AND:
		case IA_XOR:
		{
			if (sins1)	LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp], nullptr, nullptr);
			if (sins0)	LoadValueToReg(proc, sins0, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], nullptr, nullptr);

			AsmInsType	atype;
			switch (ins->mOperator)
			{
			case IA_ADD:
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
				atype = ASMIT_ADC;
				break;
			case IA_SUB:
				mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
				atype = ASMIT_SBC;
				break;
			case IA_OR:
				atype = ASMIT_ORA;
				break;
			case IA_AND:
				atype = ASMIT_AND;
				break;
			case IA_XOR:
				atype = ASMIT_EOR;
				break;
			}

			for (int i = 0; i < 4; i++)
			{
				if (ins->mSrc[1].mTemp < 0)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> (8 * i)) & 0xff));
				else
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + i));
				if (ins->mSrc[0].mTemp < 0)
					mIns.Push(NativeCodeInstruction(ins, atype, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> (8 * i)) & 0xff));
				else
					mIns.Push(NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + i));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + i));
			}
		} break;

		case IA_MUL:
		case IA_DIVS:
		case IA_MODS:
		case IA_DIVU:
		case IA_MODU:
		{
			if (sins1)
				LoadValueToReg(proc, sins1, BC_REG_ACCU, nullptr, nullptr);
			else if (ins->mSrc[1].mTemp < 0)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 16) & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 24) & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
			}
			else
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
			}

			if (sins0)
				LoadValueToReg(proc, sins0, BC_REG_WORK, nullptr, nullptr);
			else if (ins->mSrc[0].mTemp < 0)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 16) & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 24) & 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));
			}
			else
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));
			}

			int	reg = BC_REG_ACCU;

			switch (ins->mOperator)
			{
			case IA_MUL:
			{
				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mul32")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
				reg = BC_REG_WORK + 4;
			}	break;
			case IA_DIVS:
			{
				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("divs32")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
			}	break;
			case IA_MODS:
			{
				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mods32")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
				reg = BC_REG_WORK + 4;
			}	break;
			case IA_DIVU:
			{
				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("divu32")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
			}	break;
			case IA_MODU:
			{
				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("modu32")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
				reg = BC_REG_WORK + 4;
			}	break;
			}

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
		} break;
		case IA_SHL:
		{
			if (sins1) LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp], nullptr, nullptr);
			if (sins0) LoadValueToReg(proc, sins0, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], nullptr, nullptr);

			if (ins->mSrc[0].mTemp < 0)
			{
				int	shift = ins->mSrc[0].mIntConst & 31;

				int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];

				if (shift >= 24)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					sreg = treg;
					shift -= 24;
				}
				else if (shift >= 16)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					sreg = treg;
					shift -= 16;
				}
				else if (shift >= 8)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					sreg = treg;
					shift -= 8;
				}

				if (shift == 0)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					}
				}
				else if (shift == 1)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 3));
					}
				}
				else if (shift == 2)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 3));
					}
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 3));
				}
				else
				{
					NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					}
					else
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 3));

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_IMMEDIATE, shift));
					this->Close(ins, lblock, nullptr, ASMIT_JMP);

					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg + 0));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 2));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
					lblock->Close(ins, lblock, eblock, ASMIT_BNE);

					eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					return eblock;
				}
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x1f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				if (ins->mSrc[1].mTemp < 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 24) & 0xff));
				}
				else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 3));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 3));
				}

				mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
				this->Close(ins, lblock, eblock, ASMIT_BNE);

				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg + 0));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 2));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
				return eblock;
			}
		} break;

		case IA_SHR:
		{
			if (sins1) LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp], nullptr, nullptr);
			if (sins0) LoadValueToReg(proc, sins0, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], nullptr, nullptr);

			if (ins->mSrc[0].mTemp < 0)
			{
				int	shift = ins->mSrc[0].mIntConst & 31;

				int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
				int nvbits = 32;
				if (ins->mSrc[1].IsUnsigned() && ins->mSrc[1].mRange.mMaxState == IntegerValueRange::S_BOUND)
				{
					int64	mv = ins->mSrc[1].mRange.mMaxValue;
					while (nvbits > 0 && mv < (1LL << (nvbits - 1)))
						nvbits--;
				}

				if (shift >= nvbits)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					return this;
				}

				if (shift >= 24)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					sreg = treg;
					shift -= 24;
					nvbits -= 24;
				}
				else if (shift >= 16)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					sreg = treg;
					shift -= 16;
					nvbits -= 16;
				}
				else if (shift >= 8)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					sreg = treg;
					shift -= 8;
					nvbits -= 8;
				}

				if (shift == 0)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					}
				}
				else if (shift == 1)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, treg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
					}
				}
				else if (shift == 2)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, treg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
					}
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, treg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
				}
				else
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					}

					int nregs = (nvbits + 7) >> 3;

					if ((nvbits & 7) == 1)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, treg + nregs - 1));
						for (int i = nregs - 1; i > 0; i--)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + i - 1));
						nvbits--;
						nregs--;
						shift--;
					}

					if (nregs <= 2)
					{
						ShiftRegisterRight(ins, treg, shift);
					}
					else
					{
						NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
						NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + nregs - 1));

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_IMMEDIATE, shift));
						this->Close(ins, lblock, nullptr, ASMIT_JMP);

						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						for (int i = nregs - 1; i > 0; i--)
							lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + i - 1));

						//					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
						//					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
						lblock->Close(ins, lblock, eblock, ASMIT_BNE);

						eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + nregs - 1));
						return eblock;
					}
				}
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x1f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				if (ins->mSrc[1].mTemp < 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 24) & 0xff));
				}
				else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 3));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 3));
				}

				mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
				this->Close(ins, lblock, eblock, ASMIT_BNE);

				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 2));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
				return eblock;
			}
		} break;

		case IA_SAR:
		{
			if (sins1) LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp], nullptr, nullptr);
			if (sins0) LoadValueToReg(proc, sins0, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], nullptr, nullptr);

			if (ins->mSrc[0].mTemp < 0)
			{
				int	shift = ins->mSrc[0].mIntConst & 31;

				int	sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
				int	nbytes = 4;

				if (shift >= 24)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					sreg = treg;
					shift -= 24;
					nbytes = 1;
				}
				else if (shift >= 16)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					sreg = treg;
					shift -= 16;
					nbytes = 2;
				}
				else if (shift >= 8)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					sreg = treg;
					shift -= 8;
					nbytes = 3;
				}

				if (shift == 0)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
					}
				}
				else if (shift == 1)
				{
					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + nbytes - 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + nbytes - 1));

						for(int i=nbytes - 2; i >=0; i--)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + i));
					}
				}
				else
				{
					NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

					if (sreg != treg)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 3));
					}
					else
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + nbytes - 1));


					int lcost = 8 + 2 * (nbytes - 1);
					int	ucost = shift * (1 + 2 * nbytes);

					if ((nproc->mInterProc->mCompilerOptions & COPT_OPTIMIZE_CODE_SIZE)   && lcost < ucost ||
						!(nproc->mInterProc->mCompilerOptions & COPT_OPTIMIZE_AUTO_UNROLL) && 2 * lcost < ucost)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_IMMEDIATE, shift));
						this->Close(ins, lblock, nullptr, ASMIT_JMP);

						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						for (int i = nbytes - 2; i >= 0; i--)
							lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + i));
						lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
						lblock->Close(ins, lblock, eblock, ASMIT_BNE);

						eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + nbytes - 1));
						return eblock;
					}
					else
					{
						for (int si = 0; si < shift; si++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
							for (int i = nbytes - 2; i >= 0; i--)
								mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + i));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + nbytes - 1));
						}
					}
				}
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x1f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				if (ins->mSrc[1].mTemp < 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 16) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 24) & 0xff));
				}
				else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 3));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 3));
				}

				mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
				this->Close(ins, lblock, eblock, ASMIT_BNE);

				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 2));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
				return eblock;
			}
		} break;
		}
	}
	else
	{
		switch (ins->mOperator)
		{
		case IA_ADD:
		case IA_OR:
		case IA_AND:
		case IA_XOR:
		{
			if (ins->mOperator == IA_ADD && InterTypeSize[ins->mDst.mType] == 1 && (
				ins->mSrc[0].mTemp < 0 && ins->mSrc[0].mIntConst == 1 && !sins1 && ins->mSrc[1].mTemp == ins->mDst.mTemp ||
				ins->mSrc[1].mTemp < 0 && ins->mSrc[1].mIntConst == 1 && !sins0 && ins->mSrc[0].mTemp == ins->mDst.mTemp))
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_INC, ASMIM_ZERO_PAGE, treg));
				if (InterTypeSize[ins->mDst.mType] > 1)
				{
					if (ins->mDst.IsUByte())
					{
						if (ins->mSrc[0].mTemp >= 0 && !ins->mSrc[0].IsUByte() || ins->mSrc[1].mTemp >= 0 && !ins->mSrc[1].IsUByte())
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
					else
					{
						NativeCodeBasicBlock* iblock = nproc->AllocateBlock();
						NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

						this->Close(ins, eblock, iblock, ASMIT_BNE);

						iblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_INC, ASMIM_ZERO_PAGE, treg + 1));

						iblock->Close(ins, eblock, nullptr, ASMIT_JMP);
						return eblock;
					}
				}
			}
			else if (ins->mOperator == IA_ADD && InterTypeSize[ins->mDst.mType] == 1 && (
				ins->mSrc[0].mTemp < 0 && ins->mSrc[0].mIntConst == -1 && !sins1 && ins->mSrc[1].mTemp == ins->mDst.mTemp ||
				ins->mSrc[1].mTemp < 0 && ins->mSrc[1].mIntConst == -1 && !sins0 && ins->mSrc[0].mTemp == ins->mDst.mTemp))
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_DEC, ASMIM_ZERO_PAGE, treg));
			}
			else
			{
				NativeCodeInstruction	insl, insh;

				AsmInsType	atype;
				switch (ins->mOperator)
				{
				case IA_ADD:
					atype = ASMIT_ADC;
					break;
				case IA_OR:
					atype = ASMIT_ORA;
					break;
				case IA_AND:
					atype = ASMIT_AND;
					break;
				case IA_XOR:
					atype = ASMIT_EOR;
					break;
				}

				if (ins->mSrc[1].mTemp < 0)
				{
					insl = NativeCodeInstruction(ins, atype, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff);
					insh = NativeCodeInstruction(ins, atype, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff);
					if (sins0)
					{
						if (ins->mDst.IsUByte())
							insh = NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0);

						LoadValueToReg(proc, sins0, treg, &insl, &insh);
					}
					else
					{
						if (ins->mOperator == IA_ADD)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(insl);
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						if (InterTypeSize[ins->mDst.mType] > 1)
						{
							if (ins->mDst.IsUByte())
							{
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							}
							else
							{
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
								mIns.Push(insh);
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							}
						}
					}
				}
				else if (ins->mSrc[0].mTemp < 0)
				{
					insl = NativeCodeInstruction(ins, atype, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff);
					insh = NativeCodeInstruction(ins, atype, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff);
					if (sins1)
					{
						if (ins->mDst.IsUByte())
							insh = NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0);

						LoadValueToReg(proc, sins1, treg, &insl, &insh);
					}
					else
					{
						if (ins->mOperator == IA_ADD)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(insl);
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						if (InterTypeSize[ins->mDst.mType] > 1)
						{
							if (ins->mDst.IsUByte())
							{
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							}
							else
							{
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
								mIns.Push(insh);
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							}
						}
					}
				}
				else
				{
					if (sins1 && sins0)
					{
						if (sins0->mSrc[0].mMemory == IM_INDIRECT && sins1->mSrc[0].mMemory == IM_INDIRECT && sins0->mSrc[0].mIntConst < 255 && sins1->mSrc[0].mIntConst < 255)
						{
							if (ins->mOperator == IA_ADD)
								mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, sins0->mSrc[0].mIntConst + 0));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[sins0->mSrc[0].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, sins1->mSrc[0].mIntConst + 0));
							mIns.Push(NativeCodeInstruction(ins, atype, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[sins1->mSrc[0].mTemp]));
							if (InterTypeSize[ins->mDst.mType] > 1)
							{
								if (ins->mDst.mTemp == sins0->mSrc[0].mTemp || ins->mDst.mTemp == sins1->mSrc[0].mTemp)
									mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK_Y));
								else
									mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, sins0->mSrc[0].mIntConst + 1));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[sins0->mSrc[0].mTemp]));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDY, ASMIM_IMMEDIATE, sins1->mSrc[0].mIntConst + 1));
								mIns.Push(NativeCodeInstruction(ins, atype, ASMIM_INDIRECT_Y, BC_REG_TMP + proc->mTempOffset[sins1->mSrc[0].mTemp]));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
								if (ins->mDst.mTemp == sins0->mSrc[0].mTemp || ins->mDst.mTemp == sins1->mSrc[0].mTemp)
								{
									mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_WORK_Y));
									mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
								}
							}
							else
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						}
						else
						{
							insl = NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, treg);
							insh = NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, treg + 1);

							if (sins1->mDst.mTemp == ins->mDst.mTemp)
							{
								LoadValueToReg(proc, sins1, treg, nullptr, nullptr);
								LoadValueToReg(proc, sins0, treg, &insl, &insh);
							}
							else
							{
								LoadValueToReg(proc, sins0, treg, nullptr, nullptr);
								LoadValueToReg(proc, sins1, treg, &insl, &insh);
							}
						}
					}
					else if (sins1)
					{
						insl = NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]);
						insh = NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1);

						LoadValueToReg(proc, sins1, treg, &insl, &insh);
					}
					else if (sins0)
					{
						insl = NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]);
						insh = NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1);

						LoadValueToReg(proc, sins0, treg, &insl, &insh);
					}
					else
					{
						if (ins->mOperator == IA_ADD)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						if (InterTypeSize[ins->mDst.mType] > 1)
						{
#if 1
							if (ins->mDst.IsUByte())
							{
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							}
							else
#endif
							{
								mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
								mIns.Push(NativeCodeInstruction(ins, atype, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
								mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							}
						}
					}
				}
			}
		} break;
		case IA_SUB:
		{
			NativeCodeInstruction	insl, insh;

			if (InterTypeSize[ins->mDst.mType] == 1 &&
				ins->mSrc[1].mTemp < 0 && ins->mSrc[1].mIntConst == 1 && !sins0 && ins->mSrc[0].mTemp == ins->mDst.mTemp)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_DEC, ASMIM_ZERO_PAGE, treg));
			}
			else if (ins->mSrc[0].mTemp < 0)
			{
				insl = NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff);
				if (ins->mDst.IsUByte())
					insh = NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0);
				else
					insh = NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff);

				if (sins1)
					LoadValueToReg(proc, sins1, treg, &insl, &insh);
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(insl);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					if (InterTypeSize[ins->mDst.mType] > 1)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						mIns.Push(insh);
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
			}
			else if (ins->mSrc[1].mTemp < 0)
			{
				if (sins0)
				{
					LoadValueToReg(proc, sins0, treg, nullptr, nullptr);

					mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					if (InterTypeSize[ins->mDst.mType] > 1)
					{
						if (ins->mDst.IsUByte())
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, treg + 1));
						}
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					if (InterTypeSize[ins->mDst.mType] > 1)
					{
						if (ins->mDst.IsUByte())
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
						}
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
			}
			else
			{
				if (sins0)
				{
					insl = NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_WORK + 0);
					if (ins->mDst.IsUByte())
						insh = NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0);
					else
						insh = NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_WORK + 1);

					LoadValueToReg(proc, sins0, BC_REG_WORK, nullptr, nullptr);
				}
				else
				{
					insl = NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]);
					if (ins->mDst.IsUByte())
						insh = NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0);
					else
						insh = NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1);
				}

				if (sins1)
				{
					LoadValueToReg(proc, sins1, treg, &insl, &insh);
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(insl);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					if (InterTypeSize[ins->mDst.mType] > 1)
					{
						if (ins->mDst.IsUByte())
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(insh);
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
				}
			}
		} break;
		case IA_MUL:
		case IA_DIVS:
		case IA_MODS:
		case IA_DIVU:
		case IA_MODU:
		{
			int	reg = BC_REG_ACCU;

			if (ins->mOperator == IA_MUL && ins->mSrc[1].mTemp < 0)
			{
				reg = ShortMultiply(proc, nproc, ins, sins0, 0, int(ins->mSrc[1].mIntConst));
			}
			else if (ins->mOperator == IA_MUL && ins->mSrc[0].mTemp < 0)
			{
				reg = ShortMultiply(proc, nproc, ins, sins1, 1, int(ins->mSrc[0].mIntConst));
			}
			else if (ins->mOperator == IA_MUL && ins->mSrc[0].IsUByte())
			{
				if (sins1)
					LoadValueToReg(proc, sins1, BC_REG_ACCU, nullptr, nullptr);
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				}

				if (sins0)
				{
					LoadValueToReg(proc, sins0, BC_REG_WORK, nullptr, nullptr);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
				}
				else
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));

				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mul16by8")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_USE_CPU_REG_A));
				reg = BC_REG_WORK + 2;
			}
			else if (ins->mOperator == IA_MUL && ins->mSrc[1].IsUByte())
			{
				if (sins0)
					LoadValueToReg(proc, sins0, BC_REG_ACCU, nullptr, nullptr);
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				}

				if (sins1)
				{
					LoadValueToReg(proc, sins1, BC_REG_WORK, nullptr, nullptr);
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
				}
				else
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));

				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mul16by8")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_USE_CPU_REG_A));
				reg = BC_REG_WORK + 2;
			}
#if 1
			else if (ins->mOperator == IA_DIVS && ins->mSrc[0].mTemp < 0 && (ins->mSrc[0].mIntConst == 2 || ins->mSrc[0].mIntConst == 4 || ins->mSrc[0].mIntConst == 8))
			{
				reg = ShortSignedDivide(proc, nproc, ins, sins1, int(ins->mSrc[0].mIntConst));
			}
#endif
			else
			{
				if (sins1)
					LoadValueToReg(proc, sins1, BC_REG_ACCU, nullptr, nullptr);
				else if (ins->mSrc[1].mTemp < 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				}

				if (sins0)
					LoadValueToReg(proc, sins0, BC_REG_WORK, nullptr, nullptr);
				else if (ins->mSrc[0].mTemp < 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
				}

				switch (ins->mOperator)
				{
				case IA_MUL:
				{
					NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mul16")));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
					reg = BC_REG_WORK + 2;
				}	break;
				case IA_DIVS:
				{
					NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("divs16")));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
				}	break;
				case IA_MODS:
				{
					NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("mods16")));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
					reg = BC_REG_WORK + 2;
				}	break;
				case IA_DIVU:
				{
					NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("divu16")));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
				}	break;
				case IA_MODU:
				{
					NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("modu16")));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
					reg = BC_REG_WORK + 2;
				}	break;
				}
			}

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, reg + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		} break;
		case IA_SHL:
		{
			if (ins->mSrc[0].mTemp < 0 && (ins->mSrc[0].mIntConst & 15) == 1 && sins1)
			{
				NativeCodeInstruction	insl(ins, ASMIT_ASL, ASMIM_IMPLIED);
				NativeCodeInstruction	insh(ins, ASMIT_ROL, ASMIM_IMPLIED);
				LoadValueToReg(proc, sins1, treg, &insl, &insh);
				return this;
			}
			if (sins1) LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp], nullptr, nullptr);
			if (sins0) LoadValueToReg(proc, sins0, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], nullptr, nullptr);

			if (ins->mSrc[0].mTemp < 0)
			{
				int sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];

				int	shift = ins->mSrc[0].mIntConst & 15;
				if (ins->mDst.IsUByte())
				{
					if (shift == 0)
					{
						if (sreg != treg)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						}
					}
					else if (shift == 1)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
						}
					}
					else if (shift >= 8)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else if (shift > 5)
					{

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						for(int i=shift; i<8; i++)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, (0xff << shift) & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg ));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
						for (int i = 0; i < shift; i++)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					}

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				else
				{
					if (shift == 0)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
					else if (shift == 1)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
#if 1
					else if (shift == 6)
					{
						int sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_ZERO_PAGE, sreg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0xc0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
#endif
					else if (shift == 7)
					{
						int sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];

						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else if (shift == 4 && ins->mSrc[1].IsUByte() && ins->mSrc[1].mRange.mMaxValue >= 128)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_TXA, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0xf0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					}
					else if (shift >= 8)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						for (int i = 8; i < shift; i++)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
						}

						int	check = 0xffff;
						if (ins->mSrc[1].IsUByte())
							check = int(ins->mSrc[1].mRange.mMaxValue);

						check <<= 1;
						if (check >= 0x100)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						for (int i = 1; i < shift; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
							check <<= 1;
							if (check >= 0x100)
								mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						}

						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
			}
			else if (ins->mSrc[1].mTemp < 0 && IsPowerOf2(ins->mSrc[1].mIntConst & 0xffff))
			{
				int	l = Binlog(ins->mSrc[1].mIntConst & 0xffff);

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("bitshift")));

				if (l < 8)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, frt.mOffset + 8 + l, frt.mLinkerObject));
				else
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, frt.mOffset + l, frt.mLinkerObject));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
			}
			else if (ins->mSrc[1].mTemp < 0)
			{
				int	size = int(ins->mSrc[0].mRange.mMaxValue) + 1;
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
					size = 16;
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_SHL, int(ins->mSrc[1].mIntConst), size, false)));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
				if (ins->mDst.IsUByte())
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_SHL, int(ins->mSrc[1].mIntConst), size, true)));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				if (ins->mSrc[1].mTemp < 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
				}
				else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 1));
				}

				mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
				this->Close(ins, lblock, eblock, ASMIT_BNE);

				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				return eblock;
			}
		} break;
		case IA_SHR:
		{
			if (sins1) LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp], nullptr, nullptr);
			if (sins0) LoadValueToReg(proc, sins0, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], nullptr, nullptr);

			if (ins->mSrc[0].mTemp < 0)
			{
				int	shift = ins->mSrc[0].mIntConst & 15;
#if 1
				if (ins->mSrc[1].IsUByte())
				{
					if (shift == 0)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
					else if (shift == 7)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else if (shift == 6)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else if (shift >= 8)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						for (int i = 0; i < shift; i++)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
				else
#endif
				{
					if (shift == 0)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
					else if (shift == 1)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg));
						}
					}
					else if (shift == 15)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else if (shift == 14)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else if (shift >= 8)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						for (int i = 8; i < shift; i++)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else if (shift >= 5)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, treg));
						}
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						for (int i = shift; i < 8; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						}
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0xff >> shift));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, treg + 1));
						}
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						for (int i = 1; i < shift; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						}
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					}
				}
			}
			else if (ins->mSrc[1].mTemp < 0 && IsPowerOf2(ins->mSrc[1].mIntConst & 0xffff))
			{
				int	l = Binlog(ins->mSrc[1].mIntConst & 0xffff);

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("bitshift")));

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, frt.mOffset + 39 - l, frt.mLinkerObject));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, frt.mOffset + 47 - l, frt.mLinkerObject));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
			}
			else if (ins->mSrc[1].mTemp < 0)
			{
				int	size = int(ins->mSrc[0].mRange.mMaxValue) + 1;
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
					size = 16;
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_SHR, int(ins->mSrc[1].mIntConst), size, false)));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
				if (ins->mDst.IsUByte())
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_SHR, int(ins->mSrc[1].mIntConst), size, true)));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
			}
			else if (ins->mSrc[1].IsUByte())
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				if (ins->mSrc[1].mTemp < 0)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
				else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
				else
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg));

				if (ins->mSrc[0].IsInRange(1, 15))
					this->Close(ins, lblock, nullptr, ASMIT_JMP);
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
					this->Close(ins, lblock, eblock, ASMIT_BNE);
				}

				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				return eblock;
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				if (ins->mSrc[1].mTemp < 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
				}
				else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 1));
				}

				if (ins->mSrc[0].IsInRange(1, 15))
					this->Close(ins, lblock, nullptr, ASMIT_JMP);
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
					this->Close(ins, lblock, eblock, ASMIT_BNE);
				}

				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
				lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
				lblock->Close(ins, lblock, eblock, ASMIT_BNE);

				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				return eblock;
			}



		} break;
		case IA_SAR:
		{
			if (sins1) LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp], nullptr, nullptr);
			if (sins0) LoadValueToReg(proc, sins0, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp], nullptr, nullptr);

			if (ins->mSrc[0].mTemp < 0)
			{
				int	shift = ins->mSrc[0].mIntConst & 15;

				if (ins->mSrc[1].IsUByte())
				{
					if (shift == 0)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
					else if (shift == 7)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					}
					else if (shift == 6)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 3));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else if (shift >= 8)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						for (int i = 0; i < shift; i++)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
				else if (ins->mSrc[1].IsSByte() && shift != 0 && shift < 5)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));

					for (int i = 0; i < shift; i++)
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));

					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80 >> shift));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_IMMEDIATE, 0x80 >> shift));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				else
				{
					if (shift == 0)
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
					else if (shift == 1)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					}
					else if (shift == 7)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else if (shift == 6)
					{
						int sreg = BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp];
						if (sreg != treg)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, sreg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));

							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));

							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROL, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDX, ASMIM_ZERO_PAGE, treg + 1));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
						}
					}
					else if (shift >= 8)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						for (int i = 8; i < shift; i++)
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80 >> (shift - 8)));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_IMMEDIATE, 0x80 >> (shift - 8)));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else
					{
						if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						}
						else
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 1));
						}

						for (int i = 0; i < shift; i++)
						{
							mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
							mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg));
						}

						mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80 >> shift));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_IMMEDIATE, 0x80 >> shift));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
			}
			else if (ins->mSrc[1].mTemp < 0 && IsPowerOf2(ins->mSrc[1].mIntConst & 0xffff))
			{
				int	l = Binlog(ins->mSrc[1].mIntConst & 0xffff);

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("bitshift")));

				if (l == 15)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ABSOLUTE_X, frt.mOffset + 39 - l, frt.mLinkerObject));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, frt.mOffset + 47 - l, frt.mLinkerObject));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, frt.mOffset + 39 - l, frt.mLinkerObject));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, frt.mOffset + 47 - l, frt.mLinkerObject));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
			}
			else if (ins->mSrc[1].mTemp < 0)
			{
				int	size = int(ins->mSrc[0].mRange.mMaxValue) + 1;
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
					size = 16;
				}
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_SAR, int(ins->mSrc[1].mIntConst), size, false)));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
				if (ins->mDst.IsUByte())
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ABSOLUTE_X, 0, nproc->mGenerator->AllocateShortMulTable(IA_SAR, int(ins->mSrc[1].mIntConst), size, true)));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
			}
			else
			{
				NativeCodeBasicBlock* lblock = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
				if (!ins->mSrc[0].IsUByte() || ins->mSrc[0].mRange.mMaxValue > 15)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x0f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_TAX, ASMIM_IMPLIED));

				if (ins->mSrc[1].IsUByte())
				{
					if (ins->mSrc[1].mTemp < 0)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					}
					else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg));
					}

					if (ins->mSrc[0].IsInRange(1, 15))
						this->Close(ins, lblock, nullptr, ASMIT_JMP);
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
						this->Close(ins, lblock, eblock, ASMIT_BNE);
					}

					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LSR, ASMIM_IMPLIED));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
					lblock->Close(ins, lblock, eblock, ASMIT_BNE);

					eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
					eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				else if (ins->mSrc[1].IsSByte())
				{
					if (ins->mSrc[1].mTemp < 0)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
					}
					else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg));
					}

					if (ins->mSrc[0].IsInRange(1, 15))
						this->Close(ins, lblock, nullptr, ASMIT_JMP);
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
						this->Close(ins, lblock, eblock, ASMIT_BNE);
					}

					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
					lblock->Close(ins, lblock, eblock, ASMIT_BNE);

					eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
					if (ins->mSrc[1].mTemp < 0)
					{
						eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
						eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
					else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
					{
						eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
						eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
					}
				}
				else
				{
					if (ins->mSrc[1].mTemp < 0)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
					}
					else if (ins->mSrc[1].mTemp != ins->mDst.mTemp)
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));
					}
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, treg + 1));
					}

					if (ins->mSrc[0].IsInRange(1, 15))
						this->Close(ins, lblock, nullptr, ASMIT_JMP);
					else
					{
						mIns.Push(NativeCodeInstruction(ins, ASMIT_CPX, ASMIM_IMMEDIATE, 0x00));
						this->Close(ins, lblock, eblock, ASMIT_BNE);
					}

					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, 0x80));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_IMPLIED));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ROR, ASMIM_ZERO_PAGE, treg + 0));
					lblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_DEX, ASMIM_IMPLIED));
					lblock->Close(ins, lblock, eblock, ASMIT_BNE);

					eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
				}
				return eblock;
			}
		} break;

		}
	}

	return this;
}

void NativeCodeBasicBlock::SignExtendAddImmediate(InterCodeProcedure* proc, const InterInstruction* xins, const InterInstruction* ains)
{
	int val = ains->mSrc[0].mTemp == xins->mDst.mTemp ? int(ains->mSrc[1].mIntConst) : int(ains->mSrc[0].mIntConst);
	val -= 128;

	mIns.Push(NativeCodeInstruction(xins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[xins->mSrc[0].mTemp] + 0));
	mIns.Push(NativeCodeInstruction(xins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
	mIns.Push(NativeCodeInstruction(ains, ASMIT_CLC));
	mIns.Push(NativeCodeInstruction(ains, ASMIT_ADC, ASMIM_IMMEDIATE, val & 0xff));
	mIns.Push(NativeCodeInstruction(ains, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ains->mDst.mTemp] + 0));
	mIns.Push(NativeCodeInstruction(ains, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
	mIns.Push(NativeCodeInstruction(ains, ASMIT_ADC, ASMIM_IMMEDIATE, (val >> 8) & 0xff));
	mIns.Push(NativeCodeInstruction(ains, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ains->mDst.mTemp] + 1));
}

void NativeCodeBasicBlock::UnaryOperator(InterCodeProcedure* proc, NativeCodeProcedure* nproc, const InterInstruction * ins)
{
	int	treg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];

	if (ins->mDst.mType == IT_FLOAT)
	{
		switch (ins->mOperator)
		{
		case IA_NEG:
		case IA_ABS:
			if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
			}
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));

			if (ins->mOperator == IA_NEG)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x7f));

			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
			break;
		case IA_FLOOR:
		case IA_CEIL:
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));

			NativeCodeGenerator::Runtime& frx(nproc->mGenerator->ResolveRuntime(Ident::Unique("fsplita")));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frx.mOffset, frx.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));

			if (ins->mOperator == IA_FLOOR)
			{
				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("ffloor")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
			}
			else
			{
				NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("fceil")));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));
			}

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
			break;
		}
	}
	else
	{
		switch (ins->mOperator)
		{
		case IA_NEG:
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SEC, ASMIM_IMPLIED));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
			if (ins->mDst.mType == IT_INT32)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_SBC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
			}
			break;

		case IA_NOT:
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 1));
			if (ins->mDst.mType == IT_INT32)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0xff));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, treg + 3));
			}
			break;
		}
	}
}

void NativeCodeBasicBlock::NumericConversion(InterCodeProcedure* proc, NativeCodeProcedure* nproc, const InterInstruction * ins)
{
	switch (ins->mOperator)
	{
	case IA_FLOAT2INT:
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));

		NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("ftoi")));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));

	}	break;
	case IA_INT2FLOAT:
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));

		NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("ffromi")));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));

	} break;
	case IA_FLOAT2UINT:
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 3));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));

		NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("ftou")));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));

	}	break;
	case IA_UINT2FLOAT:
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));

		NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("ffromu")));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));

	} break;
	case IA_EXT8TO16S:
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
		if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		break;
	case IA_EXT8TO16U:
		if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		break;
	case IA_EXT16TO32S:
		if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
		break;
	case IA_EXT16TO32U:
		if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
		break;
	case IA_EXT8TO32S:
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
		if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ASL, ASMIM_IMPLIED));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0x00));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0xff));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
		break;
	case IA_EXT8TO32U:
		if (ins->mSrc[0].mTemp != ins->mDst.mTemp)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
		}
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
		break;
	}
}

void NativeCodeBasicBlock::RelationalOperator(InterCodeProcedure* proc, const InterInstruction * ins, NativeCodeProcedure* nproc, NativeCodeBasicBlock* trueJump, NativeCodeBasicBlock* falseJump)
{
	InterOperator	op = ins->mOperator;

	if (ins->mSrc[0].mType == IT_FLOAT)
	{
		if (ins->mSrc[0].mTemp < 0 || ins->mSrc[1].mTemp < 0)
		{
			InterOperator	op = ins->mOperator;

			int ci = 0, vi = 1;
			if (ins->mSrc[1].mTemp < 0)
			{
				ci = 1;
				vi = 0;
				op = MirrorRelational(op);
			}

			union { float f; unsigned int v; } cc;
			cc.f = float(ins->mSrc[ci].mFloatConst);

			int	ti = BC_REG_TMP + proc->mTempOffset[ins->mSrc[vi].mTemp];

			if (cc.f == 0)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_AND, ASMIM_IMMEDIATE, 0x7f));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ORA, ASMIM_ZERO_PAGE, ti + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ORA, ASMIM_ZERO_PAGE, ti + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ORA, ASMIM_ZERO_PAGE, ti + 0));

				if (op == IA_CMPEQ)
				{
					Close(ins, trueJump, falseJump, ASMIT_BEQ);
				}
				else if (op == IA_CMPNE)
				{
					Close(ins, trueJump, falseJump, ASMIT_BNE);
				}
				else
				{
					NativeCodeBasicBlock* nblock = nproc->AllocateBlock();

					if (op == IA_CMPGES || op == IA_CMPGEU || op == IA_CMPLES || op == IA_CMPLEU)
						Close(ins, trueJump, nblock, ASMIT_BEQ);
					else
						Close(ins, falseJump, nblock, ASMIT_BEQ);

					nblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 3));
					if (op == IA_CMPGES || op == IA_CMPGEU || op == IA_CMPGS || op == IA_CMPGU)
						nblock->Close(ins, trueJump, falseJump, ASMIT_BPL);
					else
						nblock->Close(ins, trueJump, falseJump, ASMIT_BMI);
				}
				return;
			}
			else
			{
				NativeCodeBasicBlock* eblock1 = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock2 = nproc->AllocateBlock();
				NativeCodeBasicBlock* eblock3 = nproc->AllocateBlock();


				if (op == IA_CMPEQ)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					Close(ins, eblock1, falseJump, ASMIT_BEQ);
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 2));
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					eblock1->Close(ins, eblock2, falseJump, ASMIT_BEQ);
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 1));
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					eblock2->Close(ins, eblock3, falseJump, ASMIT_BEQ);
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 0));
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, cc.v & 0xff));
					eblock3->Close(ins, trueJump, falseJump, ASMIT_BEQ);
					return;
				}
				else if (op == IA_CMPNE)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 3));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					Close(ins, eblock1, trueJump, ASMIT_BEQ);
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 2));
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					eblock1->Close(ins, eblock2, trueJump, ASMIT_BEQ);
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 1));
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					eblock2->Close(ins, eblock3, trueJump, ASMIT_BEQ);
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 0));
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, cc.v & 0xff));
					eblock3->Close(ins, falseJump, trueJump, ASMIT_BEQ);
					return;
				}
				else if (op == IA_CMPGS || op == IA_CMPGES || op == IA_CMPGU || op == IA_CMPGEU)
				{
					NativeCodeBasicBlock* eblock0 = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock1 = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock2 = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock3 = nproc->AllocateBlock();
					NativeCodeBasicBlock* nblock = nproc->AllocateBlock();

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 3));
					if (cc.f < 0)
						Close(ins, trueJump, eblock0, ASMIT_BPL);
					else
						Close(ins, falseJump, eblock0, ASMIT_BMI);
					eblock0->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					eblock0->Close(ins, nblock, eblock1, ASMIT_BNE);
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 2));
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					eblock1->Close(ins, nblock, eblock2, ASMIT_BNE);
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 1));
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					eblock2->Close(ins, nblock, eblock3, ASMIT_BNE);
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 0));
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, cc.v & 0xff));
					if (op == IA_CMPGES || op == IA_CMPLES || op == IA_CMPGEU || op == IA_CMPLEU)
						eblock3->Close(ins, nblock, trueJump, ASMIT_BNE);
					else
						eblock3->Close(ins, nblock, falseJump, ASMIT_BNE);

					if (cc.f < 0)
						nblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
					else
						nblock->Close(ins, trueJump, falseJump, ASMIT_BCS);
					return;
				}
				else
				{
					NativeCodeBasicBlock* eblock0 = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock1 = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock2 = nproc->AllocateBlock();
					NativeCodeBasicBlock* eblock3 = nproc->AllocateBlock();
					NativeCodeBasicBlock* nblock = nproc->AllocateBlock();

					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 3));
					if (cc.f < 0)
						Close(ins, falseJump, eblock0, ASMIT_BPL);
					else
						Close(ins, trueJump, eblock0, ASMIT_BMI);
					eblock0->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
					eblock0->Close(ins, nblock, eblock1, ASMIT_BNE);
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 2));
					eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
					eblock1->Close(ins, nblock, eblock2, ASMIT_BNE);
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 1));
					eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
					eblock2->Close(ins, nblock, eblock3, ASMIT_BNE);
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, ti + 0));
					eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, cc.v & 0xff));
					if (op == IA_CMPGES || op == IA_CMPLES || op == IA_CMPGEU || op == IA_CMPLEU)
						eblock3->Close(ins, nblock, trueJump, ASMIT_BNE);
					else
						eblock3->Close(ins, nblock, falseJump, ASMIT_BNE);

					if (cc.f < 0)
						nblock->Close(ins, trueJump, falseJump, ASMIT_BCS);
					else
						nblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
					return;
				}
			}
		}

		int	li = 0, ri = 1;
		if (op == IA_CMPLEU || op == IA_CMPGU || op == IA_CMPLES || op == IA_CMPGS)
		{
			li = 1; ri = 0;
		}

		if (ins->mSrc[li].mTemp < 0)
		{
			union { float f; unsigned int v; } cc;
			cc.f = float(ins->mSrc[li].mFloatConst);

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
		}
		else if (ins->mSrc[li].mFinal && CheckPredAccuStore(BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp]))
		{
			// cull previous store from accu to temp using direcrt forwarding
			mIns.SetSize(mIns.Size() - 8);
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
		}

		if (ins->mSrc[ri].mTemp < 0)
		{
			union { float f; unsigned int v; } cc;
			cc.f = float(ins->mSrc[ri].mFloatConst);

			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, cc.v & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 8) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 16) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (cc.v >> 24) & 0xff));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK + 3));
		}

		NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("fcmp")));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_JSRFLAGS));

		switch (op)
		{
		case IA_CMPEQ:
			Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		case IA_CMPNE:
			Close(ins, falseJump, trueJump, ASMIT_BEQ);
			break;
		case IA_CMPLU:
		case IA_CMPLS:
		case IA_CMPGU:
		case IA_CMPGS:
			Close(ins, trueJump, falseJump, ASMIT_BMI);
			break;
		case IA_CMPLEU:
		case IA_CMPLES:
		case IA_CMPGEU:
		case IA_CMPGES:
			Close(ins, falseJump, trueJump, ASMIT_BMI);
			break;
		}
	}
	else if (ins->mSrc[0].mType == IT_INT32)
	{
		int	li = 1, ri = 0;
		if (op == IA_CMPLEU || op == IA_CMPGU || op == IA_CMPLES || op == IA_CMPGS)
		{
			li = 0; ri = 1;
		}

		if (op >= IA_CMPGES && ins->mOperator <= IA_CMPLS)
		{
			if (ins->mSrc[ri].mTemp >= 0)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK));
			}

			if (ins->mSrc[li].mTemp < 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ((ins->mSrc[li].mIntConst >> 24) & 0xff) ^ 0x80));
			else
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
			}

			if (ins->mSrc[ri].mTemp < 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ((ins->mSrc[ri].mIntConst >> 24) & 0xff) ^ 0x80));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_WORK));
		}
		else
		{
			if (ins->mSrc[li].mTemp < 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[li].mIntConst >> 24) & 0xff));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 3));
			if (ins->mSrc[ri].mTemp < 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (ins->mSrc[ri].mIntConst >> 24) & 0xff));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 3));
		}

		NativeCodeBasicBlock* eblock3 = nproc->AllocateBlock();
		NativeCodeBasicBlock* eblock2 = nproc->AllocateBlock();
		NativeCodeBasicBlock* eblock1 = nproc->AllocateBlock();
		NativeCodeBasicBlock* nblock = nproc->AllocateBlock();

		this->Close(ins, nblock, eblock3, ASMIT_BNE);

		if (ins->mSrc[li].mTemp < 0)
			eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[li].mIntConst >> 16) & 0xff));
		else
			eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 2));
		if (ins->mSrc[ri].mTemp < 0)
			eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (ins->mSrc[ri].mIntConst >> 16) & 0xff));
		else
			eblock3->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 2));

		eblock3->Close(ins, nblock, eblock2, ASMIT_BNE);

		if (ins->mSrc[li].mTemp < 0)
			eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[li].mIntConst >> 8) & 0xff));
		else
			eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
		if (ins->mSrc[ri].mTemp < 0)
			eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (ins->mSrc[ri].mIntConst >> 8) & 0xff));
		else
			eblock2->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));

		eblock2->Close(ins, nblock, eblock1, ASMIT_BNE);

		if (ins->mSrc[li].mTemp < 0)
			eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[li].mIntConst & 0xff));
		else
			eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp]));
		if (ins->mSrc[ri].mTemp < 0)
			eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ins->mSrc[ri].mIntConst & 0xff));
		else
			eblock1->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp]));

		switch (op)
		{
		case IA_CMPEQ:
			nblock->Close(ins, falseJump, nullptr, ASMIT_JMP);
			eblock1->Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		case IA_CMPNE:
			nblock->Close(ins, trueJump, nullptr, ASMIT_JMP);
			eblock1->Close(ins, falseJump, trueJump, ASMIT_BEQ);
			break;
		case IA_CMPLU:
		case IA_CMPLS:
		case IA_CMPGU:
		case IA_CMPGS:
			eblock1->Close(ins, nblock, nullptr, ASMIT_JMP);
			nblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		case IA_CMPLEU:
		case IA_CMPLES:
		case IA_CMPGEU:
		case IA_CMPGES:
			eblock1->Close(ins, nblock, nullptr, ASMIT_JMP);
			nblock->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;

		}
	}
	else if (ins->mSrc[1].mTemp < 0 && ins->mSrc[1].mIntConst == 0 || ins->mSrc[0].mTemp < 0 && ins->mSrc[0].mIntConst == 0)
	{
		int	rt = ins->mSrc[1].mTemp;
		if (rt < 0)
		{
			rt = ins->mSrc[0].mTemp;
			switch (op)
			{
			case IA_CMPLEU:
				op = IA_CMPGEU;
				break;
			case IA_CMPGEU:
				op = IA_CMPLEU;
				break;
			case IA_CMPLU:
				op = IA_CMPGU;
				break;
			case IA_CMPGU:
				op = IA_CMPLU;
				break;
			case IA_CMPLES:
				op = IA_CMPGES;
				break;
			case IA_CMPGES:
				op = IA_CMPLES;
				break;
			case IA_CMPLS:
				op = IA_CMPGS;
				break;
			case IA_CMPGS:
				op = IA_CMPLS;
				break;
			}
		}

		switch (op)
		{
		case IA_CMPEQ:
		case IA_CMPLEU:
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			if (InterTypeSize[ins->mSrc[0].mType] > 1)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ORA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 1));
			this->Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		case IA_CMPNE:
		case IA_CMPGU:
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			if (InterTypeSize[ins->mSrc[0].mType] > 1)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ORA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 1));
			this->Close(ins, trueJump, falseJump, ASMIT_BNE);
			break;
		case IA_CMPGEU:
			this->Close(ins, trueJump, nullptr, ASMIT_JMP);
			break;
		case IA_CMPLU:
			this->Close(ins, falseJump, nullptr, ASMIT_JMP);
			break;
		case IA_CMPGES:
			if (InterTypeSize[ins->mSrc[0].mType] == 1)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt]));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 1));
			this->Close(ins, trueJump, falseJump, ASMIT_BPL);
			break;
		case IA_CMPLS:
			if (InterTypeSize[ins->mSrc[0].mType] == 1)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt]));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 1));
			this->Close(ins, trueJump, falseJump, ASMIT_BMI);
			break;
		case IA_CMPGS:
		{
			NativeCodeBasicBlock* eblock = nproc->AllocateBlock();
			if (InterTypeSize[ins->mSrc[0].mType] == 1)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt]));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 1));
			this->Close(ins, eblock, falseJump, ASMIT_BPL);
			if (InterTypeSize[ins->mSrc[0].mType] != 1)
				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ORA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->Close(ins, trueJump, falseJump, ASMIT_BNE);
			break;
		}
		case IA_CMPLES:
		{
			NativeCodeBasicBlock* eblock = nproc->AllocateBlock();
			if (InterTypeSize[ins->mSrc[0].mType] == 1)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt]));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 1));
			this->Close(ins, eblock, trueJump, ASMIT_BPL);
			if (InterTypeSize[ins->mSrc[0].mType] != 1)
				eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_ORA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		}

		}
	}
	else if (InterTypeSize[ins->mSrc[0].mType] == 1)
	{
		NativeCodeBasicBlock* eblock = nproc->AllocateBlock();
		NativeCodeBasicBlock* nblock = nproc->AllocateBlock();

		int	li = 1, ri = 0;
		if (op == IA_CMPLEU || op == IA_CMPGU || op == IA_CMPLES || op == IA_CMPGS)
		{
			li = 0; ri = 1;
		}

		int		iconst = 0;
		bool	rconst = false;

		if (ins->mSrc[li].mTemp < 0 && (op == IA_CMPGES || op == IA_CMPLS) && int16(ins->mSrc[li].mIntConst) > - 128)
		{
			iconst = int(ins->mSrc[li].mIntConst) - 1;
			rconst = true;
			li = ri; ri = 1 - li;

			NativeCodeBasicBlock* t = trueJump; trueJump = falseJump; falseJump = t;
		}
		else if (ins->mSrc[li].mTemp < 0 && (op == IA_CMPLES || op == IA_CMPGS) && int16(ins->mSrc[li].mIntConst) < 127)
		{
			iconst = int(ins->mSrc[li].mIntConst) + 1;
			rconst = true;
			li = ri; ri = 1 - li;

			NativeCodeBasicBlock* t = trueJump; trueJump = falseJump; falseJump = t;
		}
		else if (ins->mSrc[ri].mTemp < 0)
		{
			iconst = int(ins->mSrc[ri].mIntConst);
			rconst = true;
		}

		if (op >= IA_CMPGES && ins->mOperator <= IA_CMPLS)
		{
			if (!rconst)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK));
			}

			if (ins->mSrc[li].mTemp < 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[li].mIntConst & 0xff) ^ 0x80));
			else
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
			}

			if (rconst)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (iconst & 0xff) ^ 0x80));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_WORK));
		}
		else
		{
			if (ins->mSrc[li].mTemp < 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[li].mIntConst & 0xff));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp]));
			if (rconst)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, iconst & 0xff));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp]));
		}

		switch (op)
		{
		case IA_CMPEQ:
			this->Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		case IA_CMPNE:
			this->Close(ins, falseJump, trueJump, ASMIT_BEQ);
			break;
		case IA_CMPLU:
		case IA_CMPLS:
		case IA_CMPGU:
		case IA_CMPGS:
			this->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		case IA_CMPLEU:
		case IA_CMPLES:
		case IA_CMPGEU:
		case IA_CMPGES:
			this->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;

		}

	}
#if 1
	else if (ins->mSrc[1].mTemp < 0 && ins->mSrc[1].mIntConst < 256 && ins->mSrc[1].mIntConst > 0 || ins->mSrc[0].mTemp < 0 && ins->mSrc[0].mIntConst < 256 && ins->mSrc[0].mIntConst > 0)
	{
		int	rt = ins->mSrc[1].mTemp;
		int ival = int(ins->mSrc[0].mIntConst);
		bool	u8 = ins->mSrc[1].IsUByte();
		if (rt < 0)
		{
			rt = ins->mSrc[0].mTemp;
			u8 = ins->mSrc[0].IsUByte();;
			ival = int(ins->mSrc[1].mIntConst);
			switch (op)
			{
			case IA_CMPLEU:
				op = IA_CMPGEU;
				break;
			case IA_CMPGEU:
				op = IA_CMPLEU;
				break;
			case IA_CMPLU:
				op = IA_CMPGU;
				break;
			case IA_CMPGU:
				op = IA_CMPLU;
				break;
			case IA_CMPLES:
				op = IA_CMPGES;
				break;
			case IA_CMPGES:
				op = IA_CMPLES;
				break;
			case IA_CMPLS:
				op = IA_CMPGS;
				break;
			case IA_CMPGS:
				op = IA_CMPLS;
				break;
			}
		}

		NativeCodeBasicBlock* eblock = nproc->AllocateBlock();
		if (u8)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
		else
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 1));

		switch (op)
		{
		case IA_CMPEQ:
		{
			this->Close(ins, eblock, falseJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ival));
			eblock->Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		}
		case IA_CMPNE:
		{
			this->Close(ins, eblock, trueJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ival));
			eblock->Close(ins, falseJump, trueJump, ASMIT_BEQ);
			break;
		}

		case IA_CMPLEU:
		{
			this->Close(ins, eblock, falseJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ival));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;
		}

		case IA_CMPGEU:
		{
			this->Close(ins, eblock, trueJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ival));
			eblock->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;
		}

		case IA_CMPLU:
		{
			this->Close(ins, eblock, falseJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ival));
			eblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		}

		case IA_CMPGU:
		{
			this->Close(ins, eblock, trueJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ival));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		}

		case IA_CMPLES:
		{
			NativeCodeBasicBlock* sblock = nproc->AllocateBlock();
			this->Close(ins, sblock, trueJump, ASMIT_BPL);
			sblock->Close(ins, eblock, falseJump, ASMIT_BEQ);

			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ival));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;
		}

		case IA_CMPGES:
		{
			NativeCodeBasicBlock* sblock = nproc->AllocateBlock();
			this->Close(ins, sblock, falseJump, ASMIT_BPL);
			sblock->Close(ins, eblock, trueJump, ASMIT_BEQ);

			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ival));
			eblock->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;
		}

		case IA_CMPLS:
		{
			NativeCodeBasicBlock* sblock = nproc->AllocateBlock();
			this->Close(ins, sblock, trueJump, ASMIT_BPL);
			sblock->Close(ins, eblock, falseJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ival));
			eblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		}

		case IA_CMPGS:
		{
			NativeCodeBasicBlock* sblock = nproc->AllocateBlock();
			this->Close(ins, sblock, falseJump, ASMIT_BPL);
			sblock->Close(ins, eblock, trueJump, ASMIT_BEQ);
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ival));
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[rt] + 0));
			eblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		}

		}
	}
#endif
#if 1
	// Special case counting to 256
	else if (ins->mSrc[0].mTemp < 0 && ins->mSrc[0].mIntConst == 256 && op == IA_CMPLU &&
			ins->mSrc[1].mRange.mMinState == IntegerValueRange::S_BOUND && ins->mSrc[1].mRange.mMinValue > 0 && 
			ins->mSrc[1].mRange.mMaxState == IntegerValueRange::S_BOUND && ins->mSrc[1].mRange.mMaxValue == 256)
	{
		if (ins->mSrc[1].mTemp < 0)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
		else
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));
		this->Close(ins, falseJump, trueJump, ASMIT_BEQ);
	}
#endif
	else if (ins->mSrc[0].IsUByte() && ins->mSrc[1].IsUByte())
	{
		NativeCodeBasicBlock* eblock = nproc->AllocateBlock();
		NativeCodeBasicBlock* nblock = nproc->AllocateBlock();

		int	li = 1, ri = 0;
		if (op == IA_CMPLEU || op == IA_CMPGU || op == IA_CMPLES || op == IA_CMPGS)
		{
			li = 0; ri = 1;
		}

		int		iconst = 0;
		bool	rconst = false;

		if (ins->mSrc[ri].mTemp < 0)
		{
			iconst = int(ins->mSrc[ri].mIntConst);
			rconst = true;
		}

		if (ins->mSrc[li].mTemp < 0)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[li].mIntConst & 0xff));
		else
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp]));
		if (rconst)
			mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, iconst & 0xff));
		else
			mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp]));

		switch (op)
		{
		case IA_CMPEQ:
			this->Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		case IA_CMPNE:
			this->Close(ins, falseJump, trueJump, ASMIT_BEQ);
			break;
		case IA_CMPLU:
		case IA_CMPLS:
		case IA_CMPGU:
		case IA_CMPGS:
			this->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		case IA_CMPLEU:
		case IA_CMPLES:
		case IA_CMPGEU:
		case IA_CMPGES:
			this->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;

		}

	}
	else
	{
		NativeCodeBasicBlock* eblock = nproc->AllocateBlock();
		NativeCodeBasicBlock* nblock = nproc->AllocateBlock();
		NativeCodeBasicBlock* cblock = this;

		if (op == IA_CMPLU && ins->mSrc[0].mTemp == -1 && ins->mSrc[1].IsUnsigned() && ins->mSrc[1].mRange.mMaxValue == ins->mSrc[0].mIntConst)
			op = IA_CMPNE;

		int	li = 1, ri = 0;
		if (op == IA_CMPLEU || op == IA_CMPGU || op == IA_CMPLES || op == IA_CMPGS)
		{
			li = 0; ri = 1;
		}

		int		iconst = 0;
		bool	rconst = false;

		if (ins->mSrc[li].mTemp < 0 && (op == IA_CMPGES || op == IA_CMPLS) && int16(ins->mSrc[li].mIntConst) > - 32768)
		{
			iconst = int(ins->mSrc[li].mIntConst) - 1;
			rconst = true;
			li = ri; ri = 1 - li;

			NativeCodeBasicBlock* t = trueJump; trueJump = falseJump; falseJump = t;
		}
		else if (ins->mSrc[li].mTemp < 0 && (op == IA_CMPLES || op == IA_CMPGS) && int16(ins->mSrc[li].mIntConst) < 32767)
		{
			iconst = int(ins->mSrc[li].mIntConst) + 1;
			rconst = true;
			li = ri; ri = 1 - li;

			NativeCodeBasicBlock* t = trueJump; trueJump = falseJump; falseJump = t;
		}
		else if (ins->mSrc[ri].mTemp < 0)
		{
			iconst = int(ins->mSrc[ri].mIntConst);
			rconst = true;
		}

		if (op >= IA_CMPGES && ins->mOperator <= IA_CMPLS)
		{
			if (ins->mSrc[li].mTemp >= 0 && ins->mSrc[ri].mTemp >= 0 && ins->mSrc[li].IsPositive() && (op == IA_CMPGS || op == IA_CMPLS))
			{
				cblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));

				this->Close(ins, falseJump, cblock, ASMIT_BMI);

				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));
			}
			else if (ins->mSrc[li].mTemp >= 0 && ins->mSrc[ri].mTemp >= 0 && ins->mSrc[ri].IsPositive() && (op == IA_CMPGES || op == IA_CMPLES))
			{
				cblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));

				this->Close(ins, falseJump, cblock, ASMIT_BMI);

				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));
			}
			else if (ins->mSrc[li].mTemp >= 0 && ins->mSrc[ri].mTemp >= 0 && ins->mSrc[ri].IsPositive() && (op == IA_CMPGS || op == IA_CMPLS))
			{
				cblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));

				this->Close(ins, trueJump, cblock, ASMIT_BMI);

				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));
			}
			else if (ins->mSrc[li].mTemp >= 0 && ins->mSrc[ri].mTemp >= 0 && ins->mSrc[li].IsPositive() && (op == IA_CMPGES || op == IA_CMPLES))
			{
				cblock = nproc->AllocateBlock();

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));

				this->Close(ins, trueJump, cblock, ASMIT_BMI);

				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
				cblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));
			}
			else
			{
				if (!rconst)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_WORK));
				}

				if (ins->mSrc[li].mTemp < 0)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ((ins->mSrc[li].mIntConst >> 8) & 0xff) ^ 0x80));
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_EOR, ASMIM_IMMEDIATE, 0x80));
				}

				if (rconst)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, ((iconst >> 8) & 0xff) ^ 0x80));
				else
					mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_WORK));
			}
		}
		else
		{
			if (ins->mSrc[li].mTemp < 0)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[li].mIntConst >> 8) & 0xff));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp] + 1));
			if (rconst)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, (iconst >> 8) & 0xff));
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp] + 1));
		}

		cblock->Close(ins, nblock, eblock, ASMIT_BNE);

		if (ins->mSrc[li].mTemp < 0)
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[li].mIntConst & 0xff));
		else
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[li].mTemp]));
		if (rconst)
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_IMMEDIATE, iconst & 0xff));
		else
			eblock->mIns.Push(NativeCodeInstruction(ins, ASMIT_CMP, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[ri].mTemp]));

		switch (op)
		{
		case IA_CMPEQ:
			nblock->Close(ins, falseJump, nullptr, ASMIT_JMP);
			eblock->Close(ins, trueJump, falseJump, ASMIT_BEQ);
			break;
		case IA_CMPNE:
			nblock->Close(ins, trueJump, nullptr, ASMIT_JMP);
			eblock->Close(ins, falseJump, trueJump, ASMIT_BEQ);
			break;
		case IA_CMPLU:
		case IA_CMPLS:
		case IA_CMPGU:
		case IA_CMPGS:
			eblock->Close(ins, nblock, nullptr, ASMIT_JMP);
			nblock->Close(ins, trueJump, falseJump, ASMIT_BCC);
			break;
		case IA_CMPLEU:
		case IA_CMPLES:
		case IA_CMPGEU:
		case IA_CMPGES:
			eblock->Close(ins, nblock, nullptr, ASMIT_JMP);
			nblock->Close(ins, falseJump, trueJump, ASMIT_BCC);
			break;

		}
	}
}

void NativeCodeBasicBlock::LoadStoreOpAbsolute2D(InterCodeProcedure* proc, const InterInstruction* lins1, const InterInstruction* lins2, const InterInstruction* mins)
{	
	mIns.Push(NativeCodeInstruction(lins1, ASMIT_CLC));

	if (lins1->mSrc[0].mTemp < 0)
		mIns.Push(NativeCodeInstruction(lins1, ASMIT_LDA, ASMIM_IMMEDIATE, lins1->mSrc[0].mIntConst));
	else
		mIns.Push(NativeCodeInstruction(lins1, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[lins1->mSrc[0].mTemp]));

	if (lins2->mSrc[0].mTemp < 0)
		mIns.Push(NativeCodeInstruction(lins2, ASMIT_ADC, ASMIM_IMMEDIATE, lins2->mSrc[0].mIntConst));
	else
		mIns.Push(NativeCodeInstruction(lins2, ASMIT_ADC, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[lins2->mSrc[0].mTemp]));

	mIns.Push(NativeCodeInstruction(mins, ASMIT_TAY));

	if (mins->mCode == IC_STORE)
	{
		for (int i = 0; i < InterTypeSize[mins->mSrc[0].mType]; i++)
		{
			if (mins->mSrc[0].mTemp < 0)
				mIns.Push(NativeCodeInstruction(mins, ASMIT_LDA, ASMIM_IMMEDIATE, (mins->mSrc[0].mIntConst >> (8 * i)) & 0xff));
			else
				mIns.Push(NativeCodeInstruction(mins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[mins->mSrc[0].mTemp] + i));
			mIns.Push(NativeCodeInstruction(mins, ASMIT_STA, ASMIM_ABSOLUTE_Y, lins1->mSrc[1].mIntConst + mins->mSrc[1].mIntConst + i, lins1->mSrc[1].mLinkerObject));
		}
	}
	else
	{
		for (int i = 0; i < InterTypeSize[mins->mDst.mType]; i++)
		{
			mIns.Push(NativeCodeInstruction(mins, ASMIT_LDA, ASMIM_ABSOLUTE_Y, lins1->mSrc[1].mIntConst + mins->mSrc[0].mIntConst + i, lins1->mSrc[1].mLinkerObject));
			mIns.Push(NativeCodeInstruction(mins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[mins->mDst.mTemp] + i));
		}
	}
}


void NativeCodeBasicBlock::LoadEffectiveAddress(InterCodeProcedure* proc, const InterInstruction * ins, const InterInstruction* sins1, const InterInstruction* sins0, bool addrvalid)
{
	bool		isub = false;
	int			ireg = ins->mSrc[0].mTemp;
	AsmInsType	iop = ASMIT_ADC;

	if (sins0)
	{
		isub = true;
		ireg = sins0->mSrc[0].mTemp;
		iop = ASMIT_SBC;
	}

	if (sins1)
	{
		if (ins->mSrc[0].mTemp < 0 && ins->mSrc[0].mIntConst == 0)
			LoadValueToReg(proc, sins1, ins->mDst.mTemp, nullptr, nullptr);
		else
		{
			if (ins->mSrc[0].mTemp < 0)
			{
				NativeCodeInstruction	ainsl(ins, ASMIT_ADC, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff);
				NativeCodeInstruction	ainsh(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff);

				LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp], &ainsl, &ainsh);
			}
			else
			{
				NativeCodeInstruction	ainsl(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]);
				NativeCodeInstruction	ainsh(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg] + 1);

				LoadValueToReg(proc, sins1, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp], &ainsl, &ainsh);
			}
		}
	}
	else if (ins->mSrc[1].mTemp < 0)
	{

		mIns.Push(NativeCodeInstruction(ins, isub ? ASMIT_SEC : ASMIT_CLC, ASMIM_IMPLIED));
		if (ins->mSrc[1].mMemory == IM_GLOBAL)
		{
			if (!ins->mSrc[0].IsUnsigned() && ins->mSrc[1].mIntConst != 0 && ins->mSrc[1].mLinkerObject->mSize < 256)
			{
				// Negative index, small global

				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst));
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));

				mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE_ADDRESS, 0, ins->mSrc[1].mLinkerObject, NCIF_LOWER));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, 0, ins->mSrc[1].mLinkerObject, NCIF_UPPER));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
			}
			else
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, NCIF_LOWER));
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
				// if the global variable is smaller than 256 bytes, we can safely ignore the upper byte?
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[1].mIntConst, ins->mSrc[1].mLinkerObject, NCIF_UPPER));
#if 1
				if (ins->mSrc[0].IsUByte())
					mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, 0));
				else if ((ins->mSrc[1].mIntConst == 0 || ins->mSrc[0].IsUnsigned()) &&
					(ins->mSrc[1].mLinkerObject->mSize < 256 || (addrvalid && ins->mSrc[1].mLinkerObject->mSize <= 256)))
					mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, 0));
				else
#endif
					mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg] + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
			}
		}
		else if (ins->mSrc[1].mMemory == IM_ABSOLUTE)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[1].mIntConst & 0xff));
			mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[1].mIntConst >> 8) & 0xff));
#if 1
			if (ins->mSrc[0].IsUByte())
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, 0));
			else
#endif
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		}
		else if (ins->mSrc[1].mMemory == IM_PROCEDURE)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mSrc[1].mLinkerObject, NCIF_LOWER));
			mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mSrc[1].mLinkerObject, NCIF_UPPER));
#if 1
			if (ins->mSrc[0].IsUByte())
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, 0));
			else
#endif
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		}
		else if (ins->mSrc[1].mMemory == IM_FPARAM || ins->mSrc[1].mMemory == IM_FFRAME)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, BC_REG_FPARAMS + ins->mSrc[1].mVarIndex + ins->mSrc[1].mIntConst));
			mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_IMMEDIATE, 0));
			if (ins->mSrc[0].IsUByte())
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, 0));
			else
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
		}
		else if (ins->mSrc[1].mMemory == IM_LOCAL || ins->mSrc[1].mMemory == IM_PARAM)
		{
			int dreg = BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp];
			int	index = int(ins->mSrc[1].mIntConst);
			int areg = mNoFrame ? BC_REG_STACK : BC_REG_LOCALS;
			if (ins->mSrc[1].mMemory == IM_LOCAL)
				index += proc->mLocalVars[ins->mSrc[1].mVarIndex]->mOffset;
			else
				index += ins->mSrc[1].mVarIndex + proc->mLocalSize + 2;
			index += mFrameOffset;

			if (ins->mSrc[0].IsUByte() && ins->mSrc[0].mRange.mMaxValue + index < 256 && !isub)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_ZERO_PAGE, areg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, areg + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, 0));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
			}
			else
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, areg));
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, areg + 1));
				if (ins->mSrc[0].IsUByte())
					mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, 0));
				else
					mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg] + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));

				if (index != 0)
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_CLC, ASMIM_IMPLIED));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, index & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, dreg + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (index >> 8) & 0xff));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, dreg + 1));
				}
			}
		}
	}
	else
	{
		if (ins->mSrc[0].mTemp >= 0 || ins->mSrc[0].mIntConst != 0)
			mIns.Push(NativeCodeInstruction(ins, isub ? ASMIT_SEC : ASMIT_CLC, ASMIM_IMPLIED));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp]));

		if (ins->mSrc[0].mTemp < 0)
		{
			if (ins->mSrc[0].mIntConst)
				mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff));
		}
		else
			mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg]));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp]));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[1].mTemp] + 1));

		if (ins->mSrc[0].mTemp < 0)
		{
			if (ins->mSrc[0].mIntConst)
				mIns.Push(NativeCodeInstruction(ins, ASMIT_ADC, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff));
		}
		else if (ins->mSrc[0].IsUByte())
			mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_IMMEDIATE, 0));
		else
			mIns.Push(NativeCodeInstruction(ins, iop, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ireg] + 1));

		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
	}
}

void NativeCodeBasicBlock::CallFunction(InterCodeProcedure* proc, NativeCodeProcedure * nproc, const InterInstruction * ins)
{
	if (ins->mSrc[0].mTemp < 0)
	{
		if (ins->mSrc[0].mLinkerObject)
		{
			NativeCodeInstruction	lins(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, NCIF_LOWER);
			NativeCodeInstruction	hins(ins, ASMIT_LDA, ASMIM_IMMEDIATE_ADDRESS, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, NCIF_UPPER);

			mIns.Push(lins);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU));
			mIns.Push(hins);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		}
		else
		{
			NativeCodeInstruction	lins(ins, ASMIT_LDA, ASMIM_IMMEDIATE, ins->mSrc[0].mIntConst & 0xff);
			NativeCodeInstruction	hins(ins, ASMIT_LDA, ASMIM_IMMEDIATE, (ins->mSrc[0].mIntConst >> 8) & 0xff);

			mIns.Push(lins);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU));
			mIns.Push(hins);
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
		}
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
	}

	NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("bcexec")));
	mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_FEXEC));

	if (ins->mDst.mTemp >= 0)
	{
		if (ins->mDst.mType == IT_FLOAT)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
		}
		else
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
			if (InterTypeSize[ins->mDst.mType] > 1)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
			}
			if (InterTypeSize[ins->mDst.mType] > 2)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
			}
		}
	}
}

NativeCodeInstruction NativeCodeBasicBlock::DecodeNative(const InterInstruction* ins, LinkerObject* lobj, int& offset) const
{
	uint8	op = lobj->mData[offset++];

	AsmInsData			d = DecInsData[op];
	int					address = 0;
	LinkerObject	*	linkerObject = nullptr;
	uint32				flags = NCIF_LOWER | NCIF_UPPER;
	LinkerReference	*	lref;

	switch (d.mMode)
	{
	case ASMIM_ABSOLUTE:
	case ASMIM_ABSOLUTE_X:
	case ASMIM_ABSOLUTE_Y:
	case ASMIM_INDIRECT:
		lref = lobj->FindReference(offset);
		address = lobj->mData[offset++];
		address += lobj->mData[offset++] << 8;
		if (lref)
		{
			linkerObject = lref->mRefObject;
			address = lref->mRefOffset;
		}
		else
			flags |= NCIF_VOLATILE;
		break;
	case ASMIM_ZERO_PAGE:
	case ASMIM_ZERO_PAGE_X:
	case ASMIM_ZERO_PAGE_Y:
	case ASMIM_INDIRECT_X:
	case ASMIM_INDIRECT_Y:
		lref = lobj->FindReference(offset);
		address = lobj->mData[offset++];
		if (lref && (lref->mFlags & LREF_TEMPORARY))
			address += lobj->mTemporaries[lref->mRefOffset];
		else if (address >= BC_REG_TMP)
			flags |= NCIF_VOLATILE;
		break;
	case ASMIM_RELATIVE:
		address = lobj->mData[offset++];
		address += offset;
		break;
	case ASMIM_IMMEDIATE:
		lref = lobj->FindReference(offset);
		address = lobj->mData[offset++];
		if (lref)
		{
			d.mMode = ASMIM_IMMEDIATE_ADDRESS;
			linkerObject = lref->mRefObject;
			address = lref->mRefOffset;
			if (lref->mFlags & LREF_LOWBYTE)
				flags = NCIF_LOWER;
			else
				flags = NCIF_UPPER;
		}
		break;
	}

	return NativeCodeInstruction(ins, d.mType, d.mMode, address, linkerObject, flags);
}


void NativeCodeBasicBlock::CallAssembler(InterCodeProcedure* proc, NativeCodeProcedure * nproc, const InterInstruction* ins)
{
	if (ins->mCode == IC_ASSEMBLER)
	{
		for (int i = 1; i < ins->mNumOperands; i++)
		{
			if (ins->mSrc[i].mTemp < 0)
			{
				if (ins->mSrc[i].mMemory == IM_FPARAM || ins->mSrc[i].mMemory == IM_FFRAME)
					ins->mSrc[0].mLinkerObject->mTemporaries[i - 1] = BC_REG_FPARAMS + ins->mSrc[i].mVarIndex + int(ins->mSrc[i].mIntConst);
			}
			else
				ins->mSrc[0].mLinkerObject->mTemporaries[i - 1] = BC_REG_TMP + proc->mTempOffset[ins->mSrc[i].mTemp];
			ins->mSrc[0].mLinkerObject->mTempSizes[i - 1] = InterTypeSize[ins->mSrc[i].mType];
		}
		ins->mSrc[0].mLinkerObject->mNumTemporaries = ins->mNumOperands - 1;
	}

	uint32	lf = 0;

	if (ins->mSrc[0].mTemp < 0)
	{
		uint32	flags = NCIF_LOWER | NCIF_UPPER;
		if (ins->mSrc[0].mLinkerObject->mFlags & LOBJF_ARG_REG_A)
		{
			flags |= NCIF_USE_CPU_REG_A;
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_FPARAMS));
		}
		if (ins->mSrc[0].mLinkerObject->mFlags & LOBJF_ARG_REG_X)
			flags |= NCIF_USE_CPU_REG_X;
		if (ins->mSrc[0].mLinkerObject->mFlags & LOBJF_ARG_REG_Y)
			flags |= NCIF_USE_CPU_REG_Y;

		assert(ins->mSrc[0].mLinkerObject);

		if (ins->mCode == IC_ASSEMBLER && (proc->mCompilerOptions & COPT_OPTIMIZE_ASSEMBLER))
		{
			ExpandingArray<NativeCodeInstruction>	tains;

			uint32	uflags = 0;
			bool	simple = true;
			int i = 0;
			while (i < ins->mSrc[0].mLinkerObject->mSize)
			{
				NativeCodeInstruction	dins = DecodeNative(ins, ins->mSrc[0].mLinkerObject, i);
				if (dins.mMode == ASMIM_RELATIVE)
					simple = false;
				if (dins.mType == ASMIT_JMP)
					simple = false;
				if (dins.mType == ASMIT_RTS && i != ins->mSrc[0].mLinkerObject->mSize)
					simple = false;
				if (dins.mType == ASMIT_JSR)
				{
					dins.mFlags |= uflags;
				}

				if (dins.mType == ASMIT_BRK || dins.mMode == ASMIM_INDIRECT_X || dins.mMode == ASMIM_INDIRECT || 
					dins.mType == ASMIT_SEI || dins.mType == ASMIT_CLI || dins.mType == ASMIT_SED || dins.mType == ASMIT_CLD ||
					dins.mType == ASMIT_RTI || dins.mType == ASMIT_TXS || dins.mType == ASMIT_TSX)
					simple = false;
				if (dins.mFlags & NCIF_VOLATILE)
					simple = false;

				if (dins.mMode == ASMIM_ZERO_PAGE && dins.mAddress >= BC_REG_WORK && dins.mAddress < BC_REG_WORK + 8)
					uflags |= NICF_USE_WORKREGS;
				if (dins.ChangesAccu())
					uflags |= NCIF_USE_CPU_REG_A;
				if (dins.ChangesXReg())
					uflags |= NCIF_USE_CPU_REG_X;
				if (dins.ChangesYReg())
					uflags |= NCIF_USE_CPU_REG_Y;
				tains.Push(dins);
			}
			
			if (simple)
			{
				for (int i = 0; i + 1 < tains.Size(); i++)
					mIns.Push(tains[i]);
			}
			else
				mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, flags));
		}
		else
			mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, ins->mSrc[0].mIntConst, ins->mSrc[0].mLinkerObject, flags));

		lf = ins->mSrc[0].mLinkerObject->mFlags;
	}
	else
	{
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 0));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mSrc[0].mTemp] + 1));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));

		NativeCodeGenerator::Runtime& frt(nproc->mGenerator->ResolveRuntime(Ident::Unique("bcexec")));
		mIns.Push(NativeCodeInstruction(ins, ASMIT_JSR, ASMIM_ABSOLUTE, frt.mOffset, frt.mLinkerObject, NCIF_RUNTIME | NCIF_LOWER | NCIF_UPPER | NCIF_FEXEC));
	}

	if (ins->mDst.mTemp >= 0)
	{
		if (ins->mDst.mType == IT_FLOAT)
		{
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
		}
		else
		{
			if (!(lf & LOBJF_RET_REG_A))
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 0));
			mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 0));
			if (InterTypeSize[ins->mDst.mType] > 1)
			{
				if (lf & LOBJF_RET_REG_X)
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STX, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
				else
				{
					mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 1));
					mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 1));
				}
			}
			if (InterTypeSize[ins->mDst.mType] > 2)
			{
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 2));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_LDA, ASMIM_ZERO_PAGE, BC_REG_ACCU + 3));
				mIns.Push(NativeCodeInstruction(ins, ASMIT_STA, ASMIM_ZERO_PAGE, BC_REG_TMP + proc->mTempOffset[ins->mDst.mTemp] + 3));
			}
		}
	}
}

void NativeCodeBasicBlock::BuildLocalRegSets(void)
{
	int i;

	if (!mVisited)
	{
		mVisited = true;

		mLocalRequiredRegs = NumberSet(NUM_REGS);
		mLocalProvidedRegs = NumberSet(NUM_REGS);

		mEntryRequiredRegs = NumberSet(NUM_REGS);
		mEntryProvidedRegs = NumberSet(NUM_REGS);
		mExitRequiredRegs = NumberSet(NUM_REGS);
		mExitProvidedRegs = NumberSet(NUM_REGS);

		if (mEntryRegA)
			mLocalProvidedRegs += CPU_REG_A;
		if (mEntryRegX)
			mLocalProvidedRegs += CPU_REG_X;
		if (mEntryRegY)
			mLocalProvidedRegs += CPU_REG_Y;

		for (i = 0; i < mIns.Size(); i++)
		{
			mIns[i].FilterRegUsage(mLocalRequiredRegs, mLocalProvidedRegs);
		}

		switch (mBranch)
		{
		case ASMIT_BCC:
		case ASMIT_BCS:
			if (!mLocalProvidedRegs[CPU_REG_C])
				mLocalRequiredRegs += CPU_REG_C;
			break;
		case ASMIT_BEQ:
		case ASMIT_BNE:
		case ASMIT_BMI:
		case ASMIT_BPL:
			if (!mLocalProvidedRegs[CPU_REG_Z])
				mLocalRequiredRegs += CPU_REG_Z;
			break;
		}

		if (mExitRegA)
		{
			if (!mLocalProvidedRegs[CPU_REG_A])
				mLocalRequiredRegs += CPU_REG_A;
		}
		if (mExitRegX)
		{
			if (!mLocalProvidedRegs[CPU_REG_X])
				mLocalRequiredRegs += CPU_REG_X;
		}

		mEntryRequiredRegs = mLocalRequiredRegs;
		mExitProvidedRegs = mLocalProvidedRegs;

		if (mTrueJump) mTrueJump->BuildLocalRegSets();
		if (mFalseJump) mFalseJump->BuildLocalRegSets();
	}

}

void NativeCodeBasicBlock::BuildGlobalProvidedRegSet(NumberSet fromProvidedRegs)
{
	if (!mVisited || !(fromProvidedRegs <= mEntryProvidedRegs))
	{
		mEntryProvidedRegs |= fromProvidedRegs;
		fromProvidedRegs |= mExitProvidedRegs;

		mVisited = true;

		if (mTrueJump) mTrueJump->BuildGlobalProvidedRegSet(fromProvidedRegs);
		if (mFalseJump) mFalseJump->BuildGlobalProvidedRegSet(fromProvidedRegs);
	}

}

bool NativeCodeBasicBlock::BuildGlobalRequiredRegSet(NumberSet& fromRequiredRegs)
{
	bool revisit = false;

	if (!mVisited)
	{
		mVisited = true;

		NumberSet	newRequiredRegs(mExitRequiredRegs);

		if (mTrueJump && mTrueJump->BuildGlobalRequiredRegSet(newRequiredRegs)) revisit = true;
		if (mFalseJump && mFalseJump->BuildGlobalRequiredRegSet(newRequiredRegs)) revisit = true;

		if (!(newRequiredRegs <= mExitRequiredRegs))
		{
			revisit = true;

			mExitRequiredRegs = newRequiredRegs;
			newRequiredRegs -= mLocalProvidedRegs;
			mEntryRequiredRegs |= newRequiredRegs;
		}

	}

	fromRequiredRegs |= mEntryRequiredRegs;

	return revisit;

}

bool NativeCodeBasicBlock::RemoveUnusedResultInstructions(void)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		assert(mIndex == 1000 || mNumEntries == mEntryBlocks.Size());

		NumberSet		requiredRegs(mExitRequiredRegs);
		int i;

		switch (mBranch)
		{
		case ASMIT_BCC:
		case ASMIT_BCS:
			requiredRegs += CPU_REG_C;
			break;
		case ASMIT_BEQ:
		case ASMIT_BNE:
		case ASMIT_BMI:
		case ASMIT_BPL:
			requiredRegs += CPU_REG_Z;
			break;
		}

		for (i = mIns.Size() - 1; i >= 0; i--)
		{
			if (mIns[i].mType != ASMIT_NOP && !mIns[i].IsUsedResultInstructions(requiredRegs))
			{
				if (i > 0 && mIns[i - 1].mMode == ASMIM_RELATIVE && mIns[i - 1].mAddress > 0)
				{
					mIns[i - 1].mType = ASMIT_NOP;
					mIns[i - 1].mMode = ASMIM_IMPLIED;
				}
				mIns[i].mType = ASMIT_NOP;
				mIns[i].mMode = ASMIM_IMPLIED;
				changed = true;
			}
		}

		assert(mIndex == 1000 || mNumEntries == mEntryBlocks.Size());

		if (mTrueJump)
		{
			if (mTrueJump->RemoveUnusedResultInstructions())
				changed = true;
		}
		if (mFalseJump)
		{
			if (mFalseJump->RemoveUnusedResultInstructions())
				changed = true;
		}
	}

	return changed;
}

void NativeCodeBasicBlock::BuildCollisionTable(NumberSet* collisionSets)
{
	if (!mVisited)
	{
		mVisited = true;

		NumberSet		requiredTemps(mExitRequiredRegs);
		int i, j;

		for (i = 0; i < mExitRequiredRegs.Size(); i++)
		{
			if (mExitRequiredRegs[i])
			{
				for (j = 0; j < mExitRequiredRegs.Size(); j++)
				{
					if (mExitRequiredRegs[j])
					{
						collisionSets[i] += j;
					}
				}
			}
		}

		for (i = mIns.Size() - 1; i >= 0; i--)
		{
			mIns[i].BuildCollisionTable(requiredTemps, collisionSets);
		}

		if (mTrueJump) mTrueJump->BuildCollisionTable(collisionSets);
		if (mFalseJump) mFalseJump->BuildCollisionTable(collisionSets);
	}
}

void NativeCodeBasicBlock::BuildDominatorTree(NativeCodeBasicBlock* from, DominatorStacks& stacks)
{
	if (from == this)
		return;
	else if (!mDominator)
		mDominator = from;
	else if (from == mDominator)
		return;
	else
	{
		stacks.d1.SetSize(0);
		stacks.d2.SetSize(0);

		NativeCodeBasicBlock* b = mDominator;
		while (b)
		{
			stacks.d1.Push(b);
			b = b->mDominator;
		}
		b = from;
		while (b)
		{
			stacks.d2.Push(b);
			b = b->mDominator;
		}

		b = nullptr;
		while (stacks.d1.Size() > 0 && stacks.d2.Size() > 0 && stacks.d1.Last() == stacks.d2.Last())
		{
			b = stacks.d1.Pop(); stacks.d2.Pop();
		}

		if (mDominator == b)
			return;

		mDominator = b;
	}

	if (mTrueJump)
		mTrueJump->BuildDominatorTree(this, stacks);
	if (mFalseJump)
		mFalseJump->BuildDominatorTree(this, stacks);
}


void NativeCodeBasicBlock::CountEntries(NativeCodeBasicBlock * fromJump)
{
	if (mVisiting)
		mLoopHead = true;

	if (mNumEntries == 0)
		mFromJump = fromJump;
	else
		mFromJump = nullptr;
	mNumEntries++;

	if (!mVisited)
	{
		mVisited = true;
		mVisiting = true;

		if (mTrueJump)
			mTrueJump->CountEntries(this);
		if (mFalseJump)
			mFalseJump->CountEntries(this);

		mVisiting = false;
	}
}

bool NativeCodeBasicBlock::IsSame(const NativeCodeBasicBlock* block) const
{
	if (block->mIns.Size() != mIns.Size())
		return false;

	if (block->mBranch != mBranch)
		return false;

	if (mTrueJump)
	{
		if (!block->mTrueJump)
			return false;

		if (mTrueJump == this)
		{
			if (block->mTrueJump != block)
				return false;
		}
		else if (mTrueJump != block->mTrueJump)
			return false;
	}
	else if (block->mTrueJump)
		return false;

	if (mFalseJump)
	{
		if (!block->mFalseJump)
			return false;

		if (mFalseJump == this)
		{
			if (block->mFalseJump != block)
				return false;
		}
		else if (mFalseJump != block->mFalseJump)
			return false;
	}
	else if (block->mFalseJump)
		return false;

	for (int i = 0; i < mIns.Size(); i++)
		if (!mIns[i].IsSame(block->mIns[i]))
			return false;

	return true;
}

bool NativeCodeBasicBlock::FindSameBlocks(NativeCodeProcedure* nproc)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		if (!mSameBlock)
		{
			for (int i = 0; i < nproc->mBlocks.Size(); i++)
			{
				if (nproc->mBlocks[i] != this && nproc->mBlocks[i]->IsSame(this))
				{
					nproc->mBlocks[i]->mSameBlock = this;
					changed = true;
				}
			}
		}

		if (mTrueJump && mTrueJump->FindSameBlocks(nproc))
			changed = true;
		if (mFalseJump && mFalseJump->FindSameBlocks(nproc))
			changed = true;
	}

	return changed;
}

bool NativeCodeBasicBlock::MergeSameBlocks(NativeCodeProcedure* nproc)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		if (mTrueJump && mTrueJump->mSameBlock)
		{
			mTrueJump = mTrueJump->mSameBlock;
			changed = true;
		}

		if (mFalseJump && mFalseJump->mSameBlock)
		{
			mFalseJump = mFalseJump->mSameBlock;
			changed = true;
		}

		if (mTrueJump && mTrueJump->MergeSameBlocks(nproc))
			changed = true;
		if (mFalseJump && mFalseJump->MergeSameBlocks(nproc))
			changed = true;
	}

	return changed;
}

NativeCodeBasicBlock* NativeCodeBasicBlock::ForwardAccuBranch(bool eq, bool ne, bool pl, bool mi, int limit)
{
	if (limit == 4)
		return this;
	limit++;

	if (mIns.Size() == 0 && mNumEntries == 1 || mIns.Size() == 1 && mIns[0].mType == ASMIT_ORA && mIns[0].mMode == ASMIM_IMMEDIATE && mIns[0].mAddress == 0)
	{
		if (mBranch == ASMIT_BEQ)
		{
			if (eq)
				return mTrueJump->ForwardAccuBranch(true, false, true, false, limit);
			if (ne || mi)
				return mFalseJump->ForwardAccuBranch(false, true, pl, mi, limit);
		}
		else if (mBranch == ASMIT_BNE)
		{
			if (eq)
				return mFalseJump->ForwardAccuBranch(true, false, true, false, limit);
			if (ne || mi)
				return mTrueJump->ForwardAccuBranch(false, true, pl, mi, limit);
		}
		else if (mBranch == ASMIT_BPL)
		{
			if (eq || pl)
				return mTrueJump->ForwardAccuBranch(eq, ne, true, false, limit);
			if (mi)
				return mFalseJump->ForwardAccuBranch(false, true, false, true, limit);
		}
		else if (mBranch == ASMIT_BMI)
		{
			if (eq || pl)
				return mFalseJump->ForwardAccuBranch(eq, ne, true, false, limit);
			if (mi)
				return mTrueJump->ForwardAccuBranch(false, true, false, true, limit);
		}
	}

	return this;
}


bool NativeCodeBasicBlock::MergeBasicBlocks(void)
{
	bool	changed = false;

	if (!mVisited)
	{
		assert(mIns.Size() == 0 || mIns[0].mType != ASMIT_INV);

		mVisited = true;

		if (!mLocked)
		{
			if (mTrueJump && mFalseJump && mTrueJump != this && mFalseJump != this && (mBranch == ASMIT_BEQ || mBranch == ASMIT_BNE || mBranch == ASMIT_BPL || mBranch == ASMIT_BMI))
			{
				if (mIns.Size() > 0 && mIns[mIns.Size() - 1].mType == ASMIT_LDA)
				{
					if (mTrueJump->mIns.Size() == 1 && mTrueJump->mIns[0].IsSame(mIns[mIns.Size() - 1]))
					{
						if (mTrueJump->mBranch == mBranch)
						{
							mTrueJump = mTrueJump->mTrueJump;
							changed = true;
						}
						else if (mTrueJump->mBranch == InvertBranchCondition(mBranch))
						{
							mTrueJump = mTrueJump->mFalseJump;
							changed = true;
						}
					}
					if (mFalseJump->mIns.Size() == 1 && mFalseJump->mIns[0].IsSame(mIns[mIns.Size() - 1]))
					{
						if (mFalseJump->mBranch == mBranch)
						{
							mFalseJump = mFalseJump->mFalseJump;
							changed = true;
						}
						else if (mFalseJump->mBranch == InvertBranchCondition(mBranch))
						{
							mFalseJump = mFalseJump->mTrueJump;
							changed = true;
						}
					}
				}
			}

			if (mFalseJump)
			{
				if (mTrueJump->mIns.Size() == 0 && mTrueJump->mFalseJump)
				{
					if (mTrueJump->mBranch == mBranch)
					{
						mTrueJump = mTrueJump->mTrueJump;
						changed = true;
					}
					else if (mTrueJump->mBranch == InvertBranchCondition(mBranch))
					{
						mTrueJump = mTrueJump->mFalseJump;
						changed = true;
					}
				}
				if (mFalseJump->mIns.Size() == 0 && mFalseJump->mFalseJump)
				{
					if (mFalseJump->mBranch == mBranch)
					{
						mFalseJump = mFalseJump->mFalseJump;
						changed = true;
					}
					else if (mFalseJump->mBranch == InvertBranchCondition(mBranch))
					{
						mFalseJump = mFalseJump->mTrueJump;
						changed = true;
					}
				}
			}

			while (mTrueJump && !mFalseJump && mTrueJump->mNumEntries == 1 && mTrueJump != this && !mTrueJump->mLocked)
			{
				for (int i = 0; i < mTrueJump->mIns.Size(); i++)
					mIns.Push(mTrueJump->mIns[i]);
				mBranch = mTrueJump->mBranch;
				mFalseJump = mTrueJump->mFalseJump;
				mTrueJump = mTrueJump->mTrueJump;
				changed = true;
			}

			int steps = 100;
			while (mTrueJump && mTrueJump->mIns.Size() == 0 && !mTrueJump->mFalseJump && !mTrueJump->mLocked && mTrueJump != this && mTrueJump->mTrueJump != mTrueJump && steps > 0)
			{
				mTrueJump->mNumEntries--;
				mTrueJump = mTrueJump->mTrueJump;
				mTrueJump->mNumEntries++;
				changed = true;
				steps--;
			}

			steps = 100;
			while (mFalseJump && mFalseJump->mTrueJump && mFalseJump->mIns.Size() == 0 && !mFalseJump->mFalseJump && !mFalseJump->mLocked && mFalseJump != this && mFalseJump->mTrueJump != mFalseJump && steps > 0)
			{
				mFalseJump->mNumEntries--;
				mFalseJump = mFalseJump->mTrueJump;
				mFalseJump->mNumEntries++;
				changed = true;
				steps--;
			}

			if (mTrueJump && mTrueJump == mFalseJump)
			{
				mBranch = ASMIT_JMP;
				mFalseJump = nullptr;
				changed = true;
			}
#if 1
			if (mIns.Size() > 0 && mIns.Last().ChangesAccuAndFlag() && mTrueJump && mFalseJump)
			{
				NativeCodeBasicBlock* ntb = mTrueJump, * nfb = mFalseJump;

				if (mBranch == ASMIT_BEQ)
				{
					ntb = ntb->ForwardAccuBranch(true, false, true, false, 0);
					nfb = nfb->ForwardAccuBranch(false, true, false, false, 0);
				}
				else if (mBranch == ASMIT_BNE)
				{
					nfb = nfb->ForwardAccuBranch(true, false, true, false, 0);
					ntb = ntb->ForwardAccuBranch(false, true, false, false, 0);
				}
				else if (mBranch == ASMIT_BPL)
				{
					ntb = ntb->ForwardAccuBranch(false, false, true, false, 0);
					nfb = nfb->ForwardAccuBranch(false, true, false, true, 0);
				}
				else if (mBranch == ASMIT_BMI)
				{
					nfb = nfb->ForwardAccuBranch(false, false, true, false, 0);
					ntb = ntb->ForwardAccuBranch(false, true, false, true, 0);
				}

				if (ntb != mTrueJump)
				{
					mTrueJump->mNumEntries--;
					mTrueJump = ntb;
					mTrueJump->mNumEntries++;
					changed = true;
				}

				if (nfb != mFalseJump)
				{
					mFalseJump->mNumEntries--;
					mFalseJump = nfb;
					mFalseJump->mNumEntries++;
					changed = true;
				}
			}
#endif
		}

		if (mTrueJump)
			mTrueJump->MergeBasicBlocks();
		if (mFalseJump)
			mFalseJump->MergeBasicBlocks();

		assert(mIns.Size() == 0 || mIns[0].mType != ASMIT_INV);
	}
	return changed;
}

void NativeCodeBasicBlock::CollectEntryBlocks(NativeCodeBasicBlock* block)
{
	if (block)
		mEntryBlocks.Push(block);

	if (!mVisited)
	{
		mVisited = true;

		if (mTrueJump)
			mTrueJump->CollectEntryBlocks(this);
		if (mFalseJump)
			mFalseJump->CollectEntryBlocks(this);
	}
}

void NativeCodeBasicBlock::BuildEntryDataSet(const NativeRegisterDataSet& set)
{
	if (!mVisited)
		mEntryRegisterDataSet = set;
	else
	{
		bool	changed = false;
		for (int i = 0; i < NUM_REGS; i++)
		{
			if (set.mRegs[i].mMode == NRDM_IMMEDIATE)
			{
				if (mEntryRegisterDataSet.mRegs[i].mMode == NRDM_IMMEDIATE && set.mRegs[i].mValue == mEntryRegisterDataSet.mRegs[i].mValue)
				{
				}
				else if (mEntryRegisterDataSet.mRegs[i].mMode != NRDM_UNKNOWN)
				{
					mEntryRegisterDataSet.mRegs[i].Reset();
					mVisited = false;
				}
			}
			else if (set.mRegs[i].mMode == NRDM_IMMEDIATE_ADDRESS)
			{
				if (mEntryRegisterDataSet.mRegs[i].mMode == NRDM_IMMEDIATE_ADDRESS &&
					set.mRegs[i].mValue == mEntryRegisterDataSet.mRegs[i].mValue &&
					set.mRegs[i].mLinkerObject == mEntryRegisterDataSet.mRegs[i].mLinkerObject &&
					set.mRegs[i].mFlags == mEntryRegisterDataSet.mRegs[i].mFlags)
				{
				}
				else if (mEntryRegisterDataSet.mRegs[i].mMode != NRDM_UNKNOWN)
				{
					mEntryRegisterDataSet.mRegs[i].Reset();
					mVisited = false;
				}
			}
			else if (mEntryRegisterDataSet.mRegs[i].mMode != NRDM_UNKNOWN)
			{
				mEntryRegisterDataSet.mRegs[i].Reset();
				mVisited = false;
			}
		}
	}

	if (!mVisited)
	{
		mVisited = true;

		mNDataSet = mEntryRegisterDataSet;

		for (int i = 0; i < mIns.Size(); i++)
			mIns[i].Simulate(mNDataSet);

		if (mTrueJump)
			mTrueJump->BuildEntryDataSet(mNDataSet);
		if (mFalseJump)
			mFalseJump->BuildEntryDataSet(mNDataSet);
	}
}

bool NativeCodeBasicBlock::ApplyEntryDataSet(void)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		mNDataSet = mEntryRegisterDataSet;

		for (int i = 0; i < mIns.Size(); i++)
		{
			if (mIns[i].ApplySimulation(mNDataSet))
				changed = true;
			mIns[i].Simulate(mNDataSet);
		}

		if (mTrueJump && mTrueJump->ApplyEntryDataSet())
			changed = true;
		if (mFalseJump && mFalseJump->ApplyEntryDataSet())
			changed = true;
	}

	return changed;
}

void NativeCodeBasicBlock::FindZeroPageAlias(const NumberSet& statics, NumberSet& invalid, uint8* alias, int accu)
{
	if (!mVisited)
	{
		mVisited = true;

		if (mNumEntries > 1)
			accu = -1;

		for (int i = 0; i < mIns.Size(); i++)
		{
			if (mIns[i].mMode == ASMIM_ZERO_PAGE)
			{
				if (mIns[i].mType == ASMIT_LDA)
					accu = mIns[i].mAddress;
				else if (mIns[i].mType == ASMIT_STA)
				{
					if (accu < 0 || !statics[accu])
						invalid += mIns[i].mAddress;
					else if (alias[mIns[i].mAddress])
					{
						if (alias[mIns[i].mAddress] != accu)
							invalid += mIns[i].mAddress;
					}
					else
					{
						alias[mIns[i].mAddress] = accu;
					}
				}
				else if (mIns[i].ChangesAccu())
					accu = -1;
				else if (mIns[i].ChangesAddress())
					invalid += mIns[i].mAddress;
			}
			else if (mIns[i].ChangesAccu())
				accu = -1;
		}

		if (mTrueJump)
			mTrueJump->FindZeroPageAlias(statics, invalid, alias, accu);
		if (mFalseJump)
			mFalseJump->FindZeroPageAlias(statics, invalid, alias, accu);
	}
}

bool NativeCodeBasicBlock::CollectZeroPageSet(ZeroPageSet& locals, ZeroPageSet& global, bool ignorefcall)
{
	if (!mVisited)
	{
		mVisited = true;

		for (int i = 0; i < mIns.Size(); i++)
		{
			switch (mIns[i].mMode)
			{
			case ASMIM_ZERO_PAGE:
				if (mIns[i].ChangesAddress())
					locals += mIns[i].mAddress;
				break;
			case ASMIM_ABSOLUTE:
				if (mIns[i].mType == ASMIT_JSR)
				{
					if (mIns[i].mFlags & NCIF_RUNTIME)
					{
						if (mIns[i].mFlags & NCIF_FEXEC)
						{
							if (!ignorefcall)
								return false;
						}
						else
						{
							for (int j = 0; j < 4; j++)
							{
								locals += BC_REG_ACCU + j;
								locals += BC_REG_WORK + j;
							}
						}
					}

					if (mIns[i].mLinkerObject)
					{
						LinkerObject* lo = mIns[i].mLinkerObject;

						if (lo->mFlags & LOBJF_ZEROPAGESET)
						{
							global |= lo->mZeroPageSet;
						}
						else if (!lo->mProc)
						{
							for (int i = 0; i < lo->mNumTemporaries; i++)
							{
								for (int j = 0; j < lo->mTempSizes[i]; j++)
									global += lo->mTemporaries[i] + j;
							}
						}
						else
							return false;
					}
				}
				break;
			case ASMIM_ZERO_PAGE_X:
				if (mIns[i].ChangesAddress())
				{
					if (i > 1 && i + 2 < mIns.Size())
					{
						if (mIns[i - 2].mType == ASMIT_LDX && mIns[i - 2].mMode == ASMIM_IMMEDIATE &&
							mIns[i - 1].mType == ASMIT_LDA &&
							mIns[i + 0].mType == ASMIT_STA &&
							mIns[i + 1].mType == ASMIT_DEX &&
							mIns[i + 2].mType == ASMIT_BPL)
						{
							for (int j = 0; j < mIns[i - 2].mAddress; j++)
								locals += mIns[i].mAddress + j;
						}
					}
				}
				break;
			}
		}

		if (mTrueJump && !mTrueJump->CollectZeroPageSet(locals, global, ignorefcall))
			return false;
		if (mFalseJump && !mFalseJump->CollectZeroPageSet(locals, global, ignorefcall))
			return false;
	}

	return true;
}

void NativeCodeBasicBlock::CollectZeroPageUsage(NumberSet& used, NumberSet &modified, NumberSet& pairs)
{
	if (!mVisited)
	{
		mVisited = true;

		for (int i = 0; i < mIns.Size(); i++)
		{
			switch (mIns[i].mMode)
			{
			case ASMIM_ZERO_PAGE:
				used += mIns[i].mAddress;
				if (mIns[i].ChangesAddress())
					modified += mIns[i].mAddress;
				break;
			case ASMIM_INDIRECT_Y:
				used += mIns[i].mAddress + 0;
				used += mIns[i].mAddress + 1;
				pairs += mIns[i].mAddress;
				break;
			case ASMIM_ABSOLUTE:
				if (mIns[i].mType == ASMIT_JSR)
				{
					if (mIns[i].mFlags & NCIF_RUNTIME)
					{
						for (int j = 0; j < 4; j++)
						{
							used += BC_REG_ACCU + j;
							used += BC_REG_WORK + j;
							modified += BC_REG_ACCU + j;
							modified += BC_REG_WORK + j;
						}
					}

					if (mIns[i].mLinkerObject)
					{
						LinkerObject* lo = mIns[i].mLinkerObject;

						for (int i = 0; i < lo->mNumTemporaries; i++)
						{
							for (int j = 0; j < lo->mTempSizes[i]; j++)
								used += lo->mTemporaries[i] + j;
						}
					}
				}
				break;
			}
		}

		if (mTrueJump)
			mTrueJump->CollectZeroPageUsage(used, modified, pairs);
		if (mFalseJump)
			mFalseJump->CollectZeroPageUsage(used, modified, pairs);
	}
}

void NativeCodeBasicBlock::GlobalRegisterXMap(int reg)
{
	if (!mVisited)
	{
		mVisited = true;

		for (int i = 0; i < mIns.Size(); i++)
		{
			NativeCodeInstruction& ins(mIns[i]);
			if (ins.mMode == ASMIM_ZERO_PAGE && ins.mAddress == reg)
			{
				switch (ins.mType)
				{
				case ASMIT_STA:
					ins.mType = ASMIT_TAX;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_LDA:
					ins.mType = ASMIT_TXA;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_INC:
					ins.mType = ASMIT_INX;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_DEC:
					ins.mType = ASMIT_DEX;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_LDX:
					assert(ins.mAddress == reg);
					ins.mType = ASMIT_NOP;
					ins.mMode = ASMIM_IMPLIED;
					break;
				}
			}
		}

		if (mTrueJump)
			mTrueJump->GlobalRegisterXMap(reg);
		if (mFalseJump)
			mFalseJump->GlobalRegisterXMap(reg);
	}
}

void NativeCodeBasicBlock::GlobalRegisterYMap(int reg)
{
	if (!mVisited)
	{
		mVisited = true;

		for (int i = 0; i < mIns.Size(); i++)
		{
			NativeCodeInstruction& ins(mIns[i]);
			if (ins.mMode == ASMIM_ZERO_PAGE && ins.mAddress == reg)
			{
				switch (ins.mType)
				{
				case ASMIT_STA:
					ins.mType = ASMIT_TAY;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_LDA:
					ins.mType = ASMIT_TYA;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_INC:
					ins.mType = ASMIT_INY;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_DEC:
					ins.mType = ASMIT_DEY;
					ins.mMode = ASMIM_IMPLIED;
					break;
				case ASMIT_LDY:
					assert(ins.mAddress == reg);
					ins.mType = ASMIT_NOP;
					ins.mMode = ASMIM_IMPLIED;
					break;
				}
			}
		}

		if (mTrueJump)
			mTrueJump->GlobalRegisterYMap(reg);
		if (mFalseJump)
			mFalseJump->GlobalRegisterYMap(reg);
	}
}

bool NativeCodeBasicBlock::ReplaceYRegWithXReg(int start, int end)
{
	bool	changed = false;

//	CheckLive();

	for (int i = start; i < end; i++)
	{
		NativeCodeInstruction& ins(mIns[i]);
		if (ins.ReplaceYRegWithXReg())
			changed = true;
	}

//	CheckLive();

	return changed;
}

bool NativeCodeBasicBlock::ReduceLocalYPressure(void)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		CheckLive();

#if 1
		if (mLoopHead && mFalseJump && mEntryRequiredRegs.Size() && !mEntryRequiredRegs[CPU_REG_X] && !mExitRequiredRegs[CPU_REG_X] && mEntryBlocks.Size() == 2 && (mFalseJump == this || mTrueJump == this))
		{
			NativeCodeBasicBlock* pblock, * nblock;
			if (mTrueJump == this)
				nblock = mFalseJump;
			else
				nblock = mTrueJump;
			if (mEntryBlocks[0] == this)
				pblock = mEntryBlocks[1];
			else
				pblock = mEntryBlocks[0];

			if (!pblock->mFalseJump && !nblock->mEntryRequiredRegs[CPU_REG_Y])
			{
				int	pz = pblock->mIns.Size();
				while (pz > 0 && !pblock->mIns[pz - 1].ReferencesYReg() && !pblock->mIns[pz - 1].ReferencesXReg())
					pz--;

				if (mEntryRequiredRegs[CPU_REG_Y] && pz > 0 && pblock->mIns[pz - 1].mType == ASMIT_LDY && pblock->mIns[pz - 1].mMode == ASMIM_IMMEDIATE)
				{
					if (CanReplaceYRegWithXReg(0, mIns.Size()))
					{
						mEntryRequiredRegs += CPU_REG_X; 
						mExitRequiredRegs += CPU_REG_X; 
						pblock->mExitRequiredRegs += CPU_REG_X; pblock->mExitRequiredRegs -= CPU_REG_Y;

						ReplaceYRegWithXReg(0, mIns.Size());

						mEntryRequiredRegs -= CPU_REG_Y;
						mExitRequiredRegs -= CPU_REG_Y;

						pz--;
						pblock->mIns[pz].mType = ASMIT_LDX;
						while (pz < pblock->mIns.Size())
						{
							pblock->mIns[pz].mLive |= LIVE_CPU_REG_X;
							pz++;
						}

						changed = true;
					}
				}
			}
		}
#endif
		int start = 0;
		while (start < mIns.Size())
		{
			const NativeCodeInstruction& ins(mIns[start]);

			if ((ins.mType == ASMIT_LDY || ins.mType == ASMIT_TAY) && ins.mMode != ASMIM_ABSOLUTE_X && !(ins.mLive & LIVE_CPU_REG_X))
			{
				int end = start + 1;
				while (end < mIns.Size())
				{
					const NativeCodeInstruction& eins(mIns[end]);
					if (eins.mType == ASMIT_LDY || eins.mType == ASMIT_TAY)
					{
						ReplaceYRegWithXReg(start, end);
						changed = true;
						break;
					}
					else if (eins.ChangesXReg() || eins.mMode == ASMIM_INDIRECT_Y)
					{
						break;
					}
					else if (!(eins.mLive & LIVE_CPU_REG_Y))
					{
						end++;
						ReplaceYRegWithXReg(start, end);
						changed = true;
						break;
					}

					end++;
				}

				start = end;
			}
			else
				start++;
		}

		CheckLive();

		if (mTrueJump && mTrueJump->ReduceLocalYPressure())
			changed = true;

		if (mFalseJump && mFalseJump->ReduceLocalYPressure())
			changed = true;
	}

	return changed;
}

bool NativeCodeBasicBlock::ForwardAccuAddSub(void)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		int	aoffset = 0, apred = 0, aload = -1;
		int	carry = 0;

		CheckLive();

		for (int i = 0; i < mIns.Size(); i++)
		{
			if (mIns[i].mType == ASMIT_LDA && (mIns[i].mMode == ASMIM_ZERO_PAGE || mIns[i].mMode == ASMIM_ABSOLUTE))
			{
				if (aload != -1 && mIns[i].SameEffectiveAddress(mIns[aload]))
				{
					if (aoffset == 0)
					{
						for (int j = apred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_A;

						if (mIns[i].mLive & LIVE_CPU_REG_Z)
						{
							mIns[i].mType = ASMIT_ORA; mIns[i].mMode = ASMIM_IMMEDIATE; mIns[i].mAddress = 0;
						}
						else
						{
							mIns[i].mType = ASMIT_NOP; mIns[i].mMode = ASMIM_IMPLIED;
						}
						changed = true;
					}
					else if (i + 2 < mIns.Size() && mIns[i + 1].mType == ASMIT_CLC && mIns[i + 2].mType == ASMIT_ADC && mIns[i + 2].mMode == ASMIM_IMMEDIATE && !(mIns[i + 2].mLive & LIVE_CPU_REG_C))
					{
						for (int j = apred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_A;

						mIns[i + 0].mType = ASMIT_NOP; mIns[i + 0].mMode = ASMIM_IMPLIED;
						mIns[i + 2].mAddress = (mIns[i + 2].mAddress - aoffset) & 0xff;
						changed = true;
					}
					else if (carry == 1 && i + 1 < mIns.Size() && mIns[i + 1].mType == ASMIT_ADC && mIns[i + 1].mMode == ASMIM_IMMEDIATE && !(mIns[i + 1].mLive & LIVE_CPU_REG_C))
					{
						for (int j = apred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_A;

						mIns[i + 0].mType = ASMIT_NOP; mIns[i + 0].mMode = ASMIM_IMPLIED;
						mIns[i + 1].mAddress = (mIns[i + 1].mAddress - aoffset) & 0xff;
						changed = true;
					}
					else
					{
						aload = i;
						aoffset = 0;
					}
				}
				else
				{
					aload = i;
					aoffset = 0;
				}

				apred = i;
			}
			else if (mIns[i + 0].mType == ASMIT_CLC)
				carry = 1;
			else if (mIns[i + 0].mType == ASMIT_SEC)
				carry = -1;
			else if (aload != -1 && carry == 1 &&
				mIns[i + 0].mType == ASMIT_ADC && mIns[i + 0].mMode == ASMIM_IMMEDIATE)
			{
				aoffset = (aoffset + mIns[i + 0].mAddress) & 0xff;
				apred = i;
				carry = 0;
			}
			else if (aload != -1 && carry == -1 &&
				mIns[i + 0].mType == ASMIT_SBC && mIns[i + 0].mMode == ASMIM_IMMEDIATE)
			{
				aoffset = (aoffset - mIns[i + 0].mAddress) & 0xff;
				apred = i;
			}
			else if (aload != -1 && mIns[i].mType == ASMIT_STA && (mIns[i].mMode == ASMIM_ZERO_PAGE || mIns[i].mMode == ASMIM_ABSOLUTE) && mIns[i].SameEffectiveAddress(mIns[aload]))
			{
				aoffset = 0;
				apred = i;
			}
			else if (aload != -1 && mIns[i].mType == ASMIT_STA && mIns[aload].mMode != ASMIM_ZERO_PAGE&& mIns[i].mMode == ASMIM_ZERO_PAGE)
			{
				aload = i;
				aoffset = 0;
				apred = i;
			}
			else
			{
				if (mIns[i].ChangesCarry())
					carry = 0;

				if (aload != -1 && mIns[i].ChangesAccu())
					aload = -1;
			
				if (aload != -1 && mIns[aload].MayBeChangedOnAddress(mIns[i]))
					aload = -1;
			}
		}

		CheckLive();

		if (mTrueJump && mTrueJump->ForwardAccuAddSub())
			changed = true;

		if (mFalseJump && mFalseJump->ForwardAccuAddSub())
			changed = true;
	}

	return changed;
}

bool NativeCodeBasicBlock::ForwardAXYReg(void)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		bool	xisa = false, yisa = false;
		int		xoffset = -1, yoffset = -1;

		for (int i = 0; i < mIns.Size(); i++)
		{
			if (mIns[i].mType == ASMIT_TAX)
			{
				xisa = true;
				xoffset = i;
			}
			else if (mIns[i].mType == ASMIT_TXA)
			{
				xisa = true;
				yisa = false;
				xoffset = i;
			}
			else if (mIns[i].mType == ASMIT_TAY)
			{
				yisa = true;
				yoffset = i;
			}
			else if (mIns[i].mType == ASMIT_TYA)
			{
				yisa = true;
				xisa = false;
				yoffset = i;
			}
			else if (mIns[i].ChangesXReg())
				xisa = false;
			else if (mIns[i].ChangesYReg())
				xisa = false;
			else if (mIns[i].ChangesAccu())
			{
				xisa = false;
				yisa = false;
			}
			else if (i + 1 < mIns.Size() && mIns[i].mType == ASMIT_CLC &&
				mIns[i + 1].mType == ASMIT_ADC && mIns[i + 1].mMode == ASMIM_IMMEDIATE && !(mIns[i + 1].mLive & LIVE_CPU_REG_C))
			{
				if (xisa && !(mIns[i + 1].mLive & LIVE_CPU_REG_X))
				{
					if (mIns[i + 1].mAddress == 1)
					{
						mIns[i + 0].mType = ASMIT_INX;
						mIns[i + 1].mType = ASMIT_TXA; mIns[i + 1].mMode = ASMIM_IMPLIED;
						for (int j = xoffset; j < i + 1; j++)
							mIns[j].mLive |= LIVE_CPU_REG_X;
						xisa = false;
						changed = true;
					}
				}
				else if (yisa && !(mIns[i + 1].mLive & LIVE_CPU_REG_Y))
				{
					if (mIns[i + 1].mAddress == 1)
					{
						mIns[i + 0].mType = ASMIT_INY;
						mIns[i + 1].mType = ASMIT_TYA; mIns[i + 1].mMode = ASMIM_IMPLIED;
						for (int j = yoffset; j < i + 1; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;
						yisa = false;
						changed = true;
					}
				}
			}
		}

		if (mTrueJump && mTrueJump->ForwardAXYReg())
			changed = true;
		if (mFalseJump && mFalseJump->ForwardAXYReg())
			changed = true;
	}

	return changed;
}

bool NativeCodeBasicBlock::ForwardZpYIndex(bool full)
{
	CheckLive();

	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		int	yreg = -1, yoffset = 0, ypred = 0;

		for (int i = 0; i < mIns.Size(); i++)
		{
			if (mIns[i].mType == ASMIT_LDY && mIns[i].mMode == ASMIM_ZERO_PAGE)
			{
				if (yreg == mIns[i].mAddress)
				{
					if (yoffset == 0)
					{
						for (int j = ypred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;

						mIns[i].mType = ASMIT_NOP; mIns[i].mMode = ASMIM_IMPLIED;
						changed = true;
					}
					else if (yoffset == 1 && i + 1 < mIns.Size() && mIns[i + 1].mType == ASMIT_INY)
					{
						for (int j = ypred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;

						mIns[i + 0].mType = ASMIT_NOP; mIns[i + 0].mMode = ASMIM_IMPLIED;
						mIns[i + 1].mType = ASMIT_NOP; mIns[i + 1].mMode = ASMIM_IMPLIED;
						changed = true;
					}
					else if (yoffset == 1)
					{
						for (int j = ypred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;

						mIns[i + 0].mType = ASMIT_DEY; mIns[i + 0].mMode = ASMIM_IMPLIED;
						yoffset = 0;
						changed = true;
					}
					else if (yoffset == 2 && i + 2 < mIns.Size() && mIns[i + 1].mType == ASMIT_INY && mIns[i + 2].mType == ASMIT_INY)
					{
						for (int j = ypred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;

						mIns[i + 0].mType = ASMIT_NOP; mIns[i + 0].mMode = ASMIM_IMPLIED;
						mIns[i + 1].mType = ASMIT_NOP; mIns[i + 1].mMode = ASMIM_IMPLIED;
						mIns[i + 2].mType = ASMIT_NOP; mIns[i + 2].mMode = ASMIM_IMPLIED;
						changed = true;
					}
					else if (yoffset == 2 && i + 1 < mIns.Size() && mIns[i + 1].mType == ASMIT_INY)
					{
						for (int j = ypred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;

						mIns[i + 0].mType = ASMIT_NOP; mIns[i + 0].mMode = ASMIM_IMPLIED;
						mIns[i + 1].mType = ASMIT_DEY;
						changed = true;
					}
					else if (yoffset == 3 && i + 2 < mIns.Size() && mIns[i + 1].mType == ASMIT_INY && mIns[i + 2].mType == ASMIT_INY)
					{
						for (int j = ypred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;

						mIns[i + 0].mType = ASMIT_NOP; mIns[i + 0].mMode = ASMIM_IMPLIED;
						mIns[i + 1].mType = ASMIT_NOP; mIns[i + 1].mMode = ASMIM_IMPLIED;
						mIns[i + 2].mType = ASMIT_DEY; mIns[i + 2].mMode = ASMIM_IMPLIED;
						changed = true;
					}
					else if (yoffset == 3 && i + 1 < mIns.Size() && mIns[i + 1].mType == ASMIT_INY)
					{
						for (int j = ypred; j < i; j++)
							mIns[j].mLive |= LIVE_CPU_REG_Y;

						mIns[i + 0].mType = ASMIT_DEY; mIns[i + 0].mMode = ASMIM_IMPLIED;
						mIns[i + 1].mType = ASMIT_DEY; mIns[i + 1].mMode = ASMIM_IMPLIED;
						yoffset = 2;
						changed = true;
					}
					else
						yoffset = 0;
					ypred = i;
				}
				else
				{
					if (full && yreg >= 0)
					{
						int j = i;
						while (j < mIns.Size() && !mIns[j].ReferencesZeroPage(yreg))
							j++;
						if (j + 2 < mIns.Size() &&
							mIns[j - 1].mType == ASMIT_CLC &&
							mIns[j + 0].mType == ASMIT_LDA && mIns[j + 0].mMode == ASMIM_ZERO_PAGE &&
							mIns[j + 1].mType == ASMIT_ADC && mIns[j + 1].mMode == ASMIM_IMMEDIATE &&
							mIns[j + 2].mType == ASMIT_STA && mIns[j + 2].mMode == ASMIM_ZERO_PAGE && mIns[j + 2].mAddress == yreg &&
							!(mIns[j + 2].mLive & LIVE_CPU_REG_C))
						{
							if (mIns[j + 1].mAddress == yoffset + 1)
							{
								for (int k = ypred; k < i; k++)
									mIns[k].mLive |= LIVE_CPU_REG_Y;

								mIns.Remove(j + 2);
								mIns.Remove(j + 1);
								mIns.Remove(j - 1);
								mIns.Insert(i, NativeCodeInstruction(mIns[i].mIns, ASMIT_INY));
								mIns.Insert(i + 1, NativeCodeInstruction(mIns[i].mIns, ASMIT_STY, ASMIM_ZERO_PAGE, yreg));
								i += 2;
								changed = true;
							}
						}
					}

					yreg = mIns[i].mAddress;
					yoffset = 0;
					ypred = i;
				}
			}
			else if (i + 3 < mIns.Size() &&
				mIns[i + 0].mType == ASMIT_CLC &&
				mIns[i + 1].mType == ASMIT_LDA && mIns[i + 1].mMode == ASMIM_ZERO_PAGE &&
				mIns[i + 2].mType == ASMIT_ADC && mIns[i + 2].mMode == ASMIM_IMMEDIATE &&
				mIns[i + 3].mType == ASMIT_TAY)
			{
				if (mIns[i + 1].mAddress == yreg && mIns[i + 2].mAddress == yoffset + 1 && !(mIns[i + 3].mLive & (LIVE_CPU_REG_A | LIVE_CPU_REG_C)))
				{
					for (int j = ypred; j < i; j++)
						mIns[j].mLive |= LIVE_CPU_REG_Y;
					mIns[i + 0].mType = ASMIT_NOP; mIns[i + 0].mMode = ASMIM_IMPLIED;
					mIns[i + 1].mType = ASMIT_NOP; mIns[i + 1].mMode = ASMIM_IMPLIED;
					mIns[i + 2].mType = ASMIT_NOP; mIns[i + 2].mMode = ASMIM_IMPLIED;
					mIns[i + 3].mType = ASMIT_INY;
					changed = true;
				}
				else
				{
					yreg = mIns[i + 1].mAddress;
					yoffset = mIns[i + 2].mAddress;
					ypred = i + 3;
					i += 3;
				}
			}
			else if (i + 3 < mIns.Size() &&
				mIns[i + 0].mType == ASMIT_CLC &&
				mIns[i + 1].mType == ASMIT_LDA && mIns[i + 1].mMode == ASMIM_ZERO_PAGE && mIns[i + 1].mAddress == yreg &&
				mIns[i + 2].mType == ASMIT_ADC && mIns[i + 2].mMode == ASMIM_IMMEDIATE && mIns[i + 2].mAddress == yoffset + 1 &&
				mIns[i + 3].mType == ASMIT_STA && mIns[i + 3].mMode == ASMIM_ZERO_PAGE &&
				!(mIns[i + 3].mLive & (LIVE_CPU_REG_Y | LIVE_CPU_REG_C)))
			{
				for (int j = ypred; j < i + 3; j++)
					mIns[j].mLive |= LIVE_CPU_REG_Y;
				mIns[i + 0].mType = ASMIT_INY;
				mIns[i + 1].mType = ASMIT_STY; mIns[i + 1].mAddress = mIns[i + 3].mAddress;
				mIns[i + 2].mType = ASMIT_NOP; mIns[i + 2].mMode = ASMIM_IMPLIED;
				
				ypred = i + 1;
				yoffset++;

				if (mIns[i + 3].mLive & LIVE_CPU_REG_A)
				{
					mIns[i + 3].mType = ASMIT_TYA;
					mIns[i + 3].mMode = ASMIM_IMPLIED;
				}
				else
				{
					mIns[i + 3].mType = ASMIT_NOP; 
					mIns[i + 3].mMode = ASMIM_IMPLIED;
				}
				changed = true;
			}
			else if (i + 3 < mIns.Size() &&
				mIns[i + 0].mType == ASMIT_CLC &&
				mIns[i + 1].mType == ASMIT_LDA && mIns[i + 1].mMode == ASMIM_ZERO_PAGE && mIns[i + 1].mAddress == yreg &&
				mIns[i + 2].mType == ASMIT_ADC && mIns[i + 2].mMode == ASMIM_IMMEDIATE && mIns[i + 2].mAddress == yoffset + 2 &&
				mIns[i + 3].mType == ASMIT_STA && mIns[i + 3].mMode == ASMIM_ZERO_PAGE &&
				!(mIns[i + 3].mLive & (LIVE_CPU_REG_Y | LIVE_CPU_REG_C)))
			{
				for (int j = ypred; j < i + 3; j++)
					mIns[j].mLive |= LIVE_CPU_REG_Y;
				mIns[i + 0].mType = ASMIT_INY;
				mIns[i + 1].mType = ASMIT_INY; mIns[i + 1].mMode = ASMIM_IMPLIED;
				mIns[i + 2].mType = ASMIT_STY; mIns[i + 2].CopyMode(mIns[i + 3]);

				ypred = i + 1;
				yoffset++;

				if (mIns[i + 3].mLive & LIVE_CPU_REG_A)
				{
					mIns[i + 3].mType = ASMIT_TYA;
					mIns[i + 3].mMode = ASMIM_IMPLIED;
				}
				else
				{
					mIns[i + 3].mType = ASMIT_NOP;
					mIns[i + 3].mMode = ASMIM_IMPLIED;
				}

				changed = true;
			}
			else if (i + 1 < mIns.Size() &&
				mIns[i + 0].mType == ASMIT_INC && mIns[i + 0].mMode == ASMIM_ZERO_PAGE && mIns[i + 0].mAddress == yreg &&
				mIns[i + 1].mType == ASMIT_LDY && mIns[i + 1].mMode == ASMIM_ZERO_PAGE && mIns[i + 1].mAddress == yreg && yoffset == 0)
			{
				for (int j = ypred; j < i; j++)
					mIns[j].mLive |= LIVE_CPU_REG_Y;
				mIns[i + 0].mType = ASMIT_INY; mIns[i + 0].mMode = ASMIM_IMPLIED; mIns[i + 0].mLive |= LIVE_CPU_REG_Y;
				mIns[i + 1].mType = ASMIT_STY;

				ypred = i + 1;
				yoffset++;

				changed = true;
			}
			else if (i + 2 < mIns.Size() && full &&
				mIns[i + 0].mType == ASMIT_INC && mIns[i + 0].mMode == ASMIM_ZERO_PAGE && mIns[i + 0].mAddress == yreg &&
				mIns[i + 1].mType == ASMIT_LDA && mIns[i + 1].mMode == ASMIM_ZERO_PAGE && mIns[i + 1].mAddress == yreg && yoffset == 0 && !(mIns[i + 1].mLive & LIVE_CPU_REG_Y))
			{
				for (int j = ypred; j < i; j++)
					mIns[j].mLive |= LIVE_CPU_REG_Y;
				mIns.Insert(i, NativeCodeInstruction(mIns[i].mIns, ASMIT_INY, ASMIM_IMPLIED));
				mIns[i + 1].mType = ASMIT_STY; mIns[i + 1].mLive |= LIVE_CPU_REG_Y;
				mIns[i + 2].mType = ASMIT_TYA; mIns[i + 2].mMode = ASMIM_IMPLIED;
				yreg = -1;
				changed = true;
			}
			else if (mIns[i].mType == ASMIT_INY)
			{
				yoffset = (yoffset + 1) & 255;
			}
			else if (mIns[i].mType == ASMIT_DEY)
			{
				yoffset = (yoffset - 1) & 255;
			}
			else if (i + 1 < mIns.Size() && mIns[i].mType == ASMIT_TAY && mIns[i + 1].mType == ASMIT_STA && mIns[i + 1].mMode == ASMIM_ZERO_PAGE)
			{
				i++;
				yreg = mIns[i].mAddress;
				yoffset = 0;
				ypred = i;
			}
			else if (mIns[i].ChangesYReg())
			{
				if (full && yreg >= 0 && !mIns[i].RequiresYReg())
				{
					int j = i;
					while (j < mIns.Size() && !mIns[j].ReferencesZeroPage(yreg))
						j++;
					if (j + 2 < mIns.Size() &&
						mIns[j - 1].mType == ASMIT_CLC &&
						mIns[j + 0].mType == ASMIT_LDA && mIns[j + 0].mMode == ASMIM_ZERO_PAGE &&
						mIns[j + 1].mType == ASMIT_ADC && mIns[j + 1].mMode == ASMIM_IMMEDIATE &&
						mIns[j + 2].mType == ASMIT_STA && mIns[j + 2].mMode == ASMIM_ZERO_PAGE && mIns[j + 2].mAddress == yreg &&
						!(mIns[j + 2].mLive & LIVE_CPU_REG_C))
					{
						if (mIns[j + 1].mAddress == yoffset + 1)
						{
							for (int k = ypred; k < i; k++)
								mIns[k].mLive |= LIVE_CPU_REG_Y;

							mIns.Remove(j + 2);
							mIns.Remove(j + 1);
							mIns.Remove(j - 1);
							mIns.Insert(i, NativeCodeInstruction(mIns[i].mIns, ASMIT_INY));
							mIns.Insert(i + 1, NativeCodeInstruction(mIns[i].mIns, ASMIT_STY, ASMIM_ZERO_PAGE, yreg));
							i += 2;
							changed = true;
						}
					}
				}

				yreg = -1;
			}
			else if (mIns[i].mType == ASMIT_STY && mIns[i].mMode == ASMIM_ZERO_PAGE && mIns[i].mAddress == yreg)
			{
				yoffset = 0;
				ypred = i;
			}
#if 1
			else if (mIns[i].mType == ASMIT_INC && mIns[i].mMode == ASMIM_ZERO_PAGE && mIns[i].mAddress == yreg && yoffset == 0 && mIns[ypred].mType == ASMIT_STY && !(mIns[i].mLive & LIVE_CPU_REG_Y))
			{
				for (int j = ypred; j < i; j++)
					mIns[j].mLive |= LIVE_CPU_REG_Y;
				mIns[i].mType = ASMIT_STY;
				mIns.Insert(i, NativeCodeInstruction(mIns[i].mIns, ASMIT_INY));
				ypred = i + 1;
			}
#endif
			else if (yreg >= 0 && mIns[i].ChangesZeroPage(yreg))
			{
				yreg = -1;
			}
		}

		CheckLive();

		if (mTrueJump && mTrueJump->ForwardZpYIndex(full))
			changed = true;

		if (mFalseJump && mFalseJump->ForwardZpYIndex(full))
			changed = true;
	}

	return changed;
}

bool NativeCodeBasicBlock::CanCombineSameYtoX(int start, int end)
{
	for (int i = start; i < end; i++)
	{
		NativeCodeInstruction& ins(mIns[i]);

		if (ins.mMode == ASMIM_INDIRECT_Y)
			return false;

		if (ins.mMode == ASMIM_ABSOLUTE_Y && !HasAsmInstructionMode(ins.mType, ASMIM_ABSOLUTE_X))
			return false;
	}

	return true;
}

bool NativeCodeBasicBlock::CanCombineSameXtoY(int start, int end)
{
	for (int i = start; i < end; i++)
	{
		NativeCodeInstruction& ins(mIns[i]);

		if (ins.mMode == ASMIM_INDIRECT_X)
			return false;

		if (ins.mMode == ASMIM_ABSOLUTE_X && !HasAsmInstructionMode(ins.mType, ASMIM_ABSOLUTE_Y))
			return false;

	}

	return true;
}



bool NativeCodeBasicBlock::CombineSameXtoY(int xpos, int ypos, int end)
{
	if (xpos < ypos)
	{
		if (CanCombineSameXtoY(xpos, ypos) &&
			CanCombineSameXtoY(ypos + 1, end) &&
			!ReferencesYReg(xpos, ypos))
		{
			ReplaceXRegWithYReg(xpos, ypos);
			ReplaceXRegWithYReg(ypos + 1, end);
			if (!(mIns[ypos].mLive & LIVE_CPU_REG_Z))
			{
				mIns[ypos].mType = ASMIT_NOP;
				mIns[ypos].mMode = ASMIM_IMPLIED;
			}
			return true;
		}
	}
	else
	{
		if (CanCombineSameXtoY(xpos, end))
		{
			ReplaceXRegWithYReg(xpos, end);
			if (!(mIns[xpos].mLive & LIVE_CPU_REG_Z))
			{
				mIns[xpos].mType = ASMIT_NOP;
				mIns[xpos].mMode = ASMIM_IMPLIED;
			}
			return true;
		}
	}

	return false;
}

bool NativeCodeBasicBlock::CombineSameYtoX(int xpos, int ypos, int end)
{
	if (ypos < xpos)
	{
		if (CanCombineSameYtoX(ypos, xpos) &&
			CanCombineSameYtoX(xpos + 1, end) &&
			!ReferencesXReg(ypos, xpos))
		{
			ReplaceYRegWithXReg(ypos, xpos);
			ReplaceYRegWithXReg(xpos + 1, end);
			if (!(mIns[xpos].mLive & LIVE_CPU_REG_Z))
			{
				mIns[xpos].mType = ASMIT_NOP;
				mIns[xpos].mMode = ASMIM_IMPLIED;
			}
			return true;
		}
	}
	else
	{
		if (CanCombineSameYtoX(ypos, end))
		{
			ReplaceYRegWithXReg(ypos, end);
			if (!(mIns[ypos].mLive & LIVE_CPU_REG_Z))
			{
				mIns[ypos].mType = ASMIT_NOP;
				mIns[ypos].mMode = ASMIM_IMPLIED;
			}
			return true;
		}
	}

	return false;
}

bool NativeCodeBasicBlock::CombineSameXY(void)
{
	bool	changed = false;

	if (!mVisited)
	{
		mVisited = true;

		int	xreg = -1, yreg = -1;
		int	xpos, ypos;
		bool	samexy = false;

		CheckLive();

		for (int i = 0; i < mIns.Size(); i++)
		{
			NativeCodeInstruction& ins(mIns[i]);

			if (ins.ChangesXReg())
			{
				if (samexy)
				{
					if (!ins.RequiresXReg()