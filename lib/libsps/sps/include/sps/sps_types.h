/*!
 *  @add libSPS++
 *  @{ 
 *
 *  Copyright (c) 2006 Jürgen Schober, pointdesign DOT com
 *  This code herein is freeware and provided AS IS.
 *  Use at your own risk. No waranty!
 *  Please read the license.txt
 */
/*!
 *  @file sps_types.h
 *
 *  @brief Datastructures and types used by the libsps++.a
 * 
 *  Common macros provided herein:
 * 
 *  OPEN_IFACE()/CLOSE_IFACE():
 *      - open and close an AmigaOS4 interface. An interface and library base<br>
 *        must be defined prior to call this macro. The interface and the<br>
 *        library base must have the same name (e.g. Utility share IUtility and<br>
 *        UtilityBase, only 'Utility' is provided as a parameter.
 *      - exception handling is performed if _NO_EXCEPTIONS is not #defined prior
 *        the 'include' of this file. If enabled, openlib/openiface errors 
 *        are cought thru SPS_Exceptions
 * 
 *  _D() and _D2():
 *      - Serial debug messages (_DEBUG and _NDEBUG mode).   
 *  
 *  @author Jürgen Schober
 *
 *  @date
 *      - 08/21/2006 initial
 *      - 08/21/2006 -js-
 *          - Update doxygen docomentation
 */
#ifndef SPS_TYPES_H_
#define SPS_TYPES_H_

/*! Debug output macros */
#ifndef _NDEBUG
#ifndef _D
#define _D IExec->DebugPrintF
#endif
#ifndef _D2
#define _D2( a ) IExec->DebugPrintF( "%s::%d: %s\n", __FILE__, __LINE__, a )
#endif
#else
#ifndef _D
#define _D
#endif
#ifndef _D2
#define _D2( a )
#endif
#endif 

/*! OPEN_IFACE macro
 *
 *  A macro to open an interface and a library. The application must
 *  take care of the storage of the interface and library.
 *
 *  OPEN_IFACE can handle errors thru SPS_Exception. If you do not want to
 *  enable exceptions, you can define _NO_EXCEPTIONS before you include this
 *  file or in the makefile.
 *
 *  @param name A macro name, both, the interface and the library share,
 *              e.g. Intuition for I<B>Intuition</B> and </B>Intuition</B>Base
 */
#ifndef OPEN_IFACE
#ifndef _NO_EXCEPTIONS
#define OPEN_IFACE( name, file, version ) \
        name##Base = reinterpret_cast<struct Library*>(IExec->OpenLibrary( file, version ));         \
        if ( !name##Base ) {                                                                         \
            throw SPS_Exception( __FILE__, __LINE__, ERR_OPEN_LIB, file );                           \
        }                                                                                            \
        I##name = reinterpret_cast<struct name##IFace*>(IExec->GetInterface( name##Base, "main", 1, NULL )); \
        if ( !I##name ) {                                                                            \
            throw SPS_Exception( __FILE__, __LINE__, ERR_OPEN_IFACE, file );                         \
        }
#else // _NO_EXCEPTIONS

#define OPEN_IFACE( name, file, version ) \
        name##Base = reinterpret_cast<struct Library*>(IExec->OpenLibrary( file, version ));         \
        if ( name##Base ) {                                                                          \
            I##name = reinterpret_cast<struct name##IFace*>(IExec->GetInterface( name##Base, "main", 1, NULL )); \
        }
#endif
#endif

/*! COSE_IFACE
 *  This macro closes a library and drops an interface.
 *
 *  @param name A macro name, both, the interface and the library share,
 *              e.g. Intuition for I<B>Intuition</B> and </B>Intuition</B>Base
 */
#ifndef CLOSE_IFACE
#define CLOSE_IFACE( name ) \
        if ( I##name ) {                                                                            \
            IExec->DropInterface( reinterpret_cast<struct Interface*>( I##name ));                  \
            I##name = NULL;                                                                         \
        }                                                                                           \
        if ( name##Base ) {                                                                         \
            IExec->CloseLibrary( reinterpret_cast<struct Library*>(name##Base));                    \
            name##Base = NULL;                                                                      \
        }
#endif

#endif /*SPS_TYPES_H_*/
