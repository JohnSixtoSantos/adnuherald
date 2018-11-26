class UsersController < ApplicationController
	layout false

	def new
	end

	def create
	end

	def login
		if params[:login].nil? then 

		else
			@f_uname = params[:login][:email]
			@f_pass = params[:login][:password]

			@user = User.find_by(email: @f_uname)

			if @user && @f_pass == @user.password then			
				session[:user_id] = @user.id
				session[:first_name] = @user.first_name
				redirect_to "/dashboard"
			else
				flash[:danger] = "Invalid Login!"
				render "login"
			end
		end
	end

	def logout
	end
end
