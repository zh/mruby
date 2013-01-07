##
# File Test

if Object.const_defined?(:File)
  assert('File') do
    File.class == Class
  end

  if ENV['HOME']
    assert('File.expand_path') do
      home = (File.expand_path("~/") == ENV['HOME'])
      home_base = (File.expand_path("~/", ".") == ENV['HOME'])

      Regexp.compile("\\A(.+)\/[^\/]+$") =~ ENV['HOME']
      parent_path = $1
      parent = ((File.expand_path("~/..") == parent_path))

      absolute = (File.expand_path("/home") == "/home")
      absolute_base = (File.expand_path("/home", ".") == "/home")

      relative_base = (File.expand_path("user", ENV['HOME']) == "#{ENV['HOME']}/user")

      home && home_base && parent && absolute && absolute_base && relative_base
    end

  end

end

