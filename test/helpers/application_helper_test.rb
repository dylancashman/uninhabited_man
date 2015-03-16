require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'formatted_date_string gives MM/DD/YYYY' do
    assert_equal "03/26/2015", formatted_date_string(Date.new(2015, 03, 26))
  end

  test 'formatted_date_string gives empty string on nil date' do
    assert_equal "", formatted_date_string(nil)
  end
end
