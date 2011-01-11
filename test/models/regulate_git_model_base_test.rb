require 'test_helper'

class Regulate::Git::Model::BaseTest < ActiveSupport::TestCase

  def setup
    @resource = Regulate::Git::Model::Base.new({
      :title => "Happy Title",
      :view => "{{title}}"
    })
  end

  test "new is not persisted" do
    assert_equal false , @resource.persisted?
  end

  test "new sets attr methods" do
    assert_respond_to @resource , :title
    assert_respond_to @resource , :title=
    assert_respond_to @resource , :title?
  end

end

