Class (Number::MUIC_Text):0x165ff000

/*************************
** Custom Class: Number **
**************************
** Number is a subclass of MUIC_Text that adds two new attributes:
** MUIA_Number_Contents [.SG]: takes a pointer to a double precision floating point number.
**      This number will then be displayed by the object. If you get() this attribute,
**      you must supply the address of a pointer to double.
** MUIA_Number_Digits [.SG]  : the number of decimal places used to display the number.
*/

#include <libraries/mui.h>

#include <proto/exec.h>
#include <proto/muimaster.h>
#include <proto/utility.h>

#include <stdio.h>
#include <math.h>

Data (struct NumberData)

struct NumberData
{
	double last,diff;
	char digits;
};

Method(OM_NEW)
{
	data->last = 0.0;
	data->digits = 2;
	data->diff = pow(10.0, (double) -data->digits);
}

Method(OM_SET)
{
	static char buf[16];
	double this;

	Attributes
	{
		MUIA_Number_Contents*:public
		{
			this = *((double *) tag->ti_Data);

			if (fabs(data->last - this) >= data->diff){
				sprintf(buf, MUIX_R"%.*lf", data->digits, this);
				set(obj, MUIA_Text_Contents, buf);

				data->last = this;
			}
		}

		MUIA_Number_Digits:public
		{
			data->digits = (char) tag->ti_Data;
			data->diff = pow(10.0, (double) -data->digits);
		}
	}
}


Method(OM_GET)
{
	Attributes
	{
		MUIA_Number_Contents:public
		{
			*store = (ULONG) &(data->last);
		}

		MUIA_Number_Digits:public
		{
			*store = (ULONG) data->last;
		}
	}
}
