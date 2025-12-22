#
# 'qdev'
# by Burnt Chip Dominators
#

SUP_C2P2CPATH = ../supp/sup_c2p2c

SUP_C2P2COBJS = ChunkyToPlanarAsm.o \
                PlanarToChunkyAsm.o
SUP_C2P2COBJSB = $(addsuffix b,$(SUP_C2P2COBJS))
SUP_C2P2COBJSB32 = $(addsuffix b32,$(SUP_C2P2COBJS))

SUPPOBJECTS = $(addprefix $(SUP_C2P2CPATH)/,$(SUP_C2P2COBJS))
SUPPOBJECTSB = $(addprefix $(SUP_C2P2CPATH)/,$(SUP_C2P2COBJSB))
SUPPOBJECTSB32 = $(addprefix $(SUP_C2P2CPATH)/,$(SUP_C2P2COBJSB32))



SUP_LBSPATH = ../supp/sup_localbase

SUP_LBSCOBJSB = $(addsuffix b,$(SUP_LBSCOBJS))
SUP_LBSCOBJSB32 = $(addsuffix b32,$(SUP_LBSCOBJS))

SUPPOBJECTS += $(addprefix $(SUP_LBSPATH)/,$(SUP_LBSCOBJS))
SUPPOBJECTSB += $(addprefix $(SUP_LBSPATH)/,$(SUP_LBSCOBJSB))
SUPPOBJECTSB32 += $(addprefix $(SUP_LBSPATH)/,$(SUP_LBSCOBJSB32))
