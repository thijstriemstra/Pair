# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from sqlalchemy.sql import select, insert, and_

# defined when connected to the database
messages = None

class TestService(object):
    """
    AMF Remoting service.
    """
    def __init__(self, cfg):
        self.img_folder = cfg.get('slide-engine', 'folder')
        self.pattern = cfg.get('slide-engine', 'pattern')
        self.baseurl = cfg.get('slide-engine', 'baseurl')
        self.files = []
        
    def testMethod(self, environ):
        """        
        @rtype: Array
        @return: List of files.
        """
        for (basepath, children) in services.walktree(self.img_folder, False):
            for child in children:
                for ext in self.pattern.split(';'):
                    file_ext = str(child[-4:]).lower()
                    if  file_ext == ext.lstrip('*'):
                        self.files.append(self.baseurl + child)
                        
        return self.files
