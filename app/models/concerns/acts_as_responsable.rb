#
# ActsAsResponsable
#
module ActsAsResponsable
  extend ActiveSupport::Concern

  module Base
    def acts_as_responsable(options = nil)
      include ::ActsAsResponsable
    end
  end

  module ClassMethods
    def acts_as_responsable?; true; end
  end

  included do
    has_many :responses, class_name: 'Effective::Response', as: :responsable, dependent: :destroy
    accepts_nested_attributes_for :responses, allow_destroy: true

    validates :responses, associated: true
  end

  # Find or build
  def response(question:)
    response = responses.find { |r| r.question_id == question.id }
    response ||= responses.build(questionable: question.questionable, question: question)
  end

  def responsable_completed?
    try(:done?) == true || try(:completed?) == true
  end

  def scored_responses
    responses.select { |r| r.question&.scored? }
  end

  def responsable_score
    scored = scored_responses()
    return 0 unless scored.present?

    ((scored.count(&:correct?).to_f / scored.length) * 100_000).round
  end
end
