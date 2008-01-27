# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from pair.services import core
from pair.tasks import *

from sqlalchemy import *
from sqlalchemy.orm import relation, mapper, sessionmaker

env_md = MetaData()

core.projects = Table('projects', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(255), default='Pair Template', nullable=True),
    Column('description', Text, default='Template application for Pair', nullable=True),
    Column('language', String(2), default='en', nullable=True),
    Column('version', String(10), default='1.0.0', nullable=True),
    Column('url', String(255), default='http://pair.collab.eu', nullable=True),
    Column('copyright', Text,
           default='Copyright 2007-2008 The Pair Project. All rights reserved.',
           nullable=True),
    Column('license', String(255), default='docs/LICENSE.txt', nullable=True)
)

core.organizations = Table('organizations', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(255), default='The Pair Project', nullable=True),
    Column('unit', String(255), default='Collab', nullable=True),
    Column('country', String(100), default='The Netherlands', nullable=True),
    Column('email', String(100), default='pair@collab.eu', nullable=True),
    Column('project_id', Integer, ForeignKey('projects.id'))
)

core.build_folders = Table('build_folders', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('base', String(255), default='.', nullable=True),
    Column('build', String(255), default='build', nullable=True),
    Column('image', String(255), default='imagecontents', nullable=True),
    Column('dist', String(255), default='dist', nullable=True),
    Column('report', String(255), default='report', nullable=True)
)

core.air_source = Table('air_source', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('base', String(255), default='air', nullable=True),
    Column('swf', String(255), default='hello-world', nullable=True),
    Column('source', String(255), default='src', nullable=True),
    Column('libraries', String(255), default='lib', nullable=True),
    Column('entry', String(255), default='main.mxml', nullable=True),
    Column('locale', String(255), default='local', nullable=True)
)

core.air_compilers = Table('air_compilers', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('home', String(255), default='/Developer/SDKs/flex3', nullable=True),
    Column('libraries', String(255), default='lib', nullable=True),
    Column('config', String(255), default='frameworks/air-config.xml', nullable=True),
    Column('ant', String(255), default='ant/lib/flexTasks.jar', nullable=True),
    Column('asdoc', String(255), default='bin/asdoc', nullable=True),
    Column('benchmark', Boolean, default=True, nullable=True),
    Column('network', Boolean, default=True, nullable=True)                      
)

core.air_docs = Table('air_docs', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('output', String(255), default='reports/api/air', nullable=True),
    Column('domains', String(255), default='', nullable=True),
    Column('template', String(255), default='asdoc/templates', nullable=True),
    Column('framewidth', Integer, default=150, nullable=True),
    Column('windowtitle', String(255), default='API Documentation', nullable=True),
    Column('maintitle', String(255), default='API Documentation', nullable=True),
    Column('footer', String(255), default='API Documentation', nullable=True)                      
)

core.air_applications = Table('air_applications', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('appid', String(255), default='Pair', nullable=True),
    Column('title', String(255), default='Hello World', nullable=True),
    Column('name', String(255), default='Hello World', nullable=True),
    Column('description', Text, default='Welcome to the %s installer.', nullable=True),
    Column('systemchrome', String(255), default='standard', nullable=True),
    Column('transparent', Boolean, default=False, nullable=True),
    Column('visible', Boolean, default=True, nullable=True),  
    Column('installfolder', String(255), default='Hello World', nullable=True),
    Column('maximizable', Boolean, default=True, nullable=True),
    Column('minimizable', Boolean, default=True, nullable=True),
    Column('resizable', Boolean, default=False, nullable=True),
    Column('width', Integer, default=500, nullable=True),
    Column('height', Integer, default=500, nullable=True),
    Column('minsize', String(255), default='250 500', nullable=True),
    Column('maxsize', String(255), default='750 750', nullable=True),
    Column('x', Integer, default=150, nullable=True),
    Column('y', Integer, default=150, nullable=True)
)

core.air_icons = Table('air_icons', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('folder', String(255), default='samples/icons', nullable=True),
    Column('icon16x16', String(255), default='AIRApp_16.png', nullable=True),
    Column('icon32x32', String(255), default='AIRApp_32.png', nullable=True),
    Column('icon48x48', String(255), default='AIRApp_48.png', nullable=True),
    Column('icon128x128', String(255), default='AIRApp_128.png', nullable=True),
    Column('app_id', Integer, ForeignKey('air_applications.id'))
)

core.air_runtimes = Table('air_runtimes', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('version', String(50), default='1.0.M6', nullable=True),
    Column('packager', String(255), default='adt.jar', nullable=True),
    Column('debugger', String(255), default='bin/adl', nullable=True),
    Column('windows', String(255), default='C:/flex3/runtimes/air/win/Adobe AIR',
           nullable=True),
    Column('macosx', String(255),
           default='/Developer/SDKs/flex3/runtimes/air/mac/Adobe AIR.framework',
           nullable=True)
)

core.air_certificates = Table('air_certificates', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(50), default='My Certificate', nullable=True),
    Column('type', String(255), default='2048-RSA', nullable=True),
    Column('file', String(255), default='certificate.pfx', nullable=True),
    Column('password', String(255), default='1234567890', nullable=True)
)

core.python_source = Table('python_source', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('source', String(255), default='python', nullable=True),
    Column('includes', String(255), default=None, nullable=True),
    Column('excludes', String(255), default=None, nullable=True)
)

core.python_docs = Table('python_docs', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('type', String(10), default='html', nullable=True),
    Column('dir', String(255), default='reports/api/python', nullable=True),
    Column('source', String(10), default='yes', nullable=True),
    Column('frames', String(10), default='yes', nullable=True)                   
)

core.python_runtimes = Table('python_runtimes', env_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('version', String(10), default='2.5', nullable=True),
    Column('optimize', Integer(2), default=2, nullable=True),
    Column('windows', String(255), default='C:/Python25/python.exe', nullable=True)
)

def connect(cfg_file):
    """
    Connect to database.

    @param cfg_file: Location of database configuration file.
    @type cfg_file: C{string}

    @rtype: L{sqlalchemy.orm.sessionmaker}
    @return: Session.
    """
    import ConfigParser

    cfg = ConfigParser.SafeConfigParser()
    cfg.read(cfg_file)
    dev_mode = (cfg.get('database', 'type') == 'sqlite')

    if dev_mode:
        # in-memory sqlite database
        dsn = 'sqlite://'
    else:
        # production mysql database
        dsn = '%s://%s:%s@%s/%s' % (cfg.get('database', 'type'), cfg.get('database', 'username'),
                                    cfg.get('database', 'password'), cfg.get('database', 'host'),
                                    cfg.get('database', 'name'))
    
    env_engine = create_engine(dsn, echo=False)
    env_md.bind = env_engine

    if dev_mode:
        # create database
        env_md.create_all()

    # setup mappings
    ses = setup_session(env_engine)
    
    return ses

def setup_session(env_engine):
    """
    Setup object relational mappings.
    """
    mapper(Project, core.projects, properties={
        'organizations':relation(Organization, backref='project')
    })
    
    mapper(Organization, core.organizations)
    
    Session = sessionmaker(bind=env_engine, autoflush=True, transactional=True)
    
    return Session()

def create_project(session):
    """
    Create template project.
    """
    proj = Project('Hello World', 'Test Project')
    org = Organization('Collab')
    proj.organizations.append(org)

    session.save(proj)
    session.commit()
        
    return proj
