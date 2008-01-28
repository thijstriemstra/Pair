# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from pair.tasks import Runtime

class PythonApplication(object):
    """
    """
    def __init__(self, source=None):
        self.source = source
        self.includes = None
        self.excludes = None
        
    def __repr__(self):
        r = "<PythonApplication source=%s/>" % (
            self.source)
        
        return r

class PythonDocs(object):
    """
    """
    def __init__(self, type='html'):
        self.type = type
        self.dir = None
        self.source = None
        self.frames = None
        
    def __repr__(self):
        r = "<PythonDocs type=%s/>" % (
            self.type)
        
        return r

class PythonRuntime(Runtime):
    """
    """
    def __init__(self, name='Python', version='2.5'):
        self.name = name
        self.version = version
        self.optimize = None
                
    def __repr__(self):
        r = "<PythonRuntime version=%s/>" % (
            self.version)
        
        return r
