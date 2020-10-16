module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against unvote]
  end

  def vote_for
    unless current_user.author_of?(@votable)
      @votable.vote_up(current_user)
      render_json
    end
  end

  def vote_against
    unless current_user.author_of?(@votable)
      @votable.vote_down(current_user)
      render_json
    end
  end

  def unvote
    @votable.unvote(current_user)
    render_json
  end

  private

  def render_json
    respond_to do |format|
      if @votable.save
        format.json { render json: { id: @votable.id, klass: @votable.class.name.underscore, value: @votable.sum_votes } }
      else
        format.json { render json: @votable.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
