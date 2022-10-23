require 'rspec'

describe Ads::Create, :aggregate_failures do
  subject(:result) { described_class.call(**params) }

  let(:params) do
    {
      title: title,
      description: description,
      city: city,
      user_id: user_id
    }
  end

  let(:title) { 'Ad title' }
  let(:description) { 'Ad description' }
  let(:city) { 'Khabarovsk' }
  let(:user_id) { rand(1..10) }
  let(:geocode_service) { instance_double('GeocodeService::Client', geocode: nil) }

  before { allow(GeocodeService::Client).to receive(:new).and_return(geocode_service) }

  it 'creates a new ad' do
    expect { result }.to change { Ad.count }.from(0).to(1)
    expect(result.ad).to be_kind_of(Ad)

    #check attributes
    expect(result.ad.lat).to eq nil
    expect(result.ad.lon).to eq nil
  end

  context 'invalid parameters' do
    let(:city) { nil }

    it 'does not create ad' do
      expect { result }.not_to change { Ad.count }
      expect(result.ad).to be_kind_of(Ad)
    end
  end
end
