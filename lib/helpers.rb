Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file }
module Helpers
  extend ActiveSupport::Concern  
  include ActionView::Helpers
  include MyTagHelper
  include BootstrapHelper
end