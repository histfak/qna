class SearchController < ApplicationController
  def search
    params[:search_type] == 'All' ? @model_klass = ThinkingSphinx : @model_klass = params[:search_type].classify.constantize
    authorize! :search, @model_klass
    @result = @model_klass.search params[:query]
    render "search/show", result: @result
  end
end
