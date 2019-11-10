# spec/requests/publishers_spec.rb
require 'rails_helper'

RSpec.describe 'Publishers', type: :request do

  before do
    allow_any_instance_of(PublishersController).to(
      receive(:validate_auth_scheme).and_return(true))
    allow_any_instance_of(PublishersController).to(
      receive(:authenticate_client).and_return(true))
  end

  let(:oreilly) { create(:publisher) }
  let(:dev_media) { create(:dev_media) }
  let(:super_books) { create(:super_books) }
  let(:publishers) { [oreilly, dev_media, super_books] }

  describe 'GET /api/publishers' do
    context 'default behavior' do
    end

    describe 'field picking' do
      context 'with the fields parameter' do
      end
      context 'without the field parameter' do
      end
      context 'with invalid field name "fid"' do
      end
    end

    describe 'pagination' do
      context 'when asking for the first page' do
      end
      context 'when asking for the second page' do
      end
      context 'when sending invalid "page" and "per" parameters' do
      end
    end

    describe 'sorting' do
      context 'with valid column name "id"' do
      end
      context 'with invalid column name "fid"' do
      end
    end

    describe 'filtering' do
      context 'with valid filtering param "q[name_cont]=Reilly"' do
      end
      context 'with invalid filtering param "q[fname_cont]=Reilly"' do
      end
    end
  end

  describe 'GET /api/publishers/:id' do
    context 'with existing resource' do
    end
    context 'with nonexistent resource' do
    end
  end

  describe 'POST /api/publishers' do
    context 'with valid parameters' do
    end
    context 'with invalid parameters' do
    end
  end

  describe 'PATCH /api/publishers/:id' do
    context 'with valid parameters' do
    end
    context 'with invalid parameters' do
    end
  end

  describe 'DELETE /api/publishers/:id' do
    context 'with existing resource' do
    end
    context 'with nonexistent resource' do
    end
  end
end