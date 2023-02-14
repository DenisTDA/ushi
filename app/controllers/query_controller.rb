class QueryController < ApplicationController
  before_action :authenticate_user!, only: %i[search]
  skip_authorization_check

  def new; end

  def search
    @results = ThinkingSphinx.search(params[:search],
      :page => params[:page],
      :per_page => 100,
      classes: klasses)
end

  private

  def klasses
    klasses = [Question, Answer, Comment, User]
    klasses = params[:subjects].map { |sub| sub.capitalize.constantize } unless params[:all] 
  end
end
