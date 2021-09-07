class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @newbook = Book.new
    @books =@user.books
    
    #ログインしてるユーザーをエントリーテーブルに記録
    @currentUserEntry=Entry.where(user_id: current_user.id)
    #相手のユーザーをエントリーテーブルに記録
    @userEntry=Entry.where(user_id: @user.id)
    
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            #room_idが共通しているのユーザー同士に対して
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end
  
  

  def index
    @users = User.all
    @newbook = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user)
    end

  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       redirect_to user_path(@user.id) ,notice: "You have updated user successfully."
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
