# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

class ProjectInfo(object):
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
        r = "<ProjectInfo name=%s version=%s/>" % (
            self.name, self.version)
        
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
    def __init__(self, base_dir=None, build_dir=None, image_dir=None):
        self.base_dir = base_dir
        self.build_dir = build_dir
        self.image_dir = image_dir
        self.dist_dir = None
        self.report_dir = None
        
    def __repr__(self):
        r = "<BuildFolders base_dir=%s build_dir=%s/>" % (
            self.base_dir, self.build_dir)
        
        return r
