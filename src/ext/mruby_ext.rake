dir = File.dirname(__FILE__).sub(%r|^\./|, '')

MRuby.each_target do
  objs = Dir.glob("src/ext/*/*.{c}").map { |f| f.pathmap("#{build_dir}/%X.o") }
  self.libmruby << objs

  file "#{build_dir}/lib/libmruby_core.a" => objs do |t|
    archiver.run t.name, t.prerequisites
  end
end
