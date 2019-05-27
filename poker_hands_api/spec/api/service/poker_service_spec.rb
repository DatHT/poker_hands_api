require 'rails_helper'

RSpec.describe PokerService do
  describe '連続リストチェック' do
    example 'リストの中で特別な項目が何回出るかの確認' do
      expect(PokerService.count_appearance_of_number(%w(C7 H7 D7 S7 C8), 7)).to eql(4)
    end
    example '連続リスト' do
      expect(PokerService.continuous([1, 2, 3, 4])).to eql(true)
    end
    example '連続ではないリスト' do
      expect(PokerService.continuous([1, 7, 2, 4])).to eql(false)
    end
    example 'ストレートフラッシュチェック' do
      expect(PokerService.check_straight_flush('C7 C6 C5 C4 C3')).to eql(true)
    end
    example 'イレギュラーケースのストレートフラッシュチェック' do
      expect(PokerService.check_straight_flush('C1 C12 C13 C11 C10'))
        .to eql(true)
    end
    example 'ストレートフラッシュではない' do
      expect(PokerService.check_straight_flush('C7 C6 C9 C4 C3')).to eql(false)
    end
    example 'フォー・オブ・ア・カインドチェック' do
      expect(PokerService.check_four_of_a_kind('C7 H7 D7 S7 C8')).to eql(true)
    end
    example 'フォー・オブ・ア・カインドではないチェック' do
      expect(PokerService.check_four_of_a_kind('C7 H7 D7 S3 C8')).to eql(false)
    end
    example 'フォー・オブ・ア・カインドチェック' do
      expect(PokerService.check_four_of_a_kind('C1 H1 D1 S1 C11')).to eql(true)
    end
    example 'フォー・オブ・ア・カインドではないチェック' do
      expect(PokerService.check_four_of_a_kind('C1 H1 D1 S3 C11')).to eql(false)
    end
    example 'フルハウスのルールかをチェック' do
      expect(PokerService.check_full_house('H9 C9 S9 H1 C1')).to eql(true)
    end
    example 'フルハウスのルールではないをチェック' do
      expect(PokerService.check_full_house('H2 C9 S9 H1 C1')).to eql(false)
    end
    example 'フラッシュのルールかをチェック' do
      expect(PokerService.check_flush('H1 H12 H10 H5 H3')).to eql(true)
    end
    example 'フラッシュのルールではないをチェック' do
      expect(PokerService.check_flush('H1 H12 S10 H5 H3')).to eql(false)
    end
    example 'ストレートのルールかをチェック' do
      expect(PokerService.check_straight('S8 S7 H6 H5 S4')).to eql(true)
    end
    example 'ストレートのルールではないをチェック' do
      expect(PokerService.check_straight('S8 S7 H6 H5 S1')).to eql(false)
    end
    example 'スリー・オブ・ア・カインドのルールかをチェック' do
      expect(PokerService.check_three_of_a_kind('S12 C12 D12 S5 C3')).to eql(true)
    end
    example 'スリー・オブ・ア・カインドのルールではないをチェック' do
      expect(PokerService.check_three_of_a_kind('S12 C12 D11 S5 C3')).to eql(false)
    end
    example 'ツーペアのルールかをチェック' do
      expect(PokerService.check_two_pairs('H13 D13 C2 D2 H11')).to eql(true)
    end
    example 'ツーペアのルールではないをチェック' do
      expect(PokerService.check_two_pairs('H13 D1 C2 D2 H11')).to eql(false)
    end
    example 'ワンペアのルールかをチェック' do
      expect(PokerService.check_pair('C10 S10 S6 H4 H2')).to eql(true)
    end
  end
end