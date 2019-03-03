class Admin::AdminController < ApplicationController
  before_action :allow_admin
end
