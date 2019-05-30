# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

module V1::Service::ValidationService

  # 入力されたデータが五つ項目があるかのチェック
  # @param arrParams: 入力されたリクエストボディのリスト
  # @return: validate_error
  def check_enough_items(arr_params)
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

  # 入力されたデータがStringかどうかのチェック
  # @param arr_params: 入力されたリクエストボディのリスト
  # @return: result_hash
  def check_not_a_string(arr_params)
    result_hash = {validate_error: false }
    arr_params.each_with_index do |item, index|
      unless item.is_a? String
        result_hash[:validate_error] = true
        result_hash[:message] = (index + 1).to_s
        break
      end
    end
    result_hash
  end

  # 入力されたデータは重複があるかのチェック
  # @@param arrParams: 入力されたリクエストボディのリスト
  # @return: validate_error
  def check_duplicate_items(arr_params)
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

  # スートチェック：S, H, D, Cおよび数字チェック: 1-13
  # @param arrParams: 入力されたリクエストボディのリスト
  # @return result_hash
  def validate_data(arr_params)
    result_hash = {validate_error: false }
    message = ''
    validate_error = false
    arr_params.each_with_index do |item, index|
      items_inside = item.split(' ')
      # validate_error = check_suite_and_number(items_inside)
      items_inside.each do |chr|
        # スートチェック：S, H, D, C
        if chr[0, 1].match(/[CDHS]/)
          # 数字チェック: 1-13
          number = 0
          number = chr[1, chr.length - 1].to_i if chr[1, chr.length - 1]
                                                      .match(/^\d+$/)
          if !number.positive? || number >= 14
            validate_error = true
            message += ((index + 1).to_s + '番目行の数字の' + chr + '、')
          end
        else
          validate_error = true
          message += ((index + 1).to_s + '番目行の文字の' + chr + '、')
        end
      end
    end
    result_hash[:validate_error] = validate_error
    result_hash[:message] = message
    result_hash
  end
end