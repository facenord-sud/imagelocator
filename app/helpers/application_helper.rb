module ApplicationHelper
  def print_unread_notifications
    return unless user_signed_in?
    notifications_size = current_user.notifications.where(is_viewed: false).size
    # todo: update with the current_path method
    # ie: current_page?(:controller => 'users', :action => 'index')
    if notifications_size > 0 and request.fullpath != user_notifications_path(current_user)
      "<li><a href='#{user_notifications_path(current_user)}'>#{t('header.notifications', size: notifications_size)}</a></li>".html_safe
    end
  end

  def title(text)
    generate_meta :title, text
  end

  def key_words(text)
    generate_meta :key_words, text
  end

  def description(text)
    generate_meta :description, text
  end

  def change_lang
    result = {}
    I18n.available_locales.each do |l|
      next if l == I18n.locale
      l = l.to_s
      language_params = params
      language_params['locale'] = l
      result[l] =  url_for(language_params)
    end
    result
  end

  private
    def generate_meta(meta, text = '')
      if text.blank?
        return find_translations meta
      end
      text
    end

    def find_translations(meta)
      translation = []
      translation << meta.to_s
      action_name = params[:action]
      action_name = 'new' if action_name == 'create'
      action_name = 'edit' if action_name == 'edit'
      translation << action_name
      resource = params[:controller].split('/')
      translation << resource[1]
      translation << resource[0]
      translation.reverse!.reject! {|term| term.blank?}
      logger.debug "looking translation for SEO in: #{translation.join '.'}"
      t(translation.join('.'), default: t("default_#{meta.to_s}"))
    end
end
