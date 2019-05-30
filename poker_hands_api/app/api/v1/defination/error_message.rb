# frozen_string_literal: true
# rubocop:disable BlockComments, AsciiComments

module V1::Defination::ErrorMessage
  LENGTH_ZERO_ERROR = '入力されたデータのサイズが０でした!'
  NOT_STRING_ERROR = '番目行が間違いました。Stringで入力してください！'
  NOT_ENOUGH_ITEM_ERROR = '入力データサイズが５ではありません！5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）'
  DUPLICATE_ITEM_ERROR = '入力されたデータが重複しています！'
  NOT_CORRECT_DATA_ERROR = 'の入力されたデータが不正です！半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。'
end