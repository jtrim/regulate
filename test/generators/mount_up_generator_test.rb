require 'test_helper'
require "rails/generators/test_case"
require File.join(File.dirname(__FILE__), "../../lib/generators/regulate/mount_up_generator")

class MountUpGeneratorTest < Rails::Generators::TestCase
  tests Regulate::Generators::MountUpGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test "Assert all files are properly created" do
    run_generator
    assert_file "config/initializers/regulate.rb"
  end
end

