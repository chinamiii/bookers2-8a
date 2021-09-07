class RoomsController < ApplicationController

  def create
    @room = Room.create
    #現在ログインしているユーザーのidをentryテーブルに保存
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    #フォローされている側の情報
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      #Messageテーブルにそのチャットルームのidと紐づいたメッセージを表示
      @messages = @room.messages
      @message = Message.new
      #ユーザーの名前などの情報を表示させるため
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
