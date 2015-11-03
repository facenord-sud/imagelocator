# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  points                 :integer          default(15)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  quality_rate           :float(24)        default(1.0)
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) {FactoryGirl.create :user}
  let(:image) {FactoryGirl.create :image}
  let(:vote) {FactoryGirl.build :vote}

  it 'has_many uploaded images' do
    user.uploaded_images << image
    user.save!
    expect(user.reload.uploaded_images).to contain_exactly image
  end

  it 'has_many votes' do
    vote.user = user
    vote.image = image
    vote.save
    expect(user.votes).to contain_exactly vote
  end

  it 'has_many voted images' do
    vote.user = user
    vote.image = image
    vote.save
    expect(user.voted_images).to contain_exactly image
  end

  it 'has_many images to vote' do
    i1 = FactoryGirl.create(:image)
    i2 = FactoryGirl.create(:image)
    v1 = FactoryGirl.build(:vote)
    v2 = FactoryGirl.build(:vote)
    v3 = FactoryGirl.build(:vote)
    u2 = FactoryGirl.create(:user)
    v3.image = i1
    v3.user = u2
    v3.save!
    v1.image = i1
    v1.user = user
    v1.save!
    v2.user = u2
    v2.image = i2
    v2.save!
    expect(user.images_to_locate).to contain_exactly(i2)
  end
end
