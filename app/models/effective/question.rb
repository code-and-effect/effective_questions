module Effective
  class Question < ActiveRecord::Base
    belongs_to :questionable, polymorphic: true

    belongs_to :question, optional: true # Present when I'm a follow up question
    belongs_to :question_option, optional: true # Might be present when I'm a follow up question
    has_many :follow_up_questions, -> { order(:position) }, class_name: 'Effective::Question', foreign_key: :question_id, dependent: :destroy

    has_many :question_options, -> { order(:position) }, inverse_of: :question, dependent: :delete_all
    accepts_nested_attributes_for :question_options, reject_if: -> (atts) { atts['title'].blank? }, allow_destroy: true

    has_many :question_answers, dependent: :delete_all
    accepts_nested_attributes_for :question_answers, reject_if: :all_blank, allow_destroy: true

    has_rich_text :body
    log_changes(to: :questionable) if respond_to?(:log_changes)

    has_many :responses

    CATEGORIES = [
      'Choose one',   # Radios
      'Select all that apply', # Checks
      'Select up to 1',
      'Select up to 2',
      'Select up to 3',
      'Select up to 4',
      'Select up to 5',
      'Date',         # Date Field
      'Decimal',      # Decimal Field
      'Email',        # Email Field
      'Number',       # Numeric Field
      'Percentage',   # Percentage Field
      'Price',        # Price Field
      'Long Answer',  # Text Area
      'Short Answer', # Text Field
      'Upload File'   # File field
    ]

    WITH_OPTIONS_CATEGORIES = [
      'Choose one',   # Radios
      'Select all that apply', # Checks
      'Select up to 1',
      'Select up to 2',
      'Select up to 3',
      'Select up to 4',
      'Select up to 5'
    ]

    UNSUPPORTED_FOLLOW_UP_QUESTION_CATEGORIES = ['Upload File']

    effective_resource do
      title         :string
      category      :string
      required      :boolean

      position      :integer

      follow_up        :boolean
      follow_up_value  :string

      scored          :boolean

      timestamps
    end

    before_validation(if: -> { question.present? }) do
      assign_attributes(questionable: question.questionable)
    end

    # Set position
    before_validation do
      source = question_option.try(:follow_up_questions) || questionable.try(:questions) || []
      self.position ||= (source.map { |obj| obj.position }.compact.max || -1) + 1
    end

    scope :deep, -> { with_rich_text_body_and_embeds.includes(:question_options) }
    scope :sorted, -> { order(:position) }

    scope :top_level, -> { where(follow_up: false) }
    scope :follow_up, -> { where(follow_up: true) }

    validates :title, presence: true
    validates :category, presence: true, inclusion: { in: CATEGORIES }
    validates :position, presence: true
    validates :question_options, presence: true, if: -> { question_option? }

    validates :question, presence: true, if: -> { follow_up? }
    validates :question_option, presence: true, if: -> { follow_up? && question.try(:question_option?) }
    validates :follow_up_value, presence: true, if: -> { follow_up? && !question.try(:question_option?) }

    validates :scored, inclusion: { in: [false], message: 'is not supported' }, if: -> { category == 'Upload File' }

    validates :question_answer, presence: true, if: -> { scored? }

    validate(if: -> { scored? && (choose_one? || select_up_to_1? || select_all_that_apply?) }) do
      errors.add(:base, 'must have at least one correct answer option') if answer_options.count < 1
    end

    validate(if: -> { scored? && select_up_to_2? }) do
      errors.add(:base, 'must have two or more correct answer options') if answer_options.count < 2
    end

    validate(if: -> { scored? && select_up_to_3? }) do
      errors.add(:base, 'must have three or more correct answer options') if answer_options.count < 3
    end

    validate(if: -> { scored? && select_up_to_4? }) do
      errors.add(:base, 'must have four or more correct answer options') if answer_options.count < 4
    end

    validate(if: -> { scored? && select_up_to_5? }) do
      errors.add(:base, 'must have five or more correct answer options') if answer_options.count < 5
    end

    # Create choose_one? and select_all_that_apply? methods for each category
    CATEGORIES.each do |category|
      define_method(category.parameterize.underscore + '?') { self.category == category }
    end

    def to_s
      title.presence || model_name.human
    end

    def show_if_attribute
      return :question_option_ids if question_option?

      case category
      when 'Date' then :date
      when 'Decimal' then :decimal
      when 'Email' then :email
      when 'Number' then :number
      when 'Percentage' then :percentage
      when 'Price' then :price
      when 'Long Answer' then :long_answer
      when 'Short Answer' then :short_answer
      when 'Upload File' then :upload_file
      else :unknown
      end
    end

    def show_if_value
      question.try(:question_option?) ? question_option_id : follow_up_value
    end

    def show_if_value_to_s
      (question.try(:question_option?) ? question_option : follow_up_value).to_s
    end

    def question_option?
      WITH_OPTIONS_CATEGORIES.include?(category)
    end

    def answer_options
      question_options.reject(&:marked_for_destruction?).select(&:answer?)
    end

    def category_partial
      category.to_s.parameterize.underscore
    end

    def question_answer
      question_answers.first || question_answers.build()
    end

  end
end
