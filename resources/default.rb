ZfsBoolean = proc do |val|
  case val
  when true then 'on'
  when false then 'off'
  end
end

property :name,           String, name_attribute: true
property :mountpoint,     [String, nil], default: nil
property :recordsize,     [String, nil], default: nil
property :atime,          ['on', 'off', nil], default: nil, coerce: ZfsBoolean
property :devices,        ['on', 'off', nil], default: nil, coerce: ZfsBoolean
property :exec,           ['on', 'off', nil], default: nil, coerce: ZfsBoolean
property :setuid,         ['on', 'off', nil], default: nil, coerce: ZfsBoolean
property :xattr,          ['on', 'off', nil], default: nil, coerce: ZfsBoolean
property :compression,    ['on', 'off', 'lzjb', 'gzip', 'gzip-1', 'gzip-2', 'gzip-3', 'gzip-4', 'gzip-5', 'gzip-6', 'gzip-7', 'gzip-8', 'gzip-9', 'lz4', nil], default: nil
property :quota,          String, default: 'none'
property :refquota,       String, default: 'none'
property :reservation,    String, default: 'none'
property :refreservation, String, default: 'none'
property :dedup,          ['on', 'off', nil], default: nil, coerce: ZfsBoolean
# property :usedbydataset,  String, desired_state: false

action_class do
  def whyrun_supported?
    true
  end
end

def zfs_exist?(name)
  !shell_out("zfs list -H").stdout.lines.grep(/^#{name}\t/).empty?
end

def zfs_each_prop(name)
  shell_out("zfs get -H all #{name}").stdout.each_line do |props|
    yield props.chomp.split(/\t/)
  end
end

load_current_value do
  current_value_does_not_exist! unless zfs_exist?(name)

  zfs_each_prop(name) do |fs, prop, val, source|
    if self.class.properties[prop.to_sym] && source == 'local'
      send(prop, val)
    end
  end
end

action :create do
  # FIXME: not supported yet. I think we need to separate resource name from filesystem name to detect this
  # converge_if_changed :name do
  #   shell_out("zfs rename #{current_resource.name} #{new_resource.name}")
  # end unless current_resource.nil?g

  converge_if_changed do
    if current_resource.nil?
      args = []
      new_resource.class.properties.each do |name, prop|
        value = send(name)

        next if name == :name
        next if prop.has_default? && prop.default == value

        args << "-o #{name}=#{value}"

      end

      shell_out("zfs create #{args.join(' ')} #{name}")
    else
      zfs_each_prop(name) do |fs, prop, current_value, source|
        property_name = prop.to_sym
        property      = new_resource.class.properties[property_name]

        next if property.nil?

        desired_value = send(property_name)

        if property.has_default? && property.default == desired_value
          next
        elsif desired_value.nil? && source !~ /^(default|inherited)/
          shell_out("zfs inherit #{prop} #{name}")
        elsif desired_value != current_value
          shell_out("zfs set #{prop}=#{desired_value} #{name}")
        end
      end
    end
  end
end

action :destroy do
  if zfs_exist?(name)
    converge_by "destroy ZFS filesystem #{name.inspect}" do
      shell_out("zfs destroy #{name}")
    end
  end
end
