*** Library offsets for muimaster.library ***

_LVOMUI_NewObjectA = -$1E           * a0=class,a1=tags
_LVOMUI_NewObject = -$1E            *
_LVOMUI_DisposeObject = -$24        * a0=obj
_LVOMUI_RequestA = -$2A             * d0=app,d1=win,d2=flags,a0=title,
		                      *   a1=gadgets,a2=format,a3=params
_LVOMUI_Request = -$2A              *
_LVOMUI_AllocAslRequest = -$30      * d0=type,a0=tags
_LVOMUI_AllocAslRequestTags = -$30  *
_LVOMUI_AslRequest = -$36           * a0=req,a1=tags
_LVOMUI_AslRequestTags = -$36       *
_LVOMUI_FreeAslRequest = -$3C       * a0=req
_LVOMUI_Error = -$42                *
_LVOMUI_SetError = -$48             * d0=errnum
_LVOMUI_GetClass = -$4E             * a0=name
_LVOMUI_FreeClass = -$54            * a0=cl
_LVOMUI_RequestIDCMP = -$5A         * a0=obj,d0=flags
_LVOMUI_RejectIDCMP = -$60          * a0=obj,d0=flags
_LVOMUI_Redraw = -$66               * a0=obj,d0=flags
_LVOMUI_CreateCustom = -$6C         * a0=base,a1=supername,a2=supermcc,
                                      * d0=datasize,a3=dispatcher
_LVOMUI_DeleteCustom = -$72         * a0=mcc
_LVOMUI_MakeObjectA = -$78          * d0=type,a0=params
