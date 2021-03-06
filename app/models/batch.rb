class Batch < ApplicationRecord

  has_many :intern
  has_one :email, as: :emailable, dependent: :destroy
  has_one :slack, as: :slackable, dependent: :destroy

  accepts_nested_attributes_for :email
  accepts_nested_attributes_for :slack, :reject_if => :all_blank

  scope :all_except, -> (id) { where("id != #{id}").order('created_at DESC') }

  validates :name, presence: true, uniqueness: true, on: [:create, :save, :update]
  validate :start_date_cannot_be_empty_when_end_date_is_present, :end_date_cannot_be_less_than_start_date

  def self.all(*args)
    super.order('created_at DESC')
  end


  private
  def start_date_cannot_be_empty_when_end_date_is_present
    if end_date.present? && !start_date.present?
      errors.add(:start_date, 'cannot be empty when end date is present')
    end
  end

  def end_date_cannot_be_less_than_start_date
    if end_date.present? && start_date.present? && end_date <= start_date
      errors.add(:end_date, 'cannot be before start date')
    end
  end

end
