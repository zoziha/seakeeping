testdrive_dep = dependency('test-drive', required: false, method: 'pkg-config')
if not testdrive_dep.found()
    testdrive_dep = subproject('test-drive').get_variable('testdrive_dep')
endif

test_src = files(
    'test_seakeeping_leapfrog.f90',
    'test_seakeeping_collection.f90',
    'test_seakeeping_wave.f90',
)

test_lib = static_library(
    'test-lib',
    sources: test_src,
    link_with: seakeeping_lib,
    dependencies: testdrive_dep,
)

test(
    'func_api',
    executable(
        'tester',
        'tester.f90',
        link_with: test_lib,
        dependencies: testdrive_dep,
    )
)
