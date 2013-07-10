require 'action_view'
require 'lib/helpers'

class ViewContext
  include ActionView::Context
  include Helpers

  attr_reader :builder
  def app
    builder.app
  end
  def initialize builder
    @builder = builder
  end

  def protect_against_forgery?
    false
  end
end