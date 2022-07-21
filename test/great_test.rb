require 'test_helper'

class GreatTest < Minitest::Test
  include Great

  def quoted_regex(list)
    Regexp.union(*list.map{|suffix| Regexp.quote(suffix) })
  end

  def text_matcher(text, suffix_regexp)
    Regexp.new(Regexp.quote(text) + '\s+(' + suffix_regexp.source.gsub('\\','') + ')', Regexp::IGNORECASE)
  end

  def processor(kind)
    Great::Again.const_get(kind).new('')
  end

  def test_that_it_has_a_version_number
    refute_nil ::Great::VERSION
  end

  def test_it_adds_a_great_ending
    text = "This is my sentence."
    suffixes = quoted_regex(Great::Again.new('').suffixes)

    assert_match(text_matcher(text, suffixes), Great(text))
  end

  def test_it_adds_positive_text_for_positive_sentiment
    text = "America is great."
    suffixes = quoted_regex(Great::Again::Positive.new('').suffixes)

    assert_match(text_matcher(text, suffixes), Great(text))
  end

  def test_it_adds_neutral_text_for_neutral_sentiment
    text = "America is."
    suffixes = quoted_regex(Great::Again::Neutral.new('').suffixes)

    assert_match(text_matcher(text, suffixes), Great(text))
  end

  def test_it_adds_negative_text_for_negative_sentiment
    text = "Crooked Hillary."
    suffixes = quoted_regex(Great::Again::Negative.new('').suffixes)

    assert_match(text_matcher(text, suffixes), Great(text))

    long = "“An ‘extremely credible source’ has called my office and told me that Barack Obama’s birth certificate is a fraud."
    suffixes = quoted_regex(Great::Again::Negative.new('').suffixes)

    assert_match(text_matcher(long, suffixes), Great(long))
  end
end
