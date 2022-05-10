# frozen_string_literal: true

RSpec.describe Controllers::Tokens do
  def app
    Controllers::Tokens.new
  end

  let!(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:authorization) do
    create(:authorization, application: application, account: account)
  end

  describe 'POST /' do
    describe 'Nominal case' do
      before do
        post '/', {
          authorization_code: authorization.code,
          client_id: application.client_id,
          client_secret: application.client_secret
        }
      end

      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end

      it 'Returns the correct body' do
        expectation = Core::Models::OAuth::AccessToken.first.value
        expect(last_response.body).to include_json({ token: expectation })
      end
    end

    describe 'When the authorization code is not given' do
      before do
        post '/', {
          client_id: application.client_id,
          client_secret: application.client_secret
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'authorization_code', error: 'required'
        )
      end
    end

    describe 'When the authorization code is not found' do
      before do
        post '/', {
          client_id: application.client_id,
          client_secret: application.client_secret,
          authorization_code: 'unknown'
        }
      end

      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'authorization_code', error: 'unknown'
        )
      end
    end

    describe 'When the client ID is not given' do
      before do
        post '/', {
          authorization_code: authorization.code,
          client_secret: application.client_secret
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'client_id', error: 'required'
        )
      end
    end

    describe 'When the client ID is not found' do
      before do
        post '/', {
          client_id: 'unknown',
          authorization_code: authorization.code,
          client_secret: application.client_secret
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 404
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'client_id', error: 'unknown'
        )
      end
    end

    describe 'When the client secret is not given' do
      before do
        post '/', {
          authorization_code: authorization.code,
          client_id: application.client_id
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'client_secret', error: 'required'
        )
      end
    end

    describe 'When the client secret is not the correct one' do
      before do
        post '/', {
          client_id: application.client_id,
          authorization_code: authorization.code,
          client_secret: 'wrong_secret'
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'client_secret', error: 'wrong'
        )
      end
    end

    describe 'when the authorization code belongs to another app' do
      let!(:second_app) do
        create(:application, name: 'Another brilliant app', creator: account)
      end

      before do
        post '/', {
          client_id: second_app.client_id,
          authorization_code: authorization.code,
          client_secret: second_app.client_secret
        }
      end

      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end

      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          field: 'client_id', error: 'mismatch'
        )
      end
    end
  end
end
