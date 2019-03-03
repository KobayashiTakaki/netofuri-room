class BaseController < ApplicationController
  before_action :store_location, only: [:index]
  def index
  end
end
