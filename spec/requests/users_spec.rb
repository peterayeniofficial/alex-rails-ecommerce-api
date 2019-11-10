# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users', type: :request do

  before do
    allow_any_instance_of(UsersController).to(
      receive(:validate_auth_scheme).and_return(true))
    allow_any_instance_of(UsersController).to(
      receive(:authenticate_client).and_return(true))
  end

  let(:john) { create(:user) }
  let(:users) { [john] }

  describe 'GET /api/users' do
  end

  describe 'GET /api/users/:id' do
  end

  describe 'POST /api/users' do
  end

  describe 'PATCH /api/users/:id' do
  end

  describe 'DELETE /api/users/:id' do
  end
end