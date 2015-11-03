class TagsController < ApplicationController

  def search
    @tags = Tag.search params[:q] unless params[:q].blank?
    @tags = Tag.where(id: params[:id]).all unless params[:id].blank?
  end
end