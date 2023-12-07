# SPDX-FileCopyrightText: Copyright 2021, Siavash Ameli <sameli@berkeley.edu>
# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileType: SOURCE
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the license found in the LICENSE.txt file in the root
# directory of this source tree.


project('special_functions', 'c', 'cython',
    license: 'BSD-3',
    meson_version: '>= 1.1.0',
    default_options: [
        'buildtype=debugoptimized',
        'b_ndebug=if-release',
        'c_std=c99',
        'cpp_std=c++14',
        'fortran_std=legacy',
    ],
)

py_mod = import('python')
py3 = py_mod.find_installation(pure: false)
py3_dep = py3.dependency()

# Emit a warning for 32-bit Python installs on Windows; users are getting
# unexpected from-source builds there because we no longer provide wheels.
is_windows = host_machine.system() == 'windows'
if is_windows and py3.has_variable('EXT_SUFFIX')
    ext_suffix = py3.get_variable('EXT_SUFFIX')
    if ext_suffix.contains('win32')
        warning('You are building from source on a 32-bit Python install. ' + \
                'special_functions does not provide 32-bit wheels; ' + \
                'install 64-bit Python if you are having issues!')
    endif
endif

cc = meson.get_compiler('c')
cy = meson.get_compiler('cython')
# generator() doesn't accept compilers, only found programs - cast it.
cython = find_program(cy.cmd_array()[0])

# Check compiler is recent enough
# if cc.get_id() == 'gcc'
#     if not cc.version().version_compare('>=8.0')
#     ¦   error('special_functions requires GCC >= 8.0')
#     endif
# elif cc.get_id() == 'msvc'
#     if not cc.version().version_compare('>=19.20')
#     ¦   error('special_functions requires at least vc142 (default with ' + \
#               'Visual Studio 2019) when building with MSVC')
#     endif
# endif
# if not cy.version().version_compare('>=0.29.35')
#     error('special_functions requires Cython >= 0.29.35')
# endif

_global_c_args = cc.get_supported_arguments(
    '-Wno-unused-but-set-variable',
    '-Wno-unused-function',
    '-Wno-conversion',
    '-Wno-misleading-indentation',
)
add_project_arguments(_global_c_args, language : 'c')

# We need -lm for all C code (assuming it uses math functions, which is safe to
# assume for SciPy). For C++ it isn't needed, because libstdc++/libc++ is
# guaranteed to depend on it. For Fortran code, Meson already adds `-lm`.
m_dep = cc.find_library('m', required : false)
if m_dep.found()
    add_project_link_arguments('-lm', language : 'c')
endif

if host_machine.system() == 'os400'
    # IBM i system, needed to avoid build errors - see gh-17193
    add_project_arguments('-D__STDC_FORMAT_MACROS', language : 'cpp')
    add_project_link_arguments('-Wl,-bnotextro', language : ['c', 'cpp', 'fortran'])
endif

# Adding at project level causes many spurious -lgfortran flags.
add_languages('fortran', native: false)
ff = meson.get_compiler('fortran')
if ff.has_argument('-Wno-conversion')
    add_project_arguments('-Wno-conversion', language: 'fortran')
endif

if host_machine.system() == 'darwin' and cc.has_link_argument('-Wl,-ld_classic')
    # New linker introduced in macOS 14 not working yet, see gh-19357, gh-19387
    add_project_link_arguments('-Wl,-ld_classic', language : ['c', 'fortran'])
endif

# Intel compilers default to fast-math, so disable it if we detect Intel
# compilers. A word of warning: this may not work with the conda-forge
# compilers, because those have the annoying habit of including lots of flags
# that are gcc-specific in CFLAGS/CXXFLAGS/FFLAGS, which throws off the
# detection logic below. You have to remove the wrong flags (only `-isystem`
# is actually needed, everything else shouldn't be there).
_intel_cflags = []
_intel_fflags = []
if cc.get_id() == 'intel'
  _intel_cflags += cc.get_supported_arguments('-fp-model=strict')
elif cc.get_id() == 'intel-cl'
  _intel_cflags += cc.get_supported_arguments('/fp:strict')
endif
if ff.get_id() == 'intel'
  _intel_fflags = ff.get_supported_arguments('-fp-model=strict')
  minus0_arg = ['-assume', 'minus0']
  if ff.has_multi_arguments(minus0_arg)
    _intel_fflags += minus0_arg
  endif
elif ff.get_id() == 'intel-cl'
  # Intel Fortran on Windows does things differently, so deal with that
  # (also specify dynamic linking and the right name mangling)
  _intel_fflags = ff.get_supported_arguments(
    '/fp:strict', '/MD', '/names:lowercase', '/assume:underscore',
    '/assume:minus0'
  )
endif
add_project_arguments(_intel_cflags, language: ['c', 'cpp'])
add_project_arguments(_intel_fflags, language: 'fortran')

# Hide symbols when building on Linux with GCC. For Python extension modules,
# we only need `PyInit_*` to be public, anything else may cause problems. So we
# use a linker script to avoid exporting those symbols (this is in addition to
# Meson using `-fvisibility=hidden` for C and `-fvisibility-inlines-hidden` for
# C++ code. See gh-15996 for details.
_linker_script = meson.project_source_root() / 'special_functions/_build_utils/link-version-pyinit.map'
version_link_args = ['-Wl,--version-script=' + _linker_script]
# Note that FreeBSD only accepts version scripts when -shared is passed,
# hence we need to pass that to `cc.links` explicitly (flag is already
# present for `extension_module` invocations).
if not cc.links('', name: '-Wl,--version-script', args: ['-shared', version_link_args])
    version_link_args = []
endif

# -------------

# Platform detection
is_mingw = is_windows and cc.get_id() == 'gcc'
if is_mingw and ff.get_id() != 'gcc'
    error('If you are using GCC on Windows, you must also use GFortran! Detected ' + ff.get_id())
endif

cython_c_args = ['-DCYTHON_CCOMPLEX=0'] # see gh-18975 for why we need this
if is_mingw
    # For mingw-w64, link statically against the UCRT.
    gcc_link_args = ['-lucrt', '-static']
    add_project_link_arguments(gcc_link_args, language: ['c', 'cpp', 'fortran'])
    # Force gcc to float64 long doubles for compatibility with MSVC
    # builds, for C only.
    add_project_arguments('-mlong-double-64', language: 'c')
    # Make fprintf("%zd") work (see https://github.com/rgommers/scipy/issues/118)
    add_project_arguments('-D__USE_MINGW_ANSI_STDIO=1', language: ['c', 'cpp'])
    # Silence warnings emitted by PyOS_snprintf for (%zd), see
    # https://github.com/rgommers/scipy/issues/118.
    # Use as c_args for extensions containing Cython code
    cython_c_args += ['-Wno-format-extra-args', '-Wno-format']
    # Flag needed to work around BLAS and LAPACK Gfortran dependence on
    # undocumented C feature when passing single character string arguments. See:
    #   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=90329
    #   https://github.com/wch/r-source/blob/838f9d5a7be08f2a8c08e47bcd28756f5d0aac90/src/gnuwin32/MkRules.rules#L121
    add_project_arguments('-fno-optimize-sibling-calls', language: ['fortran'])
endif

# Fortran warning flags
_fflag_Wno_maybe_uninitialized = ff.get_supported_arguments(
    '-Wno-maybe-uninitialized')
_fflag_Wno_unused_dummy_argument = ff.get_supported_arguments(
    '-Wno-unused-dummy-argument')

# Deal with M_PI & friends; add `use_math_defines` to c_args or cpp_args
# Cython doesn't always get this right itself (see, e.g., gh-16800), so
# explicitly add the define as a compiler flag for Cython-generated code.
is_windows = host_machine.system() == 'windows'
if is_windows
    use_math_defines = ['-D_USE_MATH_DEFINES']
else
    use_math_defines = []
endif

# Suppress warning for deprecated Numpy API.
# (Suppress warning messages emitted by #warning directives).
# Replace with numpy_nodepr_api after Cython 3.0 is out
cython_c_args += [use_math_defines]

subdir('special_functions')
