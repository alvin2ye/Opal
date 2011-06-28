Factory.define :admin, :class => User do |o|
  o.first_name 'Bob'
  o.last_name  'Jones'
  o.username   'admin'
  #o.sequence(:username) { |n| "admin#{n}" }  
  o.password   'admin'
  o.email      'admin@test.com'
  #o.sequence(:email) { |n| "admin#{n}@test.com" }  
  o.is_admin   '1'  
  o.locale     'en'
end

Factory.define :user do |o|
  o.first_name 'John'
  o.last_name  'Doe'
  o.username   'test'
  #o.sequence(:username) { |n| "test#{n}" }  
  o.password   'test'
  o.email      'test@test.com'
  #o.sequence(:email) { |n| "test#{n}@test.com" }  
  o.is_admin   '0'  
  o.locale     'en'
end

Factory.define :new_user, :parent => :user  do |o|
  o.sequence(:username) { |n| "test#{n}" }  
  o.sequence(:email) { |n| "test#{n}@test.com" }  
end

Factory.define :category do |o|
  o.sequence(:name) { |n| "Category #{n}" }  
end

Factory.define :group do |o|
  o.sequence(:name) { |n| "Group #{n}" }  
end

Factory.define :item do |o|
  o.sequence(:name) { |n| "Item #{n}" }
  o.description   "This is a test desciption!"
  o.association   :category, :factory => :category
  o.association   :user, :factory => :new_user
  #o.user_id       Factory.build(:user).id
  o.is_public     "1"
  o.is_approved   "1"
  o.featured      true
  o.locked        false
  o.views         20
  o.recent_views  10
end

Factory.define :item_with_plugins, :parent => :item do |o|
  o.after_build do |o|
    o.plugin_comments = [Factory(:plugin_comment, :item => o)]
    o.plugin_descriptions = [Factory(:plugin_description, :item => o)]
    o.plugin_discussions = [Factory(:plugin_discussion, :item => o)]
    o.plugin_discussion_posts = [Factory(:plugin_discussion_post, :item => o)]
    o.plugin_feature_values = [Factory(:plugin_feature_value, :item => o)]    
    o.plugin_files = [Factory(:plugin_file, :item => o)]
    o.plugin_images = [Factory(:plugin_image, :item => o)]    
    o.plugin_links = [Factory(:plugin_link, :item => o)]    
    o.plugin_reviews = [Factory(:plugin_review, :item => o)]    
    o.plugin_tags = [Factory(:plugin_tag, :item => o)]    
    o.plugin_videos = [Factory(:plugin_video, :item => o)]        
  end
end

Factory.define :page do |o|
  o.association   :user, :factory => :new_user
  o.published     true
  o.title         "Test Page"
  o.description   "This is a test description"
  o.content       '<div style="text-align: center;">This is some test content!</div>' 
end

Factory.define :plugin_image do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.url           "/path/to/image"
end


Factory.define :plugin_comment do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.comment       "This is a test comment."
end

Factory.define :plugin_description do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.title
  o.content
end

Factory.define :plugin_discussion_post do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.association   :plugin_discussion, :factory => :plugin_discussion
  o.post          "This is a test post."
end

Factory.define :plugin_discussion do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.title         "Test Discussion"
  o.description
  o.is_sticky
  o.is_closed
end

Factory.define :plugin_feature_value_option do |o|
  o.association :plugin_feature, :factory => :plugin_feature
  o.association :user, :factory => :new_user
  o.value
  o.description
end

Factory.define :plugin_feature_value do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.association   :plugin_feature, :factory => :plugin_feature
  o.value         "Test Value"
  o.is_approved   "1"
end

Factory.define :plugin_feature do |o|
  o.association   :user, :factory => :new_user
  o.name          "Test Feature"
  o.feature_type  "Text"
end

Factory.define :plugin_file do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.title         "Test Title"
  o.filename      "testfilename.txt"
  o.downloads     0
end

Factory.define :plugin_link do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.title         "Test Link"
  o.url           "http://localhost"
end

Factory.define :plugin_review_vote do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.association   :plugin_review, :factory => :plugin_review
  o.is_approved   "1"
  o.score         1
end

Factory.define :plugin_review do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.review_score  3.5
  o.review        "This is a test review"
  o.useful_score  10
  o.vote_score    11
end

Factory.define :plugin_tag do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"
  o.name          "Tag"
end

Factory.define :plugin_video do |o|
  o.association   :item, :factory => :item
  o.association   :user, :factory => :new_user
  o.is_approved   "1"  
  o.title         "Test Video"
  o.description   "This is a test description"
  o.code          '<div style="text-align: center;"><iframe width="560" height="349" src="http://www.youtube.com/embed/4kIKynSUbJw" frameborder="0" allowfullscreen></iframe></div>' 
end
