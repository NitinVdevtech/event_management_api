require 'rails_helper'

RSpec.describe Api::V1::AuthenticationsController, type: :controller do
  let(:user) { FactoryBot.create(:user, password: 'password') }
  let(:token) { JsonWebToken::JwtTokenGenerator.encode(user_id: user.id) }

  describe 'POST #signup' do
    context 'with valid parameters' do
      it 'creates a new user and returns a token' do
        post :signup, params: { user: { name: 'Test User', email: 'testuser@example.com', password: 'password', role: 'user' } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(json_response['user']['email']).to eq('testuser@example.com')
        expect(json_response['token']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user and returns errors' do
        post :signup, params: { user: { name: '', email: 'invalidemail', password: '', role: '' } }
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'POST #login' do
    context 'with valid credentials' do
      before do
        request.headers['Authorization'] = token
        post :login, params: { user: { email: user.email, password: 'password' } }
      end

      it 'returns a token and user details' do
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).to be_present
        expect(json_response['message']).to eq('Login successful')
      end
    end

    context 'with invalid credentials' do
      before do
        request.headers['Authorization'] = token
        post :login, params: { user: { email: user.email, password: 'wrongpassword' } }
      end

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq('Invalid email or password')
      end
    end
  end
end
