include_recipe 'apt'

apt_repository 'zfs' do
  uri 'ppa:zfs-native/stable'
  distribution node['lsb']['codename']
end

package "linux-headers-#{node[:kernel][:release]}"
package 'ubuntu-zfs'

kernel_module 'zfs'
