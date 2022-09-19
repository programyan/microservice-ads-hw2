# frozen_string_literal: true

require 'spec_helper'

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
    before { post '/ads', params.to_json, 'CONTENT_TYPE' => 'application/json' }

    let(:params) do
      {
        ad: {
          title: title,
          description: description,
          city: city,
          user_id: user_id
        }
      }
    end

    let(:title) { 'Ad title' }
    let(:description) { 'Ad description' }
    let(:city) { 'Khabarovsk' }
    let(:user_id) { rand(1..10) }

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