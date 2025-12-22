/*!
 *  @addtogroup <sps>
 *  @{ pointdesign DOT com
 *
 *  Copyright (c) 2006 Jürgen Schober
 *  This code herein is freeware and provided AS IS.
 *  Use at your own risk. No waranty!
 */

/*!
 *  @file sps_hook.h
 *
 *  Hooks as objects.
 * 
 *  SPS_Hook provide a OOP way of createing AmigaOS hooks. Instead
 *  of filling your entry point manually, a SPS_Hook object provides a 
 *  
 *  virtual int32 OnEntry(APTR object, APTR message) = 0;
 * 
 *  function call which you hook implementation might overload.
 *  
 *  A SPS_Hook is not directly derived from a struct Hook! The virtual
 *  function makes this impossible. However, a casting operator is 
 *  available which allows you to cast an SPS_Hook into a struct Hook
 *  which you can provide to any function which requires an AmigaOS hook
 *  structure. Additionally, GetHook() method provides the same functionality.
 * 
 *  @author Jürgen Schober
 *
 *  @date
 *      - 08/21/2006 initial
 *
 *  @changes
 *      - 08/21/2006 -js-
 */
#ifndef SPS_HOOK_H_
#define SPS_HOOK_H_

#include <exec/types.h>
#include <utility/hooks.h>

class SPS_Hook
{
private:
    struct Hook m_Hook;

	/*! static generic hook entry function */
	static int32 sHookEntry(struct Hook* hook, APTR object, APTR message);

public:
    /*! c'tor. Inits the hook and attaches the static entry function + this pointer to it */
	SPS_Hook();
    virtual ~SPS_Hook() {}

    operator const struct Hook*() const {
        return &m_Hook;
    }
    operator struct Hook*() {
        return &m_Hook;
    }

    const struct Hook* GetHook( ) const {
        return &m_Hook;
    }
    struct Hook* GetHook() {
        return &m_Hook;
    }

protected:
	/*! This is your virtual hook function call. Derive and implement at will. */
	virtual int32 OnEntry(APTR object, APTR message) = 0;

};

#endif /* SPS_HOOK_H_ */

/*! @} sps */


