module Effective
  class QuestionAnswer < ActiveRecord::Base
    belongs_to :question

    OPERATIONS = [
      'Equal to', 
      'Within range', 
      'Less than',
      'Less than or equal to', 
      'Greater than',
      'Greater than or equal to', 
      'Contains', 
      'Does not contain'
    ]

    effective_resource do
      operation       :string

      # The answer
      date            :date
      date_begin      :date
      date_end        :date

      decimal         :decimal
      decimal_begin   :decimal
      decimal_end     :decimal

      email           :string

      number          :integer
      number_begin    :integer
      number_end      :integer

      percentage      :integer
      percentage_begin :integer
      percentage_end   :integer

      price           :integer
      price_begin     :integer
      price_end       :integer

      long_answer     :text
      short_answer    :text

      timestamps
    end

    scope :deep, -> { includes(:question) }

    with_options(unless: -> { question.blank? }) do
      validate(if: -> { question.category.present? }) do
        supported = operations(question.category)
        errors.add(:operation, 'is not supported for this question') if supported.present? && supported.exclude?(operation)
      end

      validates :date, presence: true, if: -> { question.date? && (equals? || gteq? || lteq? || lt? || gt?) }
      validates :date_begin, presence: true, if: -> { question.date? && within_range? }
      validates :date_end, presence: true, if: -> { question.date? && within_range? }

      validates :decimal, presence: true, if: -> { question.decimal? && (equals? || gteq? || lteq? || lt? || gt?) }
      validates :decimal_begin, presence: true, if: -> { question.decimal? && within_range? }
      validates :decimal_end, presence: true, if: -> { question.decimal? && within_range? }

      validates :email, presence: true, if: -> { question.email? && (equals? || contains? || does_not_contain?) }
      validates :email, email: true, if: -> { question.email? && equals? }

      validates :number, presence: true, if: -> { question.number? && (equals? || gteq? || lteq? || lt? || gt?) }
      validates :number_begin, presence: true, if: -> { question.number? && within_range? }
      validates :number_end, presence: true, if: -> { question.number? && within_range? }

      validates :percentage, presence: true, if: -> { question.percentage? && (equals? || gteq? || lteq? || lt? || gt?) }
      validates :percentage_begin, presence: true, if: -> { question.percentage? && within_range? }
      validates :percentage_end, presence: true, if: -> { question.percentage? && within_range? }

      validates :price, presence: true, if: -> { question.price? && (equals? || gteq? || lteq? || lt? || gt?) }
      validates :price_begin, presence: true, if: -> { question.price? && within_range? }
      validates :price_end, presence: true, if: -> { question.price? && within_range? }

      validates :long_answer, presence: true, if: -> { question.long_answer? }
      validates :short_answer, presence: true, if: -> { question.short_answer? }
    end

    def to_s
      return '' unless question.present?
      return '-' unless operations(question.category).present?

      case operation
      when 'Equal to'
        "Equal to #{format_value(answer)}"
      when 'Within range'
        "Between #{format_value(answer.begin)} and #{format_value(answer.end)}"
      when 'Less than'
        "Less than #{format_value(answer)}"
      when 'Less than or equal to'
        "Less than or equal to #{format_value(answer)}"
      when 'Greater than'
        "Greater than #{format_value(answer)}"
      when 'Greater than or equal to'
        "Greater than or equal to #{format_value(answer)}"
      when 'Contains'
        "Contains #{format_value(answer)}"
      when 'Does not contain'
        "Does not contain #{format_value(answer)}"
      else
        raise("unknown operation: #{operation}")
      end
    end

    def operations(category)
      case category
      when 'Choose one' then nil
      when 'Select all that apply' then nil
      when 'Select up to 1' then nil 
      when 'Select up to 2' then nil
      when 'Select up to 3' then nil
      when 'Select up to 4' then nil
      when 'Select up to 5' then nil
      when 'Upload File' then nil
      when 'Date' then OPERATIONS - ['Contains', 'Does not contain']
      when 'Decimal' then OPERATIONS - ['Contains', 'Does not contain']
      when 'Number' then OPERATIONS - ['Contains', 'Does not contain']
      when 'Percentage' then OPERATIONS - ['Contains', 'Does not contain']
      when 'Price' then OPERATIONS - ['Contains', 'Does not contain']
      when 'Email' then ['Equal to', 'Contains', 'Does not contain']
      when 'Long Answer' then ['Equal to', 'Contains', 'Does not contain']
      when 'Short Answer' then ['Equal to', 'Contains', 'Does not contain']
      else
        raise("unknown operations for category: #{category}")
      end
    end

    def answer
      if operation == 'Within range'
        return (date_begin..date_end) if question.date?
        return (decimal_begin..decimal_end) if question.decimal?
        return (number_begin..number_end) if question.number?
        return (percentage_begin..percentage_end) if question.percentage?
        return (price_begin..price_end) if question.price?
      else
        return date if question.date?
        return decimal if question.decimal?
        return email if question.email?
        return number if question.number?
        return percentage if question.percentage?
        return price if question.price?
        return long_answer if question.long_answer?
        return short_answer if question.short_answer?
      end

      raise('unknown operation: #{operation}')
    end

    def equals?
      operation == 'Equals'
    end

    def contains?
      operation == 'Contains'
    end

    def does_not_contain?
      operation == 'Does not contain'
    end

    def within_range?
      operation == 'Within Range'
    end

    def lt?
      operation == 'Less than'
    end

    def gt?
      operation == 'Greater than'
    end

    def lteq?
      operation == 'Less than or equal to'
    end

    def gteq?
      operation == 'Greater than or equal to'
    end

    private 

    def format_value(val)
      return '""' if val.blank?
      return val.to_s if val.is_a?(Numeric)
      return val.strftime('%Y-%m-%d') if val.respond_to?(:strftime)
      "\"#{val}\""
    end
  end
end
