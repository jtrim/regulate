require 'test_helper'

class DefaultRoutingTest < ActionController::TestCase

  @@sample_page = Regulate::Page.create!({
    :title => "Whatup sample page",
    :view => "{{title}}"
  })


  # Setup our tests
  def setup
    Regulate.setup do |config|
      config.route_namespace = "a_test_namespace"
    end
    Dummy::Application.reload_routes!
  end

  test 'map public page show' do
    assert_routing( { :path => "#{Regulate.route_namespace}/pages/#{@@sample_page.id}" , :method => :get } , { :controller => 'regulate/pages' , :action => 'show', :id => @@sample_page.id } )
  end

  test 'map admin pages index' do
    assert_routing( { :path => "#{Regulate.route_namespace}/admin/pages" , :method => :get } , { :controller => 'regulate/admin/pages' , :action => 'index' } )
  end

  test 'map admin edit page' do
    assert_routing( { :path => "#{Regulate.route_namespace}/admin/pages/#{@@sample_page.id}/edit" , :method => :get } , { :controller => 'regulate/admin/pages' , :action => 'edit', :id => @@sample_page.id } )
  end

end

