
You can put stuff here.

Class ( MyClass :: MUIC_Area ) : 0x12340000


Note that whitespace is ignored between tokens.

/* Some comment on the class, if you like. */

#include <any files you need>

This can be anything at all, it will simply be passed through. Well, unless it
contains a "Data" in the appropriate context. :-)

Data ( struct instancedata )

struct {
		long a;
		long b;
} instancedata;

Method ( OM_NEW )
{
		some stuff  {
			some more stuff
		}
}

	Method(MUIM_MyClass_Test)
	{
		testing...
	}

Method (MUIM_AskMinMax)
{
	minmax stuff
}

Method (MUIM_Setup)
{
	setup
}

Method (MUIM_Cleanup)
{
	cleanup
}

Method (OM_DISPOSE)
{
	dispose
}

Method (MUIM_Draw)
{
	draw stuff
}

Method*(MUIM_MyClass):public
{
	struct instancedata *data = GetData();

	do things manually for this method

	return (Super());
}

/*
Method(MUIM_MyClass_Commented)
{
	This will be ignored.
	/* Comments can also nest. */
}
*/

// Method(MUIM_MyClass_C++Commented)
// {
//      This will be ignored, too.
// }

Method  ( OM_GET  )
{
	Attributes
	{
		MUIA_MyClass_TestAttribute:public
		{
			*store = data->a;
		}

		MUIA_MyClass_TestSmallAtt*:public
		{
			*store = data->b;

			return (TRUE);
		}

		MUIA_MyClass_TestPrivAtt
		{
			*store = data->b;
		}
	}
}

Method(OM_SET)
{
	Attributes
	{
		MUIA_MyClass_TestPrivAtt
		{
			b = tag->ti_Data;
		}
		MUIA_MyClass_TestAttribute:public
		{
			a = tag->ti_Data;
		}
	}
}
