
cython_c_args = ['-DCYTHON_CCOMPLEX=0'] # see gh-18975 for why we need this

numpy_nodepr_api = '-DNPY_NO_DEPRECATED_API=NPY_1_9_API_VERSION'

# The list of sources for amos and cephes are processed in "_extern" subdir
amos_sources = []
cephes_sources = []
subdir('_extern')

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

# sources = files('besselk.pyx')

py3.extension_module(
  'lngamma',
  'lngamma.pyx',
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'cbessely',
  'cbessely.pyx',
  include_directories: ['.'],
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'cbesselh',
  'cbesselh.pyx',
  include_directories: ['.'],
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'cbesselj',
  'cbesselj.pyx',
  include_directories: ['.'],
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'cbesseli',
  'cbesseli.pyx',
  include_directories: ['.'],
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'cbesselk',
  'cbesselk.pyx',
  include_directories: ['.'],
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)


py3.extension_module(
  '_complex_functions',
  '_complex_functions.pyx',
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'besselh',
  'besselh.pyx',
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'bessely',
  'bessely.pyx',
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'besseli',
  'besseli.pyx',
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'besselj',
  'besselj.pyx',
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

py3.extension_module(
  'besselk',
  'besselk.pyx',
  dependencies: py3_dep,
  link_with: [
    amos_lib,
    cephes_lib
  ],
  install: true,
  link_language: 'fortran',
  subdir: 'special_functions'
)

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

py3.install_sources(
  python_sources,
  subdir: 'special_functions'
)
