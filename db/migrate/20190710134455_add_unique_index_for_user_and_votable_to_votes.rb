class AddUniqueIndexForUserAndVotableToVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :votes, %i[user_id votable_id votable_type], unique: true
  end
end
