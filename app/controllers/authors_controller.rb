# app/controllers/authors_controller.rb
class AuthorsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :authorize_actions


  def index
    authors = orchestrate_query(Author.all)
    render serialize(authors)
  end

  def show
    render serialize(author)
  end

  def create
    if author.save
      render serialize(author).merge(status: :created, location: author)
    else
      unprocessable_entity!(author)
    end
  end

  def update
    if author.update(author_params)
      render serialize(author).merge(status: :ok)
    else
      unprocessable_entity!(author)
    end
  end

  def destroy
    author.destroy
    render status: :no_content
  end

  private

  def author
    @author ||= params[:id] ? Author.find_by!(id: params[:id]) :
                              Author.new(author_params)
  end
  alias_method :resource, :author

  def author_params
    params.require(:data).permit(:given_name, :family_name)
  end

end