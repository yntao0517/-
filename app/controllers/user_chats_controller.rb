class UserChatsController < ApplicationController
  def show
    @user = User.find(current_user)
    @hospital_items = @user.hospital_items
    @hosptial_ids = []
    @hospital_items.each do |item|
      @hospital_ids.append(item.hospital_id)
    end
    @hospital_ids.uniq!
  end
end