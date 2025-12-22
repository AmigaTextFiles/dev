#
# File:     __init__.py
#
# Author:   Guillaume ROGUEZ <yomgui1@gmail.com>
# Creation date:            2005/06/17
# Last modification date:   2005/12/01
#

import os
from Boa.Defaults import *
from Boa.Utils import *
from Boa.Environment import *

__all__ = ( 'ScriptError', 'CompileError',
            'C_Object', 'CPP_Object', 'Library', 'Program', 'Builder',
            'DefaultEnv', 'lib_startup_filename' )

pjoin = os.path.join

# Lib startup code full filename
lib_startup_filename = pjoin(os.path.dirname(__file__), 'Lib_startup.c')

##
# Errors Classes
#

class ScriptError(Exception):
    def __init__(self, cause, target=None):
        self.cause = cause
        self.target = target

    def __str__(self):
        return "!!! Target '%s' failed: %s" % (self.target, self.cause)

class CompileError(ScriptError):
    def __init__(self, name, target=None):
        ScriptError.__init__(self, "compilation of '%s' failed" % name, target)


##
# Boa Classes
#

from string import Template
import posixpath

class Common(DefaultEnv):
    def __init__(self, name, sources, **kw):
        self['title'] = True
        self.obsolete = True

        DefaultEnv.__init__(self, **kw)
        
        if not posixpath.isabs(self.root):
            self.root = toposix(os.path.abspath(fromposix(self.root)))

        self.root = os.path.normpath(self.root)
        self.set_name(name)
        self.sources = self._flattenSources(sources)
        self.depends = self.genDepends()

    def set_name(self, name):
        self.filename = posixpath.basename(name)
        self.path = posixpath.dirname(name)
        if not posixpath.isabs(self.path):
            self.path = self.root + '/' + self.path
        self.fullname = posixpath.join(self.path, self.filename)
        self.name = name

    def __str__(self):
        return self.fullname

    def _flattenSources(self, sources):
        if isinstance(sources, list) or isinstance(sources, tuple):
            def f(l, x):
                if isinstance(x, list) or isinstance(x, tuple):
                    for y in x:
                        f(l, y)
                else:
                    l.append(x)
                
            s = []
            f(s, sources)
            return s

        else:
            return (sources,)

    def _enter_root(self):
        self._olddir = os.path.normpath(os.getcwd())
        native_root = fromposix(self.root)

        if self._olddir == native_root:
            del self._olddir
            return
    
        if self.verbose:
            self.log(native_root, pre="+ Enter in directory: '", post="'\n")
    
        try:
            os.chdir(native_root)

        except OSError:
            raise ScriptError("The path '" + native_root + "' doesn't exists", self.filename)

        else:
            self._native_enter_path = native_root

    def _leave_root(self):
        if self.has_key('_olddir'):
            if self.verbose:
                self.log(self._native_enter_path, pre="\n- Leave directory: '", post="'")

            os.chdir(self._olddir)
            del self._native_enter_path, self._olddir

    def genDepends(self):
        depends = []
        for source in self.sources:
            if isinstance(source, str) or isinstance(source, unicode):
                source = Template(source).safe_substitute(self)
                name, ext = posixpath.splitext(source)
                
                if ext.lower() == '.c':
                    source = C_Object(None, source, env=self)

                elif ext.lower() == '.cpp':
                    source = CPP_Object(None, source, env=self)

            depends.append(source)
        return tuple(depends)
 
    def build(self, title=True):
        self.finalize()

        self._enter_root()
        try:
            depends = filter(lambda d: isinstance(d, Common) and d.isobsolete(), self.depends)
            for dep in depends:
                try:
                    dep.build(title and dep.title)

                except ScriptError, error:
                    print error
                    raise ScriptError('build dependency error', self.filename)

            if depends or self.isobsolete():
                title = title and self.title   
                
                if title:
                    self.log(' %s ' % self.filename, pre='='*6, post='='*6+'\n')

                self._build()
                self.obsolete = False
                
                if title:
                    self.log('')

        finally:
            self._leave_root()

    def isobsolete(self):
        if not self.has_key('_level'):
            self._level = 0

        # not already marked as obsolete or exist ?
        if self.depends and (not self.obsolete or os.path.exists(fromposix(self.fullname))):
            # are all dependencies ok ?
            ref = os.stat(fromposix(self.fullname)).st_mtime
            for dep in self.depends:
                if isinstance(dep, Common):
                    dep._level = self._level + 1  
                    if dep.isobsolete():
                        return True
                else:
                    if not posixpath.isabs(dep):
                        dep = self.root + '/' + dep
                    name = fromposix(dep)
                    if os.path.exists(name):
                        import time
                        self.obsolete = os.stat(name).st_mtime > ref
                        if self.obsolete:
                            return True

            self.obsolete = False
        
        else:
            self.obsolete = True

        return self.obsolete

    def clean(self):
        for dep in self.depends:
            if isinstance(dep, Common):
                dep.master = False
                dep._olddir = None
                dep.clean()
                del dep._olddir

        if not posixpath.isabs(self.name):
            name = posixpath.join(self.root, self.name)
        else:
            name = self.name

        name = fromposix(name)

        if os.path.exists(name):
            self.log(name, pre="Deleting '", post="'")
            execute('Delete >NIL: "%s"' % name, self.dryrun)

import Boa.gcc  # XXX: change this by the user selected compiler 

c_compiler = Boa.gcc
cpp_compiler = Boa.gcc
linker = Boa.gcc

c_env = { 'CFLAGS': '',
          'INCLUDES': '',
          'includes': '',
          'cflags': '' }
 

class C_Object(Common):
    class_env = {}
    class_env.update(linker.defaults, **c_env)

    def __init__(self, name, source, *args, **kw):
        # Auto naming
        if not name:
            name = posix_get_obj(source)

        Common.__init__(self, name, source, *args, **kw)

        self.compile = c_compiler.compile

        self.INCLUDES = self.includes or self.INCLUDES
        self.CFLAGS = self.cflags or self.CFLAGS

        # replace an header '#' by the current dir
        curdir = toposix(os.path.abspath(os.curdir))
        l = []
        for path in self.INCLUDES:
            if path[0] == '#':
                if path[1] == '/':
                    path = path[2:]
                else:
                    path = path[1:]
                path = posixpath.join(curdir, path)
            l.append(path)
        self.INCLUDES = l

        self.title = False

    def __repr__(self):
        return "<C_Object '%s'>" % self.filename

    def genDepends(self):
        return self.sources

    def _build(self):
        if self.compile(fromposix(self.name), self.depends[0], cflags=self.CFLAGS, includes=self.INCLUDES, env=self):
            raise ScriptError('compile error', self.filename)


class CPP_Object(C_Object):
    class_env = {}
    class_env.update(cpp_compiler.defaults, **c_env)

    def __init__(self, *args, **kw):
        C_Object.__init__(self, *args, **kw)

        self.compile = cpp_compiler.compile

    def __repr__(self):
        return "<CPP_Object '%s'>" % self.filename


class Library(Common):
    _env = { 'LIB_PREFIX': 'lib',
             'LIB_EXT': '.a' }

    class_env = {}
    class_env.update(linker.defaults, **_env)
    del _env
    
    def __init__(self, *args, **kw):
        Common.__init__(self, *args, **kw)

        self.link = linker.ar

        # Auto naming
        name, ext = posixpath.splitext(self.fullname)
        path = posixpath.dirname(name)
        name = posixpath.basename(name)
        if not name:
            raise ArgumentError

        if ext != self.LIB_EXT:
            name += ext

        try:
            if name[3] == self.LIB_PREFIX:
                name = name[3:]
        
        except IndexError:
            pass

        self.set_name(posixpath.join(path, self.LIB_PREFIX + name + self.LIB_EXT))

    def __repr__(self):
        return "<Library '%s'>" % self.filename

    def _build(self):
        if self.link(self.name, map(str, self.depends), env=self):
            raise ScriptError('link error', self.filename)

class Program(Common):
    _env = { 'LFLAGS': '',
             'LIBS': [] }

    class_env = {}
    class_env.update(linker.defaults, **_env)
    del _env

    def __init__(self, name, sources, lflags='', libs=[], **kw):
        Common.__init__(self, name, sources, **kw)
        
        self.link = linker.link

        self.LFLAGS = lflags or self.LFLAGS
        self.LIBS = libs or self.LIBS

        self.first_depends = self.depends
        self.depends = list(self.depends)

        libs = []
        for lib in self.LIBS:
            if isinstance(lib, Common):
                libs.append(lib.filename[3:][:-2])
                self.depends.append(lib)
                self.LFLAGS += ' -l%s' % lib.path
            else:
                libs.append(lib)
        self.LIBS = libs

        self.depends = tuple(self.depends)

    def __str__(self):
        return "<Program '%s'>" % self.filename

    def _build(self):
        if self.link(fromposix(self.name), map(str, self.first_depends), lflags=self.LFLAGS, libs=self.LIBS, env=self):
            raise ScriptError('link error', self.filename)

class Builder(Common):
    def __init__(self, name, sources, cmd='', **kw):
        self.title = False
        Common.__init__(self, name, sources, **kw)

        self.cmd = cmd

    def __repr__(self):
        return "<Builder '%s'>" % self.filename
    
    def _build(self):
        if callable(self.cmd):
            self.cmd(self)
        else:
            if not self.quiet:
                self.log(self.cmd)
            if execute(self.cmd, self.dryrun, self.quiet):
                raise ScriptError('execute error', self.filename)
 
