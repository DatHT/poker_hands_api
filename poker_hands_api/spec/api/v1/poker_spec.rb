require 'rails_helper'

RSpec.describe 'Poker', type: :request do

  it '⼊⼒データとして１組以上のカードの情報を受け付け、 ⼊⼒したカードとポーカーの役の名前、それらの 中で最も強い役を返すAPI' do
    headers = {CONTENT_TYPE: 'application/json' }
    post '/api/v1/poker', params: '{  "cards": [   "H1 H13 H12 H11 H10",   "H9 C9 S9 H2 C2",   "C13 D12 C11 H8 H7"  ] } ', headers: headers
    expect(response.status).to eql 201
    expect(response.content_type).to eq('application/json')
    expect(response.body).to include 'ストレートフラッシュ'
  end

end