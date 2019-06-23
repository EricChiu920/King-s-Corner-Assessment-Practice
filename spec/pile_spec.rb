require 'rspec'
require 'deck'
require 'pile'

describe Pile do
  subject(:pile) { Pile.new(first_card, top_card) }
  let(:first_card) { Card.new(:clubs, :jack) }
  let(:top_card) { Card.new(:clubs, :jack) }

  describe '#initialize' do
    it 'correctly sets the first card' do
      expect(pile.first_card).to eq(first_card)
    end

    it 'correctly sets the top card' do
      expect(pile.top_card).to eq(top_card)
    end
  end

  describe '#current_value' do
    it 'returns the top card value' do
      expect(pile.current_value).to eq(11)
    end
  end

  describe '#suit_color' do
    it 'returns the top card suit color' do
      expect(pile.current_suit_color).to eq(:black)
    end
  end

  describe '#valid_play?' do
  it 'approves playing a card that has both the immediate lower value and is a opposite color suit' do
    expect(pile.valid_play?(Card.new(:diamonds, :ten))).to eq(true)
  end
  
  it 'approves any card when the pile is empty' do
      pile.top_card = nil
      expect(pile.valid_play?(Card.new(:diamonds, :ten))).to eq(true)
    end

    it 'rejects a card that has a higher value' do
      expect(
        pile.valid_play?(Card.new(:hearts, :king))
      )
    end

    it 'rejects a card that does not have the immediate lower value' do
      expect(
        pile.valid_play?(Card.new(:diamonds, :nine))
      ).to eq(false)
    end

    it 'rejects a card that does not have a opposite color suit' do
      expect(
        pile.valid_play?(Card.new(:spades, :ten))
      )
    end
  end

  describe '#play' do
    it 'changes top card on valid play' do
      played_card = Card.new(:diamonds, :ten)

      pile.play(played_card)
      expect(pile.top_card).to eq(played_card)
    end

    it 'rejects an invalid play' do
      expect do
        pile.play(Card.new(:diamonds, :seven))
      end.to raise_error('invalid play')
    end
  end

  describe '#move_pile' do
    let(:top_card_true) { Card.new(:clubs, :five) }
    let(:top_card_false) { Card.new(:hearts, :five) }
    let(:other_pile) {Pile.new(Card.new(:hearts, :ten), Card.new(:hearts, :ten))}
    
    it 'changes top card on valid play' do
      pile.move_pile(Pile.new(Card.new(:hearts, :ten), top_card_true))
      expect(pile.top_card).to eq(top_card_true)
    end

    it 'sets the other pile to empty' do
      pile.move_pile(other_pile)
      expect(other_pile.top_card).to eq(nil)
      expect(other_pile.first_card).to eq(nil)
    end

    it 'rejects an invalid play' do
      expect do
        pile.move_pile(Pile.new(Card.new(:clubs, :ten), top_card_false))
      end.to raise_error('invalid play')
    end
  end
end
