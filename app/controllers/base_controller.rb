class BaseController < ApplicationController
  before_action :store_location, only: [:index]
end
