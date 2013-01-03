dir = File.dirname(__FILE__).sub(%r|^\./|, '')

MRuby.each_target do
  self.libmruby << "#{build_dir}/#{dir}/mrblib_ext.o"

  file "#{build_dir}/#{dir}/mrblib_ext.o" => "#{build_dir}/#{dir}/mrblib_ext.c"
  file "#{build_dir}/#{dir}/mrblib_ext.c" => [mrbcfile] + Dir.glob("#{dir}/*.rb") do |t|
    mrbc, *rbfiles = t.prerequisites
    FileUtils.mkdir_p File.dirname(t.name)
    open(t.name, 'w') do |f|
      f.puts File.read("#{dir}/init_mrblib_ext.c")
      compile_mruby f, rbfiles, 'mrblib_ext_irep'
    end
  end
end
