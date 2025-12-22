/* Prototypes for vmem.library support routines	*/
/* Link with vmemsupport.o */

/* Init and exit calls */
extern void OpenVMem(void);	/* Open vmem.library, CALL FIRST	*/
extern void CloseVMem(void);	/* Close vmem.library, CALL BEFORE EXIT	*/

/* These are emulation calls which are safe even if vmem.library */
/* is not present 						 */
/* Read autodocs for more information about the associated calls */

/* Allocation and free calls */				    /* Emulates:  */
extern APTR VAllocMem(ULONG size, ULONG reqs, ULONG flags); /* VMAllocMem */
extern void VFreeMem(APTR mem, ULONG size);		    /* VMFreeMem  */
extern APTR VAllocVec(ULONG size, ULONG reqs, ULONG flags); /* VMAllocVec */
extern void VFreeVec(APTR mem);				    /* VMFreeVec  */

/* Get information calls */
extern ULONG VAvailMem(ULONG reqs, ULONG flags);	 /* VMAvailMem    */
extern BOOL  VTypeOfMem(APTR addr);			 /* VMTypeOfMem   */
extern ULONG VGetPageSize(void);			 /* VMGetPageSize */

