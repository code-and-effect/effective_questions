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
      decimal         :decimal
      email           :string
      number          :integer
      percentage      :integer
      price           :integer
      long_answer     :text
      short_answer    :text

      timestamps
    end

    scope :deep, -> { includes(:question, :question_options) }

    validate(if: -> { questionable.present? && question.present? }) do
      errors.add(:question, 'must match questionable') unless question.questionable == questionable
    end

    validates :date, presence: true, if: -> { question&.required? && question.date? }
    validates :decimal, presence: true, if: -> { question&.required? && question.decimal? }
    validates :percentage, presence: true, if: -> { question&.required? && question.percentage? }
    validates :price, presence: true, if: -> { question&.required? && question.price? }
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
      return '' unless question.present?
      return '' unless response.present?

      case question.category
      when 'Date'
        response.strftime('%Y-%m-%d')
      when 'Price'
        "$#{'%0.2f' % (response / 100.0)}"
      when 'Percentage'
        precision = (response % 1000).zero? ? 0 : 3
        "#{format("%.#{precision}f", response.to_f / 1000)}%"
      when 'Upload File'
        response.filename.to_s
      when 'Select all that apply', 'Select up to 2', 'Select up to 3', 'Select up to 4', 'Select up to 5'
        Array(response).map(&:to_s).join(', ')
      else
        response.to_s
      end
    end

    def response
      return nil unless question.present?

      return date if question.date?
      return email if question.email?
      return number if question.number?
      return percentage if question.percentage?
      return price if question.price?
      return decimal if question.decimal?
      return long_answer if question.long_answer?
      return short_answer if question.short_answer?
      return upload_file if question.upload_file?

      return response_options.first if question.choose_one?
      return response_options.first if question.select_up_to_1?
      return response_options if question.question_option?

      raise('unknown response for unexpected question category')
    end

    def category_partial
      question&.category_partial
    end

    def completed?
      responsable.responsable_completed?
    end

    def correct?
      return unless question.present? && question.scored?
      return false unless response.present?

      if question.question_option?
        # For option-based questions, check if selected options match answer options
        answers = question.answer.map(&:id)
        selected = Array(response).map(&:question_option_id)

        if question.select_all_that_apply?
          return selected.sort == answers.sort
        else
          # For choose_one or select_up_to_X, all selected must be correct
          return selected.present? && (selected - answers).blank?
        end
      end

      # For non-option questions, check against question_answer
      answer = question.question_answer
      return false unless answer.present?

      case answer.operation
      when 'Equal to'
        if response.is_a?(String) && answer.answer.is_a?(String)
          response.downcase.strip == answer.answer.downcase.strip
        else
          response == answer.answer
        end
      when 'Within range'
        answer.answer.cover?(response)
      when 'Less than'
        response < answer.answer
      when 'Less than or equal to'
        response <= answer.answer
      when 'Greater than'
        response > answer.answer
      when 'Greater than or equal to'
        response >= answer.answer
      when 'Contains'
        response.to_s.downcase.include?(answer.answer.to_s.downcase)
      when 'Does not contain'
        !response.to_s.downcase.include?(answer.answer.to_s.downcase)
      else
        false
      end
    end

  end
end
