# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  latitude   :float(24)
#  longitude  :float(24)
#  validate   :string(255)      default("pending")
#  comment    :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  image_id   :integer
#

require 'rails_helper'

RSpec.describe Vote, :type => :model do
  let(:user) {FactoryGirl.create :user}
  let(:image) {FactoryGirl.create :image}
  let(:vote) {FactoryGirl.build :vote}

end
