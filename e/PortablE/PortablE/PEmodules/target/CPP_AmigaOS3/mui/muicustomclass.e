OPT INLINE, NATIVE
MODULE 'muimaster', 'exec/libraries', 'exec/types', 'intuition/classes', 'intuition/classusr'
MODULE 'target/amigalib', 'utility/hooks'
{
class data_muicustomclass: public object {
public:
	long  user;          // for userdata (use iclass.userdata[] instead of iclass.userdata)
	void* dispfunc;      // holds the address of the dispatcher-function
};

long dispentry_muicustomclass(struct IClass* iclass, Object* object2, struct _Msg* message)  {
	long methodid;
	data_muicustomclass* data2=NULL;
	
	data2 = (data_muicustomclass*) iclass->cl_UserData ;
	methodid = ((long (*)(struct IClass*,Object*,struct _Msg*))data2->dispfunc )(iclass, object2, message);
	return methodid ;
} 

struct MUI_CustomClass* eMUI_CreateCustomClass(struct Library* base, char* supername, struct MUI_CustomClass* supermcc, long datasize, void* dispfunc)  {
	struct MUI_CustomClass* mcc=NULL;
	struct IClass* iclass=NULL; data_muicustomclass* data2=NULL;
	data_muicustomclass* temp_PTR_TO_data=NULL; long temp_QUAD;
try {
	temp_QUAD = exception ;
	exception = 0 ;
	
	data2 = new data_muicustomclass;
	data2->user     = 0;
	data2->dispfunc = dispfunc;
	
	mcc = MUI_CreateCustomClass(base ,supername ,supermcc , (int) datasize ,(APTR) (long) (void*) &HookEntry  );
	if( (void*) mcc == NULL ) { goto finally;}
	
	iclass = mcc->mcc_Class;
	temp_PTR_TO_data = data2;
	data2= (data_muicustomclass*) NULL;
	iclass->cl_UserData = (ULONG) (long) temp_PTR_TO_data ;
	
	//bad hack starts here!
	iclass->cl_Dispatcher.h_Entry    = (ULONG (*)()) (long) (void*) &HookEntry;
	iclass->cl_Dispatcher.h_SubEntry = (ULONG (*)()) (long) (void*) &dispentry_muicustomclass;
finally: 0; 
} catch(...) {}
	delete data2; data2=NULL; 
	if (exception!=0) {throw eException;} else {EMPTY;};
	exception = temp_QUAD ;
	return mcc ;
} 
}
NATIVE {data_muicustomclass} OBJECT
NATIVE {dispentry_muicustomclass} PROC
NATIVE {eMUI_CreateCustomClass} PROC

PROC eMui_CreateCustomClass(base:PTR TO lib, supername:ARRAY OF CHAR, supermcc:PTR TO mui_customclass, datasize:VALUE, dispfunc:PTR) IS NATIVE {eMUI_CreateCustomClass(} base {,} supername {,} supermcc {,} datasize {,} dispfunc {)} ENDNATIVE !!PTR TO mui_customclass
