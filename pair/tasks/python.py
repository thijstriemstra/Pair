# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

class PythonSource(object):
    """
    """
    def __init__(self, source=None):
        self.source = source
        self.includes = None
        self.excludes = None
        
    def __repr__(self):
        r = "<PythonSource source=%s/>" % (
            self.source)
        
        return r

class PythonDocs(object):
    """
    """
    def __init__(self, type='html'):
        self.type = type
        self.dir = None
        self.source = 'yes'
        self.frames = 'yes'
        
    def __repr__(self):
        r = "<PythonDocs type=%s/>" % (
            self.type)
        
        return r

class PythonRuntime(object):
    """
    """
    def __init__(self, version=None):
        self.version = '2.5'
        self.optimize = 2
        self.windows = None
                
    def __repr__(self):
        r = "<PythonRuntime version=%s/>" % (
            self.version)
        
        return r
