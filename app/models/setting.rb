class Setting < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name, :value
  
  class << self # open up metaclass  
    attr_accessor :global_settings # Setting.global_settings
  end     
  
  def validate
  end

  def self.get_setting(name) # get a setting from the database, usually text-based string
    setting = Setting.find_by_name(name)
    return setting.to_s
  rescue # ActiveRecord not found
    return ""
  end
  
  def self.get_setting_bool(name) # get a setting from the database return true or false depending on "1" or "0"
    setting = Setting.find_by_name(name)
	setting.to_bool
  rescue # ActiveRecord not found
    return false
  end
  
  
  def self.get_global_settings
    logger.info "Retrieving global settings."
    
    setting_array = Setting.all # get ALL settings
    
    # Convert 
    setting = setting_array.hash_by(:name, :to_value) # convert array to hash, indexed by name, value by to_value
	setting[:title] = setting[:site_title]
	setting[:description] = setting[:site_description]
    setting[:theme_url] =  "/themes/#{setting[:theme]}" # url for theme directory
    setting[:themes_dir] =  File.join(Rails.root.to_s, "public", "themes") # system path for main themes directory 
    setting[:theme_dir] =  File.join(setting[:themes_dir], setting[:theme]) # system path for current theme directory 
    setting[:default_preview_type] =  setting[:default_preview_type].constantize
    return setting
  end
  
  def to_param # make custom parameter generator for friendly urls
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  def title
    return I18n.t("activerecord.records.setting.#{self.name.downcase}.title", :default => self.name.humanize)
  end
  
  def description
    return I18n.t("activerecord.records.setting.#{self.name}.description", :default => "")
  end  
  
  def to_bool
  	value == "1"
  end
  
  def to_s
  	value
  end
  
  def to_value # return a value based on setting type
  	item_type == "bool" ? to_bool : to_s 
  end 
  	
  self.global_settings = Setting.get_global_settings if table_exists? # load global settings into metaclass variable  
end
