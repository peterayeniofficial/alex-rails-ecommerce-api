# app/controllers/downloads_controller.rb
class DownloadsController < ApplicationController
  before_action :authenticate_user

  def show
    authorize(book)
    render status: 204, location: book.download_url
  end

  private

  def book
    @book ||= Book.find_by!(id: params[:book_id])
  end

end