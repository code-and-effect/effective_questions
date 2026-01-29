module Effective
  class Response < ActiveRecord::Base
    belongs_to :responsable, polymorphic: true
    belongs_to :questionable, polymorphic: true
    belongs_to :question

    has_many :response_options, dependent: :delete_all
    has_many :question_options, through: :response_options

    has_one_attached :upload_file

    effective_resource do
      # The response
      date            :date
      email           :string
      number          :integer
      long_answer     :text
      short_answer    :text

      timestamps
    end

    scope :deep, -> { includes(:question, :question_options) }

    validate(if: -> { questionable.present? && question.present? }) do
      errors.add(:question, 'must match questionable') unless question.questionable == questionable
    end

    validates :date, presence: true, if: -> { question&.required? && question.date? }
    validates :email, presence: true, email: true, if: -> { question&.required? && question.email? }
    validates :number, presence: true, if: -> { question&.required? && question.number? }
    validates :long_answer, presence: true, if: -> { question&.required? && question.long_answer? }
    validates :short_answer, presence: true, if: -> { question&.required? && question.short_answer? }
    validates :upload_file, presence: true, if: -> { question&.required? && question.upload_file? }
    validates :question_option_ids, presence: true, if: -> { question&.required? && question.question_option? }

    validates :question_option_ids, if: -> { question&.choose_one? },
      length: { maximum: 1, message: 'please choose 1 option only' }

    validates :question_option_ids, if: -> { question&.select_up_to_1? },
      length: { maximum: 1, message: 'please select 1 option or fewer' }

    validates :question_option_ids, if: -> { question&.select_up_to_2? },
      length: { maximum: 2, message: 'please select 2 options or fewer' }

    validates :question_option_ids, if: -> { question&.select_up_to_3? },
      length: { maximum: 3, message: 'please select 3 options or fewer' }

    validates :question_option_ids, if: -> { question&.select_up_to_4? },
      length: { maximum: 4, message: 'please select 4 options or fewer' }

    validates :question_option_ids, if: -> { question&.select_up_to_5? },
      length: { maximum: 5, message: 'please select 5 options or fewer' }

    def to_s
      #model_name.human
      response.to_s
    end

    def response
      return nil unless question.present?

      return date if question.date?
      return email if question.email?
      return number if question.number?
      return long_answer if question.long_answer?
      return short_answer if question.short_answer?
      return upload_file if question.upload_file?

      return question_options.first if question.choose_one?
      return question_options.first if question.select_up_to_1?
      return question_options if question.question_option?

      raise('unknown response for unexpected question category')
    end

    def category_partial
      question&.category_partial
    end

    def completed?
      return false if responsable.blank?
      responsable.completed?
    end

  end
end
