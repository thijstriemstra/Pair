# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
Pair adapter for Python.

@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from pair.adapters import Adapter
from pair import Application, Documentation, Runtime

class PythonAdapter(Adapter):
    """
    Adapter for Python.
    """

    def install(self):
        """
        Install the Python adapter.
        """
        
    def uninstall(self):
        """
        Uninstall the Python adapter.
        """
        
class PythonApplication(Application):
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

class PythonDocs(Documentation):
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
