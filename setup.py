# Copyright (c) 2007 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
Build script for Pair.

@author: U{Thijs Triemstra<mailto:info@collab.nl>}
@since: December 2007
@see: U{http://dev.collab.com/pair}
"""

from ez_setup import use_setuptools

use_setuptools()

import sys
from setuptools import setup, find_packages

mainscript = 'pair/bootloader.py'

if sys.platform == 'darwin':
    extra_options = dict(
        setup_requires=['py2app>=0.3.6'],
        app=[mainscript],
        # Cross-platform applications generally expect sys.argv to
        # be used for opening files.
        options=dict(py2app=dict(argv_emulation=True)),
    )
elif sys.platform == 'win32':
    extra_options = dict(
        setup_requires=['py2exe>=0.6.6'],
        app=[mainscript],
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
