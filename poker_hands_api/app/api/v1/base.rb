# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

module V1
  class Base < Grape::API
    version 'v1'
    format :json
    content_type :json, 'application/json'

    # app/api/v1/poker.rbをマウント
    mount V1::Poker
  end
end
