# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

module PokerRuleName
  STRAIGHT_FLUSH = 1
  FOUR_OF_A_KIND = 2
  FULL_HOUSE = 3
  FLUSH = 4
  STRAIGHT = 5
  THREE_OF_A_KIND = 6
  TWO_PAIRS = 7
  ONE_PAIR = 8
  HIGH_CARD = 9


  # ポーカーの役名の数字（強さ）から文字変換
  # @@param data_item: 強さ：（１は一番強い）
  # @return: result
  def self.get_name(type)
    result = case type
             when STRAIGHT_FLUSH
               'ストレートフラッシュ'
             when FOUR_OF_A_KIND
               'フォー・オブ・ア・カインド'
             when FULL_HOUSE
               'フルハウス'
             when FLUSH
               'フラッシュ'
             when STRAIGHT
               'ストレート'
             when THREE_OF_A_KIND
               'スリー・オブ・ア・カインド'
             when TWO_PAIRS
               'ツーペア'
             when ONE_PAIR
               'ワンペア'
             else
               'ハイカード'
             end
    result
  end
end