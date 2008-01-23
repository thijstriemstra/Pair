# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from sqlalchemy import *

from pair.services import core

env_md = MetaData()

core.messages = Table('messages', env_md,
    Column('q_id', Integer, primary_key=True, autoincrement=True),
    Column('message', String(255), default=None, nullable=True)
)

def connect(cfg_file):
    """
    Connect to database.

    @param cfg_file: location of database cfg file
    @type cfg_file: string
    """
    # Settings
    import ConfigParser

    cfg = ConfigParser.SafeConfigParser()
    cfg.read(cfg_file)

    dev_mode = (cfg.get('database', 'type') == 'sqlite')
    
    if dev_mode:
        # in-memory sqlite databases
        dsn = 'sqlite://'
    else:
        # production mysql databases
        dsn = '%s://%s:%s@%s/%s' % (cfg.get('database', 'type'), cfg.get('database', 'username'),
                                    cfg.get('database', 'password'), cfg.get('database', 'host'),
                                    cfg.get('database', 'name'))
        
    env_engine = create_engine(dsn, echo=False)
    
    env_md.bind = env_engine

    if dev_mode:
        # create database
        env_md.create_all()
    
    return env_engine
