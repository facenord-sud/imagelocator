# -*- encoding : utf-8 -*-
class NotificationSystem::Save

  def self.perform(class_name, method_name, values, owners)
    if owners.is_a? Array
      owners.each do |user|
        AppNotification.create(class_name: class_name, method_name: method_name, values: values, user: user)
      end
    elsif owners.is_a? User
      AppNotification.create(class_name: class_name, method_name: method_name, values: values, user: owners)
    end
  end
end
