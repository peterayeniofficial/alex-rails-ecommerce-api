# spec/features/user_auth_flow_spec.rb
require 'rails_helper'

RSpec.describe 'User Auth Flow', type: :request do

  def headers(user_id = nil, token = nil)
    api_key_str = "#{api_key.id}:#{api_key.key}"
    if user_id && token
      token_str = "#{user_id}:#{token}"
      { 'HTTP_AUTHORIZATION' =>
          "Alexandria-Token api_key=#{api_key_str}, access_token=#{token_str}" }
    else
      { 'HTTP_AUTHORIZATION' =>
          "Alexandria-Token api_key=#{api_key.id}:#{api_key.key}" }
    end
  end

  let(:api_key) { ApiKey.create }
  let(:email) { 'john@gmail.com' }
  let(:password) { 'password' }
  let(:params) { { email: email, password: password, given_name: 'Johnny'  } }

  it 'authenticate a new user' do
    # Step 1 - Create a user
    post '/api/users', params: { data: params }, headers: headers
    expect(response.status).to eq 201
    id = json_body['data']['id']

    # Step 2 - Try to update given_name
    patch "/api/users/#{id}",
          params: { data: { given_name: 'John' } },
          headers: headers
    expect(response.status).to eq 401

    # Step 3 - Login
    post '/api/access_tokens',
          params: { data: { email: email, password: 'password' } },
          headers: headers
    expect(response.status).to eq 201
    expect(json_body['data']['token']).to_not be nil
    expect(json_body['data']['user']['email']).to eq email
    token = json_body['data']['token']
    user_id = json_body['data']['user']['id']

    # Step 4 - Update given_name
    patch "/api/users/#{id}",
          params: { data: { given_name: 'John' } },
          headers: headers(user_id, token)
    expect(response.status).to eq 200
    expect(json_body['data']['given_name']).to eq 'John'

    # Step 5 - Try to list all users
    get '/api/users', headers: headers(user_id, token)
    expect(response.status).to eq 403

    # Step 6 - Logout
    delete '/api/access_tokens', headers: headers(user_id, token)
    expect(response.status).to eq 204

    # Step 7 - Try to access user info with invalid token
    get "/api/users/#{id}", headers: headers(user_id, token)
    expect(response.status).to eq 401
  end

end