#
# Cookbook Name:: oh_my_zsh
# Recipe:: default
#

git "#{node['etc']['passwd'][node['current_user']]['dir']}/.oh-my-zsh" do
  repository 'git://github.com/robbyrussell/oh-my-zsh.git'
  user node.current_user
  reference "master"
  action :sync
end

template "#{node['etc']['passwd'][node['current_user']]['dir']}/.zshrc" do
  source "zshrc.erb"
  owner node.current_user
  mode "644"
  action :create_if_missing
  variables({
    theme: node.oh_my_zsh.theme,
    case_sensitive: node.oh_my_zsh.case_sensitive,
    plugins: node.oh_my_zsh.plugins,
    sources: node.oh_my_zsh.sources
  })
end

user node['current_user'] do
  action :modify
  shell '/bin/zsh'
end

execute "fixing osx zsh environment bug" do
  command "mv /etc/{zshenv,zprofile}"
  only_if { File.exists?("/etc/zshenv") }
end
