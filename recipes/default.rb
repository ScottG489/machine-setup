#
# Cookbook Name:: machine-setup
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'apt::default'

apt_repository 'cwchien-ubuntu-gradle-vivid' do
    uri 'ppa:cwchien/gradle'
    distribution 'vivid'
end
apt_repository 'mmk2410-ubuntu-intellij-idea-community-vivid' do
    uri 'ppa:mmk2410/intellij-idea-community'
    distribution 'vivid'
end
apt_repository 'hipchat' do
    uri 'https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client'
    key 'https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public'
    distribution 'vivid'
    components ['main']
end

# Required for cookbook to run
package 'git'
package 'ruby'
package 'stow'
package 'zsh'

package 'chef'
package 'docker.io'
package 'tmux'
package 'vagrant'
package 'vim'
package 'virtualbox'
package 'xorg'
package 'i3'
package 'mercurial'
package 'xbindkeys'
package 'xcompmgr'
package 'rxvt-unicode'
package 'chromium-browser'
package 'gradle'
package 'intellij-idea-community'
package 'hipchat4'
package 'remmina'
package 'alsa'

package 'virtualbox-guest-utils'
package 'virtualbox-guest-x11'
package 'virtualbox-guest-dkms'


gem_package 'tmuxinator'


user 'scott' do
  shell '/bin/zsh'
  manage_home true
  home '/home/scott'
  # TODO: This may not be necessary for any actual environment because you'll probably already have your user created
  password node['machine']['password']
end

group 'sudo' do
  members ['scott']
  append true
end
group 'docker' do
  members ['scott']
  append true
end

file '/home/scott/.bashrc' do
  action :delete
end

# TODO: In addition to below ssh stuff, the pub key needs to be in remotes's authorized_keys
directory '/home/scott/.ssh'
file '/home/scott/.ssh/id_rsa' do
  content node['machine']['id_rsa']
end
file '/home/scott/.ssh/known_hosts' do
  content node['machine']['known_hosts']
end
git 'dotfiles' do
  repository 'git@gitlab.com:ScottG489/dotfiles.git'
  destination '/home/scott/.dotfiles'
  user 'scott'
end

lxmx_oh_my_zsh_user 'scott'
file '/home/scott/.zshrc' do
  action :delete
end

directory '/home/scott/.vim/bundle' do
  recursive true
  owner 'scott'
  group 'scott'
end
git 'vundle' do
  repository 'https://github.com/VundleVim/Vundle.vim.git'
  destination '/home/scott/.vim/bundle/Vundle.vim'
  user 'scott'
end
git 'vim-airline' do
  repository 'https://github.com/bling/vim-airline.git'
  destination '/home/scott/.vim/bundle/vim-airline'
  user 'scott'
end
git 'vim-colors-solarized' do
  repository 'https://github.com/altercation/vim-colors-solarized.git'
  destination '/home/scott/.vim/bundle/vim-colors-solarized'
  user 'scott'
end
git 'vim-easymotion' do
  repository 'https://github.com/Lokaltog/vim-easymotion.git'
  destination '/home/scott/.vim/bundle/vim-easymotion'
  user 'scott'
end
git 'vim-fugitive' do
  repository 'https://github.com/tpope/vim-fugitive.git'
  destination '/home/scott/.vim/bundle/vim-fugitive'
  user 'scott'
end
git 'vim-sensible' do
  repository 'https://github.com/tpope/vim-sensible.git'
  destination '/home/scott/.vim/bundle/vim-sensible'
  user 'scott'
end

execute 'stow_dotfiles' do
  command 'stow -S *'
  cwd '/home/scott/.dotfiles'
end

directory '/home/scott' do
  owner 'scott'
  group 'scott'
  recursive true
end

directory '/mnt/windows'
mount '/mnt/windows' do
    device 'D_DRIVE'
    fstype 'vboxsf'
    options 'umask=0022,gid=scott,uid=scott'
    action :enable
end
# TODO: Isn't working for some reason
#mount '/mnt/windows'

# TODO: Commented out for now cuz seemingly slow.
#chef_dk 'my_chef_dk'
