require 'test_helper'

class RegulateTest < ActiveSupport::TestCase

  test "truth" do
    assert_kind_of Module, Regulate
  end

  test 'setup block yields self' do
    Regulate.setup do |config|
      assert_equal Regulate, config
    end
  end

  test 'repo is set' do
    assert_equal File.join(Regulate.app_root,"db", "repos", "test.git", ".git"), Regulate.repo.path
  end

end
