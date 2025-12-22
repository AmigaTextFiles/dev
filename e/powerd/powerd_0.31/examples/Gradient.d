// gradientslider in D!

OPT	NOSTD

MODULE	'intuition/intuition',
			'intuition/gadgetclass',
			'intuition/icclass',
			'gadgets/gradientslider',
			'utility/tagitem'

DEF	w:PTR TO Window,grad:PTR TO Gadget,GradBase

PROC main()
	IF w:=OpenWindowTags(NIL,
			WA_Flags,$E,
			WA_IDCMP,$268,
			WA_Width,400,
			WA_Height,80,
			WA_Title,'Gradients in E!',
			TAG_END)
		IF GradBase:=OpenLibrary('gadgets/gradientslider.gadget',39)
			IF grad:=NewObject(NIL,'gradientslider.gadget',
					GA_Top,20,
					GA_Left,20,
					GA_Width,350,
					GA_Height,30,
					GA_ID,1,
					GRAD_PenArray,[0,7,-1]:WORD,
					GRAD_KnobPixels,20,
					TAG_END)
				AddGList(w,grad,-1,-1,NIL)
				RefreshGList(grad,w,NIL,-1)
				WaitPort(w.UserPort)
				RemoveGList(w,grad,-1)
				DisposeObject(grad)
			ELSE
				PrintF('Could not create GradientSlider!\n')
			ENDIF
			CloseLibrary(GradBase)
		ELSE
			PrintF('Could not open "gradientslider.gadget"\n')
		ENDIF
		CloseWindow(w)
	ELSE
		PrintF('No Window!\n')
	ENDIF
ENDPROC
