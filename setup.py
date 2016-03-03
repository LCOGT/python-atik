'''
setup.py - Setup file for the python-atik module.

Author:
    Martin Norbury

February 2016
'''
import numpy as np

from setuptools import setup, Extension

extensions = [Extension('_atik', ['atik.i'],
                        swig_opts=['-c++'],
                        libraries=['atikccd'],
                        include_dirs=[np.get_include()])]

setup(name    = 'python-atik',
      version = '0.1',
      author  = 'Martin Norbury',
      description = '''Simple swig wrappings around ATIK camera''',
      ext_modules = extensions,
      py_modules = 'atik',
      install_requires = ['numpy'],
     )
