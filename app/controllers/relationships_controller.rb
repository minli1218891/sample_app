class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create       #关注某人，即创建relationships中一条数据
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to @user
  end

  def destroy     #取消关注，删除relationships中一条数据
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
  end

end