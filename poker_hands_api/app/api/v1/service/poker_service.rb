# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

# WebとAPIの共通部分です。
# ロジックの処理としては、ここで処理です。WebはAPIを叩くだけ！
module V1::Service::PokerService
  include V1::Defination::PokerRuleName

  extend V1::Defination::PokerRuleName

  # リストポーカカードのルールをチェックする
  # @param arr_params: 入力されたリクエストボディのリスト
  # @return: リストの役名と強さ
  def check_rule(arr_params)
    result = []
    arr_params.each do |item|
      result.push(check_item_rule(item))
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

  private
  # 一つのポーカのルールをチェックする
  # @param arr_params: 入力されたリクエストボディのリストの一つの項目
  # @return: Hash {card: "五つのカード", hand: "役名", best: 強さ}
  def check_item_rule(item)
    rule = if check_straight_flush(item)
             STRAIGHT_FLUSH
           elsif check_four_of_a_kind(item)
             FOUR_OF_A_KIND
           elsif check_full_house(item)
             FULL_HOUSE
           elsif check_flush(item)
             FLUSH
           elsif check_straight(item)
             STRAIGHT
           elsif check_three_of_a_kind(item)
             THREE_OF_A_KIND
           elsif check_two_pairs(item)
             TWO_PAIRS
           elsif check_pair(item)
             ONE_PAIR
           else
             HIGH_CARD
           end
    { card: item, hand: get_name(rule), best: rule }
  end

  # 数字のリストが連続するかの確認
  # @@param list_number: ソート数字のリスト
  # @return result
  def continuous(list_number)
    first_item = list_number[0]
    result = true
    list_number[1, list_number.count].each do |item|
      if first_item + 1 != item
        result = false
      else
        first_item = item
      end
    end
    result
  end

  # リストの中で特別な項目が何回出るかの確認
  # @param list: カードのリスト
  # @param check_number:　回数知りたい数字
  # @return result
  def count_appearance_of_number(list, check_number)
    list_number = []
    list.each do |item|
      number = item[1, item.length]
      list_number.push(number.to_i)
    end
    list_number.count(check_number)
  end

  # ストレートフラッシュのルールかをチェックする
  # @param data_item: 5まいのカードのString
  # @return is_straight_forward
  def check_straight_flush(data_item)
    items_inside = data_item.split(' ')

    straight_flush_char = items_inside[0][0, 1]
    list_number = []
    is_straight_forward = true
    items_inside.each do |item|
      chr = item[0, 1]
      number = item[1, item.length]
      if !chr.eql? straight_flush_char
        is_straight_forward = false
        break
      else
        list_number.push(number.to_i)
      end
    end
    if is_straight_forward
      list_number.sort!
      is_straight_forward = if list_number == [1, 10, 11, 12, 13]
                              # 特別ケースをチェック [10, 11, 12, 13, 1]
                              true
                            else
                              continuous(list_number)
                            end
    end
    is_straight_forward
  end

  # フォー・オブ・ア・カインドのルールかをチェックする
  # @param data_item: 5まいのカードのString
  # @return is_four_of_a_kind
  def check_four_of_a_kind(data_item)
    items_inside = data_item.split(' ')
    is_four_of_a_kind = false
    items_inside.each do |item|
      number = item[1, item.length]
      if count_appearance_of_number(items_inside, number.to_i) == 4
        is_four_of_a_kind = true
        break
      end
    end
    is_four_of_a_kind
  end

  # フルハウスのルールかをチェックする
  # @param data_item: 5まいのカードのString
  # @return have_three && have_two
  def check_full_house(data_item)
    items_inside = data_item.split(' ')
    have_three = false
    have_two = false
    items_inside.each do |item|
      number = item[1, item.length]
      if count_appearance_of_number(items_inside, number.to_i) == 3
        have_three = true
      else
        have_two = true if count_appearance_of_number(items_inside, number.to_i) == 2
      end
    end
    have_three && have_two
  end

  # フラッシュのルールかをチェックする
  # @param data_item: 5まいのカードのString
  # @return is_flush
  def check_flush(data_item)
    items_inside = data_item.split(' ')
    is_flush = true
    flush_character = items_inside[0][0, 1]
    items_inside.each do |item|
      unless item[0, 1].eql? flush_character
        is_flush = false
        break
      end
    end
    is_flush
  end

  # ストレートのルールかをチェックする
  # @@param data_item: 5まいのカードのString
  # @return is_straight
  def check_straight(data_item)
    items_inside = data_item.split(' ')
    list_number = []
    items_inside.each do |item|
      number = item[1, item.length]
      list_number.push(number.to_i)
    end
    list_number.sort!
    is_straight = if list_number == [1, 10, 11, 12, 13]
                    true
                  else
                    continuous(list_number)
                  end
    is_straight
  end

  # スリー・オブ・ア・カインドのルールかをチェックする
  # @param data_item: 5まいのカードのString
  # @return is_three_of_a_kind
  def check_three_of_a_kind(data_item)
    items_inside = data_item.split(' ')
    is_three_of_a_kind = false
    items_inside.each do |item|
      number = item[1, item.length]
      is_three_of_a_kind = true if count_appearance_of_number(items_inside, number.to_i) == 3
    end
    is_three_of_a_kind
  end

  # ツーペアのルールかをチェックする
  # @@param data_item: 5まいのカードのString
  # @return: two_pairs_count == 4
  def check_two_pairs(data_item)
    items_inside = data_item.split(' ')
    two_pairs_count = 0
    items_inside.each do |item|
      number = item[1, item.length]
      two_pairs_count += 1 if count_appearance_of_number(items_inside, number.to_i) == 2
    end
    two_pairs_count == 4
  end

  # ワンペアのルールかをチェックする
  # @@param data_item: 5まいのカードのString
  # @return: pair_count == 2
  def check_pair(data_item)
    items_inside = data_item.split(' ')
    pair_count = 0
    items_inside.each do |item|
      number = item[1, item.length]
      pair_count += 1 if count_appearance_of_number(items_inside, number.to_i) == 2
    end
    pair_count == 2
  end
end
