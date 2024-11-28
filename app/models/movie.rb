class Movie < ApplicationRecord
  has_many :bookmarks, dependent: :restrict_with_error

  validates :title, uniqueness: true, presence: true
  validates :overview, presence: true

  before_destroy :check_for_bookmarks

  private

  def check_for_bookmarks
    if bookmarks.any?
      errors.add(:base, "Cannot delete movie while it has bookmarks")
      throw :abort
    end
  end
end
