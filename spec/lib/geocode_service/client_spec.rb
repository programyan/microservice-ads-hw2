RSpec.describe GeocodeService::Client, :aggregate_failures, type: :client do
  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  before do
    stubs.post('') { [status, headers, body.to_json] }
  end

  describe '#geocode' do
    subject { described_class.new(connection: connection).geocode(city) }

    let(:lat) { rand(100) }
    let(:lon) { rand(100) }
    let(:body) { { data: { lat: lat, lon: lon } } }

    context 'with valid city' do
      let(:city) { 'City 17' }

      it { is_expected.to eq('lat' => lat, 'lon' => lon) }
    end

    context 'with invalid city' do
      let(:city) { 'City 18' }
      let(:status) { 422 }

      it { is_expected.to be_nil }
    end

    context 'with nil city' do
      let(:city) { nil }
      let(:status) { 422 }

      it { is_expected.to be_nil }
    end
  end
end
