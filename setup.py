# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

from ez_setup import use_setuptools

use_setuptools()

import sys
from setuptools import setup, find_packages

if sys.platform == 'darwin':
    mainscript = 'install/mac/startup.py'
    
    extra_options = dict(
        setup_requires=['py2app>=0.3.6'],
        app=[mainscript],
    )
elif sys.platform == 'win32':
    import py2exe

    mainscript = 'install/win/startup.py'
    extra_options = dict(
        setup_requires=['py2exe>=0.6.6'],
        console=[dict(script=mainscript)],
    )
else:
    extra_options = dict(
        # Normally unix-like platforms will use "setup.py install"
        # and install the main script as such
        scripts=[mainscript],
    )
     
setup(
    name = "Pair",
    version = "1.0.0",
    description = "AIR for Python",
    url = "http://pair.collab.eu",
    packages = find_packages(exclude=["*.tests"]),
    install_requires = ["buildbot>=0.7.6", "Twisted>=2.5.0", "PyAMF>=0.1.0a"],
    license = "GNU General Public License (GPL)",
    entry_points={
        'console_scripts': [
            'pair = pair.scripts.cmd:run',
        ],
    },
    classifiers = [
        "Development Status :: 2 - Pre-Alpha",
        "Natural Language :: English",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: GNU General Public License (GPL)",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
    **extra_options)
