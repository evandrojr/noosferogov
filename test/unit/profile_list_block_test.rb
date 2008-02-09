require File.dirname(__FILE__) + '/../test_helper'

class ProfileListBlockTest < Test::Unit::TestCase

  should 'describe itself' do
    assert_not_equal Block.description, ProfileListBlock.description
  end

  should 'accept a limit of people to be displayed (and default to 6)' do
    block = ProfileListBlock.new
    assert_equal 6, block.limit

    block.limit = 20
    assert_equal 20, block.limit
  end

  should 'list people' do
    User.destroy_all
    person1 = create_user('testperson1').person
    person2 = create_user('testperson2').person
    person3 = create_user('testperson3').person

    owner = create_user('mytestuser').person
    block = ProfileListBlock.new
    owner.boxes.first.blocks << block
    block.save!

    # faking that we are picking random people
    profiles = [person1, person3]
    block.expects(:profiles).returns(profiles)

    self.expects(:profile_image_link).with(person1).once
    self.expects(:profile_image_link).with(person2).never
    self.expects(:profile_image_link).with(person3).once

    self.expects(:content_tag).returns('<div></div>').at_least_once
    self.expects(:_).returns('text').at_least_once
    self.expects(:block_title).returns('block title').at_least_once

    assert_kind_of String, instance_eval(&block.content)
  end

  should 'pick random people' do
    block = ProfileListBlock.new

    Profile.expects(:count).returns(3)

    block.expects(:random).times(3).returns(7).then.returns(4).then.returns(5)

    Profile.expects(:find).with(8)
    Profile.expects(:find).with(5)
    Profile.expects(:find).with(6)

    block.profiles
  end

  should 'use Kernel.rand to generate random numbers' do
    Kernel.expects(:rand).with(77).once
    ProfileListBlock.new.random(77)
  end

end
