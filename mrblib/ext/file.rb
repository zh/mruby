class File < IO
  include Enumerable

  class FileError < Exception; end
  class NoFileError < FileError; end
  class UnableToStat < FileError; end
  class PermissionError < FileError; end

  def initialize(fd_or_path, mode = "r", perm = 0666)
    if fd_or_path.kind_of? Integer
      super(fd_or_path, mode)
      path = nil
    else
      path = fd_or_path

      fd = IO.sysopen(path, mode, perm)
      if fd < 0
        begin
          Errno.handle path
        rescue Errno::EMFILE
          GC.run(true)

          fd = IO.sysopen(path, mode, perm)
          Errno.handle if fd < 0
        end
      end

      super(fd, mode)
    end
  end

  def self.join(*names)
    if names.size == 0
      ""
    elsif names.size == 1
      names[0]
    else
      if names[0][-1] == File::SEPARATOR
        s = names[0][0..-2]
      else
        s = names[0].dup
      end
      (1..names.size-2).each { |i|
        t = names[i]
        if t[0] == File::SEPARATOR and t[-1] == File::SEPARATOR
	  t = t[1..-2]
        elsif t[0] == File::SEPARATOR
	  t = t[1..-1]
        elsif t[-1] == File::SEPARATOR
	  t = t[0..-2]
        end
        s += File::SEPARATOR + t if t != ""
      }
      if names[-1][0] == File::SEPARATOR
        s += File::SEPARATOR + names[-1][1..-1]
      else
        s += File::SEPARATOR + names[-1]
      end
      s
    end
  end

  def self.expand_path(path, default_dir = '.')
    def concat_path(path, base_path)
      own_home_path = Regexp.compile('\\A~(/.*)?\\z')
      other_home_path = Regexp.compile('\\A~([^/]+)(/.*)?\\z')
      absolute_path = Regexp.compile('\\A/.*')
      relative_path = Regexp.compile('\\A[^/]')

      if own_home_path =~ path
        dir = $1
        expanded_path = ENV['HOME']

        unless expanded_path
          raise ArgumentError, "couldn't find HOME environment -- expanding '~'"
        end

        expanded_path += dir if dir
        expanded_path += "/"
      elsif other_home_path =~ path
        user = $1
        dir = $2
        pwnam = _getpwnam(user)

        unless pwnam
          raise ArgumentError, "user #{user} doesn't exist"
        end

        expanded_path = pwnam.dir
        expanded_path += dir if dir
        expanded_path += "/"
      elsif absolute_path =~ path
        expanded_path = path
      else relative_path =~ path
        expanded_path = concat_path(base_path, _getwd)
        expanded_path += "/#{path}"
      end

      expanded_path
    end

    expanded_path = concat_path(path, default_dir)
    expand_path_array = []
    expanded_path = expanded_path.gsub(/\/{2,}/, '/')

    if expanded_path == "/"
      expanded_path
    else
      expanded_path.split('/').each do |path_token|
        if path_token == '..'
          if expand_path_array.size > 1
            expand_path_array.pop
          end
        elsif path_token == '.'
          # nothing to do.
        else
          expand_path_array << path_token
        end
      end

      if expand_path_array.size == 1
        expand_path_array << ''
      end

      expand_path_array.join("/")
    end
  end

  def self._getpwnam(user)
    Struct.new("Passwd", :name, :password, :uid, :gid, :gecos, :dir, :shell)

    pwd = nil
    File.open("/etc/passwd", "r") do |f|
      f.each_line do |line|
        if line =~ Regexp.compile('^(.+?):(.+?):(.+?):(.+?):(.+?):(.+?):(.+?)$')
          if $1 == user
            pwd = Struct::Passwd.new($1, $2, $3, $4, $5, $6, $7)
            break
          end
        end
      end
    end

    pwd
  end

end
