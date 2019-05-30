require 'rails_helper'
RSpec.describe V1::Service::ValidationService do
  include V1::Service::ValidationService
  describe 'ValidationServiceのテストケース' do
    example('入力されたデータが五つ項目があるかのチェック') do
      expect(check_enough_items(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 H7'])).to eql(false)
      expect(check_enough_items(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8'])).to eql(true)
    end

    example('入力されたデータがいらないスペースがあるかのチェック') do
      expect(check_spaces(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 H7'])[:validate_error]).to eql(false)
      expect(check_spaces(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8  '])[:validate_error]).to eql(true)
    end

    example('入力されたデータがStringかどうかのチェック') do
      expect(check_not_a_string(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 H7'])[:validate_error]).to eql(false)
      expect(check_not_a_string(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 1])[:validate_error]).to eql(true)
    end

    example('入力されたデータは重複があるかのチェック') do
      expect(check_duplicate_items(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 H7'])).to eql(false)
      expect(check_duplicate_items(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 C11'])).to eql(true)
    end

    example('スートチェック：S, H, D, Cおよび数字チェック: 1-13') do
      expect(validate_data(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 H7'])[:validate_error]).to eql(false)
      expect(validate_data(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 A1'])[:validate_error]).to eql(true)
      expect(validate_data(['H1 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 H17'])[:validate_error]).to eql(true)
    end

  end
end