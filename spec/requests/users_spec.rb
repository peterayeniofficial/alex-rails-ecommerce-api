# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users', type: :request do

  include_context 'Skip Auth'

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