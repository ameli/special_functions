
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

foreach ext: extensions
  py3.extension_module(
    ext,
    ext + '.pyx',
    dependencies: py3_dep,
    include_directories: ['.'],
    link_with: [
      amos_lib,
      cephes_lib
    ],
    install: true,
    link_language: 'fortran',
    subdir: 'special_functions'
  )
endforeach

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
  pure: false,                  # Will be installed next to binaries
  subdir: 'special_functions'   # Folder relative to site-package to install to
)
