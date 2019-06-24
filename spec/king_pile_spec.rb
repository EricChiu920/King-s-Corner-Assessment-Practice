require 'rspec'
require 'deck'
require 'pile'
require 'king_pile'

describe King_Pile do
  subject(:king_pile) { King_Pile.new(first_card, top_card) }
  let(:first_card) { Card.new(:clubs, :king) }
  let(:top_card) { Card.new(:clubs, :king) }

  it "is a Pile subclass" do
    expect(king_pile).to be_a(Pile)
  end

  describe '#initialize' do
    let(:initialize_pile_empty) { King_Pile.new }
    it "initializes the pile to be empty as default" do
      expect(initialize_pile_empty.first_card).to eq(nil)
      expect(initialize_pile_empty.top_card).to eq(nil)
    end

    context 'only initializes the pile to be a card if it is a king:' do
      it 'allows the first card in the pile to be a king' do
        expect(king_pile.top_card.value).to eq(:king)
      end

      let(:initialize_pile) { King_Pile.new(Card.new(:diamonds, :jack), Card.new(:diamonds, :jack)) }
      it 'rejects any non-king card when initializing' do
        expect(initialize_pile.top_card).to be(nil)
      end
    end
  end

  describe '#valid_play?' do
    before(:each) do
      king_pile.first_card = first_card
      king_pile.top_card = top_card
    end

    it 'approves playing a card that has both the immediate lower value and is a opposite color suit' do
      expect(king_pile.valid_play?(Card.new(:diamonds, :queen))).to eq(true)
    end
  
    context ' when the king_pile is empty' do
      before(:each) do
        king_pile.top_card = nil
      end
      it 'reject any card unless it is a King' do
        expect(king_pile.valid_play?(Card.new(:diamonds, :queen))).to eq(false)
      end

      it 'only allows a king to be played on the pile when it is empty' do
        expect(king_pile.valid_play?(Card.new(:hearts, :king))).to eq(true)
      end
    end

    it 'rejects a card that has a equal or higher value' do
      expect(
        king_pile.valid_play?(Card.new(:hearts, :king))
      )
    end

    it 'rejects a card that does not have the immediate lower value' do
      expect(
        king_pile.valid_play?(Card.new(:diamonds, :nine))
      ).to eq(false)
    end

    it 'rejects a card that does not have a opposite color suit' do
      expect(
        king_pile.valid_play?(Card.new(:spades, :ten))
      ).to eq(false)
    end
  end
end
