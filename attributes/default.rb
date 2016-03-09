default['idea']['setup_dir'] = '/opt/idea'
default['idea']['version'] = '15.0.4'
# TODO: I don't like how the cookbook in general is overwriting the default idea64.vmoptions file
default['idea']['64bits']['Xms'] = '128m'
default['idea']['64bits']['Xmx'] = '750m'

default['java']['jdk_version'] = '7'
