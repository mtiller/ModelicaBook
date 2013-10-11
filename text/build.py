#!/usr/bin/env python

#import paver
#import paver.misctasks
#from paver.path import path
from paver.easy import *
from paver.setuputils import setup
import paver.doctools
#import paver.setuputils
#paver.setuputils.install_distutils_tasks()

from sphinxcontrib import paverutils

options(
    setup(
        sphinx = Bunch(
            docroot='.',
            sourcedir='source',
            builder='html'),
        pdf = Bunch(
            builddir='pdf',
            builder='latex')))

