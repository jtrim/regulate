require 'test_helper'

class GitTest < ActiveSupport::TestCase
  test "create page" do
    sha = Regulate::Git::Interface.save({
            :id => 'a-real-deal-id',
            :commit_message => 'Creating Page',
            :author_name => 'Collin',
            :author_email => 'collin@quickleft.com',
            :attributes => "{ 'test' : 'test' }",
            :rendered => '<h1>Test</h1>'
          })
    puts sha
  end
end

