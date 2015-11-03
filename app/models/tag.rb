# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base

  #translates :name, fallbacks_for_empty_translations: true

  has_and_belongs_to_many :images
  has_and_belongs_to_many :users

  def self.search(search_criteria)
    #with_translations.where('name LIKE ?', "#{search_criteria}%").order('name ASC')
    where('name LIKE ?', "#{search_criteria}%").order('name ASC')
  end

end
