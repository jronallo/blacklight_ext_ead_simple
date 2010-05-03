unless File.exists? 'vendor/plugins/blacklight'
  puts "The Blacklight Simple EAD Plugin requires that Blacklight be installed first"
  if yes?("Install Blacklight from a template ?")
    run "rake rails:template LOCATION=http://github.com/projectblacklight/blacklight/raw/master/template.rb"
  else
    puts "****ERROR: The Blacklight Simple EAD Plugin requires that Blacklight be installed first"
    exit 0
  end  
end
puts "\n* Blacklight Extension for Simple EAD Rails Template \n\n"

plugin_dirname = 'blacklight_ext_ead_simple'

tag = nil

# plugin 'blacklight_ext_ead_simple', :git => 'git://github.com/foo/bar.git'

# run "cp #{RAILS_ROOT}/vendor/blacklight_ext_ead_simple/assets/stylesheets/blacklight_ext_ead_simple.css  #{RAILS_ROOT}/public/stylesheets/."

