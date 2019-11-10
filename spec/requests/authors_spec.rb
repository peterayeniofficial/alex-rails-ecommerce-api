# spec/requests/authors_spec.rb
require 'rails_helper'

RSpec.describe 'Authors', type: :request do

  include_context 'Skip Auth'

  let(:pat) { create(:author) }
  let(:michael) { create(:michael_hartl) }
  let(:sam) { create(:sam_ruby) }
  let(:authors) { [pat, michael, sam] }

  describe 'GET /api/authors' do    
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
      context 'with valid filtering param "q[given_name_cont]=Pat"' do
      end
      context 'with invalid filtering param "q[fgiven_name_cont]=Pat"' do
      end
    end

  end

  describe 'GET /api/authors/:id' do
    context 'with existing resource' do
    end
    context 'with nonexistent resource' do
    end
  end

  describe 'POST /api/authors' do
    context 'with valid parameters' do
    end
    context 'with invalid parameters' do
    end
  end

  describe 'PATCH /api/authors/:id' do
    context 'with valid parameters' do
    end
    context 'with invalid parameters' do
    end
  end

  describe 'DELETE /api/authors/:id' do
    context 'with existing resource' do
    end
    context 'with nonexistent resource' do
    end
  end

end