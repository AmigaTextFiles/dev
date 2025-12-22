#!python
#
# File:     CreateLibInfo.py
#
# Date:     2005/06/16
# Author:   Guillaume ROGUEZ <yomgui1@gmail.com>
#

from os import environ

if environ.has_key('USER'):
    user = environ['USER']
else:
    user = '<unknown>'

def writeInfoFile(name, version=1, revision=0,
                  lib_funcs='',
                  copyright='written by ' + user,
                  destination='lib_info.h',
                  date=None,
                  dry=False,
                  verbose=False):

    from time import localtime

    if not date:
        date = "%04u/%02u/%02u" % localtime()[:3]

    version = int(version)
    revision = int(revision)
    name += '.fc'

    if verbose:
        print "Generating Lib Info file '%s' (%lu.%lu)..." % (destination, version, revision)

    if not dry:
        f = open(destination, 'w')
        f.write('const char _LIB_VersionString[] = "\\0$VER: %s %lu.%lu (%s) %s";\n' %
                (name, version, revision, date, copyright))
        f.write('const char _LIB_LibName[] = "%s";\n' % name)
        f.write('unsigned long _LIB_Version = %lu;\n' % version)
        f.write('unsigned long _LIB_Revision = %lu;\n' % revision)
        f.write('#define LIB_FUNCTIONS ' +  ' \\\n'.join(lib_funcs.split()))
        f.close()

