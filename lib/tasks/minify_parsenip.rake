
namespace :assets do

  desc "minify parsenip assets"

  def minify_js
    Dir.glob(Rails.root.join('distribute', 'assets', 'js', '**' )).each do |original|
      name = File.basename(original)
      target = Rails.root.join('public', 'js', name).to_s
      target.gsub!(/\.js$/, '.min.js')
      if Rails.env.development?
        File.write(target, File.read(original))
      else
        File.write(target, Uglifier.compile(File.read(original)))
      end
      puts "[JS] Compiling #{target} from #{original}"
    end
  end
  def minify_css
    Dir.glob(Rails.root.join('distribute', 'assets', 'css', '**' )).each do |original|
      name = File.basename(original)
      target = Rails.root.join('public', 'css', name).to_s
      target.gsub!(/\.scss$/, '.min.css')

      File.write(target, Sass.compile_file(original, {style: :compressed}))
      puts "[CSS] Compiling #{target} from #{original}"
    end
  end
  task :minify_parsenip => :environment do
    minify_js
    minify_css
  end
end