# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

require 'json'

module V1
  class Poker < Grape::API
    include V1::Defination::ErrorMessage

    extend V1::Service::PokerService
    extend V1::Service::ValidationService

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
      is_error = false
      list_error = []
      if arr_params.length.zero?
        is_error = true
        list_error.push(LENGTH_ZERO_ERROR)
      end
      if check_not_a_string(arr_params)[:validate_error]
        is_error = true
        list_error.push(check_not_a_string(arr_params)[:message] + NOT_STRING_ERROR)
      end
      if check_enough_items(arr_params)
        is_error = true
        list_error.push(NOT_ENOUGH_ITEM_ERROR)
      end
      if check_duplicate_items(arr_params)
        is_error = true
        list_error.push(DUPLICATE_ITEM_ERROR)
      end
      redundant_spaces = check_spaces(arr_params)
      if redundant_spaces[:validate_error]
        is_error = true
        list_error.push(redundant_spaces[:message] + REDUNDANT_SPACE)
      end
      validate = validate_data(arr_params)
      if validate[:validate_error]
        is_error = true
        list_error.push(validate[:message] + NOT_CORRECT_DATA_ERROR)
      end
      result_hash[:result] = if is_error
                               result_hash[:success] = false
                               list_error
                             else
                               check_rule(arr_params)
                             end
      result_hash
    end
  end
end
