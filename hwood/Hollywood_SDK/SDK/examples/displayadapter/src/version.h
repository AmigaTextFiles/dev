/*
** SDL display adapter Hollywood plugin
** Copyright (C) 2014-2017 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included in
** all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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
#define PLUGIN_PLAT "Windows"
#define PLUGIN_ARCH HWARCH_WIN32
#elif defined(HW_MACOS)
#define PLUGIN_PLAT "MacOS"
#define PLUGIN_ARCH HWARCH_MACOS
#elif defined(HW_LINUX)
#define PLUGIN_PLAT "Linux"
#define PLUGIN_ARCH HWARCH_LINUX
#elif defined(HW_ANDROID)
#define PLUGIN_PLAT "Android"
#define PLUGIN_ARCH HWARCH_ANDROID
#elif defined(HW_IOS)
#define PLUGIN_PLAT "iOS"
#define PLUGIN_ARCH HWARCH_IOS
#endif

#define PLUGIN_NAME "Display adapter"
#define PLUGIN_MODULENAME "displayadapter"
#define PLUGIN_AUTHOR "Andreas Falkenhahn"
#define PLUGIN_DESCRIPTION "Demonstrates how to use the display adapter interface"
#define PLUGIN_COPYRIGHT "Freeware"
#define PLUGIN_URL ""
#define PLUGIN_DATE "13.09.17"
