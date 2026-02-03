#
# ActsAsQuestionable
#
module ActsAsQuestionable
  extend ActiveSupport::Concern

  module Base
    def acts_as_questionable(options = nil)
      include ::ActsAsQuestionable
    end
  end

  module ClassMethods
    def acts_as_questionable?; true; end
  end

  included do
    has_many :questions, -> { order(:position) }, class_name: 'Effective::Question', as: :questionable, dependent: :destroy
    accepts_nested_attributes_for :questions, allow_destroy: true

    has_many :responses, -> { order(:id) }, class_name: 'Effective::Response', as: :questionable, dependent: :destroy
    accepts_nested_attributes_for :responses, allow_destroy: true
  end

  def completed_responses(question: nil)
    return responses.select(&:completed?) if question.nil?
    responses.select { |response| response.completed? && response.question_id == question.id }
  end

  def questionable_scored?
    questions.any?(&:scored?)
  end

end
