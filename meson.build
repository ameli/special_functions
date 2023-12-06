project('special_functions', 'c', 'cython')

py_mod = import('python')
py3 = py_mod.find_installation(pure: false)
py3_dep = py3.dependency()

cc = meson.get_compiler('c')
cy = meson.get_compiler('cython')
# generator() doesn't accept compilers, only found programs - cast it.
cython = find_program(cy.cmd_array()[0])

# Check compiler is recent enough (see "Toolchain Roadmap" for details)
# if cc.get_id() == 'gcc'
#   if not cc.version().version_compare('>=8.0')
#   ¦ error('special_functions requires GCC >= 8.0')
#   endif
# elif cc.get_id() == 'msvc'
#   if not cc.version().version_compare('>=19.20')
#   ¦ error('special_functions requires at least vc142 (default with ' + \
#           'Visual Studio 2019) when building with MSVC')
#   endif
# endif
# if not cy.version().version_compare('>=0.29.35')
#   error('special_functions requires Cython >= 0.29.35')
# endif

# _global_c_args = cc.get_supported_arguments(
#   '-Wno-unused-but-set-variable',
#   '-Wno-unused-function',
#   '-Wno-conversion',
#   '-Wno-misleading-indentation',
# )
# add_project_arguments(_global_c_args, language : 'c')

# We need -lm for all C code (assuming it uses math functions, which is safe to
# assume for SciPy). For C++ it isn't needed, because libstdc++/libc++ is
# guaranteed to depend on it. For Fortran code, Meson already adds `-lm`.
# m_dep = cc.find_library('m', required : false)
# if m_dep.found()
#   add_project_link_arguments('-lm', language : 'c')
# endif

# Adding at project level causes many spurious -lgfortran flags.
add_languages('fortran', native: false)
ff = meson.get_compiler('fortran')
if ff.has_argument('-Wno-conversion')
  add_project_arguments('-Wno-conversion', language: 'fortran')
endif

if host_machine.system() == 'darwin' and \
    cc.has_link_argument('-Wl,-ld_classic')
  # New linker introduced in macOS 14 not working yet, see gh-19357, gh-19387
  add_project_link_arguments('-Wl,-ld_classic', language : ['c', 'fortran'])
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


subdir('special_functions')
