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

end
