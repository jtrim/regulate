require 'test_helper'

class Regulate::Git::InterfaceTest < ActiveSupport::TestCase

  @@iterator = 0

  def get_iterator
    @@iterator += 1
    @@iterator
  end

  # lets create a commit to run our tests with
  def setup
    @commit_data = {
      :id => "a-real-deal-id-#{get_iterator}",
      :commit_message => 'Creating Git Resource',
      :author_name => 'Collin',
      :author_email => 'collin@quickleft.com',
      :attributes => "{ \"title\" : \"test #{get_iterator}\" }",
      :rendered => "<h1>Test #{get_iterator}</h1>"
    }
    @commit_sha = Regulate::Git::Interface.save(@commit_data)
  end

  # Test that our commit returns a sha
  # Just check length > 0
  test "create a commit" do
    assert_operator @commit_sha.length , :> , 0
  end

  test "commits return" do
    commit_found = false
    Regulate::Git::Interface.commits(@commit_data[:id]).each do |commit|
      commit_found = true if commit.sha == @commit_sha
    end
    assert commit_found
  end

  test "can find by id" do
    result = Regulate::Git::Interface.find(@commit_data[:id])
    assert_equal @commit_data[:attributes] , result
  end

  test "can find all git resources" do
    results = Regulate::Git::Interface.find_all
    assert results.include? @commit_data[:attributes]
  end

  test "can grab rendered from the repo" do
    assert_equal @commit_data[:rendered] , Regulate::Git::Interface.find_rendered(@commit_data[:id])
  end

  test "can check if a resource exists" do
    assert Regulate::Git::Interface.exists?(@commit_data[:id])
  end

  test "can grab the most recent commit" do
    assert_equal @commit_sha , Regulate::Git::Interface.last_commit.sha
  end

  test "can delete a git resource" do
    Regulate::Git::Interface.delete(@commit_data).inspect
    assert_nil Regulate::Git::Interface.find(@commit_data[:id])
  end

  test "can find a specific version of a git resource" do
    new_commit_data = @commit_data.merge({
      :commit_message => 'Updating Git Resource',
      :author_name => 'Collin',
      :author_email => 'collin@quickleft.com',
      :attributes => "{ \"title\" : \"1234567\" }"
    })
    new_commit_sha = Regulate::Git::Interface.save(new_commit_data)
    assert_equal @commit_data[:attributes] , Regulate::Git::Interface.find_by_version(@commit_data[:id],@commit_sha)
    assert_equal new_commit_data[:attributes] , Regulate::Git::Interface.find_by_version(@commit_data[:id],new_commit_sha)
  end

end

