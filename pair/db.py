# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
Database for Pair core.

@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from pair import core, project

from pair.adapters import *

from sqlalchemy import *
from sqlalchemy.orm import relation, mapper, sessionmaker

core_md = MetaData()
project_md = MetaData()

# Core

core.projects = Table('projects', core_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(255), default='Untitled Project', nullable=True),
    Column('description', Text, default='Template for Pair project',
           nullable=True),
    Column('language', String(2), default='en', nullable=True),
    Column('version', String(10), default='1.0.0', nullable=True),
    Column('url', String(255), default='http://pair.collab.eu', nullable=True),
    Column('copyright', Text,
           default='Copyright 2007-2008 The Pair Project. All rights reserved.',
           nullable=True),
    Column('license', String(255), default='docs/LICENSE.txt', nullable=True)
)

core.organizations = Table('organizations', core_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(255), default='The Pair Project', nullable=True),
    Column('unit', String(255), default='Collab', nullable=True),
    Column('country', String(100), default='The Netherlands', nullable=True),
    Column('email', String(100), default='pair@collab.eu', nullable=True)
)

core.build_folders = Table('build_folders', core_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('base', String(255), default='.', nullable=True),
    Column('build', String(255), default='build', nullable=True),
    Column('image', String(255), default='imagecontents', nullable=True),
    Column('dist', String(255), default='dist', nullable=True),
    Column('report', String(255), default='report', nullable=True)
)

core.adapters = Table('adapters', core_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('source', String(255), default='python', nullable=True),
    Column('includes', String(255), default=None, nullable=True),
    Column('excludes', String(255), default=None, nullable=True)
)

core.doctools = Table('doctools', core_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('type', String(10), default='html', nullable=True),
    Column('dir', String(255), default='reports/api/python', nullable=True),
    Column('source', String(10), default='yes', nullable=True),
    Column('frames', String(10), default='yes', nullable=True)
)

core.runtimes = Table('runtimes', core_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('version', String(10), default='2.5', nullable=True),
    Column('optimize', Integer(2), default=2, nullable=True),
    Column('windows', String(255), default='C:/Python25/python.exe', nullable=True)
)

core.libraries = Table('libraries', core_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('version', String(10), default='2.5', nullable=True),
    Column('optimize', Integer(2), default=2, nullable=True),
    Column('windows', String(255), default='C:/Python25/python.exe', nullable=True)
)

# Project

project.applications = Table('applications', project_md,
    Column('id', Integer, primary_key=True, autoincrement=True),
    Column('name', String(255), default='Untitled Project', nullable=True),
    Column('description', Text, default='Template for Pair project',
           nullable=True),
    Column('language', String(2), default='en', nullable=True),
    Column('version', String(10), default='1.0.0', nullable=True),
    Column('url', String(255), default='http://pair.collab.eu', nullable=True),
    Column('copyright', Text,
           default='Copyright 2007-2008 The Pair Project. All rights reserved.',
           nullable=True),
    Column('license', String(255), default='docs/LICENSE.txt', nullable=True)
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
        dsn = '%s://%s:%s@%s/%s' % (cfg.get('database', 'type'),
                                    cfg.get('database', 'username'),
                                    cfg.get('database', 'password'),
                                    cfg.get('database', 'host'),
                                    cfg.get('database', 'name'))
    
    core_engine = create_engine(dsn, echo=False)
    project_engine = create_engine(dsn, echo=False)
    
    core_md.bind = core_engine
    project_md.bind = project_engine
    
    if dev_mode:
        # create database
        core_md.create_all()
        project_md.create_all()
        
    ses = setup_session(core_engine)
    
    return ses

def setup_session(engine):
    """
    Setup object relational mappings.

    @param engine:
    @type engine:

    @rtype: L{sqlalchemy.orm.sessionmaker}
    @return: Session.
    """
    mapper(Project, core.projects, properties={
        'organizations':relation(Organization, backref='project'),
        'folders':relation(BuildFolders, backref='project'),
        'air':relation(AIRApplication, backref='project'),
        'python':relation(PythonApplication, backref='project')
    })   
    
    mapper(Organization, core.organizations)
    mapper(BuildFolders, core.build_folders)

    mapper(AIRApplication, core.air_applications, properties={
        'source':relation(AIRSource, backref='project'),
        'compilers':relation(AIRCompiler, backref='project'),
        'docs':relation(AIRDocs, backref='project'),
        'icons':relation(AIRIcons, backref='project'),
        'runtimes':relation(AIRRuntime, backref='project'),
        'certificates':relation(AIRCertificate, backref='project')
    })

    mapper(AIRSource, core.air_source)
    mapper(AIRCompiler, core.air_compilers)
    mapper(AIRDocs, core.air_docs)
    mapper(AIRIcons, core.air_icons)
    mapper(AIRRuntime, core.air_runtimes)
    mapper(AIRCertificate, core.air_certificates)

    mapper(PythonApplication, core.python_applications, properties={
        'docs':relation(PythonDocs, backref='project'),
        'runtimes':relation(PythonRuntime, backref='project')
    })

    mapper(PythonDocs, core.python_docs)
    mapper(PythonRuntime, core.python_runtimes)
    
    Session = sessionmaker(bind=engine, autoflush=True, transactional=True)
    
    return Session()

def create_project(session):
    """
    Create template project.

    @param session:
    @type session:
    """
    proj = Project()
    
    org = Organization()
    proj.organizations.append(org)

    fold = BuildFolders()
    proj.folders.append(fold)

    # AIR
    air_app = AIRApplication()
    
    air_source = AIRSource()
    air_app.source.append(air_source)

    air_comp = AIRCompiler()
    air_app.compilers.append(air_comp)

    air_docs = AIRDocs()
    air_app.docs.append(air_docs)

    air_icons = AIRIcons()
    air_app.icons.append(air_icons)

    air_runtime = AIRRuntime()
    air_app.runtimes.append(air_runtime)

    air_cert = AIRCertificate()
    air_app.certificates.append(air_cert)
    
    proj.air.append(air_app)

    # Python
    py_app = PythonApplication()

    py_docs = PythonDocs()
    py_app.docs.append(py_docs)

    py_runtime = PythonRuntime()
    py_app.runtimes.append(py_runtime)
    
    proj.python.append(py_app)

    # Save
    session.save(proj)
    session.commit()
        
    return proj
