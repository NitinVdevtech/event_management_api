require 'rails_helper'

RSpec.describe 'Api::V1::Events', type: :request do
  let(:user) { create(:user, :admin) }
  let(:event) { create(:event, user: user) }

  def authorize_request(user)
    token = JsonWebToken::JwtTokenGenerator.encode(user_id: user.id)
    { 'Authorization': "Bearer #{token}" }
  end

  describe 'GET /events' do
    before do
      get '/api/v1/events', headers: authorize_request(user)
    end

    it 'returns a list of events' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /events/:id' do
    before do
      get "/api/v1/events/#{event.id}", headers: authorize_request(user)
    end

    it 'returns the event' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event.name)
    end
  end

  describe 'POST /events' do
    let(:valid_attributes) { { event: { name: 'New Event', description: 'Event Description', location: 'Location', start_time: '2024-01-01T00:00:00Z', end_time: '2024-01-02T00:00:00Z' } } }

    context 'with valid parameters' do
      before do
        post '/api/v1/events', params: valid_attributes, headers: authorize_request(user)
      end

      it 'creates a new event' do
        expect(response).to have_http_status(:created)
        expect(response.body).to include('New Event')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { event: { name: nil } } }

      before do
        post '/api/v1/events', params: invalid_attributes, headers: authorize_request(user)
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can't be blank")
      end
    end
  end

  describe 'PUT /events/:id' do
    let(:new_attributes) { { event: { name: 'Updated Event' } } }

    before do
      put "/api/v1/events/#{event.id}", params: new_attributes, headers: authorize_request(user)
    end

    it 'updates the event' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Updated Event')
    end
  end

  describe 'DELETE /events/:id' do
    context 'when deletion is successful' do
      before do
        delete "/api/v1/events/#{event.id}", headers: authorize_request(user)
      end

      it 'returns a success message' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Event deleted successfully')
      end
    end

    context 'when deletion fails' do
      before do
        allow_any_instance_of(Event).to receive(:destroy).and_return(false)
        delete "/api/v1/events/#{event.id}", headers: authorize_request(user)
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Failed to delete event')
      end
    end
  end

  describe 'authorization' do
    let(:non_admin_user) { create(:user) }

    it 'does not allow non-admin users to create events' do
      post '/api/v1/events', params: { event: { name: 'Unauthorized Event', description: 'Description', location: 'Location', start_time: '2024-01-01T00:00:00Z', end_time: '2024-01-02T00:00:00Z' } }, headers: authorize_request(non_admin_user)
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include('You are not authorized to access this page.')
    end
  end
end
