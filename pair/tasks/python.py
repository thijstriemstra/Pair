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
    def __init__(self, output_type='html'):
        self.output_type = output_type
        self.output_dir = None
        self.source_code = 'yes'
        self.frames = 'yes'
        
    def __repr__(self):
        r = "<PythonDocs output_type=%s/>" % (
            self.output_type)
        
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
