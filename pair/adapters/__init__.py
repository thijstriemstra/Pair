# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

class Adapter(object):
    """
    Base adapter.

    Database:
     - record in 'adapters' table
     - multiple records in 'runtimes' table for different versions
     - multiple records in 'doctools' table for different asdoc versions

    Modules:
     - '__init__' for class implementations
     - 'db' for custom database info
     - 'services' for remote methods

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

        Database:
         - add record in 'adapters' table
         - initial 'runtimes' record
        """
        
    def uninstall(self):
        """
        Uninstall the adapter by executing the delete scripts for
        the database and files.

        Database:
         - remove record from 'adapters' table
        """
        
