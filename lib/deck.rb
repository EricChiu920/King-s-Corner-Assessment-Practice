require 'byebug'
require_relative 'card'

class Deck
  def self.all_cards
  end

  def initialize(cards)
  end

  def count
  end

  def empty?
  end

  def take(n)
  end

  protected
  attr_reader :cards

  private
  attr_writer :cards
end