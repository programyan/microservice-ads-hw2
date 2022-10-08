RSpec.describe AuthService::Client, :aggregate_failures, type: :client do
  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  before do
    stubs.post('') { [status, headers, body.to_json] }
  end

  describe '#auth' do
    subject { described_class.new(connection: connection).auth(token) }

    let(:user_id) { rand(10) }
    let(:body) { { meta: { user_id: user_id } } }

    context 'with valid token' do
      let(:token) { 'valid.token' }

      it { is_expected.to eq user_id }
    end

    context 'with invalid token' do
      let(:token) { 'invalid.token' }
      let(:status) { 403 }

      it { is_expected.to be_nil }
    end

    context 'with nil token' do
      let(:token) { nil }
      let(:status) { 403 }

      it { is_expected.to be_nil }
    end
  end
end
