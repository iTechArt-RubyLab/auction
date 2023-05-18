class Lot < ApplicationRecord
  belongs_to :user
  has_many_attached :images, dependent: :destroy
  validates :name, :description, presence: true

  def tags=(value)
    value = value.split(', ').map(&:strip) if value.is_a?(String)
    super(value)
  end

  def self.find_by_tags(tags)
    array_of_tags = PG::TextEncoder::Array.new.encode(tags)
    where('tags ?| :tags', tags: array_of_tags)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
