module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    votes.create(user: user, value: 1) unless votes.where(user: user).exists?
  end

  def vote_down(user)
    votes.create!(user: user, value: -1) unless votes.where(user: user).exists?
  end

  def unvote(user)
    votes.find_by(user: user).destroy if votes.where(user: user).exists?
  end

  def sum_votes
    votes.sum(:value)
  end
end
