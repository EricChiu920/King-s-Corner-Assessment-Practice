require 'rspec'
require 'deck'
require 'pile'

describe Pile do
  subject(:pile) { Pile.new(first_card, top_card) }
  let(:first_card) { Card.new(:clubs, :jack) }
  let(:top_card) { Card.new(:clubs, :jack) }

  describe '#initialize' do
    it 'correctly sets the top card' do
      expect(pile.first_card).to eq(top_card)
    end

    it 'correctly sets the top card' do
      expect(pile.top_card).to eq(top_card)
    end
  end

  describe '#current_value' do
    it 'returns the top card value' do
      expect(pile.current_value).to eq(top_card.value)
    end
  end

  describe '#current_suit' do
    it 'returns the top card suit (for non-eights)' do
      expect(pile.current_suit).to eq(top_card.suit)
    end
  end

  describe '#valid_play?' do
    it 'approves playing a card that has both the immediate lower value and is a opposite color suit' do
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
        pile.valid_play(Card.new(:spades, :ten))
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
    it 'changes top card on valid play' do
      let(:other_pile) { Pile.new(other_first_card, other_top_card) }
      let(:other_first_card) { Card.new(:hearts, :ten) }
      let(:other_top_card) { Card.new(:clubs, :five) }

      pile.move_pile(other_pile)
      expect(pile.top_card).to eq(other_top_card)
    end

    it 'rejects an invalid play' do
      let(:other_pile) { Pile.new(other_first_card, other_top_card) }
      let(:other_first_card) { Card.new(:clubs, :ten) }
      let(:other_top_card) { Card.new(:hearts, :five) }

      pile.move_pile(other_pile)
      expect(pile.top_card).to_not eq(other_top_card)
    end
  end
end
