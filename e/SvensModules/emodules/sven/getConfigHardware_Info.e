/* Returns system datas as strings.
** Uses getConfigHardware, therefore you must initialize it via
** initConfigHardware()
*/

OPT PREPROCESS
OPT MODULE

MODULE 'sven/getRelatedListValue',
       'sven/getConfigHardware'


EXPORT PROC getProcessorDescription() IS
  getRelatedListValue(getProcessorType(),[MC_None,MC68000,MC68010,MC68020,MC68030,MC68040,MC68060],
                                         ['Unknown','68000','68010','68020','68030','68040','68060'])

EXPORT PROC getFPUDescription() IS
  getRelatedListValue(getFPUType(),[FPU_None,FPU_MC68881,FPU_MC68882,FPU_040,FPU_060],
                                   ['None','68881','68882','040 FPU','060 FPU'])

EXPORT PROC getChipSetDescription() IS
  getRelatedListValue(getChipSet(),[GFX_None,GFX_Standard,GFX_ECS,GFX_AGA],
                                   ['Unknown','OCS','ECS','AGA'])


