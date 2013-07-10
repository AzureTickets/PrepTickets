module BootstrapHelper
  extend ActiveSupport::Concern
  
  def link_to_btn name, path='#', options={}
    icon_class = ""
    icon_class = "icon-#{options.delete(:icon)}" if options[:icon].present?
    icon_class += " icon-white" if options.delete(:white).present?
    type = options.delete(:type)
    klass = extract_class(options.delete(:class))
    klass << 'btn'
    klass << "btn-#{type}" if type
    klass << "btn-#{options.delete(:size)}" if options[:size]
    options[:class] = compact_class klass
    link_to path, options do
      raw("#{content_tag(:i, "", :class => icon_class)} #{name}")
    end
  end
  def bs_label text, options={}
    type = options.delete(:type)
    klass = extract_class(options.delete(:class))
    klass << "label"
    klass << "label-#{type}" if type
    options[:class] = compact_class klass
    content_tag :div, options  do
      text
    end
  end

  #######
  private
  #######
  
  def extract_class(class_string = nil)
    (class_string || "").split " "
  end
  def compact_class(klass=[])
    klass.compact.uniq.join(" ")
  end
end