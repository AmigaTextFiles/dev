#
# File:     Environment.py
#
# Author:   Guillaume ROGUEZ <yomgui1@gmail.com>
# Creation date:            2005/06/18
# Last modification date:   2005/07/16
#

from Boa.Utils import log
from string import Template

__all__ = [ 'Environment' ]

class Environment(dict):
    def __init__(self, _env=None, **kw):
        if kw.has_key('env'):
            _env = kw.pop('env')
        else:
            _env = _env or {}

        if hasattr(self, 'class_env'):
            self.update(self.class_env, **_env)
        else:
            self.update(_env)

        self.update(kw)

    def __getattr__(self, name):
        return dict.__getitem__(self, name)

    def __setattr__(self, name, value):
        dict.__setitem__(self, name, value)

    def __getitem__(self, name):
        return getattr(self, name)

    def __delattr__(self, name):
        dict.__delitem__(self, name)

    def log(self, *args, **kw):
        log(*args, **kw)

    def finalize(self):
        for (k, v) in self.iteritems():
            if isinstance(v, str):
                while True:
                    newv = Template(v).safe_substitute(self)
                    if newv == v:
                        break
                    else:
                        v = newv

                self[k] = newv
