# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

from ez_setup import use_setuptools

use_setuptools()

from setuptools import setup, find_packages

setup(
    name = "Pair",
    version = "1.0.0",
    description = "AIR for Python",
    url = "http://pair.collab.eu",
    packages = ["pair"],
    install_requires = ["buildbot>=0.7.6", "Twisted>=2.5.0", "PyAMF>=0.1.0a", "wsgiref"],
    license = "GNU General Public License (GPL)",
    entry_points={
        'console_scripts': [
            'pair = pair.scripts.start:run',
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
    ]
)
