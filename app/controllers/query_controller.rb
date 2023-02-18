class QueryController < ApplicationController
  authorize_resource :class => false

  def new; end

  def search
    return if (params[:all].nil? && params[:subjects].nil?) || params[:search].empty?

    @results = ThinkingSphinx.search(params[:search],
      :page => params[:page],
      :per_page => 15,
      classes: klasses)
  end

  private

  def klasses
    klasses = [Question, Answer, Comment, User]
    klasses = params[:subjects].map { |sub| sub.capitalize.constantize } unless params[:all] 
  end
end
