class RecoveriesController < ApplicationController

  layout 'index', :only => [:show] 
  
  include RecoveriesHelper

  # GET show recovery password form
  def show 
    if rec = Recovery.find_by_key(params[:key])
      @user = rec.user
      @key = params[:key]
      respond_to do |format|
        format.html
      end
    end
  end

  # GET form for e-mail sending (ajax)
  def new
    $rec = Recovery.new
    respond_to do |format|
      format.js
    end
  end

  # POST create record into db and send e-mail
  def create
    user = User.find_by_email(params[:recovery][:email])
    if user.nil?
      render :text => "User isn't found"
    else
      # clear db from old records for current user
      Recovery.delete_all(['user_id = ?', user[:id]])

      key = rec_key(user[:email])
      
      rec = Recovery.new(:key => key, :user_id => user[:id])
      if rec.save
        # FIXME tune heroku.com, because doesn't work currently
        UserMailer.recovery_pswd(user[:email],
          'http://furious-fire-5881.heroku.com/recovery?key=' + key).deliver
        # render :text => root_url + 'recovery?key=' + key
        render :text => 'E-mail is sent'
      else
        render :text => "Cann't send message"
      end
    end
  end

  # PUT update all user's information, including password
  def update
    if Recovery.find_by_key(params[:key])   
      @user = User.find_by_email(params[:user][:email])
      if @user.update_attributes(params[:user])
        render :text => 'Update was successfull'
      else
        render :text => 'Sorry, something is wrong'
      end
    else
      render :text => 'Access denied!'
    end
  end
end
