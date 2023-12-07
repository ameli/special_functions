# SPDX-FileCopyrightText: Copyright 2021, Siavash Ameli <sameli@berkeley.edu>
# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileType: SOURCE
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the license found in the LICENSE.txt file in the root
# directory of this source tree.


# The list of sources for amos and cephes are processed in "_extern" subdir
amos_sources = []
cephes_sources = []
subdir('_extern')

# Create amos library (Fortran code)
amos_lib = static_library(
    'amos',
    amos_sources,
    fortran_args: _fflag_Wno_maybe_uninitialized,
    include_directories: [
        './_extern/amos/double_precision',
        './_extern/amos/single_precision',
        './_extern/amos/mach',
    ],
    dependencies: [py3_dep],
)

# Create cephes library (C code)
cephes_lib = static_library(
  'cephes',
  cephes_sources,
  c_args: use_math_defines,
  include_directories: [
      './_extern/cephes/bessel',
      './_extern/cephes/cmath',
      './_extern/cephes/cprob',
      './_extern/cephes/eval',
  ],
  dependencies: [py3_dep],
)

# Cythonize compiler arguments. -X stands for cython compiler derivatives
cython_args = [
    '-3',
    '-X', 'boundscheck=False',
    '-X', 'cdivision=True',
    '-X', 'wraparound=False',
    '-X', 'nonecheck=False',
    '-X', 'embedsignature=True',
    '-X', 'cpow=True',
    '-X', 'linetrace=True',
    '--output-file', '@OUTPUT@',
    '--include-dir', '@BUILD_ROOT@',
    '@INPUT@'
]

# Cythonize object
cython_gen = generator(cython,
    arguments : cython_args,
    output : '@BASENAME@.c')

# List of pyx files (without their extension) to be cythonized
extensions = [
    'besseli',
    'besselj',
    'besselk',
    'besselh',
    'bessely',
    'cbesseli',
    'cbesselj',
    'cbesselk',
    'cbesselh',
    'cbessely',
    'lngamma',
    '_complex_functions',
]

# Create extensions from each cythonized file
foreach ext: extensions
    py3.extension_module(
        ext,
        cython_gen.process(ext + '.pyx'),
        c_args: cython_c_args,
        dependencies: py3_dep,
        include_directories: ['.'],
        link_args: version_link_args,
        link_with: [
            amos_lib,
            cephes_lib
        ],
        install: true,
        link_language: 'fortran',
        subdir: 'special_functions'
    )
endforeach

# List of files to be directly copied to the installation package directory
python_sources = [
    '__init__.py',
    '__init__.pxd',
    '__config__.py',
    'besseli.pxd',
    'besselj.pxd',
    'besselk.pxd',
    'besselh.pxd',
    'bessely.pxd',
    'cbesseli.pxd',
    'cbesselj.pxd',
    'cbesselk.pxd',
    'cbesselh.pxd',
    'cbessely.pxd',
    'lngamma.pxd',
    '_complex_functions.pxd',
    'cython_wrappers.py',
]

# Install the above list of files
py3.install_sources(
    python_sources,
    pure: false,                  # Will be installed next to binaries
    subdir: 'special_functions'   # Folder relative to site-package to install to
)
