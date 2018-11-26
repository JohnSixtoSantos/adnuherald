class PageController < ApplicationController
	skip_before_action :require_login

  	def front_page
  		render layout: "front_page"
	end
end
