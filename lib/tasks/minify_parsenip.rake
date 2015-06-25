
namespace :assets do

  desc "minify parsenip assets"


  def minify_js
    Dir.glob(Rails.root.join('distribute', 'assets', 'js', '**' )).each do |original|
      name = File.basename(original)
      target = Rails.root.join('public', 'js', name).to_s
      target.gsub!(/\.js$/, '.min.js')
      File.write(target, Uglifier.compile(File.read(original)))
      puts "Compiling #{target} from #{original}"
    end
  end
  task :minify_parsenip => :environment do
    minify_js
  end
end