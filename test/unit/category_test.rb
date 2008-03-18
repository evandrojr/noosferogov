require File.dirname(__FILE__) + '/../test_helper'

# FIXME move the filesystem-related tests out here
class CategoryTest < Test::Unit::TestCase

  def setup
    @env = Environment.create!(:name => 'Enviroment for testing')
  end

  def test_mandatory_field_name
    c = Category.new
    c.organization = @env
    c.save
    assert c.errors.invalid?(:name)
  end

  def test_mandatory_field_name
    c = Category.new
    c.name = 'product category for testing'
    assert !c.valid?
    assert c.errors.invalid?(:environment_id)
  end

  def test_relationship_with_environment
    c = Category.create!(:name => 'product category for testing', :environment_id => @env.id)
    assert_equal @env, c.environment
  end

  def test_relation_with_parent
    parent_category = Category.create!(:name => 'parent category for testing', :environment_id => @env.id)
    c = Category.create!(:name => 'product category for testing', :environment_id => @env.id, :parent_id => parent_category.id)
    assert_equal parent_category, c.parent
  end

  # def test_full_text_search
  #   c = Category.create!(:name => 'product category for testing', :environment_id => @env.id)
  #   assert @env.product_categories.full_text_search('product*').include?(c)
  # end

  def test_category_full_name
    cat = Category.new(:name => 'category_name')
    assert_equal 'category_name', cat.full_name
  end

  def test_subcategory_full_name
    cat = Category.new(:name => 'category_name')
    sub_cat = Category.new(:name => 'subcategory_name')
    sub_cat.stubs(:parent).returns(cat)
    sub_cat.parent = cat
    assert_equal 'category_name/subcategory_name', sub_cat.full_name
  end

  should 'cope with nil name when calculating full_name' do
    cat = Category.new(:name => 'toplevel')
    sub = Category.new
    sub.parent = cat
    assert_equal 'toplevel/?', sub.full_name
  end

  def test_category_level
    cat = Category.new(:name => 'category_name')
    assert_equal 0, cat.level
  end

  def test_subegory_level
    cat = Category.new(:name => 'category_name')
    sub_cat = Category.new(:name => 'subcategory_name')
    sub_cat.stubs(:parent).returns(cat)
    sub_cat.parent = cat
    assert_equal 1, sub_cat.level
  end

  def test_top_level
    cat = Category.new(:name => 'category_name')
    assert cat.top_level?
  end

  def test_not_top_level
    cat = Category.new(:name => 'category_name')
    sub_cat = Category.new(:name => 'subcategory_name')
    sub_cat.stubs(:parent).returns(cat)
    sub_cat.parent = cat
    assert !sub_cat.top_level?
  end

  def test_leaf
    cat = Category.new(:name => 'category_name')
    sub_cat = Category.new(:name => 'subcategory_name')
    cat.stubs(:children).returns([sub_cat])
    assert !cat.leaf?
  end

  def test_not_leaf
    cat = Category.new(:name => 'category_name')
    sub_cat = Category.new(:name => 'subcategory_name')
    cat.stubs(:children).returns([])
    assert cat.leaf?
  end

  def test_top_level_for
    cat = Category.create(:name => 'Category for testing', :environment_id => @env.id)
    sub_cat = Category.create(:name => 'SubCategory for testing', :environment_id => @env.id, :parent_id => cat.id)

    roots = Category.top_level_for(@env)
    
    assert_equal 1, roots.size
  end
 
  def test_slug
    c = Category.create(:name => 'Category name')
    assert_equal 'category-name', c.slug
  end

  def test_path_for_toplevel
    c = Category.new(:name => 'top_level')
    assert_equal 'top-level', c.path
  end

  def test_path_for_subcategory
    c1 = Category.new(:name => 'parent')

    c2 = Category.new
    c2.parent = c1
    c2.name = 'child'

    assert_equal 'parent/child', c2.path
  end

  def test_should_set_path_correctly_before_saving
    c1 = Category.create!(:name => 'parent', :environment_id => @env.id)

    c2 = Category.new(:name => 'child', :environment_id => @env.id)
    c2.parent = c1
    c2.save!

    assert_equal 'parent/child', c2.path
  end

  def test_should_refuse_to_duplicate_slug_under_the_same_parent
    c1 = Category.create!(:name => 'test category', :environment_id => @env.id)
    c2 = Category.new(:name => 'Test: Category', :environment_id => @env.id)

    assert !c2.valid?
    assert c2.errors.invalid?(:slug)

  end

  def test_renaming_a_category_should_change_path_of_children
    c1 = Category.create!(:name => 'parent', :environment_id => @env.id)
    c2 = Category.create!(:name => 'child', :environment_id => @env.id, :parent_id => c1.id)
    c3 = Category.create!(:name => 'grandchild', :environment_id => @env.id, :parent_id => c2.id)

    c1.name = 'parent new name'
    c1.save!

    assert_equal 'parent-new-name', c1.path
    assert_equal 'parent-new-name/child', Category.find(c2.id).path
    assert_equal 'parent-new-name/child/grandchild', Category.find(c3.id).path

  end

  should "limit the possibile display colors" do
    c = Category.new(:name => 'test category', :environment_id => @env.id)


    c.display_color = 10
    c.valid?
    assert c.errors.invalid?(:display_color)
    
    valid = %w[ 1 2 3 4 ].map { |item| item.to_i }
    valid.each do |item|
      c.display_color = item
      c.valid?
      assert !c.errors.invalid?(:display_color)
    end

  end

  should 'avoid duplicated display colors' do

    @env.categories.destroy_all

    c1 = Category.create!(:name => 'test category', :environment_id => @env.id, :display_color => 1)

    c = Category.new(:name => 'lalala', :environment_id => @env.id)
    c.display_color = 1
    assert !c.valid?
    assert c.errors.invalid?(:display_color)

    c.display_color = 2
    c.valid?
    assert !c.errors.invalid?(:display_color)
    
  end

  should 'be able to get top ancestor' do
    c1 = Category.create!(:name => 'test category', :environment_id => @env.id)
    c2 = Category.create!(:name => 'test category', :environment_id => @env.id, :parent_id => c1.id)
    c3 = Category.create!(:name => 'test category', :environment_id => @env.id, :parent_id => c2.id)

    assert_equal c1, c1.top_ancestor
    assert_equal c1, c2.top_ancestor
    assert_equal c1, c3.top_ancestor
  end

  should 'explode path' do
    c1 = Category.create!(:name => 'parent', :environment_id => @env.id)
    c2 = Category.create!(:name => 'child', :environment_id => @env.id, :parent_id => c1.id)

    assert_equal [ 'parent', 'child'], c2.explode_path
  end

  ################################################################
  # category filter stuff
  ################################################################

  should 'list recent articles' do
    c = @env.categories.build(:name => 'my category'); c.save!
    person = create_user('testuser').person

    a1 = person.articles.build(:name => 'art1')
    a1.categories << c
    a1.save!

    a2 = person.articles.build(:name => 'art2')
    a2.categories << c
    a2.save!

    assert_equivalent [a1, a2], c.recent_articles
  end


  should 'list recent comments' do
    c = @env.categories.build(:name => 'my category'); c.save!
    person = create_user('testuser').person

    a1 = person.articles.build(:name => 'art1')
    a1.categories << c
    a1.save!
    c1 = a1.comments.build(:title => 'comm1', :body => 'khdkashd ', :author => person); c1.save!

    a2 = person.articles.build(:name => 'art2')
    a2.categories << c
    a2.save!
    c2 = a2.comments.build(:title => 'comm1', :body => 'khdkashd ', :author => person); c2.save!

    assert_equivalent [c1, c2], c.recent_comments
  end

  should 'list most commented articles' do
    c = @env.categories.build(:name => 'my category'); c.save!
    person = create_user('testuser').person

    a1 = person.articles.build(:name => 'art1', :categories => [c]); a1.save!
    a2 = person.articles.build(:name => 'art2', :categories => [c]); a2.save!
    a3 = person.articles.build(:name => 'art3', :categories => [c]); a3.save!

    a1.comments.build(:title => 'test', :body => 'asdsa', :author => person).save!
    5.times { a2.comments.build(:title => 'test', :body => 'asdsa', :author => person).save! }

    10.times { a3.comments.build(:title => 'test', :body => 'kajsdsa', :author => person).save! }

    assert_equal [a3, a2], c.most_commented_articles(2)

  end

end
