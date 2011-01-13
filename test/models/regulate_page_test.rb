require 'test_helper'

class Regulate::PageTest < ActiveSupport::TestCase

  test "title setter sets id" do
    page = Regulate::Page.new({
      :title => "A Fancy Title"
    })
    assert_equal "a-fancy-title" , page.id
  end

  test "title with crazy symbols gets regulated" do
    page = Regulate::Page.new({
      :title => "*@A Fa$ncy titlE!!!"
    })
    assert_equal "a-fa-ncy-title" , page.id
  end

  test "removes apostrophes when creating id from title" do
    page = Regulate::Page.new({
      :title => "We'll LOVE you FORever"
    })
    assert_equal "we-ll-love-you-forever" , page.id
  end

end
