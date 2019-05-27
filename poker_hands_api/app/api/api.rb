# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

class API < Grape::API
  # urlの第１セグメント名
  # localhost:3000/api/
  prefix 'api'

  # app/api/v1/base.rbをマウント
  mount V1::Base
end
