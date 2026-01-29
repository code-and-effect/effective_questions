require 'effective_resources'
require 'effective_datatables'
require 'effective_questions/engine'
require 'effective_questions/version'

module EffectiveQuestions

  def self.config_keys
    [ :layout ]
  end

  include EffectiveGem
end
