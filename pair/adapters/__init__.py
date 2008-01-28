# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

class Adapter(object):
    """
    Base adapter.
    """
    def __init__(self, name=None):
        self.name = name
        
    def __repr__(self):
        r = "<Adapter name=%s/>" % (
            self.name)
        
        return r

    def install(self):
        """
        Install the adapter by executing the startup scripts for
        the database and files.
        """
        
    def uninstall(self):
        """
        Uninstall the adapter by executing the delete scripts for
        the database and files.
        """
        
