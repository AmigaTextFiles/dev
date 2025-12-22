#
# File:     gcc.py
#
# Author:   Guillaume ROGUEZ <yomgui1@gmail.com>
# Creation date:            2005/06/16
# Last modification date:   2005/06/17
#

from Boa.Defaults import DefaultEnv
from Boa.Utils import get_obj, execute, join_opts

__all__ = ( 'defaults', 'compile', 'link' )

defaults = {'CC': 'ppc-morphos-gcc',
            'CCLINK': 'ppc-morphos-g++',
            'CXX': 'ppc-morphos-g++',
            'CFLAGS': '-Wall',
            'LFLAGS': '',
            'LIBS': [],
            'SHARED_LFLAGS': '-nostartfiles',
            'AR': 'ppc-morphos-ar',
            'ARFLAGS': 'cru',
            'RANLIB': 'ppc-morphos-ranlib' }

def compile(target, source,
            cflags='',
            includes=(),
            env=DefaultEnv()):

    cmd = '%s -c %s %s -o %s %s' % (env['CC'], cflags, ' '.join('-I'+n for n in includes), target, source)
    if env['quiet']:
        cmd += '>NIL:'
 
    env['log'](target, pre="Compile '", post="'")
    if env['verbose']:
        print cmd + '\n'
    
    return execute(cmd, env['dryrun'], env['quiet'])

def link(target, objs,
         lflags=None,
         libs=(),
         ranlib=False,
         env=DefaultEnv()):

    if hasattr(objs, '__getitem__'):
        objs = ' '.join(objs)

    if not objs: return
        
    cmd = '%s %s %s %s -o %s' % (env['CCLINK'], objs, lflags, ' '.join('-l'+n for n in libs), target)
    if env['quiet']:
        cmd += '>NIL:'

    env['log'](target, pre="Link '", post="'")
    if env['verbose']:
        print cmd + '\n'

    r = execute(cmd, env['dryrun'], env['quiet'])
    if ranlib and not r:
        cmd = '%s %s' % (env['RANLIB'], target)
        if env['quiet']:
            cmd += '>NIL:'
        
        env['log'](target, pre="Link '", post="'")
        if env['verbose']:
            print cmd + '\n'
        
        r = execute(cmd, env['dryrun'], env['quiet'])
    return r

def ar(target, objs, env=DefaultEnv()):

    if hasattr(objs, '__getitem__'):
        objs = ' '.join(objs)
        
    if not objs: return

    cmd = '%s %s %s "%s" %s' % (env['AR'], env['ARFLAGS'], env['quiet'] and '-q' or '', target, objs)

    env['log'](target, pre="Link '", post="'")
    if env['verbose']:
        print cmd + '\n'

    return execute(cmd, env['dryrun'], env['quiet'])
 
