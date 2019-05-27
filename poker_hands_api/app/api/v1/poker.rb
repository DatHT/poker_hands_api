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
    # Params:
    # - arrParams: 入力されたリクエストボディのリスト
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
            result_hash[:result] = '入力されたデータのサイズが正しくないです！例：　H1 H13 H12 H11 H10。文字が S, H, D, Cだけで数字は1~13です！'
            result_hash[:success] = false
          else
            validate = Poker.check_duplicate_items(arr_params)
            if validate
              result_hash[:result] = '入力されたデータが重複しています！'
              result_hash[:success] = false
            else
              validate = Poker.validate_data(arr_params)
              if validate
                result_hash[:result] = '入力されたデータのサイズが正しくないです！例：　H1 H13 H12 H11 H10。文字が S, H, D, Cだけで数字は1~13です！'
                result_hash[:success] = false
              else
                # データが正しい場合の処理
                result_hash[:result] = '正解'
              end
            end
          end


        end
      end
      result_hash
    end

    # 入力されたデータをベリファイする
    # Params:
    # - arrParams: 入力されたリクエストボディのリスト
    # return validate_error
    def self.validate_data(arr_params)
      validate_error = false
      arr_params.each do |item|
        items_inside = item.split(' ')
        validate_error = Poker.check_suite_and_number(items_inside)
      end
      validate_error
    end

    # 入力されたデータが五つ項目があるかのチェック
    # Params:
    # - arrParams: 入力されたリクエストボディのリスト
    # return: validate_error
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
    # Params:
    # - arrParams: 入力されたリクエストボディのリスト
    # return: validate_error
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
    # Params:
    # - arrParams: 入力されたリクエストボディのリスト
    # return: validate_error
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
    # Params:
    # - arrParams: 入力されたリクエストボディのリスト
    # return: validate_error
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

    #ポーカのルールをチェックする
    # Params:
    # - data_item: 5まいのカードのString
    def self.check_rule(data_item)
      items_inside = data_item.split(' ')
      items_inside.each do |item|
        chr = item[0, 1]
        number = item[1, chr.length - 1]
      end

    end


  end
end
