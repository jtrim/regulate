require 'test_helper'
require "rails/generators/test_case"
require File.join(File.dirname(__FILE__), "../../lib/generators/regulate/mount_up_generator")

class StrapGeneratorTest < Rails::Generators::TestCase
  tests Regulate::Generators::StrapGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test "Assert all files are properly created" do
    run_generator
    assert_file "app/views/regulate/admin/pages/index.html.erb" 
    assert_file "app/views/regulate/admin/pages/_form.html.erb"
    assert_file "app/views/regulate/admin/pages/edit.html.erb"
    assert_file "app/views/regulate/admin/pages/new.html.erb"
    assert_file "app/views/regulate/pages/show.html.erb"
  end
end


