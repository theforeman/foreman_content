module Repositories
  class ProvidersController < ApplicationController
    def index
      @providers = CustomProvider.all.paginate(:page => params[:page])
    end
  end
end