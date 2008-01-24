# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

class Project(object):
    """
    """
    def __init__(self, name=None, description=None, language='en'):
        self.name = name
        self.description = description
        self.language = language
        self.version = None
        self.url = None
        self.copyright = None
        self.license = None
        
    def __repr__(self):
        r = "<Project name='%s'/>" % (self.name)
        
        return r

class Organization(object):
    """
    """
    def __init__(self, name=None, unit=None, country=None):
        self.name = name
        self.unit = unit
        self.country = country
        self.email = None
        
    def __repr__(self):
        r = "<Organization name=%s unit=%s/>" % (
            self.name, self.unit)
        
        return r

class BuildFolders(object):
    """
    """
    def __init__(self, base=None, build=None, image=None):
        self.base = base
        self.build = build
        self.image = image
        self.dist = None
        self.report = None
        
    def __repr__(self):
        r = "<BuildFolders base=%s build=%s/>" % (
            self.base, self.build)
        
        return r
