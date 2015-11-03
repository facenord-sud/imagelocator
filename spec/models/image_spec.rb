# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  latitude   :float(24)
#  longitude  :float(24)
#  validate   :boolean          default(FALSE)
#  comment    :text
#  image      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe Image, :type => :model do
  let(:user) {FactoryGirl.create :user}
  let(:image) {FactoryGirl.create :image}
  let(:vote) {FactoryGirl.build :vote}
  it 'has_many votes' do
    vote.user = user
    vote.image = image
    vote.save!
    expect(image.reload.votes).to contain_exactly(vote)
  end
end
