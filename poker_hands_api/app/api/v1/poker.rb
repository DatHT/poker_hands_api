# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

require 'json'

module V1
  class Poker < Grape::API

    resource :poker do
      # http://localhost:3000/api/v1/poker
      desc 'check poker hand'
      params do
        requires :cards, type: Array
      end
      post do
        Poker.process(params[:cards])
      end
    end


    # 出力データの処理アルゴリズム
    # @param arrParams: 入力されたリクエストボディのリスト
    def self.process(arr_params)
      result_data = []
      result_hash = { result: result_data }

      if arr_params.length.zero?
        result_hash[:result] = '入力されたデータのサイズが０でした!'
        result_hash[:success] = false
      else
        validate = Poker.check_not_a_string(arr_params)
        if validate
          result_hash[:result] = 'Stringで入力してください！'
          result_hash[:success] = false
        else
          validate = Poker.check_enough_items(arr_params)
          if validate
            result_hash[:result] = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
            result_hash[:success] = false
          else
            validate = Poker.check_duplicate_items(arr_params)
            if validate
              result_hash[:result] = '入力されたデータが重複しています！'
              result_hash[:success] = false
            else
              validate = Poker.validate_data(arr_params)
              if validate
                result_hash[:result] = '入力されたデータが不正です！半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。'
                result_hash[:success] = false
              else
                # データが正しい場合の処理
                result_hash[:result] = Poker.check_rule(arr_params)
              end
            end
          end
        end
      end
      result_hash
    end

    # 入力されたデータをベリファイする
    # @param arrParams: 入力されたリクエストボディのリスト
    # @return validate_error
    def self.validate_data(arr_params)
      validate_error = false
      arr_params.each do |item|
        items_inside = item.split(' ')
        validate_error = Poker.check_suite_and_number(items_inside)
      end
      validate_error
    end

    # 入力されたデータが五つ項目があるかのチェック
    # @param arrParams: 入力されたリクエストボディのリスト
    # @return: validate_error
    def self.check_enough_items(arr_params)
      validate_error = false
      arr_params.each do |item|
        items_inside = item.split(' ')
        if items_inside.length != 5
          validate_error = true
          break
        end
      end
      validate_error
    end

    # 入力されたデータは重複があるかのチェック
    # @@param arrParams: 入力されたリクエストボディのリスト
    # @return: validate_error
    def self.check_duplicate_items(arr_params)
      validate_error = false
      arr_params.each do |item|
        items_inside = item.split(' ')
        unless items_inside.uniq.length == items_inside.length
          validate_error = true
          break
        end
      end
      validate_error
    end

    # 入力されたデータがStringかどうかのチェック
    # @param arr_params: 入力されたリクエストボディのリスト
    # @return: validate_error
    def self.check_not_a_string(arr_params)
      validate_error = false
      arr_params.each do |item|
        unless item.is_a? String
          validate_error = true
          break
        end
      end
      validate_error
    end

    # スートチェック：S, H, D, Cおよび数字チェック: 1-13
    # @param arrParams: 入力されたリクエストボディのリスト
    # @return: validate_error
    def self.check_suite_and_number(items_inside)
      validate_error = false
      items_inside.each do |chr|
        # スートチェック：S, H, D, C
        if chr[0, 1].match(/[CDHS]/)
          # 数字チェック: 1-13
          number = 0
          number = chr[1, chr.length - 1].to_i if chr[1, chr.length - 1]
                                                  .match(/^\d+$/)
          validate_error = true if !number.positive? || number >= 14
        else
          validate_error = true
          break
        end
      end
      validate_error
    end

    # リストポーカカードのルールをチェックする
    # @param arr_params: 入力されたリクエストボディのリスト
    # @return: リストの役名と強さ
    def self.check_rule(arr_params)
      result = []
      arr_params.each do |item|
        result.push(Poker.check_item_rule(item))
      end
      result.sort_by! {|item| item[:best]}
      duplicate_role = false
      duplicate_role = true if result.size >= 2 && result[0][:best] == result[1][:best]
      result.each_with_index do |item, index|
        if duplicate_role
          item[:best] = false
        else
          item[:best] = true if index.zero?
          item[:best] = false unless index.zero?
        end
      end
      result
    end

    # 一つのポーカのルールをチェックする
    # @param arr_params: 入力されたリクエストボディのリストの一つの項目
    # @return: Hash {card: "五つのカード", hand: "役名", best: 強さ}
    def self.check_item_rule(item)
      rule = if PokerService.check_straight_flush(item)
               PokerRuleName::STRAIGHT_FLUSH
             elsif PokerService.check_four_of_a_kind(item)
               PokerRuleName::FOUR_OF_A_KIND
             elsif PokerService.check_full_house(item)
               PokerRuleName::FULL_HOUSE
             elsif PokerService.check_flush(item)
               PokerRuleName::FLUSH
             elsif PokerService.check_straight(item)
               PokerRuleName::STRAIGHT
             elsif PokerService.check_three_of_a_kind(item)
               PokerRuleName::THREE_OF_A_KIND
             elsif PokerService.check_two_pairs(item)
               PokerRuleName::TWO_PAIRS
             elsif PokerService.check_pair(item)
               PokerRuleName::ONE_PAIR
             else
               PokerRuleName::HIGH_CARD
              end
      return { card: item, hand: PokerRuleName.get_name(rule), best: rule }
    end
  end
end
