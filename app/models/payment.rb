class Payment < ApplicationRecord
  belongs_to :group, optional: true
  # has_many :groups
end
