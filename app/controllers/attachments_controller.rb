class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file

  def destroy
    @file.purge if current_user.author_of?(@file.record)
  end

  private

  def find_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end 
