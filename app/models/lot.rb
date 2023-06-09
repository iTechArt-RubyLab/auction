class Lot < ApplicationRecord
  belongs_to :user
  belongs_to :winner, class_name: 'User', optional: true
  has_many :bids, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  scope :without_winner, -> { where(winner: nil) }
  validates :name, :description, presence: true

  def tags=(value)
    value = value.split(', ').map(&:strip) if value.is_a?(String)
    super(value)
  end

  def self.find_by(tags:)
    array_of_tags = PG::TextEncoder::Array.new.encode(tags)
    where('tags ?| :tags', tags: array_of_tags)
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end

  def owned_by?(user)
    self.user == user
  end
end
