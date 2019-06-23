require 'rspec'
require 'ai_player'
require 'card'
require 'deck'
require 'pile'

describe AIPlayer do
  let(:cards) do
    [Card.new(:hearts, :five),
     Card.new(:diamonds, :four),
     Card.new(:hearts, :four)]
  end

  describe '#initialize' do
    it 'sets the players initial cards' do
      expect(AIPlayer.new(cards.dup).cards).to eq(cards)
    end
  end

  describe '::deal_player' do
    it 'deals seven cards from the deck to a new player' do
      deck = double('deck')
      cards = double('cards')
      expect(deck).to receive(:take).with(7).and_return(cards)

      player = AIPlayer.deal_player(deck)
      expect(player.cards).to eq(cards)
    end
  end

  context 'with single card' do
    subject(:player) { AIPlayer.new(cards) }
    let(:cards) { [card] }

    let(:pile) { double('pile') }
    let(:card) { Card.new(:spades, :three) }

    describe '#play_card' do
      it 'plays normally' do
        # **must call `play` on the Pile**
        expect(pile).to receive(:play).with(card)
        player.play_card(pile, card)
      end

      it 'card must be in your hand to play it' do
        expect do
          # create a card outside your hand.
          other_card = Card.new(:spades, :ace)
          player.play_card(pile, other_card)
        end.to raise_error('cannot play card outside your hand')
      end

      it 'removes card from hand' do
        # let the Player call `Pile#play`, but don't actually do
        # anything.
        allow(pile).to receive(:play)

        player.play_card(pile, card)
        expect(player.cards).to_not include(card)
      end
    end
  end

  describe '#play_pile' do
    subject(:player) { AIPlayer.new(cards) }
    let(:other_pile) { double('pile') }
    let(:pile) { double('pile') }

    it 'plays normally' do
      # **must call `move_pile` on the Pile**
      expect(pile).to receive(:move_pile).with(other_pile)
      player.play_pile(pile, other_pile)
    end
  end

  describe '#draw_from' do
    subject(:player) { AIPlayer.new([]) }

    it 'adds a card from the deck to hand' do
      card = Card.new(:clubs, :deuce)
      deck = double('deck')
      allow(deck).to receive(:take).with(1).and_return([card])

      player.draw_from(deck)
      expect(player.cards).to eq([card])
    end
  end

  describe '#choose_card' do
    subject(:player) { AIPlayer.new(cards) }

    let(:pile1) { double('pile') }
    let(:pile2) { double('pile') }
    let(:piles) { [pile1, pile2] }

    context 'with a single card' do
      let(:cards) { [card] }
      let(:card) { Card.new(:clubs, :deuce) }

      it 'choose a legal card if possible' do
        # **must call `valid_play?` in `choose_card`**
        allow(pile1).to receive(:valid_play?).with(card).and_return(true)

        expect(player.choose_card(piles)).to eq(card)
      end

      it 'returns nil if no legal play is possible' do
        allow(pile1).to receive(:valid_play?).with(card).and_return(false)
        allow(pile2).to receive(:valid_play?).with(card).and_return(false)

        expect(player.choose_card(piles)).to be_nil
      end
    end
  end

  describe '#choose_pile' do
    subject(:player) { AIPlayer.new(cards) }

    let(:pile1) { Pile.new(Card.new(:clubs, :six), Card.new(:clubs, :six)) }
    let(:pile2) { Pile.new(Card.new(:hearts, :five), Card.new(:hearts, :five)) }
    let(:piles) { [pile1, pile2] }
    let(:card) { Card.new(:clubs, :deuce) }

    it 'should move a pile if it can go on top of a another pile' do
      allow(pile2).to receive(:valid_play?).with(pile1.first_card).and_return(true)
      expect(player.choose_pile(piles)).to eq([pile1, pile2])
    end
  end

  # work in progress
  # describe '#play_turn' do
  #   let(:player) { AIPlayer.new(hand_cards) }
  #   let(:pile) { Pile.new(Card.new(:clubs, :three)) }
  #   let(:deck) { Deck.new(deck_cards) }

  #   context 'with playable card in hand' do
  #     let(:hand_cards) { [Card.new(:clubs, :four)] }
  #     let(:deck_cards) { [] }

  #     it 'plays a card out of its hand if possible' do
  #       expect(player)
  #         .to receive(:play_card)
  #         .with(pile, hand_cards[0])

  #       player.play_turn(pile, deck)
  #     end
  #   end

  #   context 'with no playable card in hand' do
  #     let(:hand_cards) { [Card.new(:hearts, :four)] }

  #     let(:deck_cards) do
  #       [Card.new(:hearts, :king),
  #       Card.new(:hearts, :seven),
  #       Card.new(:clubs, :four),
  #       Card.new(:hearts, :three)]
  #     end

  #     it 'draws until it takes in a playable card' do
  #       expect(player)
  #         .to receive(:draw_from)
  #         .with(deck)
  #         .exactly(3)
  #         .times
  #         .and_call_original # calls the underlying `Player#draw_from`

  #       player.play_turn(pile, deck)
  #     end

  #     it 'plays the first drawn playable card' do
  #       expect(player)
  #         .to receive(:play_card)
  #         .with(pile, deck_cards[2])

  #       player.play_turn(pile, deck)
  #     end

  #     context 'with no playable card in deck' do
  #       let(:deck_cards) do
  #         [Card.new(:hearts, :king),
  #         Card.new(:hearts, :seven)]
  #       end

  #       it 'draws all cards into hand' do
  #         expect(player)
  #           .to receive(:draw_from)
  #           .exactly(2)
  #           .times.and_call_original

  #         player.play_turn(pile, deck)
  #       end

  #       it 'does not play a card' do
  #         expect(player).not_to receive(:play_card)

  #         player.play_turn(pile, deck)
  #       end
  #     end
  #   end
  # end

  describe '#win?' do
    subject(:player) { AIPlayer.new([]) }
    it 'returns true when the hand is empty' do
      expect(player.win?).to eq(true)
    end

    it 'returns false if hand is not empty' do
      player.cards.concat(cards)
      expect(player.win?).to eq(false)
    end
  end
end
