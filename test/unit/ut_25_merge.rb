
#
# testing ruote
#
# Fri May 13 14:12:52 JST 2011
#

require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

module Ruote; end
require 'ruote/exp/merge'


class MergeTest < Test::Unit::TestCase

  class Merger
    include Ruote::Exp::MergeMixin

    def expand_atts
      nil
    end
  end

  def new_workitem(fields)

    { 'fields' => fields }
  end

  def new_workitems

    [
      new_workitem('a' => 0, 'b' => -1),
      new_workitem('a' => 1)
    ]
  end

  def test_merge_override

    assert_equal(
      { 'fields' => { 'a' => 1 } },
      Merger.new.merge_workitems(new_workitems, 'override'))
    assert_equal(
      { 'fields' => { 'a' => 0, 'b' => -1 } },
      Merger.new.merge_workitems(new_workitems.reverse, 'override'))
  end

  def test_merge_mix

    assert_equal(
      { 'fields' => { 'a' => 1, 'b' => -1 } },
      Merger.new.merge_workitems(new_workitems, 'mix'))
    assert_equal(
      { 'fields' => { 'a' => 0, 'b' => -1 } },
      Merger.new.merge_workitems(new_workitems.reverse, 'mix'))
  end

  def test_merge_isolate

    assert_equal(
      { 'fields' => {
        '0' => { 'a' => 0, 'b' => -1 },
        '1' => { 'a' => 1 }
      } },
      Merger.new.merge_workitems(new_workitems, 'isolate'))
    assert_equal(
      { 'fields' => {
        '0' => { 'a' => 1 },
        '1' => { 'a' => 0, 'b' => -1 }
      } },
      Merger.new.merge_workitems(new_workitems.reverse, 'isolate'))
  end

  def test_merge_stack

    assert_equal(
      { 'fields' => {
          'stack' => [ { 'a' => 0, 'b' => -1 }, { 'a' => 1 } ],
          'stack_attributes' => nil
      } },
      Merger.new.merge_workitems(new_workitems, 'stack'))
    assert_equal(
      { 'fields' => {
          'stack' => [ { 'a' => 1 }, { 'a' => 0, 'b' => -1 } ],
          'stack_attributes' => nil
      } },
      Merger.new.merge_workitems(new_workitems.reverse, 'stack'))
  end
end

