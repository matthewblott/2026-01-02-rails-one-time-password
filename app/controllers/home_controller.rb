class HomeController < ApplicationController
  # skip_before_action :authenticate, only: [:index, :about]
  skip_before_action :authenticate, only: [:about]

  def index
  end
end
