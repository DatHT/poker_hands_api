require 'rails_helper'

RSpec.describe V1::Service::PokerService do
  include V1::Service::PokerService
  extend V1::Defination::PokerRuleName
  describe 'PokerServiceのテストケース' do
    example 'リストの中で特別な項目が何回出るかの確認' do
      expect(count_appearance_of_number(%w[C7 H7 D7 S7 C8], 7)).to eql(4)
    end
    example '連続リスト' do
      expect(continuous([1, 2, 3, 4])).to eql(true)
    end
    example '連続ではないリスト' do
      expect(continuous([1, 7, 2, 4])).to eql(false)
    end
    example 'ストレートフラッシュチェック' do
      expect(check_straight_flush('C7 C6 C5 C4 C3')).to eql(true)
    end
    example 'イレギュラーケースのストレートフラッシュチェック' do
      expect(check_straight_flush('C1 C12 C13 C11 C10'))
        .to eql(true)
    end
    example 'ストレートフラッシュではない' do
      expect(check_straight_flush('C7 C6 C9 C4 C3')).to eql(false)
    end
    example 'フォー・オブ・ア・カインドチェック' do
      expect(check_four_of_a_kind('C7 H7 D7 S7 C8')).to eql(true)
    end
    example 'フォー・オブ・ア・カインドではないチェック' do
      expect(check_four_of_a_kind('C7 H7 D7 S3 C8')).to eql(false)
    end
    example 'フォー・オブ・ア・カインドチェック' do
      expect(check_four_of_a_kind('C1 H1 D1 S1 C11')).to eql(true)
    end
    example 'フォー・オブ・ア・カインドではないチェック' do
      expect(check_four_of_a_kind('C1 H1 D1 S3 C11')).to eql(false)
    end
    example 'フルハウスのルールかをチェック' do
      expect(check_full_house('H9 C9 S9 H1 C1')).to eql(true)
    end
    example 'フルハウスのルールではないをチェック' do
      expect(check_full_house('H2 C9 S9 H1 C1')).to eql(false)
    end
    example 'フラッシュのルールかをチェック' do
      expect(check_flush('H1 H12 H10 H5 H3')).to eql(true)
    end
    example 'フラッシュのルールではないをチェック' do
      expect(check_flush('H1 H12 S10 H5 H3')).to eql(false)
    end
    example 'ストレートのルールかをチェック' do
      expect(check_straight('S8 S7 H6 H5 S4')).to eql(true)
    end
    example 'ストレートのルールではないをチェック' do
      expect(check_straight('S8 S7 H6 H5 S1')).to eql(false)
    end
    example 'スリー・オブ・ア・カインドのルールかをチェック' do
      expect(check_three_of_a_kind('S12 C12 D12 S5 C3')).to eql(true)
    end
    example 'スリー・オブ・ア・カインドのルールではないをチェック' do
      expect(check_three_of_a_kind('S12 C12 D11 S5 C3')).to eql(false)
    end
    example 'ツーペアのルールかをチェック' do
      expect(check_two_pairs('H13 D13 C2 D2 H11')).to eql(true)
    end
    example 'ツーペアのルールではないをチェック' do
      expect(check_two_pairs('H13 D1 C2 D2 H11')).to eql(false)
    end
    example 'ワンペアのルールかをチェック' do
      expect(check_pair('C10 S10 S6 H4 H2')).to eql(true)
    end
    example '強さから文字変換のチェック' do
      expect(get_name(7)).to eql('ツーペア')
    end
  end
end