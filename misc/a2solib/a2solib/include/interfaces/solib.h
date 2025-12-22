#ifndef INTERFACES_SOLIB_H_
#define INTERFACES_SOLIB_H_

#include <exec/types.h>
#include <exec/exec.h>
#include <exec/interfaces.h>

#include <solib.h>

struct SolibSymIFace
{
		struct InterfaceData Data;

		uint32 APICALL (*Obtain)(struct SolibSymIFace *Self);
		uint32 APICALL (*Release)(struct SolibSymIFace *Self);
		void APICALL (*Expunge)(struct SolibSymIFace *Self);
		struct Interface * APICALL (*Clone)(struct SolibSymIFace *Self);
		void * APICALL (*GetSymbol)(struct SolibSymIFace *Self, char *symbol, 
			uint32 flags);
		void APICALL (*DoCtors)(struct SolibSymIFace *Self);
		void APICALL (*DoDtors)(struct SolibSymIFace *Self);
};

struct SolibMainIFace
{
		struct InterfaceData Data;

		uint32 APICALL (*Obtain)(struct SolibMainIFace *Self);
		uint32 APICALL (*Release)(struct SolibMainIFace *Self);
		void APICALL (*Expunge)(struct SolibMainIFace *Self);
		struct Interface * APICALL (*Clone)(struct SolibMainIFace *Self);
		struct SolibSymIFace * APICALL (*GetInterface)(struct SolibMainIFace *Self, 
			struct SolibContext *ctx);
		void APICALL (*DropInterface)(struct SolibMainIFace *Self, 
			struct SolibSymIFace *other);
};

#endif
