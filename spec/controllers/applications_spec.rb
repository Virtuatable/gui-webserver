# frozen_string_literal: true

RSpec.describe Controllers::Applications do
  def app
    Controllers::Applications.new
  end

  describe 'GET /' do
    let!(:account) { create(:account) }
    let!(:application) { create(:application, creator: account) }

    describe 'Nominal case' do
      before do
        get "/#{application.client_id}?redirect_uri=#{application.redirect_uris.first}"
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          application: {
            client_id: application.client_id,
            name: application.name,
            premium: false
          },
          redirect_uri: application.redirect_uris.first
        )
      end
    end

    describe 'Alternative case with parameters in the URI' do
      let!(:uri) { "#{application.redirect_uris.first}?foo=bar" }

      before do
        get "/#{application.client_id}?redirect_uri=#{CGI.escape(uri)}"
      end

      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          application: {
            client_id: application.client_id,
            name: application.name,
            premium: false
          },
          redirect_uri: uri
        )
      end
    end

    describe 'when the redirection URI is not given' do
      before do
        get "/#{application.client_id}"
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'redirect_uri', error: 'required'
        )
      end
    end

    describe 'when the application does not exist' do
      before do
        get '/unknown?redirect_uri=unknown'
      end

      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'client_id', error: 'unknown'
        )
      end
    end

    describe 'when the redirection URI is not in the application' do
      before do
        get "/#{application.client_id}?redirect_uri=unknown"
      end

      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'redirect_uri', error: 'unknown'
        )
      end
    end
  end
end
