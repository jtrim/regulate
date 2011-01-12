require 'test_helper'

class Regulate::Git::Model::BaseTest < ActiveSupport::TestCase

  @@iterator = 0

  def get_iterator
    @@iterator += 1
    @@iterator
  end

  def setup
    iterator = get_iterator
    @resource = Regulate::Git::Model::Base.new({
      :id => "happy-title-#{iterator}",
      :title => "Happy Title #{iterator}",
      :view => "<h1>{{title}}</h1>"
    })
  end

  # /////////
  # Instance Methods
  # /////////

  test "new is not persisted" do
    assert !@resource.persisted?
  end

  test "resource without id is not valid" do
    @resource.id = nil
    assert !@resource.valid?
  end

  test "resource save when invalid returns false" do
    @resource.id = nil
    assert !@resource.save
  end

  test "resource save! when inavlid throws error" do
    @resource.id = nil
    assert_raise Regulate::Git::Errors::InvalidGitResourceError do
      @resource.save!
    end
  end

  test "can save a resource" do
    assert @resource.save
  end

  test "resource is persisted after save" do
    @resource.save
    assert @resource.persisted?
  end

  test "can delete a resource" do
    @resource.save
    assert @resource.destroy
    assert_nil Regulate::Git::Model::Base.find(@resource.id)
  end

  test "can update attributes of saved resource" do
    @resource.save
    assert @resource.update_attributes({
      :title => "Whoa New Title"
    })
    updated_resource = Regulate::Git::Model::Base.find(@resource.id)
    assert_not_nil updated_resource
    assert_equal "Whoa New Title" , updated_resource.title
  end

  test "cannot change id when saving resource" do
    @resource.save
    assert !@resource.update_attributes({
      :id => "whoa-new-title",
      :title => "Whoa New Title"
    })
    assert_nil Regulate::Git::Model::Base.find("whoa-new-title")
  end

  test "can get a list of versions of a resource" do
    @resource.save
    versions = @resource.versions
    assert_equal 1 , versions.length
    assert_kind_of Grit::Commit , versions[0]
  end

  test "can build the rendered html" do
    assert_equal "<h1>Happy Title #{@@iterator}</h1>" , @resource.build_rendered_html
    assert_equal "<h1>Happy Title #{@@iterator}</h1>" , @resource.rendered
  end

  test "can grab the rendered html from git" do
    @resource.save
    assert_equal "<h1>Happy Title #{@@iterator}</h1>" , @resource.rendered
  end

  test "can get our attributes as a hash" do
    assert_kind_of Hash , @resource.attributes
    assert_equal "happy-title-#{@@iterator}" , @resource.attributes["id"]
    assert_equal "Happy Title #{@@iterator}" , @resource.attributes["title"]
    assert_equal "<h1>{{title}}</h1>" , @resource.attributes["view"]
  end

  # /////////
  # End Instance Methods
  # /////////

  # /////////
  # Class Methods
  # /////////

  test "can setup class level attributes" do
    class ::RandomTestClass < Regulate::Git::Model::Base
      attributes :a_random_attribute
    end
    assert RandomTestClass._attributes.include?(:a_random_attribute)
    x = RandomTestClass.new
    assert_respond_to x , :a_random_attribute
    assert_respond_to x , :a_random_attribute=
    assert_respond_to x , :a_random_attribute?
  end

  test "can check if a resource with the given id exists" do
    @resource.save
    assert Regulate::Git::Model::Base.exists?(@resource.id)
  end

  test "can find a git resource given an id" do
    @resource.save
    found = Regulate::Git::Model::Base.find(@resource.id)
    assert_not_nil found
    assert_kind_of Regulate::Git::Model::Base , found
  end

  test "find will return nil if nothing is found" do
    assert_nil Regulate::Git::Model::Base.find("a-random-id")
  end

  test "find! will raise an exception if nothing is found" do
    assert_raise Regulate::Git::Errors::PageDoesNotExist do
      Regulate::Git::Model::Base.find!("a-random-id")
    end
  end

  test "can find a version of a git resource by id and sha" do
    @resource.save
    @resource.title = "Oh Hey a new TItle!"
    @resource.save
    versions = @resource.versions
    assert_equal 2 , versions.length
    old_version = Regulate::Git::Model::Base.find_by_version(@resource.id,versions[1].sha)
    assert_not_nil old_version
    assert_equal "Happy Title #{@@iterator}" , old_version.title
  end

  test "find_by_versions! will raise an exception if nothing is found" do
    assert_raise Regulate::Git::Errors::PageDoesNotExist do
      Regulate::Git::Model::Base.find_by_version!("a-random-id","2798hjfsdjfgk25jklj")
    end
  end

  test "find_all returns all resources in the repo" do
    all = Regulate::Git::Model::Base.find_all
    assert_operator 1 , :< , all.length
    assert_kind_of Regulate::Git::Model::Base , all[0]
  end

  test "can create with attributes hash" do
    new_resource = Regulate::Git::Model::Base.create({
      :id => "happy-title-#{@@iterator}",
      :title => "Happy Title #{@@iterator}",
      :view => "<h1>{{title}}</h1>"
    })
    assert_not_nil new_resource
    assert_kind_of Regulate::Git::Model::Base , new_resource
    assert new_resource.persisted?
  end

  test "create will return nil" do
    new_resource = Regulate::Git::Model::Base.create({
      :title => "Happy Title #{@@iterator}",
      :view => "<h1>{{title}}</h1>"
    })
    assert_nil new_resource
  end

  # /////////
  # End Class Methods
  # /////////

end

