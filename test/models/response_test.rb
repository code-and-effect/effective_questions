require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  test 'log_changes? delegates to responsable when available' do
    responsable = build_user
    responsable.define_singleton_method(:log_changes?) { false }

    response = Effective::Response.new(responsable: responsable)

    refute response.log_changes?
  end

  test 'log_changes? defaults to true when responsable has no logging preference' do
    response = Effective::Response.new(responsable: build_user)

    assert response.log_changes?
  end
end
