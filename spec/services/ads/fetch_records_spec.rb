describe Ads::FetchRecords, :aggregate_failures do
  subject(:result) { described_class.call(path: path, params: params, page: page) }

  let!(:ad1) { create(:ad) }
  let!(:ad2) { create(:ad) }

  let(:page) { nil }
  let(:path) { '' }
  let(:params) { {} }

  it 'returns ads in reverse order' do
    expect(result.ads.to_a).to eq [ad2, ad1]
    expect(result.links).to match(first: '?page=1', last: '?page=1')
  end
end