# This file is part of Seakeeping
project(
    'seakeeping',
    'fortran',
    version : '2.0.0',
    license : 'BSD-3-Clause',
    license_files : 'LICENSE',
    default_options : [
        'buildtype=debugoptimized',
        'fortran_std=f2008',
        'default_library=both',
    ],
)
seakeeping_src_filenames = []
seakeeping_src = files()
subdir('src')
seakeeping_lib = library(
    meson.project_name(),
    seakeeping_src,
    version : meson.project_version(),
    install : true,
)
seakeeping_inc = seakeeping_lib.private_dir_include()
seakeeping_dep = declare_dependency(
    link_with : seakeeping_lib,
    include_directories : seakeeping_inc,
)
seakeeping_lic = files('LICENSE')
install_data(
    seakeeping_lic,
    install_dir : join_paths(get_option('prefix'), 'share', 'licenses', meson.project_name()),
)
if host_machine.system() == 'windows'
    symbols_file = 'lib'+meson.project_name()+'-'+meson.project_version().split('.')[0]+'.dll.symbols'
    obj_suffix = '.obj'
else
    symbols_file = 'lib'+meson.project_name()+'.so.'+meson.project_version()+'.symbols'
    obj_suffix = '.o'
endif
seakeeping_obj = []
foreach source: seakeeping_src_filenames
    seakeeping_obj += 'src_'+source+obj_suffix
endforeach
install_subdir(
    seakeeping_lib.path()+'.p',
    install_dir: 'include'/meson.project_name(),
    strip_directory: true,
    exclude_files: [
        'depscan.dd',
        meson.project_name()+'-deps.json',
        symbols_file,
        meson.project_name()+'.dat',
        seakeeping_obj,
    ]
)
pkg = import('pkgconfig')
pkg.generate(
    name : meson.project_name(),
    description : 'Seakeeping Routines for Naval Architecture and Ocean Engineering',
    version : meson.project_version(),
    libraries : seakeeping_lib,
    subdirs : meson.project_name(),
)