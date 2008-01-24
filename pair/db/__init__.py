# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from sqlalchemy import *

from pair.services import core
from pair.tasks import *

env_md = MetaData()

core.projects = Table('projects', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(255), default=None, nullable=True),
    Column('description', Text, default=None, nullable=True),
    Column('language', String(2), default=None, nullable=True),
    Column('version', String(10), default=None, nullable=True),
    Column('url', String(255), default=None, nullable=True),
    Column('copyright', Text, default=None, nullable=True),
    Column('license', String(255), default=None, nullable=True)
)

core.organizations = Table('organizations', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(255), default=None, nullable=True),
    Column('unit', String(255), default=None, nullable=True),
    Column('country', String(100), default=None, nullable=True),
    Column('email', String(100), default=None, nullable=True),
    Column('project_id', Integer, ForeignKey('projects.id'))
)

core.build_folders = Table('build_folders', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('base', String(255), default=None, nullable=True),
    Column('build', String(255), default=None, nullable=True),
    Column('image', String(255), default=None, nullable=True),
    Column('dist', String(255), default=None, nullable=True),
    Column('report', String(255), default=None, nullable=True)
)

core.air_source = Table('air_source', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('base', String(255), default=None, nullable=True),
    Column('swf', String(255), default=None, nullable=True),
    Column('source', String(255), default=None, nullable=True),
    Column('libraries', String(255), default=None, nullable=True),
    Column('entry', String(255), default=None, nullable=True),
    Column('locale', String(255), default=None, nullable=True)
)

core.air_compilers = Table('air_compilers', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('home', String(255), default=None, nullable=True),
    Column('libraries', String(255), default=None, nullable=True),
    Column('config', String(255), default=None, nullable=True),
    Column('ant', String(255), default=None, nullable=True),
    Column('asdoc', String(255), default=None, nullable=True),
    Column('benchmark', Boolean, default=True, nullable=True),
    Column('network', Boolean, default=True, nullable=True)                      
)

core.air_docs = Table('air_docs', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('output', String(255), default=None, nullable=True),
    Column('domains', String(255), default=None, nullable=True),
    Column('template', String(255), default=None, nullable=True),
    Column('framewidth', Integer, default=150, nullable=True),
    Column('windowtitle', String(255), default=None, nullable=True),
    Column('maintitle', String(255), default=None, nullable=True),
    Column('footer', String(255), default=True, nullable=True)                      
)

core.air_applications = Table('air_applications', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('appid', String(255), default=None, nullable=True),
    Column('config', String(255), default=None, nullable=True),
    Column('title', String(255), default=None, nullable=True),
    Column('name', String(255), default=None, nullable=True),
    Column('description', Text, default=None, nullable=True),
    Column('systemchrome', String(255), default=None, nullable=True),
    Column('transparent', Boolean, default=False, nullable=True),
    Column('visible', Boolean, default=True, nullable=True),  
    Column('installfolder', String(255), default=None, nullable=True),
    Column('maximizable', Boolean, default=True, nullable=True),
    Column('minimizable', Boolean, default=True, nullable=True),
    Column('resizable', Boolean, default=False, nullable=True),
    Column('width', Integer, default=500, nullable=True),
    Column('height', Integer, default=500, nullable=True),
    Column('minsize', String(255), default=None, nullable=True),
    Column('maxsize', String(255), default=None, nullable=True),
    Column('x', Integer, default=150, nullable=True),
    Column('y', Integer, default=150, nullable=True),
    Column('icons', Integer, default=None, nullable=True)
)

core.air_icons = Table('air_icons', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('folder', String(255), default=None, nullable=True),
    Column('icon16x16', String(255), default=None, nullable=True),
    Column('icon32x32', String(255), default=None, nullable=True),
    Column('icon48x48', String(255), default=None, nullable=True),
    Column('icon128x128', String(255), default=None, nullable=True)
)

core.air_runtimes = Table('air_runtimes', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('version', String(50), default=None, nullable=True),
    Column('base', String(255), default=None, nullable=True),
    Column('packager', String(255), default=None, nullable=True),
    Column('debugger', String(255), default=None, nullable=True),
    Column('windows', String(255), default=None, nullable=True),
    Column('macosx', String(255), default=None, nullable=True)
)

core.air_certificates = Table('air_certificates', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(50), default=None, nullable=True),
    Column('type', String(255), default=None, nullable=True),
    Column('file', String(255), default=None, nullable=True),
    Column('password', String(255), default=None, nullable=True)
)

core.python_source = Table('python_source', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('source', String(255), default=None, nullable=True),
    Column('includes', String(255), default=None, nullable=True),
    Column('excludes', String(255), default=None, nullable=True)
)

core.python_docs = Table('python_docs', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('type', String(10), default='html', nullable=True),
    Column('dir', String(255), default=None, nullable=True),
    Column('source', String(10), default='yes', nullable=True),
    Column('frames', String(10), default='yes', nullable=True)                   
)

core.python_runtimes = Table('python_runtimes', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('version', String(10), default=None, nullable=True),
    Column('optimize', Integer(2), default=None, nullable=True),
    Column('windows', String(255), default=None, nullable=True)
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

    # DB type
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

def mappings():
    """
    """
    from sqlalchemy.orm import relation, mapper

    mapper(Project, core.projects, properties={
        'organizations':relation(Organization, backref='project')
    })
    
    mapper(Organization, core.organizations)

def session(env_engine):
    """
    """
    from sqlalchemy.orm import sessionmaker
    
    Session = sessionmaker(bind=env_engine, autoflush=True, transactional=True)
    
    return Session()
