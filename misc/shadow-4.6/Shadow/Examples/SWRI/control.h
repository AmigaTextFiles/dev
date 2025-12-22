/*
 * SWRI controller Program -- the header.
 *
 * å© Copyright 1991, ALl Rights Reserved
 *
 *  David C. Navas
 */
#include <shadow/coreMeta.h>
#include <shadow/coreRoot.h>
#include <shadow/process.h>


/*
 * the process name
 */
#define SWRINDE_CONTROL_PROGRAM "SWRI Control Program\0"

/*
 * for the class
 */
#define SWRINDE_DATA_CLASS "SWRI NDE data table Class"

#define ATTR_SWRINDE_DATA "256 block data\0"


/*
 * for the cluster.
 */
#define SWRINDE_CONTROL_CLUSTER "SWRI NDE Control Cluster\0"

#define METHOD_SWRINDECONTROLCLUSTER_COMPUTE "Computation method for SWRINDE Control"

/*
 * The control window class
 */

#define CONTROLWINCLASS "Window class that controls SWRI NDE"

/*
 * define all of our gui class names, so that they can be distinct from
 * the default names, which browser uses.
 */
#define GUIPROCESSCLASS "swri gui process class\0"
#define GUITASK "SWRI's Gui Task"
#define GUICLASS        "swri gui class\0"
#define WINDOWCLASS     "swri Window Class"
#define GADGTCLASS    "swri Gadget GadTool Class"
