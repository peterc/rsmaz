# encoding: binary
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'strscan'

# Silly hack to allow usage of String#ord in Ruby 1.9 without breaking Ruby 1.8
if RUBY_VERSION < '1.9.0'
  class String
    def ord; self[0]; end;
  end
end  

# RSmaz is too small to bother splitting into separate files, so I'll be lazy..
module RSmaz
  VERSION = '0.0.4'
  DEFAULT_DICTIONARY = [" ", "the", "e", "t", "a", "of", "o", "and", "i", "n", "s", "e ", "r", " th",
              " t", "in", "he", "th", "h", "he ", "to", "\r\n", "l", "s ", "d", " a", "an",
              "er", "c", " o", "d ", "on", " of", "re", "of ", "t ", ", ", "is", "u", "at",
              "   ", "n ", "or", "which", "f", "m", "as", "it", "that", "\n", "was", "en",
              "  ", " w", "es", " an", " i", "\r", "f ", "g", "p", "nd", " s", "nd ", "ed ",
              "w", "ed", "http://", "for", "te", "ing", "y ", "The", " c", "ti", "r ", "his",
              "st", " in", "ar", "nt", ",", " to", "y", "ng", " h", "with", "le", "al", "to ",
              "b", "ou", "be", "were", " b", "se", "o ", "ent", "ha", "ng ", "their", "\"",
              "hi", "from", " f", "in ", "de", "ion", "me", "v", ".", "ve", "all", "re ",
              "ri", "ro", "is ", "co", "f t", "are", "ea", ". ", "her", " m", "er ", " p",
              "es ", "by", "they", "di", "ra", "ic", "not", "s, ", "d t", "at ", "ce", "la",
              "h ", "ne", "as ", "tio", "on ", "n t", "io", "we", " a ", "om", ", a", "s o",
              "ur", "li", "ll", "ch", "had", "this", "e t", "g ", "e\r\n", " wh", "ere",
              " co", "e o", "a ", "us", " d", "ss", "\n\r\n", "\r\n\r", "=\"", " be", " e",
              "s a", "ma", "one", "t t", "or ", "but", "el", "so", "l ", "e s", "s,", "no",
              "ter", " wa", "iv", "ho", "e a", " r", "hat", "s t", "ns", "ch ", "wh", "tr",
              "ut", "/", "have", "ly ", "ta", " ha", " on", "tha", "-", " l", "ati", "en ",
              "pe", " re", "there", "ass", "si", " fo", "wa", "ec", "our", "who", "its", "z",
              "fo", "rs", ">", "ot", "un", "<", "im", "th ", "nc", "ate", "><", "ver", "ad",
              " we", "ly", "ee", " n", "id", " cl", "ac", "il", "</", "rt", " wi", "div",
              "e, ", " it", "whi", " ma", "ge", "x", "e c", "men", ".com"].each_with_index.inject({}){ |sum, (el, i )| sum.tap{ sum[el] = i } }

  REVERSE_DICTIONARY = DEFAULT_DICTIONARY.invert

  def self.compress(input, dictionary = DEFAULT_DICTIONARY, rdictionary = REVERSE_DICTIONARY, crumbs_lengths = [7,5,4,3,2,1] )
    verb = 0
    input = force_binary(input.dup)

    i = 0
    q = []
    while (i <= input.length)
      crumb_number = nil
      crumbs_lengths.find{|num| crumb_number = dictionary[input[i, num]] }

      if crumb_number
        q << input[i - verb, verb] if verb > 0
        verb = 0
        q << crumb_number
        i += rdictionary[crumb_number].length
      else
        # If the verbatim buffer is getting too long or we're at the end of the doc
        # throw the verbatim buffer to the output queue
        if verb == 256 || i == input.length
          q << input[i - verb, verb]
          verb = 0
        end
        verb += 1
        i+= 1
      end

    end

    # Turn the queue into correctly encoded data
    q.map do |item|
      if item.class == String && item.length == 1
        "\376" + item
      elsif item.class == String && item.length > 1
        "\377" + (item.length - 1).chr + item
      elsif item.class == Fixnum
        item.chr
      end
    end.join
  end

  # Decompress a Smaz encoded string back to normal plain text.
  # On Ruby 1.9, the returned string has the binary encoding. You
  # must manually force the encoding back to the right one because
  # RSmaz does not store information about the original encoding.
  def self.decompress(input, rdictionary = REVERSE_DICTIONARY )
    out = ""
    s = StringScanner.new(dup_and_force_binary(input))
    until s.eos?
      bv = s.get_byte.ord
      if (bv == 254)
        out << s.get_byte
      elsif (bv == 255)
        len = s.get_byte.ord + 1
        len.times do
          out << s.get_byte
        end
      else
        out << rdictionary[bv]
      end
    end

    out
  end
  private

  if ''.respond_to?(:encoding)
    def self.force_binary(str)
      str.force_encoding('binary')
    end

    def self.dup_and_force_binary(str)
      str.dup.force_encoding('binary')
    end
  else
    def self.force_binary(str)
      str
    end

    def self.dup_and_force_binary(str)
      str
    end
  end
end
