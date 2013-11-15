require 'set'

class TermDistances
  
  def initialize( terms )
    @terms = terms
    analyze_distances
  end
  
  def analyze_distances
    gelijk = File.read( 'fixtures/IHG_def_corr_clean_UTF8_LF_20131106_0156.txt' ).downcase.gsub(/[^a-z\s]/, '')
    @matches = ""
    chapt = 0
    last_match_position = 0
    distance = 0
    distances = Hash.new(0)
    gelijk.split(' ').each do |word|
      if !word.eql?( 'pagebreakidentifierpartbreakidentifier' )
        if word.eql?( 'pagebreakidentifier' )
          chapt += 1
          x = last_match_position + distance
          y = 0
          @matches << "{x:#{x},y:#{y},l:'#{chapt}'},"
        else
          chapt_value = ""
          distance += 1
        end
        if @terms.include? word
          x = last_match_position + ( 0.5 * distance )  # does not necessarily land on an exact word position!
          y = ( 1.0 / distance ) * 1000
          @matches << "{x:#{x},y:#{y},l:''},"
          last_match_position += distance
          distances[distance] += 1
          distance = 0
        end
      end
    end
    @dists = ""
    distances.sort_by{ | distance, frequency | distance }.each do | distance, frequency | 
      @dists << "{d:#{distance},f:#{frequency}},"
    end
  end

  def matches
    "[#{@matches[0..-2]}]"
  end
  
  def dists
    "[#{@dists[0..-2]}]"
  end

end

# Probability of seeing a term is equal to its relative frequency: frel(term) 
# Probability of seeing any of the terms is Sigma frel(term), or the total of relative frequencies of the terms
# Probability of seeing another term is 1 - Sigma frel(term)

