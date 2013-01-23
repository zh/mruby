MRuby.each_target do
  dir = File.dirname(__FILE__).relative_path_from(root)
  self.libmruby << "#{build_dir}/#{dir}/mrblib_ext.o"

  file "#{build_dir}/#{dir}/mrblib_ext.o" => "#{build_dir}/#{dir}/mrblib_ext.c"
  file "#{build_dir}/#{dir}/mrblib_ext.c" => [mrbcfile] + Dir.glob("#{dir}/*.rb") do |t|
    mrbc_, *rbfiles = t.prerequisites
    FileUtils.mkdir_p File.dirname(t.name)
    open(t.name, 'w') do |f|
      _pp "GEN", "*.rb", "#{t.name}"
      f.puts File.read("#{dir}/init_mrblib_ext.c")
      mrbc.run f, rbfiles, 'mrblib_ext_irep'
    end
  end
end
