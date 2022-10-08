# frozen_string_literal: true

describe Api, :aggregate_failures do
  include Rack::Test::Methods

  def app
    Api
  end

  describe 'GET /ads' do
    context 'without page param' do
      before { get '/ads' }

      it { expect(last_response.status).to eq(200) }
    end

    context 'with page param id' do
      before { get "/ads?page=#{page}" }

      let(:page) { 2 }

      it { expect(last_response.status).to eq(200) }
    end
  end

  describe 'POST /ads' do
    let(:params) do
      {
        ad: {
          title: title,
          description: description,
          city: city,
        }
      }
    end

    let(:title) { 'Ad title' }
    let(:description) { 'Ad description' }
    let(:city) { 'Khabarovsk' }
    let(:user_id) { rand(1..10) }
    let(:auth_service) { instance_double('AuthService::Client', auth: user_id) }
    let(:geocode_service) { instance_double('GeocodeService::Client', geocode: geocode_result) }
    let(:geocode_result) { { 'lat' => rand(100), 'lon' => rand(100) } }

    before do
      allow(AuthService::Client).to receive(:new).and_return(auth_service)
      allow(GeocodeService::Client).to receive(:new).and_return(geocode_service)
      post '/ads', params.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it { expect(last_response.status).to eq 201 }

    context 'without any param' do
      let(:description) { nil }
      let(:title) { nil }

      it 'return errors' do
        expect(last_response.status).to eq 422
        expect(JSON.parse(last_response.body)['errors']).to contain_exactly(
          a_hash_including('detail' => I18n.t!('ad.errors.description.blank')),
          a_hash_including('detail' => I18n.t!('ad.errors.title.blank'))
        )
      end
    end
  end

  describe 'Swagger Documentation' do
    before { get '/swagger/docs' }

    it { expect(last_response.status).to eq 200 }
  end
end