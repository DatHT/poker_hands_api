require 'rails_helper'
require 'json'

RSpec.describe 'Poker', type: :request do
  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (正常ケース-役割確認)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H9 C9 S9 H2 C2", "D6 H6 S6 C6 S1",
                                                  "S13 S12 S11 S9 S6", "D6 S5 D4 H3 C2", "C5 H5 D5 D12 C10", "D11 S11 S10 C10 S9",
                                                  "H9 C9 H1 D12 D10", "C13 D12 C11 H8 H7"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(9)

    #正常のデータ確認
    expect(response_body['result'][0]['hand']).to eql('ストレートフラッシュ')
    expect(response_body['result'][0]['card']).to eql('H1 H13 H12 H11 H10')
    expect(response_body['result'][0]['best']).to eql(true)
    expect(response_body['result'][1]['hand']).to eql('フォー・オブ・ア・カインド')
    expect(response_body['result'][1]['card']).to eql('D6 H6 S6 C6 S1')
    expect(response_body['result'][1]['best']).to eql(false)
    expect(response_body['result'][2]['hand']).to eql('フルハウス')
    expect(response_body['result'][2]['card']).to eql('H9 C9 S9 H2 C2')
    expect(response_body['result'][2]['best']).to eql(false)
    expect(response_body['result'][3]['hand']).to eql('フラッシュ')
    expect(response_body['result'][3]['card']).to eql('S13 S12 S11 S9 S6')
    expect(response_body['result'][3]['best']).to eql(false)
    expect(response_body['result'][4]['hand']).to eql('ストレート')
    expect(response_body['result'][4]['card']).to eql('D6 S5 D4 H3 C2')
    expect(response_body['result'][4]['best']).to eql(false)
    expect(response_body['result'][5]['hand']).to eql('スリー・オブ・ア・カインド')
    expect(response_body['result'][5]['card']).to eql('C5 H5 D5 D12 C10')
    expect(response_body['result'][5]['best']).to eql(false)
    expect(response_body['result'][6]['hand']).to eql('ツーペア')
    expect(response_body['result'][6]['card']).to eql('D11 S11 S10 C10 S9')
    expect(response_body['result'][6]['best']).to eql(false)
    expect(response_body['result'][7]['hand']).to eql('ワンペア')
    expect(response_body['result'][7]['card']).to eql('H9 C9 H1 D12 D10')
    expect(response_body['result'][7]['best']).to eql(false)
    expect(response_body['result'][8]['hand']).to eql('ハイカード')
    expect(response_body['result'][8]['card']).to eql('C13 D12 C11 H8 H7')
    expect(response_body['result'][8]['best']).to eql(false)
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (正常、ベストケースがない)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H4 H5 H6 H7 H8"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(2)

    #正常のデータ確認
    expect(response_body['result'][0]['hand']).to eql('ストレートフラッシュ')
    expect(response_body['result'][0]['best']).to eql(false)
    expect(response_body['result'][1]['hand']).to eql('ストレートフラッシュ')
    expect(response_body['result'][1]['best']).to eql(false)
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ 五つ項目ではない)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H4 H5 H6 H7"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('入力データサイズが５ではありません！5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11）')
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ 入力されたデータがいらないスペースがあるかのチェック)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H4 H5 H6 H7 H2   "  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('2番目行、はいらないスペースが記載されました！見直してください！')
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ 入力されたデータがいらないスペースがあるかのチェック)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H4 H5 H6 H7   H2"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('2番目行、はいらないスペースが記載されました！見直してください！')
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ 入力されたデータがいらないスペースがあるかのチェック)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "  H4 H5 H6 H7 H2"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('2番目行、はいらないスペースが記載されました！見直してください！')
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ Stringかどうかのチェック)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   1  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('2番目行が間違いました。Stringで入力してください！')
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ 重複があるかのチェック)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H1 H13 H12 H11 H11"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('入力されたデータが重複しています！')
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ スートチェック：S, H, D, Cおよび数字チェック: 1-13)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H1 H13 H12 H11 H22"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('2番目行の数字のH22、の入力されたデータが不正です！半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。')
  end

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI (異常ケース $ スートチェック：S, H, D, Cおよび数字チェック: 1-13)' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H1 H13 H12 P11 H22"  ] } ', headers: headers

    response_body = JSON.parse(response.body)
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    # サイズ確認
    expect(response_body['result'].length).to eql(1)

    #正常のデータ確認
    expect(response_body['result'][0]).to eql('2番目行の文字のP11、2番目行の数字のH22、の入力されたデータが不正です！半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。')
  end

end