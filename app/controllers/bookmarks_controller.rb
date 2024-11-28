class BookmarksController < ApplicationController
  before_action :set_list, only: [:new, :create]

  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark = @list.bookmarks.new(bookmark_params)
    if @bookmark.save
      redirect_to list_path(@list), notice: 'Bookmark was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    list = @bookmark.list
    @bookmark.destroy
    redirect_to list_path(list), notice: 'Bookmark was successfully deleted.', status: :see_other
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end
end
