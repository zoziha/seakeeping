# This file is part of Seakeeping

project(
    'seakeeping',
    'fortran',
    version : '1.5.0',
    license : 'BSD-3-Clause',
    default_options : [
        'buildtype=debugoptimized',
    ],
)

src = files(
    'src/seakeeping_array.f90',
    'src/seakeeping_constants.f90',
    'src/seakeeping_error.F90',
    'src/seakeeping_filesystem.F90',
    'src/seakeeping_geometry.f90',
    'src/seakeeping_kinds.F90',
    'src/seakeeping_linalg.F90',
    'src/seakeeping_math.f90',
    'src/seakeeping_statics.f90',
    'src/seakeeping_stats.f90',
    'src/seakeeping_string.f90',
    'src/seakeeping_time.f90',
    'src/seakeeping_tsa.f90',
    'src/seakeeping_units.f90',
    'src/seakeeping_utils.f90',
    'src/seakeeping_wave.f90',
)

seakeeping_lib = library(
    meson.project_name(),
    src,
    version : meson.project_version(),
    dependencies : [
        dependency('openblas'),
        dependency('openmp'),
    ],
    install : true,
)

seakeeping_inc = seakeeping_lib.private_dir_include()

seakeeping_dep = declare_dependency(
    link_with : seakeeping_lib,
    include_directories : seakeeping_inc,
)
