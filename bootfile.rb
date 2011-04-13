class BlacklightExtEadSimple
  def self.boot_up  
    Rails::Initializer.run do |config|
      config.gem 'eadsax', :version => '0.0.0'    
    end
  end
end
