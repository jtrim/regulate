class Regulate::Git::Model::BaseLintTest < ActiveModel::TestCase
  include ActiveModel::Lint::Tests
  def setup
    @model = Regulate::Git::Model::Base.new
  end
end

