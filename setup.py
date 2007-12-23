# Copyright (c) 2007 The Pair Project. All rights reserved.
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
    url = "http://dev.collab.com/pair",
    packages = find_packages(exclude=["*.tests"]),
    license = "MIT License",
    extras_require={
        'wsgi': ['wsgiref']
    },
    classifiers = [
        "Development Status :: 2 - Pre-Alpha",
        "Natural Language :: English",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
    **extra_options)
