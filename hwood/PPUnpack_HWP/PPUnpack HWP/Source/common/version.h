#define PLUGIN_VER 1
#define PLUGIN_REV 0
#define PLUGIN_VER_STR "1.0"

#if defined(HW_AMIGAOS3)
#define PLUGIN_PLAT "AmigaOS3"
#define PLUGIN_ARCH HWARCH_OS3
#elif defined(HW_WARPOS)
#define PLUGIN_PLAT "WarpOS"
#define PLUGIN_ARCH HWARCH_WOS
#elif defined(HW_AMIGAOS4)
#define PLUGIN_PLAT "AmigaOS4"
#define PLUGIN_ARCH HWARCH_OS4
#elif defined(HW_MORPHOS)
#define PLUGIN_PLAT "MorphOS"
#define PLUGIN_ARCH HWARCH_MOS
#elif defined(HW_AROS)
#define PLUGIN_PLAT "AROS"
#define PLUGIN_ARCH HWARCH_AROS
#elif defined(HW_WIN32)
#define PLUGIN_PLAT "Win32"
#define PLUGIN_ARCH HWARCH_WIN32
#elif defined(HW_MACOS)
#define PLUGIN_PLAT "MacOS"
#define PLUGIN_ARCH HWARCH_MACOS
#elif defined(HW_LINUX)
#define PLUGIN_PLAT "Linux"
#define PLUGIN_ARCH HWARCH_LINUX
#endif

#define PLUGIN_NAME "PowerPacker unpacker"
#define PLUGIN_MODULENAME "ppunpack"
#define PLUGIN_AUTHOR "Lazi"
#define PLUGIN_DESCRIPTION "A simple plugin that reads PowerPacked files into Hollywood"
#define PLUGIN_COPYRIGHT "Freeware"
#define PLUGIN_URL ""
#define PLUGIN_DATE "08.01.14"

