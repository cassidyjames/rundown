project('com.github.cassidyjames.rundown', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

executable(
  meson.project_name(),
  'src/Application.vala',
  'src/MainWindow.vala',
  'src/Utils/Inhibitor.vala',
  dependencies: [
    dependency('granite'),
    dependency('gtk+-3.0'),
  ],
  install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')

