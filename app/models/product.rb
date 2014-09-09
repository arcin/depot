class Product < ActiveRecord::Base
  has_many :line_items

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  scope :latest, ->{ order(:updated_at).last }

  before_destroy :ensure_not_referenced_by_any_line_item

  private
    def ensure_not_referenced_by_any_line_item
      return true if line_items.empty?

      errors.add(:base, 'Line Items present')
      false
    end
end
