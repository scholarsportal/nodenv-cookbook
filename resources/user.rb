unified_mode true

property :git_revision, String, default: 'HEAD'
property :git_url, String, default: 'https://github.com/nodenv/nodenv.git'
property :group, String
property :nodenv_root, String, default: lazy { ::File.join ::File.expand_path("~#{owner}"), '.nodenv' }
property :owner, String, name_property: true
deprecated_property_alias :user, :owner,
                          'User property is deprecated. Use owner instead'

action :install do
  node.run_state['root_path'] = new_resource.nodenv_root

  git_client 'default'

  # git root_path do
  #   repository new_resource.git_url
  #   revision new_resource.git_revision
  #   user new_resource.owner
  #   group new_resource.group if new_resource.property_is_set?(:group)
  #   action :checkout
  #   not_if { ::File.exist? nodenv_bin_file }
  # end

  directory root_path do
    user new_resource.owner
    group new_resource.group if new_resource.property_is_set?(:group)
    mode '0755'
  end

  remote_file "v1.4.0.tar.gz" do
    source "https://nexus.scholarsportal.info/repository/github/nodenv/nodenv/archive/refs/tags/v1.4.0.tar.gz"
    owner new_resource.owner
    group new_resource.group if new_resource.property_is_set?(:group)
    mode '0755'
    notifies :run, 'execute[extract_nodenv_tar]', :immediately
    action :create
    not_if { ::File.exist? nodenv_bin_file }
  end

  execute 'extract_nodenv_tar' do
    command "gunzip -c v1.4.0.tar.gz | tar -xf - -C #{root_path} "\
    '--strip-components 1'
    action :nothing
  end

  template '/etc/profile.d/nodenv.sh' do
    source 'nodenv.sh.erb'
    owner 'root'
    mode '0755'
    cookbook 'nodenv'
  end

  node_build_plugin_install ::File.join(nodenv_plugins_path, 'node-build') do
    owner new_resource.owner
    group new_resource.owner
  end
end

action_class do
  include Chef::Nodenv::ScriptHelpers
end
