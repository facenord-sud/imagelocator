# == Schema Information
#
# Table name: app_notifications
#
#  id          :integer          not null, primary key
#  class_name  :string(255)
#  method_name :string(255)
#  values      :string(255)
#  is_viewed   :boolean          default(FALSE)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe AppNotification, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:u2) { FactoryGirl.create(:user) }

  it 'has an user with a notification' do
    UserNotifications.create!(
        :hello_world, #la méthode de la notif
        ['numa'], # les paramètres de la notification
        user
    )
    expect(user.notifications.first.print_message).to include 'numa'
  end
  it 'has an array of users with a notification with more than one param' do
    # You save which class, method and params to call for printing the notification message
    UserNotifications.create!(
        :hello_world2, #la méthode de la notif
        ['numa', 'tibo'], # les paramètres de la notification
        [user, u2]
    )
    puts user.notifications.inspect
    # The message printed is from the class userNotification and the method hello_world2
    expect(user.notifications.first.print_message).to include 'numa', 'tibo'
  end
end
