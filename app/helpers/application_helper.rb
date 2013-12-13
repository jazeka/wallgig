module ApplicationHelper
  ALERT_TYPES = [:danger, :info, :success, :warning]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?
      
      type = :success if type == :notice
      type = :danger  if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def container_class_for(controller_name, action_name)
    case [controller_name, action_name]
    when ['wallpapers', 'index'],
         ['wallpapers', 'show'],
         ['users', 'show'] then
      'container-full'
    end
  end

  def gravatar_url(user, size = 200)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=identicon&s=#{size}"
  end

  def irc_url_for_user(user)
    url = "https://qchat.rizon.net/?channels=wallgig&prompt=1"
    url << "&nick=#{user.username.parameterize}" if user.present?
    url
  end

end
