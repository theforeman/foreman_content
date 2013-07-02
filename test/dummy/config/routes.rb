Rails.application.routes.draw do

  mount Repositories::Engine => "/repositories"
end
