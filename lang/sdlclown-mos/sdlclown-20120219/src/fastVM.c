/*
 * Modified SDLclown VM,
 * meant to be faster.
 *
 * No dynamic typing, but rather
 * good old "everything is a float".
 */

#include "Clown_HEADERS.h"
#include <assert.h>
#include <math.h>

/* storage for clown program variables */
clown_float_t* VirtualMachineMemory = NULL;

int fastVM_Run()
{
    /* program counter */
    clown_int_t address;

    /* have we found a legal opcode ? */
    int found;

    /* temporary storage for opcode interpreters */
    char buf[1024];
    clown_int_t data2, data3, data4, data5, data6, data7;
    clown_int_t data, data8, data9, data10, data11;
    clown_float_t f1;
    clown_int_t temp_int;

    int gm_counter = GM_INTERVAL;

    setCursor(0);

    while (1)
    {
        found=0;

        data = programFile_readInt();
        address = getCursor();

        /* Call SDL-based events manager at fixed frequency */
        if(!(gm_counter--))
        {
            gm_counter = GM_INTERVAL;
        }
        else
        {
            if(GMManageEvents())      /* Returns true on quit event */
                break;
        }

        /* Initialize temporary variables */
        data2 =
        data3 =
        data4 =
        data5 =
        data6 =
        data7 = 
        data8 =
        data9 =
        data10 =
        data11 = 0;

	switch(data)
	{

	case 10:
        {
	    /* Arithmetic */
            data2=programFile_readInt();  /* address */
            data3=programFile_readInt();  /* operation code */
            data4=programFile_readInt();  /* operand type code */
            f1 = programFile_readFloat(); /* operand */

            switch(data4)
	    {

            case 1:
            {
                if(data3 == 90 || data3 >= 160)
                    data5 = (int)f1;

                if (data3==10)
                    VirtualMachineMemory[ManageDAE(data2)] = f1;
                else if (data3==20)
                    VirtualMachineMemory[ManageDAE(data2)] += f1;
                else if (data3==30)
                    VirtualMachineMemory[ManageDAE(data2)] -= f1;
                else if (data3==40)
                    VirtualMachineMemory[ManageDAE(data2)] *= f1;
                else if (data3==50)
                    VirtualMachineMemory[ManageDAE(data2)] /= f1;
                else if (data3==90)
		{
                    temp_int = (int)VirtualMachineMemory[ManageDAE(data2)] % data5;
                    VirtualMachineMemory[ManageDAE(data2)] = (clown_float_t)temp_int;
                }
                else if (data3==100)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]==f1);
                else if (data3==110)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]!=f1);
                else if (data3==120)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]>=f1);
                else if (data3==130)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]<=f1);
                else if (data3==140)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]>f1);
                else if (data3==150)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]<f1);
                else if(data3==160)
                {
                    temp_int = (int)VirtualMachineMemory[ManageDAE(data2)] & data5;
                    VirtualMachineMemory[ManageDAE(data2)] = (clown_float_t)temp_int;
                }
                else if(data3==170)
                {
                    temp_int = (int)VirtualMachineMemory[ManageDAE(data2)] | data5;
                    VirtualMachineMemory[ManageDAE(data2)] = (clown_float_t)temp_int;
                }
            }
	    break;

            default:
            {
                f1 = VirtualMachineMemory[ManageDAE((int)f1)];

                if(data3 == 90 || data3 >= 160)
                    data5 = (int)f1;

                if (data3==10)
                    VirtualMachineMemory[ManageDAE(data2)] = f1;
                else if (data3==20)
                    VirtualMachineMemory[ManageDAE(data2)] += f1;
                else if (data3==30)
                    VirtualMachineMemory[ManageDAE(data2)] -= f1;
                else if (data3==40)
                    VirtualMachineMemory[ManageDAE(data2)] *= f1;
                else if (data3==50)
                    VirtualMachineMemory[ManageDAE(data2)] /= f1;
                else if (data3==90)
                {
                    temp_int = (int)VirtualMachineMemory[ManageDAE(data2)] % data5;
                    VirtualMachineMemory[ManageDAE(data2)] = (clown_float_t)temp_int;
                }
                else if (data3==100)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]==f1);
                else if (data3==110)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]!=f1);
                else if (data3==120)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]>=f1);
		else if (data3==130)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]<=f1);
                else if (data3==140)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]>f1);
                else if (data3==150)
                    VirtualMachineMemory[ManageDAE(data2)] = (VirtualMachineMemory[ManageDAE(data2)]<f1);
                else if(data3==160)
                {
                    temp_int = (int)VirtualMachineMemory[ManageDAE(data2)] & data5;
                    VirtualMachineMemory[ManageDAE(data2)] = (clown_float_t)temp_int;
                }
                else if(data3==170)
                {
                    temp_int = (int)VirtualMachineMemory[ManageDAE(data2)] | data5;
                    VirtualMachineMemory[ManageDAE(data2)] = (clown_float_t)temp_int;
                }
            }
	    break;
	    }

        }
	break;

	case 12:
        {
            /* PtrTo (store program counter) */
            data2 = ManageDAE(programFile_readInt());
            VirtualMachineMemory[data2] = getCursor();
        }
	break;

	case 13:
        {
            /* PtrFrom (branch by setting program counter) */
            setCursor(VirtualMachineMemory[ManageDAE(programFile_readInt())]);
        }
	break;

	case 14:
        {
            /* BoolDie (end program if boolean is false) */
            if (!VirtualMachineMemory[ManageDAE(programFile_readInt())])
		goto stop_vm;
        }
	break;

	case 35:
        {
            /* zbPtrTo (conditional branching) */
            data2=programFile_readInt(); /* variable address */
            data3=programFile_readInt(); /* maximum */
            data4=programFile_readInt(); /* jump size address */

            if (VirtualMachineMemory[ManageDAE(data2)]>data3)
                setCursor(getCursor()+VirtualMachineMemory[ManageDAE(data4)]);
        }
	break;

	case 40:
        {
            /* operate square root */
            data2 = programFile_readInt();	/* concerned address */
            VirtualMachineMemory[ManageDAE(data2)] = sqrt(VirtualMachineMemory[ManageDAE(data2)]);
        }
	break;

	case 41:
        {
            /* operate cosine */
            data2 = programFile_readInt();	/* concerned address */
            VirtualMachineMemory[ManageDAE(data2)] = cos(VirtualMachineMemory[ManageDAE(data2)]);
        }
	break;

	case 42:
        {
            /* operate sine */
            data2 = programFile_readInt();	/* concerned address */
            VirtualMachineMemory[ManageDAE(data2)] = sin(VirtualMachineMemory[ManageDAE(data2)]);
        }
	break;

	case 43:
        {
            /* operate tangent */
            data2 = programFile_readInt();	/* concerned address */
            VirtualMachineMemory[ManageDAE(data2)] = tan(VirtualMachineMemory[ManageDAE(data2)]);
        }
	break;

	case 44:
        {
            /* unary not */
            data2 = programFile_readInt();      /* concerned address */
            VirtualMachineMemory[ManageDAE(data2)] = !(VirtualMachineMemory[ManageDAE(data2)]);
        }
	break;

	case 45:
        {
            /* unary minus */
            data2 = programFile_readInt();      /* concerned address */
            VirtualMachineMemory[ManageDAE(data2)] = -VirtualMachineMemory[ManageDAE(data2)];
        }
	break;
	
	case 46:
        {
            /* floor function */
            data2 = programFile_readInt();      /* concerned address */
            VirtualMachineMemory[ManageDAE(data2)] = floor(VirtualMachineMemory[ManageDAE(data2)]);
        }
	break;

	case 11:
        {
            /* Output variable's value */  
            f1 = VirtualMachineMemory[ManageDAE(programFile_readInt())];
            sprintf(buf, "%f", f1);
            neat_print(buf);
        }
	break;

	case 150:
        {
            putchar(programFile_readInt());
        }
	break;

	case 151:
        {
            printf("\n");
        }
	break;

	case 152:
        {
            /* ClownSystem - InputInt */
            data2 = ManageDAE(programFile_readInt());

            while(1)
            {
                scanf("%s", buf);

                if(stringRepresentsNumeral(buf)==AUTO_INT || stringRepresentsNumeral(buf)==AUTO_FLOAT)
                {
                    VirtualMachineMemory[data2] = (clown_float_t)char2float(buf);
                    break;
                }

                printf("? ");
            }
        }
	break;

	case 255:
        {
            /* End-of-program indicator */
            goto stop_vm;
        }
	break;

        /* ------------------------------- start SDLClown extensions ---------------------- */

	case 70:
        {
            /* FlipVideo */
            FlipVideo();
        }
	break;

	case 71:
        {
            /* GetMouseX */
            data2 = programFile_readInt();    /* address */
            VirtualMachineMemory[ManageDAE(data2)] = GetMouseX();
        }
	break;

	case 72:
        {
            /* GetMouseY */
            data2 = programFile_readInt();    /* address */
            VirtualMachineMemory[ManageDAE(data2)] = GetMouseY();
        }
	break;
	
	case 73:
        {
            /* DrawRect */

            data2=programFile_readInt(); /* x */
            data3=programFile_readInt(); /* y */
            data4=programFile_readInt(); /* w */
            data5=programFile_readInt(); /* h */
            data6=programFile_readInt(); /* r */
            data7=programFile_readInt(); /* g */
            data8=programFile_readInt(); /* b */

            GMDrawRect(VirtualMachineMemory[ManageDAE(data2)], VirtualMachineMemory[ManageDAE(data3)],
                       VirtualMachineMemory[ManageDAE(data4)], VirtualMachineMemory[ManageDAE(data5)],
                       VirtualMachineMemory[ManageDAE(data6)], VirtualMachineMemory[ManageDAE(data7)],
                       VirtualMachineMemory[ManageDAE(data8)]);
        }
	break;

	case 74:
        {
            /* LimitFPS */
            data2 = programFile_readInt();    /* address */
            LimitFPS(VirtualMachineMemory[ManageDAE(data2)]);
        }
	break;

        /* ------------------------------- end SDLClown extensions ---------------------- */

	default:
	{
            address=getCursor();
            printf("Runtime error: illegal instruction %d at address %d\n", (int)data, (int)address);
            goto stop_vm;
        }
	break;
    }
    }

    stop_vm:

    freeProgram();

    return 0;
}

void fastVM_InitializeMemory(void)
{
    int i;

    VirtualMachineMemory = (clown_float_t *)malloc(MEMORY_QTY * sizeof(clown_float_t));

    assert(VirtualMachineMemory != NULL);

    for(i = 0; i< MEMORY_QTY; i++)
        VirtualMachineMemory[i] = 0;
}


void fastVM_CleanupMemory(void)
{
    free(VirtualMachineMemory);
}

int ManageDAE(int data)
{
    int i;
    if (data<=-100)
    {
        i = DAE_GetAbsoluteIndex(data)+VirtualMachineMemory[DAE_GetIndirectValue(data)];
        if (i>=254)
            i+=2;

        if(i<0 || i>MEMORY_QTY)
        {
            return 0;	/* clown behavior */
        }


        return i;
    }
    else
    {
        return data;
    }
}


