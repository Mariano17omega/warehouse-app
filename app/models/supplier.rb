class Supplier < ApplicationRecord
  validates :corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email, presence: true

  validates :email, :registration_number, :corporate_name, :brand_name, uniqueness: true
end
