class RulesController < ApplicationController
  layout 'plain'

  def edit
    @rule = Rule.new(params.delete(:rule))
  end

  def create
    redirect_to :root
  end

  def destroy
    redirect_to :root
  end
end