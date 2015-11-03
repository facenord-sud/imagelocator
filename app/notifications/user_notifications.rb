# You can use the I18n t and l methods to translate, as well routes and link helpers
class UserNotifications < NotificationSystem::Base
  def hello_world(name)
    "hello #{name}!"
  end

  def hello_world2(numa, tibo)
    "hello #{numa} and #{tibo}"
  end

  # todo display image in small? Or link to image? Please, not too complicated! A link is ok, just depends how it's represented!
  def image_located(image_id)
    if Image.exists?(image_id)
      "<a href='#{eval("root_#{I18n.locale}_path")}/images/#{image_id}'>#{t('notifications.content')}</a>"
    else
      t('notifications.img_deleted')
    end
  end

end