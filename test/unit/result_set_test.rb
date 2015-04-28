require_relative '../test_helper'

class ResultSetTest < Test::Unit::TestCase
  def test_ok
    json_string = IO.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'ok.json'))
    set = TwitterAPI::ResultSet.new(json_string, 'path')
    assert !set.error?
    assert_nil set.error_code
    assert_equal 15, set.results.length
  end

  def test_errors
    set = TwitterAPI::ResultSet.new('{"errors":[{"message":"Bad Authentication data","code":215}]}', 'path')
    assert set.error?
    assert_equal 215, set.error_code
  end

  def test_not_json
    set = TwitterAPI::ResultSet.new('abc', 'path')
    assert set.error?
    assert_nil set.error_code
  end
end
