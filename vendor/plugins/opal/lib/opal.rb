require "opal/plugin_support"
require "opal/action_view"
require "opal/active_record"

ActionView::Base.send :include, Opal::ActionView::Base
ActionView::Base.send :include, Opal::ActionView::Helpers::FormHelper

ActiveRecord::Base.send :include, Opal::ActiveRecord::Base::InstanceMethods
ActiveRecord::Base.send :extend, Opal::ActiveRecord::Base::ClassMethods