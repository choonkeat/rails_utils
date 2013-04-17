require 'action_view'

module RailsUtils
  module ActionViewExtensions
    def page_class
      "#{page_controller_class} #{page_action_class}"
    end

    def javascript_initialization
      application_name = Rails.application.class.parent_name

      javascript_tag <<-JS
        #{application_name}.init();
        if(#{application_name}.#{page_controller_class}) {
          if(#{application_name}.#{page_controller_class}.init) { #{application_name}.#{page_controller_class}.init(); }
          if(#{application_name}.#{page_controller_class}.init_#{page_action_class}) { #{application_name}.#{page_controller_class}.init_#{page_action_class}(); }
        }
      JS
    end

    def flash_messages
      html = ""
      flash.each do |key, message|
        html <<
          content_tag(:div, class: "#{flash_class(key)} fade in") do
            content = ""
            content << content_tag(:button, "x", type: "button", class: "close", "data-dismiss-alert" => "alert")
            content << content_tag(:p, message)
            content.html_safe
          end
      end
      html
    end

    private

    def page_controller_class
      controller.controller_name
    end

    def page_action_class
      class_mappings = { "create" => "new", "update" => "edit" }
      class_mappings[controller.action_name] || controller.action_name
    end

    def flash_class(key)
      case key
        when :success
          "alert alert-success"
        when :notice
          "alert alert-info"
        when :error
          "alert alert-error"
        when :alert
          "alert alert-error"
        else
          "alert alert-#{key}"
      end
    end
  end
end

ActionView::Base.send :include, RailsUtils::ActionViewExtensions