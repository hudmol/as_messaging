Sequel.migration do

  up do
    create_table(:message) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :repo_id, :null => false

      HalfLongString :title, :null => true
      TextField :summary

      apply_mtime_columns
    end

    create_table(:message_assignee_user_rlshp) do
      primary_key :id

      Integer :message_id
      Integer :user_id

      Integer :aspace_relationship_position

      apply_mtime_columns(false)
    end

    # NOTE: There's an open question of what to do if a user gets deleted.
    # Default behaviour will be to unassign anything that was assigned to them
    # as this relationship will be deleted automatically.
    #
    alter_table(:message_assignee_user_rlshp) do
      add_foreign_key([:user_id], :user, :key => :id)
      add_foreign_key([:message_id], :message, :key => :id)
    end
  end

  down do
    # NO TURNING BACK.  GLORY TO THE BRAVE!
  end

end
