# app/presenters/publisher_presenter.rb
class PublisherPresenter < BasePresenter
  cached
  related_to    :books
  sort_by       :id, :name, :created_at, :updated_at
  filter_by     :id, :name, :created_at, :updated_at
  build_with    :id, :name, :created_at, :updated_at
end